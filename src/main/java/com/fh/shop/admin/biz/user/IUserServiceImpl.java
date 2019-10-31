package com.fh.shop.admin.biz.user;

import com.fh.shop.admin.common.DataTableResult;
import com.fh.shop.admin.common.ResponseEnum;
import com.fh.shop.admin.common.ServerResponse;
import com.fh.shop.admin.mapper.user.IUserMapper;
import com.fh.shop.admin.param.user.UserPasswordParam;
import com.fh.shop.admin.param.user.UserSearchParam;
import com.fh.shop.admin.po.role.UserRole;
import com.fh.shop.admin.po.user.User;
import com.fh.shop.admin.util.*;
import com.fh.shop.admin.vo.user.UserVo;
import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.*;

import static com.fh.shop.admin.util.SystemConstant.ownEmailAccount;
import static com.fh.shop.admin.util.SystemConstant.receiveMailAccount;

@Service("userService")
public class IUserServiceImpl implements IUserService {
    @Autowired
    private IUserMapper userMapper;

    //新增用户
    public void addUser(User user) {
        //生成一个32位字符串
        String uuid = UUID.randomUUID().toString();
        user.setPassword(Md5Util.md5(Md5Util.md5(user.getPassword())+uuid));
        user.setSalt(uuid);
        userMapper.addUser(user);
        addUserRole(user);
    }


    //新增用户角色中间表
    private void addUserRole(User user) {
        //添加用户角色中间表
        if (StringUtils.isNotEmpty(user.getIds())){
            String[] roleIdArr=user.getIds().split(",");
            for (String s : roleIdArr) {
                UserRole userRole=new UserRole();
                userRole.setRoleId(Long.parseLong(s));
                userRole.setUserId(user.getId());
                userMapper.addUserRole(userRole);
            }
        }
    }

    @Override
    public void deleteUserById(Long id) {
        //先删除用户角色中间表数据
        userMapper.deleteUserRole(id);
        //删除用户
        userMapper.deleteUserById(id);
    }

    @Override
    public UserVo findUser(Long id) {
        User user = userMapper.findUser(id);
        UserVo userVo = getUserVo(user);
        //获取相关角色信息
        List<Long> roleIdList=userMapper.roleIdList(id);
        userVo.setRoleIdList(roleIdList);
        System.out.println();
        return userVo;
    }

    private UserVo getUserVo(User user) {
        UserVo userVo=new UserVo();
        userVo.setId(user.getId());
        userVo.setUserName(user.getUserName());
        userVo.setPassword(user.getPassword());
        userVo.setRealName(user.getRealName());
        userVo.setSex(user.getSex());
        userVo.setAge(user.getAge());
        userVo.setEmail(user.getEmail());
        userVo.setPhone(user.getPhone());
        userVo.setPay(user.getPay());
        userVo.setPhoto(user.getPhoto());
        userVo.setEntryTime(DateUtil.date2str(user.getEntryTime(),DateUtil.Y_M_D));
        userVo.setLoginCount(user.getLoginCount());
        userVo.setLoginTime(DateUtil.date2str(user.getLoginTime(),DateUtil.FUFF_YEAR));
        userVo.setLock(user.getLoginErrorCount() == SystemConstant.LOGIN_ERROR_MAX_COUNT);
        return userVo;
    }

    @Override
    public void updateUser(User user) {
        userMapper.updateUser(user);
        //先删除 之前的用户角色中间表数据
        userMapper.deleteUserRole(user.getId());
        //再添加
        addUserRole(user);
    }

    @Override
    public DataTableResult findUserPageList(UserSearchParam userSearchParam) {
        //获取角色查询条件
        buildRoleArray(userSearchParam);
        //查询总条数
        Long totalCount=userMapper.findUserCount(userSearchParam);
        //获取分页列表
        List<User> userList = userMapper.findUserPageList(userSearchParam);
        //po转vo
        List<UserVo> userVoList = new ArrayList<UserVo>();
        for (User userInfo : userList) {
            UserVo userVo=getUserVo(userInfo);
            System.out.println();
            //查询相关角色集合
            List<String> roleName=userMapper.findRoleNameList(userInfo.getId());
            if (roleName != null && roleName.size()>0 ){
                String roleNames=StringUtils.join(roleName,",");
                userVo.setRoleNames(roleNames);
            }
            userVoList.add(userVo);
        }
        DataTableResult dataTableResult = new DataTableResult(userSearchParam.getDraw(), totalCount, totalCount, userVoList);
        return dataTableResult;
    }

    //批量删除
    @Override
    public void batchDelete(List<Integer> ids) {
        //先删除 用户角色中间表数据
        userMapper.batchDeleteUserRole(ids);
        //删除用户
        userMapper.batchDelete(ids);
    }

    //通过用户名查询用户
    @Override
    public User findUserByUserName(String userName) {
        User userByUserName = userMapper.findUserByUserName(userName);
        return userByUserName;
    }

    //修改 登录时间
    @Override
    public void updateLogin(Long id,Date date) {
        userMapper.updateLogin(id,date);
    }


    //记录密码错误次数
    @Override
    public void updateLoginErrorCount(Long id,int i,Date date) {
        userMapper.updateLoginErrorCount(id,i,date);
    }

