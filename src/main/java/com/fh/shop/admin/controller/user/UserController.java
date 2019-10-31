package com.fh.shop.admin.controller.user;

import com.fh.shop.admin.biz.resource.IResourceService;
import com.fh.shop.admin.biz.user.IUserService;
import com.fh.shop.admin.common.DataTableResult;
import com.fh.shop.admin.common.Log;
import com.fh.shop.admin.common.ResponseEnum;
import com.fh.shop.admin.common.ServerResponse;
import com.fh.shop.admin.param.user.UserPasswordParam;
import com.fh.shop.admin.param.user.UserSearchParam;
import com.fh.shop.admin.po.user.User;
import com.fh.shop.admin.util.DateUtil;
import com.fh.shop.admin.util.FileUtil;
import com.fh.shop.admin.util.Md5Util;
import com.fh.shop.admin.util.SystemConstant;
import com.fh.shop.admin.vo.resource.ResourceVo;
import com.fh.shop.admin.vo.user.UserVo;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.xssf.usermodel.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;


import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.*;
import java.util.List;

@Controller
@RequestMapping("/user")
public class UserController {
    @Resource(name="userService")
    private IUserService userService;
    @Resource(name="resourceService")
    private IResourceService resourceService;

    //登录
    @RequestMapping("/login")
    @ResponseBody
    @Log("登陆")
    public ServerResponse login(User user, HttpServletRequest request){
        //判断用户名 密码不能为空
        if(StringUtils.isEmpty(user.getUserName()) || StringUtils.isEmpty(user.getPassword())){
            return ServerResponse.error(ResponseEnum.USERNAME_PASSWORD_IS_NULL);
        }
        //通过用户名查询用户
        User userInfo = userService.findUserByUserName(user.getUserName());
        if (userInfo == null){
            //用户名不存在
            return ServerResponse.error(ResponseEnum.USERNAME_ERROR);
        }
        //当前登陆时间和上次登录错误时间做判断 同一天 判断错误次数
        //上次登录时间
        Date loginTime = DateUtil.str2date(DateUtil.date2str(userInfo.getLoginTime(),DateUtil.Y_M_D),DateUtil.Y_M_D);
        Date date = new Date();
        //本次登陆时间
        Date currTime = DateUtil.str2date(DateUtil.date2str(date,DateUtil.Y_M_D),DateUtil.Y_M_D);
        //上次登陆密码错误时间
        Date loginErrorTime = DateUtil.str2date(DateUtil.date2str(userInfo.getLoginErrorTime(),DateUtil.Y_M_D),DateUtil.Y_M_D);
        //判断密码错误次数 =3
        if(userInfo.getLoginErrorCount() == SystemConstant.LOGIN_ERROR_MAX_COUNT){
            //同一天 return 返回被锁定
            if(!currTime.after(loginErrorTime)){
                //用户被锁定
                return ServerResponse.error(ResponseEnum.USER_LOCK);
            }else{
                //重置登录错误次数
                userService.updateResultLoginErrorCount(userInfo.getId());
            }
        }
        //判断密码
        if (!userInfo.getPassword().equals(Md5Util.md5(Md5Util.md5(user.getPassword())+userInfo.getSalt()))){
            //密码错误 判断密码错误时间是否为null
            if (userInfo.getLoginErrorTime() == null){
                //为null 将登录错误次数改为1 更新错误时间
                userService.updateLoginErrorCount(userInfo.getId(),SystemConstant.CONGT_1,date);
            }else{
                // 判断和上次错误时间是否是同一天
                if (currTime.after(loginErrorTime)){
                    //不是同一天错误 登录错误次数重置为1 更新错误时间
                    userService.updateLoginErrorCount(userInfo.getId(),SystemConstant.CONGT_1,date);
                }else{
                    //同一天错误
                    //如果错误三次 账户锁定 发送邮件 更新错误时间
                    if (userInfo.getLoginErrorCount() == (SystemConstant.LOGIN_ERROR_MAX_COUNT-SystemConstant.CONGT_1)){
                        userService.updateLockUser(userInfo.getId(),userInfo.getEmail(),date);
                        return ServerResponse.error(ResponseEnum.USER_PASSWORD_ERROR_LOCK);
                    }
                    // 登录错误次+1 更新错误时间
                    userService.updateLoginErrorCount(userInfo.getId(),userInfo.getLoginErrorCount()+SystemConstant.CONGT_1,date);
                }
            }
            return ServerResponse.error(ResponseEnum.PASSWORD_ERROR);
        }

        //修改 登录时间
        userService.updateLogin(userInfo.getId(),new Date());
        //修改 登陆次数
        if (loginTime == null){
            //第一次登陆 重置1
            userService.updateLoginCount(userInfo.getId(),SystemConstant.CONGT_1);
            userInfo.setLoginCount(SystemConstant.CONGT_1);

        }else{
            if(currTime.after(loginTime)){
                //当前登陆时间在上次登录时间后 不是同一天 重置为1
                userService.updateLoginCount(userInfo.getId(),SystemConstant.CONGT_1);
                userInfo.setLoginCount(SystemConstant.CONGT_1);
            }else{
                //同一天登录  +1
                userService.updateLoginCount(userInfo.getId(),userInfo.getLoginCount()+SystemConstant.CONGT_1);
                userInfo.setLoginCount(userInfo.getLoginCount()+SystemConstant.CONGT_1);
            }
        }
        // 将用户信息 存储在session中
        request.getSession().setAttribute(SystemConstant.CUURREND_USER, userInfo);
        //根据用户查询用户对应的菜单集合 用于前台导航条的展示
        List<com.fh.shop.admin.po.resource.Resource> menuList=resourceService.findResourceByUserId(userInfo.getId());
        request.getSession().setAttribute(SystemConstant.LOGIN_USER_RESOURCE,menuList);
        //查询所有菜单集合 权限拦截器里判断是否是公共资源
        List<ResourceVo> resourceList = resourceService.findResourceList();
        request.getSession().setAttribute(SystemConstant.RESOURCE_LIST,resourceList);
        //查询当前用户的所有资源
        List<com.fh.shop.admin.po.resource.Resource> userResourceList=resourceService.findUserAllResource(userInfo.getId());
        request.getSession().setAttribute(SystemConstant.LOGIN_USER_ALL_RESOURCE,userResourceList);
        return ServerResponse.success();
    }

