package com.fh.shop.admin.controller.role;

import com.fh.shop.admin.biz.role.IRoleService;
import com.fh.shop.admin.common.DataTableResult;
import com.fh.shop.admin.common.Log;
import com.fh.shop.admin.common.ServerResponse;
import com.fh.shop.admin.param.role.RoleSearchParam;
import com.fh.shop.admin.po.role.Role;
import com.fh.shop.admin.po.user.User;
import com.fh.shop.admin.util.SystemConstant;
import com.fh.shop.admin.vo.role.RoleVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/role")
public class RoleController {
    @Resource(name="roleService")
    private IRoleService roleService;

    //角色分页查询
    @RequestMapping("/findRoleList")
    @ResponseBody
    public DataTableResult findRoleList(RoleSearchParam roleSearchParam){
        DataTableResult dataTableResult=roleService.findRolePageList(roleSearchParam);
        return dataTableResult;
    }

    @RequestMapping("/roleList")
    @ResponseBody
    public ServerResponse roleList(){
        List<Role> roleList=roleService.roleList();
        return ServerResponse.success(roleList);
    }

    /*回显*/
    @RequestMapping("/findRole")
    @ResponseBody
    public ServerResponse findRole(Long id){
        RoleVo roleVo=roleService.findRole(id);
        return ServerResponse.success(roleVo);
    }

    /*修改*/
    @RequestMapping("/updateRole")
    @ResponseBody
    @Log("修改角色")
    public ServerResponse updateRole(Role role,@RequestParam("resourceIdArr[]") List<Long> resourceIdArr){
        roleService.updateRole(role,resourceIdArr);
        return ServerResponse.success();
    }

    /*角色新增*/
    @RequestMapping("/addRole")
    @ResponseBody
    @Log("新增角色")
    public ServerResponse addRole(Role role, @RequestParam(value = "resourceIdArr[]",required = false) List<Long> resourceIdArr){
        roleService.addRole(role,resourceIdArr);
        return ServerResponse.success();

    }

    /*删除*/
    @Log("删除角色")
    @RequestMapping("/deleteRoleById")
    @ResponseBody
    public ServerResponse deleteRoleById(Long id){
        ServerResponse serverResponse = roleService.deleteRoleById(id);
        return serverResponse;

    }

    //跳转角色页面
    @RequestMapping("toList")
    public String toList(){
        return "role/roleList";
    }

}
