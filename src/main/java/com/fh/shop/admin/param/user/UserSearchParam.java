package com.fh.shop.admin.param.user;

import com.fh.shop.admin.common.Page;
import org.springframework.format.annotation.DateTimeFormat;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

public class UserSearchParam extends Page implements Serializable {

    private String userName;

    private String realName;

    private Integer minAge;

    private Integer maxAge;

    private Double minPay;

    private Double maxPay;
    @DateTimeFormat(pattern="yyyy-MM-dd")
    private Date minEntryTime;
    @DateTimeFormat(pattern="yyyy-MM-dd")
    private Date maxEntryTime;

    private String roleIds;

    private String[] roleIdArr;

    private Integer roleIdLength;

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getRealName() {
        return realName;
    }

    public void setRealName(String realName) {
        this.realName = realName;
    }

    public Integer getMaxAge() {
        return maxAge;
    }

    public void setMaxAge(Integer maxAge) {
        this.maxAge = maxAge;
    }

    public Double getMinPay() {
        return minPay;
    }

    public void setMinPay(Double minPay) {
        this.minPay = minPay;
    }

    public Double getMaxPay() {
        return maxPay;
    }

    public void setMaxPay(Double maxPay) {
        this.maxPay = maxPay;
    }

    public Date getMinEntryTime() {
        return minEntryTime;
    }

    public void setMinEntryTime(Date minEntryTime) {
        this.minEntryTime = minEntryTime;
    }

    public Date getMaxEntryTime() {
        return maxEntryTime;
    }

    public void setMaxEntryTime(Date maxEntryTime) {
        this.maxEntryTime = maxEntryTime;
    }

    public Integer getMinAge() {
        return minAge;
    }

    public void setMinAge(Integer minAge) {
        this.minAge = minAge;
    }

    public String getRoleIds() {
        return roleIds;
    }

    public void setRoleIds(String roleIds) {
        this.roleIds = roleIds;
    }

    public String[] getRoleIdArr() {
        return roleIdArr;
    }

    public void setRoleIdArr(String[] roleIdArr) {
        this.roleIdArr = roleIdArr;
    }

    public Integer getRoleIdLength() {
        return roleIdLength;
    }

    public void setRoleIdLength(Integer roleIdLength) {
        this.roleIdLength = roleIdLength;
    }
}