    //修改用户密码
    @RequestMapping("updatePassword")
    @ResponseBody
    @Log("修改密码")
    public ServerResponse updatePassword(UserPasswordParam userPasswordParam){
        ServerResponse serverResponse = userService.updatePassword(userPasswordParam);
        return serverResponse;
    }

    //找回密码
    @RequestMapping("findPassword")
    @ResponseBody
    public ServerResponse findPassword(String email){
        ServerResponse serverResponse = userService.updateFindPassword(email);
        return serverResponse;
    }

    //重置用户密码
    @RequestMapping("updateResultPassword")
    @ResponseBody
    @Log("重置用户密码")
    public ServerResponse updateResultPassword(Long id){
        ServerResponse serverResponse = userService.updateResultPassword(id);
        return serverResponse;
    }




    //解锁 锁定 用户
    @RequestMapping("updateLock")
    @ResponseBody
    @Log("解锁或锁定用户")
    public ServerResponse updateLock(Long id,Boolean lock){
        userService.updateLock(id,lock);
        return ServerResponse.success();
    }

    //@Scheduled(cron = "0 0/1 * * * ?") 一分钟一次
    //@Scheduled(cron = "0 0 0 * * ?")  //每天晚上12点执行
    /*public void updateLockUser(){
        //解锁全部用户
        System.out.println("========================");
        userService.updateLock();
    }*/

    //上传图片
    @RequestMapping("/uploadPhoto")
    @ResponseBody
    private ServerResponse uploadPhoto(MultipartFile myfile){
        //判断文件是否为空
        if (!myfile.isEmpty()) {
            String fileName=UUID.randomUUID()+myfile.getOriginalFilename().substring(myfile.getOriginalFilename().lastIndexOf("."));
            InputStream inputStream;
            try {
                inputStream = myfile.getInputStream();
                FileUtil.FTP(fileName, inputStream);
            } catch (IOException e) {
                e.printStackTrace();
                return ServerResponse.error();
            }
                return ServerResponse.success(fileName);
        } else {
            return ServerResponse.error();
        }
    }

