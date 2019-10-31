package com.fh.shop.admin.biz.brand;

import com.fh.shop.admin.common.DataTableResult;
import com.fh.shop.admin.mapper.brand.IBrandMapper;
import com.fh.shop.admin.param.brand.BrandSearchParam;
import com.fh.shop.admin.po.brand.Brand;
import com.fh.shop.admin.vo.brand.BrandVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service("brandService")
public class IBrandServiceImpl implements IBrandService {
    @Autowired
    private IBrandMapper brandMapper;

    @Override
    public void addBrand(Brand brand) {
        brandMapper.addBrand(brand);
    }

    @Override
    public void deleteBrandById(Long id) {
        brandMapper.deleteBrandById(id);
    }

    @Override
    public BrandVo findBrand(Long id) {
        Brand brand = brandMapper.findBrand(id);
        BrandVo BrandVo = getBrandVo(brand);
        return BrandVo;
    }

    @Override
    public void updateBrand(Brand brand) {
        brandMapper.updateBrand(brand);
    }

    @Override
    public DataTableResult findBrandPageList(BrandSearchParam brandSearchParam) {
        //查询总条数
        Long totalCount = brandMapper.findBrandCount(brandSearchParam);
        //查询分页数据
        List<Brand> brandList = brandMapper.findBrandPageList(brandSearchParam);
        //po转vo
        List<BrandVo> brandVoList = getBrandVoList(brandList);
        return new DataTableResult(brandSearchParam.getDraw(),totalCount,totalCount,brandVoList);
    }

    @Override
    public List<Brand> findAllBrand() {
        List<Brand> brandList = brandMapper.findAllBrand();
        return brandList;
    }

    @Override
    public void updateSellWell(Brand brand) {
        if (brand.getIsSellWell() == 1){
            brand.setIsSellWell(2);
            brandMapper.updateSellWell(brand);
        }else{
            brand.setIsSellWell(1);
            brandMapper.updateSellWell(brand);
        }
    }

    @Override
    public void updateBrandSort(Brand brand) {
        brandMapper.updateBrandSort(brand);
    }

    private List<BrandVo> getBrandVoList(List<Brand> brandList) {
        List<BrandVo> brandVoList = new ArrayList<BrandVo>();
        for (Brand brandInfo : brandList) {
            BrandVo brandVo = getBrandVo(brandInfo);
            brandVoList.add(brandVo);
        }
        return brandVoList;
    }

    private BrandVo getBrandVo(Brand brand) {
        BrandVo brandVo=new BrandVo();
        brandVo.setId(brand.getId());
        brandVo.setBrandName(brand.getBrandName());
        brandVo.setPhoto(brand.getPhoto());
        brandVo.setIsSellWell(brand.getIsSellWell());
        brandVo.setSort(brand.getSort());
        return brandVo;
    }


}
