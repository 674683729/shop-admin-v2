package com.fh.shop.admin.po.role;

import com.fh.shop.admin.common.Page;

import java.io.Serializable;

public class Role implements Serializable {

    private Long Id;

    private String roleName;

    public Long getId() {
        return Id;
    }

    public void setId(Long id) {
        Id = id;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }
}