    /*用户分页查询*/
    @RequestMapping("/findUserList")
    @ResponseBody
    public DataTableResult findUserList(UserSearchParam userSearchParam){
        //查询分页数据
        DataTableResult dataTableResult=userService.findUserPageList(userSearchParam);
        return dataTableResult;
    }

    /*回显*/
    @RequestMapping("/findUser")
    @ResponseBody
    public ServerResponse findUser(Long id){
            UserVo userVo=userService.findUser(id);
            return ServerResponse.success(userVo);
    }

    /*修改*/
    @RequestMapping("/updateUser")
    @ResponseBody
    @Log("修改用户")
    public ServerResponse updateUser(User user){
        userService.updateUser(user);
        return ServerResponse.success();
    }

    /*用户新增*/
    @RequestMapping("/addUser")
    @ResponseBody
    @Log("新增用户")
    public ServerResponse addUser(User user){
        userService.addUser(user);
        return ServerResponse.success();
    }

    /*删除*/
    @Log("删除用户")
    @RequestMapping("/deleteUserById")
    @ResponseBody
    public ServerResponse deleteUserById(Long id){
        userService.deleteUserById(id);
        return ServerResponse.success();
    }

    //批量删除
    @RequestMapping("batchDelete")
    @ResponseBody
    @Log("批量删除用户")
    public ServerResponse batchDelete(@RequestParam("ids[]") List<Integer> ids){
        userService.batchDelete(ids);
        return ServerResponse.success();
    }

    //跳转用户页面
    @RequestMapping("toList")
    public String toList(){
        return "/user/userList";
    }

    //退出登录
    @RequestMapping("logout")
    public String logout(HttpServletRequest request){
        //清空session所有数据    removeAttribute(key) 根据key删除对应数据
        request.getSession().invalidate();
        return "redirect:/";
    }

    //Excel导出
    @RequestMapping("excelExpord")
    public void excelExpord(UserSearchParam userSearchParam,HttpServletResponse response) {
        //获取角色查询条件
        if (StringUtils.isNotEmpty(userSearchParam.getRoleIds())){
            String[] roleIdArr=userSearchParam.getRoleIds().split(",");
            userSearchParam.setRoleIdLength(roleIdArr.length);
            userSearchParam.setRoleIdArr(roleIdArr);
        }

        //按条件查询要导出的数据
        List<UserVo> userList=userService.findUserExpord(userSearchParam);
        //创建workbook
        XSSFWorkbook xwk = new XSSFWorkbook();
        //创建sheet
        XSSFSheet createSheet = xwk.createSheet("用户表");

        //创建字体
        XSSFFont createFont = xwk.createFont();
        createFont.setBold(true);

        //创建样式
        XSSFCellStyle createCellStyle = xwk.createCellStyle();
        createCellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        createCellStyle.setFillForegroundColor(HSSFColor.BLUE.index);
        //字体执行样式
        createCellStyle.setFont(createFont);

        //创建表头
        XSSFRow createRow = createSheet.createRow(0);
        //创建第一个单元格
        XSSFCell createCell = createRow.createCell(0);
        createCell.setCellValue("用户名称");
        createCell.setCellStyle(createCellStyle);
        //创建第二个单元格
        XSSFCell createCell1 = createRow.createCell(1);
        createCell1.setCellValue("真实姓名");
        createCell1.setCellStyle(createCellStyle);
        //创建第三个单元格
        XSSFCell createCell2 = createRow.createCell(2);
        createCell2.setCellValue("性别");
        createCell2.setCellStyle(createCellStyle);
        //创建第四个单元格
        XSSFCell createCell3 = createRow.createCell(3);
        createCell3.setCellValue("年龄");
        createCell3.setCellStyle(createCellStyle);
        //创建第五个单元格
        XSSFCell createCell4 = createRow.createCell(4);
        createCell4.setCellValue("电话");
        createCell4.setCellStyle(createCellStyle);
        //创建第六个单元格
        XSSFCell createCell5 = createRow.createCell(5);
        createCell5.setCellValue("Email");
        createCell5.setCellStyle(createCellStyle);
        //创建第七个单元格
        XSSFCell createCell6 = createRow.createCell(6);
        createCell6.setCellValue("薪资");
        createCell6.setCellStyle(createCellStyle);
        //创建第七个单元格
        XSSFCell createCell7 = createRow.createCell(7);
        createCell7.setCellValue("入职时间");
        createCell7.setCellStyle(createCellStyle);
        //创建第八个单元格
        XSSFCell createCell8 = createRow.createCell(8);
        createCell8.setCellValue("角色");
        createCell8.setCellStyle(createCellStyle);

        //循环导出内容
        for (int i = 0; i < userList.size(); i++) {
            //创建行
            XSSFRow createRow1 = createSheet.createRow(i+1);
            //第二个单元格 真实姓名
            XSSFCell createCell10 = createRow1.createCell(1);
            createCell10.setCellValue(userList.get(i).getRealName());
            //第一个单元格 用户名称
            XSSFCell createCell9 = createRow1.createCell(0);
            createCell9.setCellValue(userList.get(i).getUserName());
            //第三个单元格 性别
            XSSFCell createCell11 = createRow1.createCell(2);
            createCell11.setCellValue((userList.get(i).getSex()==1?"男":"女"));
            //第四个单元格 年龄
            XSSFCell createCell12 = createRow1.createCell(3);
            createCell12.setCellValue(userList.get(i).getAge());
            //第五个单元格 电话
            XSSFCell createCell13 = createRow1.createCell(4);
            createCell13.setCellValue(userList.get(i).getPhone());
            //第六个单元格 email
            XSSFCell createCell14 = createRow1.createCell(5);
            createCell14.setCellValue(userList.get(i).getEmail());
            //第七个单元格 薪资
            XSSFCell createCell15 = createRow1.createCell(6);
            createCell15.setCellValue(userList.get(i).getPay());
            //第八个单元格 入职时间
            XSSFCell createCell16 = createRow1.createCell(7);
            createCell16.setCellValue(userList.get(i).getEntryTime());
            //第九个单元格 角色
            XSSFCell createCell17 = createRow1.createCell(8);
            createCell17.setCellValue(userList.get(i).getRoleNames());
        }
        FileUtil.excelDownload(xwk, response);
    }

