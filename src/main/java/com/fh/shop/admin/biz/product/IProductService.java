package com.fh.shop.admin.biz.product;

import com.fh.shop.admin.common.DataTableResult;
import com.fh.shop.admin.param.product.ProductSearchParam;
import com.fh.shop.admin.po.product.Product;
import com.fh.shop.admin.vo.product.ProductVo;

import java.util.List;

public interface IProductService {

    void addProduct(Product product);

    void deleteProductById(Long id);

    ProductVo findProduct(Long id);

    void updateProduct(Product product);

    DataTableResult findProductPageList(ProductSearchParam productSearchParam);

    void batchDelete(List<Integer> ids);

    void updateValid(Long id);

    List<ProductVo> findProductList(ProductSearchParam productSearchParam);
}
