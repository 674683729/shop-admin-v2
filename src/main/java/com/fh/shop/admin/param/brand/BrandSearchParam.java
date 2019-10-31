package com.fh.shop.admin.param.brand;

import com.fh.shop.admin.common.Page;

import java.io.Serializable;

public class BrandSearchParam extends Page implements Serializable {

    private String brandName;

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }
}