    //word导出
    @RequestMapping("wordExpord")
    public void wordExpord(UserSearchParam userSearchParam,HttpServletRequest request,HttpServletResponse response) {
        //获取角色查询条件
        if (StringUtils.isNotEmpty(userSearchParam.getRoleIds())){
            String[] roleIdArr=userSearchParam.getRoleIds().split(",");
            userSearchParam.setRoleIdLength(roleIdArr.length);
            userSearchParam.setRoleIdArr(roleIdArr);
        }

        //按条件查询要导出的数据
        List<UserVo> userList=userService.findUserExpord(userSearchParam);
        Map<String, Object> dataMap = new HashMap<String, Object>();
        dataMap.put("title", "用户表");
        dataMap.put("userList",userList);
        try {
            //.创建随机文件名
            String fileName = UUID.randomUUID().toString() + ".docx";
            System.out.println(fileName);
            //.获取模板
            //新建configuration对象 并 设置默认编码 和 模板所在路径
            Configuration configuration = new Configuration();
            configuration.setDefaultEncoding("UTF-8");
            configuration.setClassForTemplateLoading(this.getClass(), "/template");
            //根据模板文件名获取模板
            Template template = configuration.getTemplate("userWord.xml");
            //新建文件对象
            File file = new File("D:/" + fileName);
            //新建文件输出流
            FileOutputStream fos = new FileOutputStream(file);
            //新建写入器
            OutputStreamWriter osw = new OutputStreamWriter(fos, "UTF-8");
            //6.将填充数据填入模板文件 并 输出到目标文件
            template.process(dataMap, osw);

            //7.调用FileUtil文件下载方法
            FileUtil.downloadFile(request, response, file.getPath(), fileName);
            // 刷新缓冲区
            osw.flush();
            // 关流
            osw.close();
            // 删除没用的文件
            file.delete();
        } catch (IOException e1) {
            e1.printStackTrace();
        } catch (TemplateException e) {
            e.printStackTrace();
        }
    }

