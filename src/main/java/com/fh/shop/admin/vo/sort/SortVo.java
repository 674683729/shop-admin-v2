package com.fh.shop.admin.vo.sort;

import java.io.Serializable;

public class SortVo implements Serializable {
    private Long id;

    private String name;

    private Long pId;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Long getpId() {
        return pId;
    }

    public void setpId(Long pId) {
        this.pId = pId;
    }
}
