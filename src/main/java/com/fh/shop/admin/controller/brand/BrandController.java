package com.fh.shop.admin.controller.brand;

import com.fh.shop.admin.biz.brand.IBrandService;
import com.fh.shop.admin.common.DataTableResult;
import com.fh.shop.admin.common.Log;
import com.fh.shop.admin.common.ServerResponse;
import com.fh.shop.admin.param.brand.BrandSearchParam;
import com.fh.shop.admin.po.brand.Brand;
import com.fh.shop.admin.po.user.User;
import com.fh.shop.admin.util.FileUtil;
import com.fh.shop.admin.util.SystemConstant;
import com.fh.shop.admin.vo.brand.BrandVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("brand")
public class BrandController {
    @Resource
    private IBrandService brandService;

    /*商品分页查询*/
    @RequestMapping("/findBrandList")
    @ResponseBody
    public DataTableResult findBrandList(BrandSearchParam brandSearchParam){
        //查询分页数据
        DataTableResult dataTableResult=brandService.findBrandPageList(brandSearchParam);
        return dataTableResult;
    }

    /*回显*/
    @RequestMapping("/findBrand")
    @ResponseBody
    public ServerResponse findBrand(Long id){
        BrandVo brandVo=brandService.findBrand(id);
        return ServerResponse.success(brandVo);
    }

    /*修改*/
    @RequestMapping("/updateBrand")
    @ResponseBody
    @Log("修改品牌")
    public ServerResponse updateBrand(Brand brand){
        brandService.updateBrand(brand);
        return ServerResponse.success();

    }

    /*商品新增*/
    @RequestMapping("/addBrand")
    @ResponseBody
    @Log("新增品牌")
    public ServerResponse addBrand(Brand brand){
        brandService.addBrand(brand);
        return ServerResponse.success();

    }

    /*删除*/
    @RequestMapping("/deleteBrandById")
    @ResponseBody
    @Log("删除品牌")
    public ServerResponse deleteBrandById(Long id){
        brandService.deleteBrandById(id);
        return ServerResponse.success();
    }
    //修改排序
    @RequestMapping("updateBrandSort")
    @ResponseBody
    @Log("修改排序")
    public ServerResponse updateBrandSort(Brand brand){
        brandService.updateBrandSort(brand);
        return ServerResponse.success();
    }

    //设置热销
    @RequestMapping("updateSellWell")
    @ResponseBody
    @Log("修改热销")
    public ServerResponse updateSellWell(Brand brand) {
        brandService.updateSellWell(brand);
        return ServerResponse.success();
    }
    //跳转品牌页面
    @RequestMapping("toList")
    public String toList(){
        return "brand/brandList";
    }

    //查询所有品牌
    @RequestMapping("findAllBrand")
    @ResponseBody
    public ServerResponse findAllBrand(){
        List<Brand> brandList = brandService.findAllBrand();
        return ServerResponse.success(brandList);
    }

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
                System.out.println();
                return ServerResponse.success(fileName);
            } catch (IOException e) {
                e.printStackTrace();
                return ServerResponse.error();
            }
        } else {
            return ServerResponse.error();
        }

    }
}
