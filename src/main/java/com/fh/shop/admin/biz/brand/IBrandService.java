package com.fh.shop.admin.biz.brand;

import com.fh.shop.admin.common.DataTableResult;
import com.fh.shop.admin.param.brand.BrandSearchParam;
import com.fh.shop.admin.po.brand.Brand;
import com.fh.shop.admin.vo.brand.BrandVo;

import java.util.List;

public interface IBrandService {

    void addBrand(Brand brand);

    void deleteBrandById(Long id);

    BrandVo findBrand(Long id);

    void updateBrand(Brand brand);

    DataTableResult findBrandPageList(BrandSearchParam brandSearchParam);

    List<Brand> findAllBrand();

    void updateSellWell(Brand brand);

    void updateBrandSort(Brand brand);
}
