package com.fh.shop.admin.controller.sort;

import com.fh.shop.admin.biz.sort.ISortService;
import com.fh.shop.admin.common.Log;
import com.fh.shop.admin.common.ServerResponse;
import com.fh.shop.admin.po.sort.Sort;
import com.fh.shop.admin.vo.sort.SortVo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;

@Controller
@RequestMapping("/sort")
public class SortController {

    @Resource(name="sortService")
    private ISortService sortService;

    //删除节点
    @RequestMapping("deleteSort")
    @ResponseBody
    @Log("删除菜单")
    public ServerResponse deleteSort(@RequestParam("nodeIdArr[]") List<Long> ids){
        sortService.deleteSort(ids);
        return ServerResponse.success();
    }

    //修改分类节点
    @RequestMapping("updateSort")
    @ResponseBody
    public ServerResponse updateSort(Sort sort) {
        sortService.updateSort(sort);
        return ServerResponse.success();
    }
    //新增分类节点
    @RequestMapping("addSort")
    @ResponseBody
    public ServerResponse addSort(Sort sort){
        sortService.addSort(sort);
        return ServerResponse.success(sort.getId());
    }
    //查询分类表集合
    @RequestMapping("findSortList")
    @ResponseBody
    public ServerResponse findSortList(){
        List<SortVo> sortVoList = sortService.findSortList();
        return ServerResponse.success(sortVoList);
    }

    //跳转到分类管理页面
    @RequestMapping("/toList")
    public String toList() {
        return "sort/sortList";
    }
}
