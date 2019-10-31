package com.fh.shop.admin.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("admin")
@Controller
public class AdminController {

    //跳转首页
    @RequestMapping("toIndex")
    public String toIndex(){
        return "index";
    }
}
