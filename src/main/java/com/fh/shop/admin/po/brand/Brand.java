package com.fh.shop.admin.po.brand;

import com.fh.shop.admin.common.Page;

import java.io.Serializable;

public class Brand implements Serializable {
    private Long id;

    private String brandName;

    private String photo;

    private Integer isSellWell;

    private Integer sort;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public Integer getIsSellWell() {
        return isSellWell;
    }

    public void setIsSellWell(Integer isSellWell) {
        this.isSellWell = isSellWell;
    }

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }
}
