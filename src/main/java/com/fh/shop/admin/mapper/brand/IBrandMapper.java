package com.fh.shop.admin.mapper.brand;

import com.fh.shop.admin.param.brand.BrandSearchParam;
import com.fh.shop.admin.po.brand.Brand;

import java.util.List;

public interface IBrandMapper {

    void addBrand(Brand brand);

    void deleteBrandById(Long id);

    Brand findBrand(Long id);

    void updateBrand(Brand brand);

    Long findBrandCount(BrandSearchParam brandSearchParam);

    List<Brand> findBrandPageList(BrandSearchParam brandSearchParam);

    List<Brand> findAllBrand();

    void updateSellWell(Brand brand);

    void updateBrandSort(Brand brand);
}
