package com.fh.shop.admin.controller.product;

import com.fh.shop.admin.biz.product.IProductService;
import com.fh.shop.admin.common.DataTableResult;
import com.fh.shop.admin.common.Log;
import com.fh.shop.admin.common.ServerResponse;
import com.fh.shop.admin.param.product.ProductSearchParam;
import com.fh.shop.admin.po.product.Product;
import com.fh.shop.admin.po.user.User;
import com.fh.shop.admin.util.DateUtil;
import com.fh.shop.admin.util.FileUtil;
import com.fh.shop.admin.util.SystemConstant;
import com.fh.shop.admin.vo.product.ProductVo;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.CellRangeAddress;
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

@Controller
@RequestMapping("/product")
public class ProductController {
    @Resource
    private IProductService productService;

    /*商品分页查询*/
    @RequestMapping("/findProductList")
    @ResponseBody
    public DataTableResult findProductList(ProductSearchParam productSearchParam){
        DataTableResult dataTableResult=productService.findProductPageList(productSearchParam);
        return dataTableResult;
    }

    /*回显*/
    @RequestMapping("/findProduct")
    @ResponseBody
    public ServerResponse findProduct(Long id){
        ProductVo productVo=productService.findProduct(id);
        return ServerResponse.success(productVo);
    }

    /*修改*/
    @RequestMapping("/updateProduct")
    @ResponseBody
    @Log("修改商品")
    public ServerResponse updateProduct(Product product){
        productService.updateProduct(product);
        return ServerResponse.success();

    }

    /*商品新增*/
    @RequestMapping("/addProduct")
    @ResponseBody
    @Log("新增商品")
    public ServerResponse addProduct(Product product){
        productService.addProduct(product);
        return ServerResponse.success();

    }

    /*删除*/
    @RequestMapping("/deleteProductById")
    @ResponseBody
    @Log("删除商品")
    public ServerResponse deleteProductById(Long id){
        productService.deleteProductById(id);
        return ServerResponse.success();

    }

    //批量删除
    @RequestMapping("batchDelete")
    @ResponseBody
    @Log("批量删除商品")
    public ServerResponse batchDelete(@RequestParam("ids[]") List<Integer> ids){
        productService.batchDelete(ids);
        return ServerResponse.success();
    }

    //上下架
    @RequestMapping("updateValid")
    @ResponseBody
    @Log("上下架")
    public ServerResponse updateValid(Long id){
        productService.updateValid(id);
        return ServerResponse.success();
    }
    //跳转商品页面
    @RequestMapping("toList")
    public String toList(){
        return "product/productList";
    }

    //excel导出
    @RequestMapping("/expordExcel")
    public void exportExcel(ProductSearchParam productSearchParam, HttpServletResponse response) {
        List<ProductVo> productVoList = productService.findProductList(productSearchParam);
        XSSFWorkbook workbook = buildWorkbook(productVoList);
        FileUtil.excelDownload(workbook, response);
    }

    private XSSFWorkbook buildWorkbook(List<ProductVo> productVoList) {
        //创建workbook
        XSSFWorkbook xwk = new XSSFWorkbook();
        //创建sheet
        XSSFSheet sheet = xwk.createSheet("商品信息【"+productVoList.size()+"】");
        buildTitle(sheet,xwk);
        builtTitleRow(sheet);
        //内容
        buildBody(productVoList, sheet);
        return xwk;
    }

    private void buildTitle(XSSFSheet sheet,XSSFWorkbook xwk) {
        XSSFRow row = sheet.createRow(3);
        XSSFCell cell = row.createCell(7);
        cell.setCellValue("商品列表");
        CellRangeAddress cellRangeAddress = new CellRangeAddress(3, 5, 7, 10);
        sheet.addMergedRegion(cellRangeAddress);
        //构建样式
        XSSFCellStyle cellStyle = buildTitleStyle(xwk);
        //设置样式
        cell.setCellStyle(cellStyle);
    }

