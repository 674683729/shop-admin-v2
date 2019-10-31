package com.fh.shop.admin.controller.resource;

import com.fh.shop.admin.biz.resource.IResourceService;
import com.fh.shop.admin.common.Log;
import com.fh.shop.admin.common.ServerResponse;
import com.fh.shop.admin.po.user.User;
import com.fh.shop.admin.util.SystemConstant;
import com.fh.shop.admin.vo.resource.ResourceVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/resource")
public class ResourceController {
    @Resource(name="resourceService")
    private IResourceService resourceService;
    @Autowired(required = false)
    private HttpServletRequest request;

    //查询资源表集合
    @RequestMapping("/findResourceList")
    @ResponseBody
    public ServerResponse findResourceList(){
        List<ResourceVo> resourceVoList = resourceService.findResourceList();
        return ServerResponse.success(resourceVoList);
    }

    //根据登陆的用户查询菜单树
    @RequestMapping("findResourceByUserId")
    @ResponseBody
    public ServerResponse findResourceByUserId(){
        //取出session中的菜单信息
        List<com.fh.shop.admin.po.resource.Resource> menuList = (List<com.fh.shop.admin.po.resource.Resource>)request.getSession().getAttribute(SystemConstant.LOGIN_USER_RESOURCE);
        return ServerResponse.success(menuList);
    }

    //新增节点
    @RequestMapping("/addResource")
    @ResponseBody
    @Log("新增菜单")
    public ServerResponse addResource(com.fh.shop.admin.po.resource.Resource resource){
        resourceService.addResource(resource);
        return ServerResponse.success(resource.getId());
    }

    //回显菜单名
    @RequestMapping("/findResource")
    @ResponseBody
    public ServerResponse findResource(Long id){
        ResourceVo resourceVo=resourceService.findResource(id);
        return ServerResponse.success(resourceVo);
    }

    //修改
    @RequestMapping("/updateResource")
    @ResponseBody
    @Log("修改菜单")
    public ServerResponse updateResource(com.fh.shop.admin.po.resource.Resource resource){
        resourceService.updateResource(resource);
        return ServerResponse.success();
    }

    //删除节点
    @RequestMapping("deleteResource")
    @ResponseBody
    @Log("删除菜单")
    public ServerResponse deleteResource(@RequestParam("nodeIdArr[]") List<Integer> ids){
        resourceService.deleteResource(ids);
        return ServerResponse.success();
    }

    //跳转菜单资源页面
    @RequestMapping("toList")
    public String toList(){
        return "resource/resourceList";
    }
}
