package com.fh.shop.admin.biz.product;

import com.fh.shop.admin.common.DataTableResult;
import com.fh.shop.admin.mapper.product.IProductMapper;
import com.fh.shop.admin.param.product.ProductSearchParam;
import com.fh.shop.admin.po.product.Product;
import com.fh.shop.admin.util.DateUtil;
import com.fh.shop.admin.vo.product.ProductVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
@Service("productService")
public class IProductServiceImpl implements IProductService {
    @Autowired
    private IProductMapper productMapper;

    //新增商品
    @Override
    public void addProduct(Product product) {
        productMapper.addProduct(product);
    }

    //通过id删除单个商品
    @Override
    public void deleteProductById(Long id) {
        productMapper.deleteProductById(id);
    }

    //通过id查询单个商品
    @Override
    public ProductVo findProduct(Long id) {
        Product product = productMapper.findProduct(id);
        //po转vo
        ProductVo ProductVo = getProductVo(product);
        return ProductVo;
    }

    //修改商品
    @Override
    public void updateProduct(Product product) {
        productMapper.updateProduct(product);
    }

    //商品分页查询
    @Override
    public DataTableResult findProductPageList(ProductSearchParam productSearchParam) {
        //查询商品总条数
        Long totalCount=productMapper.findProductCount(productSearchParam);
        //删除分页数据
        List<Product> productList = productMapper.findProductPageList(productSearchParam);
        //po转vo
        List<ProductVo> productVoList = getProductVoList(productList);
        DataTableResult dataTableResult=new DataTableResult(productSearchParam.getDraw(),totalCount,totalCount,productVoList);
        return dataTableResult;
    }

    //批量删除
    @Override
    public void batchDelete(List<Integer> ids) {
        productMapper.batchDelete(ids);
    }

    //上下架
    @Override
    public void updateValid(Long id) {
        Product product = productMapper.findProduct(id);
        if (product.getIsValid() == 1){
            product.setIsValid(2);
            productMapper.updateValid(product);
        }else{
            product.setIsValid(1);
            productMapper.updateValid(product);
        }
    }

    //根据条件查询商品表数据
    @Override
    public List<ProductVo> findProductList(ProductSearchParam productSearchParam) {
        List<Product> productList = productMapper.findProductList(productSearchParam);
        //po转vo
        List<ProductVo> productVoList = getProductVoList(productList);
        return productVoList;
    }

    private List<ProductVo> getProductVoList(List<Product> productList) {
        List<ProductVo> productVoList = new ArrayList<ProductVo>();
        for (Product product : productList) {
            ProductVo productVo = getProductVo(product);
            productVoList.add(productVo);
        }
        return productVoList;
    }

    private ProductVo getProductVo(Product product) {
        ProductVo productVo=new ProductVo();
        productVo.setId(product.getId());
        productVo.setProductName(product.getProductName());
        productVo.setPrice(product.getPrice().toString());
        productVo.setStock(product.getStock());
        productVo.setIsSellWell(product.getIsSellWell());
        productVo.setIsValid(product.getIsValid());
        productVo.setBrandName(product.getBrand().getBrandName());
        productVo.setBrandId(product.getBrandId());
        productVo.setMainImage(product.getMainImage());
        productVo.setCreateTime(DateUtil.date2str(product.getCreateTime(),DateUtil.FUFF_YEAR));
        return productVo;
    }

}