    private XSSFCellStyle buildTitleStyle(XSSFWorkbook xwk) {
        //通过workbook创建样式
        XSSFCellStyle cellStyle = xwk.createCellStyle();
        cellStyle.setAlignment(cellStyle.ALIGN_CENTER);
        cellStyle.setVerticalAlignment(cellStyle.ALIGN_CENTER);
        //通过wookbook创建字体
        XSSFFont font = xwk.createFont();
        //加粗
        font.setBold(true);
        font.setFontHeightInPoints((short)22);
        font.setColor(HSSFColor.RED.index);
        //将单元格样式和字体合二为一
        cellStyle.setFont(font);
        //背景色
        cellStyle.setFillBackgroundColor(HSSFColor.BLUE.index);
        cellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        return cellStyle;
    }

    private void buildBody(List<ProductVo> productVoList, XSSFSheet sheet) {
        for (int i = 0; i < productVoList.size(); i++) {
            ProductVo product = productVoList.get(i);
            //创建row
            XSSFRow row = sheet.createRow(i + 7);
            //创建单元格
            row.createCell(7).setCellValue(product.getProductName());
            row.createCell(8).setCellValue(product.getPrice().toString());
            row.createCell(9).setCellValue(product.getStock());
            row.createCell(10).setCellValue(product.getBrandName());
        }
    }

    private void builtTitleRow(XSSFSheet sheet) {
        //创建row
        XSSFRow row = sheet.createRow(6);
        String[] title = {"商品名","价格","库存量","品牌"};
        for (int i = 0; i < title.length; i++) {
            row.createCell(i+7).setCellValue(title[i]);
        }
    }

    //导出word
    @RequestMapping("expordWord")
    public void expordWord(ProductSearchParam productSearchParam, HttpServletRequest request, HttpServletResponse response) {
        //按条件查询要导出的数据
        List<ProductVo> productVoList = productService.findProductList(productSearchParam);

        Map<String, Object> dataMap = new HashMap<String, Object>();
        dataMap.put("title", "商品表");
        dataMap.put("productList",productVoList);
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
            Template template = configuration.getTemplate("productWord.xml");
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

    //导出pdf
    @RequestMapping("/exportPdf")
    public void exportPdf(ProductSearchParam productSearchParam,HttpServletResponse response){
        //根据条件查询数据
        List<ProductVo> productVoList = productService.findProductList(productSearchParam);
        // 构建模板数据
        Map data = buildData(productVoList);
        // 生成模板对应的html
        String htmlContent = FileUtil.buildPdfHtml(data, SystemConstant.PRODUCT_PDF_TEMPLATE_FILE);
        // 转为pdf并进行下载
        FileUtil.pdfDownloadFile(response, htmlContent);
    }


    private Map buildData(List<ProductVo> productVoList) {
        Map data = new HashMap();
        //单位
        data.put("companyName", SystemConstant.COMPANY_NAME);
        //数据
        data.put("products", productVoList);
        //导出的时间
        data.put("createDate", DateUtil.date2str(new Date(), DateUtil.Y_M_D));
        return data;
    }

    //上传图片
    @RequestMapping("/uploadMainImage")
    @ResponseBody
    private ServerResponse uploadMainImage(MultipartFile myfile){
        //判断文件是否为空
        if (!myfile.isEmpty()) {
            String fileName=UUID.randomUUID()+myfile.getOriginalFilename().substring(myfile.getOriginalFilename().lastIndexOf("."));
            InputStream inputStream;
            try {
                inputStream = myfile.getInputStream();
                FileUtil.FTP(fileName, inputStream);
                return ServerResponse.success(fileName);
            } catch (IOException e) {
                e.printStackTrace();
                System.out.println();
                return ServerResponse.error();
            }
        } else {
            return ServerResponse.error();
        }
    }
}
