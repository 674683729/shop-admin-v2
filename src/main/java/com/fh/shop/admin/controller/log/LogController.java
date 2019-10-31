package com.fh.shop.admin.controller.log;

import com.fh.shop.admin.biz.log.ILogService;
import com.fh.shop.admin.common.DataTableResult;
import com.fh.shop.admin.param.log.LogSearchParam;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

@Controller
@RequestMapping("/log")
public class LogController {
    @Resource(name="logService")
    private ILogService logService;

    //日志信息分页查询
    @RequestMapping("/findLogList")
    @ResponseBody
    public DataTableResult findLogList(LogSearchParam logSearchParam){
        //查询分页数据
        DataTableResult dataTableResult=logService.findLogList(logSearchParam);
        return dataTableResult;
    }

    //跳转至日志页面
    @RequestMapping("toList")
    public String toList(){
        return "log/logList";
    }

}