    //pdf导出
    @RequestMapping("pdfExpord")
    public void pdfExpord(UserSearchParam userSearchParam,HttpServletResponse response) {
        try {
            //获取角色查询条件
            if (StringUtils.isNotEmpty(userSearchParam.getRoleIds())){
                String[] roleIdArr=userSearchParam.getRoleIds().split(",");
                userSearchParam.setRoleIdLength(roleIdArr.length);
                userSearchParam.setRoleIdArr(roleIdArr);
            }
            //按条件查询要导出的数据
            List<UserVo> userList=userService.findUserExpord(userSearchParam);
            //定义一个字节数组
            ByteArrayOutputStream byteOut=new ByteArrayOutputStream();
            //创建一个doucment对象 文本对象
            Document document =new Document();
            document.setPageSize(PageSize.A4);
            //创建字体  设置为中文 STSong-Light是宋体 不嵌入
            BaseFont font = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);
            //创建列的字体样式   NORMAL正规字体
            Font keyFont = new Font(font, 15,Font.NORMAL);
            //创建pdf文件
            PdfWriter.getInstance(document, byteOut);
            //设置一个表头数组
            String[] str= {"用户名称","真实姓名","性别","年龄","电话","Email","薪资","入职时间","角色"};
            //设置书写器
            PdfPTable table = FileUtil.createTable(str.length);
            //打开文本对象
            document.open();
            //设置标题
            Font headFont = new Font(font,25,Font.BOLD);
            //设置标题的颜色
            headFont.setColor(BaseColor.BLACK);
            //创建标题
            PdfPCell headCell = FileUtil.createHeadline("商品表", headFont);
            headCell.setExtraParagraphSpace(20);
            //放入书写器
            table.addCell(headCell);
            for (int i = 0; i < str.length; i++) {
                table.addCell(FileUtil.createCell(str[i], keyFont, Element.ALIGN_CENTER));
            }
            //把查询到的数据集合遍历到书写器里面
            for (int i = 0; i < userList.size(); i++) {
                table.addCell(FileUtil.createCell(userList.get(i).getUserName(), keyFont, Element.ALIGN_CENTER));
                table.addCell(FileUtil.createCell(userList.get(i).getRealName(), keyFont, Element.ALIGN_CENTER));
                table.addCell(FileUtil.createCell((userList.get(i).getSex()==1?"男":"女"), keyFont, Element.ALIGN_CENTER));
                System.out.println();
                table.addCell(FileUtil.createCell(Integer.toString(userList.get(i).getAge()), keyFont, Element.ALIGN_CENTER));
                table.addCell(FileUtil.createCell(userList.get(i).getPhone(), keyFont, Element.ALIGN_CENTER));
                table.addCell(FileUtil.createCell(userList.get(i).getEmail(), keyFont, Element.ALIGN_CENTER));
                table.addCell(FileUtil.createCell(Double.toString(userList.get(i).getPay()), keyFont, Element.ALIGN_CENTER));
                table.addCell(FileUtil.createCell(userList.get(i).getEntryTime(), keyFont, Element.ALIGN_CENTER));
                table.addCell(FileUtil.createCell(userList.get(i).getRoleNames(), keyFont, Element.ALIGN_CENTER));
            }
            //放入文本对象
            document.add(table);
            document.close();
            FileUtil.pdfDownload(response, byteOut);

        } catch (DocumentException | IOException e) {
            e.printStackTrace();
        }
    }

    //表单验证 查询用户名是否存在
    @RequestMapping("/findUserName")
    @ResponseBody
    public Map findUserName(String userName){
        User user = userService.findUserByUserName(userName);
        return getFormValidation(user);
    }

    //表单验证 查询邮箱是否存在
    @RequestMapping("/findEmail")
    @ResponseBody
    public Map findEmail(String email){
        User user = userService.findUserByEmail(email);
        return getFormValidation(user);
    }

    private Map getFormValidation(User user) {
        Map<String,Boolean> map = new HashMap<String,Boolean>();
        if(user==null){
            map.put("valid",true);
            return map;
        }
        else {
            map.put("valid",false);
            return map;
        }
    }


    //跳转修改密码页面
    @RequestMapping("toUpdatePassword")
    public String toUpdatePassword(){
        return "user/updatePassword";
    }

    //跳转找回密码页面
    @RequestMapping("toFindPassword")
    public String toFindPassword(){
        return "user/findPassword";
    }
}
