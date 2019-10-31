package com.fh.shop.admin.common;

import java.io.Serializable;

public enum ResponseEnum implements Serializable {
    USERNAME_PASSWORD_IS_NULL(201,"用户名或密码为空!"),
    USERNAME_ERROR(202,"用户名不存在!"),
    PASSWORD_ERROR(203,"密码错误!"),
    USER_PASSWORD_ERROR_LOCK(204,"由于密码错误3次,用户被锁定!"),
    DBY(205,"当前删除的数据被占用!"),
    USER_LOCK(207,"用户被锁定!"),
    UPDATE_PASSWORD_NOT_EMPTY(209,"修改密码信息不能为空!"),
    TWO_PASSWORD_NOT_AS(210,"输入的两次密码不一致!"),
    OLDPASSWORD_ERROR(211,"旧密码输入错误!"),
    USER_NOT_EMPTH(212,"用户不存在!"),
    EMAIL_IS_EMPTY(213,"您输入的邮箱不存在!"),

    ;
    private Integer code;

    private String msg;

    ResponseEnum(Integer code,String msg) {
        this.code = code;
        this.msg =msg;
    }

    public Integer getCode() {
        return code;
    }

    public String getMsg() {
        return msg;
    }
}