    //锁定用户
    @Override
    public void updateLockUser(Long id, String email,Date date) {
        userMapper.updateLockUser(id,date);
        //发邮件通知用户
        String subJect = "安全通知";
        String content = "<h1>亲爱的用户,由于您的商品管理平台账号连续三次输入密码错误,存在被盗风险.现已被锁定.若非本人操作,建议您立即修改密码</h1>";
        SendEmail.sendEmail(email, subJect, content);
    }

    //解锁全部用户
    @Override
    public void updateLock(Long id,Boolean lock) {
        if (lock){
            //解锁
            userMapper.updateLock(id,SystemConstant.CONGT_0);
        }else{
            //锁定
            userMapper.updateLock(id,SystemConstant.LOGIN_ERROR_MAX_COUNT);
        }
    }

    //按条件查询要导出的数据
    @Override
    public List<UserVo> findUserExpord(UserSearchParam userSearchParam) {
        List<User> userExpordList = userMapper.findUserExpord(userSearchParam);
        //po转vo
        List<UserVo> userVoList=new ArrayList<UserVo>();
        for (User userInfo : userExpordList) {
            UserVo userVo=getUserVo(userInfo);
            //查询相关角色集合
            List<String> roleName=userMapper.findRoleNameList(userInfo.getId());
            if (roleName != null && roleName.size()>0 ){
                String roleNames=StringUtils.join(roleName,",");
                userVo.setRoleNames(roleNames);
                System.out.println();
            }
            userVoList.add(userVo);
        }
        return userVoList;
    }

    //修改 登陆次数
    @Override
    public void updateLoginCount(Long id, int i) {
        userMapper.updateLoginCount(id,i);
    }

    //重置登录错误次数
    @Override
    public void updateResultLoginErrorCount(Long id) {
        userMapper.updateResultLoginErrorCount(id);
    }

    //修改用户密码
    @Override
    public ServerResponse updatePassword(UserPasswordParam userPasswordParam) {
        //判断修改密码信息不为空
        if (       StringUtils.isEmpty(userPasswordParam.getOldPassword())
                || StringUtils.isEmpty(userPasswordParam.getNewPassword())
                || StringUtils.isEmpty(userPasswordParam.getConfirmPassword()) ){
            return ServerResponse.error(ResponseEnum.UPDATE_PASSWORD_NOT_EMPTY);
        }

        //判断两次密码是否一致
        if (!userPasswordParam.getNewPassword().equals(userPasswordParam.getConfirmPassword())){
            return ServerResponse.error(ResponseEnum.TWO_PASSWORD_NOT_AS);
        }
        //通过id查询用户信息
        User userInfo = userMapper.findUser(userPasswordParam.getId());

        //判断旧密码是否正确
        String encodePassword = Md5Util.encodePassword(userPasswordParam.getOldPassword(),userInfo.getSalt());
        if (!encodePassword.equals(userInfo.getPassword())){
            return ServerResponse.error(ResponseEnum.OLDPASSWORD_ERROR);
        }

        //更新密码
        String newPassword = Md5Util.encodePassword(userPasswordParam.getNewPassword(),userInfo.getSalt());
        userMapper.updatePassword(userPasswordParam.getId(),newPassword);
        return ServerResponse.success();
    }

    //找回密码
    @Override
    public ServerResponse updateFindPassword(String email) {
        //通过邮箱查询用户
        User userInfo = userMapper.findUserByEmail(email);
        //判断是否存在
        if (userInfo == null){
            return ServerResponse.error(ResponseEnum.EMAIL_IS_EMPTY);
        }
        //生成由字母数字组成的新密码
        String newPassword = RandomStringUtils.randomAlphanumeric(6);
        //将密码发送至邮箱
        String subJect = "安全中心";
        String content = "<h1>密码找回成功,您的新密码为:"+newPassword+"</h1>";
        SendEmail.sendEmail(email,subJect,content);
        //加密密码
        String password = Md5Util.encodePassword(newPassword, userInfo.getSalt());
        //修改密码
        userMapper.updatePassword(userInfo.getId(),password);
        return ServerResponse.success();
    }

    //表单验证 邮箱是否存在
    @Override
    public User findUserByEmail(String email) {
        User user = userMapper.findUserByEmail(email);
        return user;
    }

    //重置用户密码
    @Override
    public ServerResponse updateResultPassword(Long id) {
        User userInfo = userMapper.findUser(id);
        if (userInfo == null){
            return ServerResponse.error(ResponseEnum.USER_NOT_EMPTH);
        }
        String defaultPassword = Md5Util.encodePassword(SystemConstant.USER_DEFAULT_PASSWORD,userInfo.getSalt());
        userInfo.setPassword(defaultPassword);
        userMapper.updateResultPassword(userInfo);
        return ServerResponse.success();
    }



    private void buildRoleArray(UserSearchParam userSearchParam) {
        if (StringUtils.isNotEmpty(userSearchParam.getRoleIds())){
            String[] roleIdArr=userSearchParam.getRoleIds().split(",");
            userSearchParam.setRoleIdArr(roleIdArr);
            userSearchParam.setRoleIdLength(roleIdArr.length);
        }
    }


}
