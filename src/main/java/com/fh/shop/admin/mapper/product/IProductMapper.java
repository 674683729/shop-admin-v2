package com.fh.shop.admin.mapper.product;

import com.fh.shop.admin.param.product.ProductSearchParam;
import com.fh.shop.admin.po.product.Product;

import java.util.List;

public interface IProductMapper {

    void addProduct(Product product);

    void deleteProductById(Long id);

    Product findProduct(Long id);

    void updateProduct(Product product);

    Long findProductCount(ProductSearchParam productSearchParam);

    List<Product> findProductPageList(ProductSearchParam productSearchParam);

    void batchDelete(List<Integer> ids);

    void updateValid(Product product);

    List<Product> findProductList(ProductSearchParam productSearchParam);
}
