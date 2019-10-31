package com.fh.shop.admin.biz.role;

import com.fh.shop.admin.common.DataTableResult;
import com.fh.shop.admin.common.ResponseEnum;
import com.fh.shop.admin.common.ServerResponse;
import com.fh.shop.admin.mapper.role.IRoleMapper;
import com.fh.shop.admin.param.role.RoleSearchParam;
import com.fh.shop.admin.po.role.Role;
import com.fh.shop.admin.po.role.RoleResource;
import com.fh.shop.admin.po.role.UserRole;
import com.fh.shop.admin.vo.role.RoleVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service("roleService")
public class IRoleServiceImpl implements IRoleService {
    @Autowired
    private IRoleMapper roleMapper;

    //查询所有角色
    @Override
    public List<Role> roleList() {
        List<Role> roleList= roleMapper.roleList();
        return roleList;
    }

    //分页查询
    @Override
    public DataTableResult findRolePageList(RoleSearchParam roleSearchParam) {
        //查询角色总条数
        Long totalCount=roleMapper.findRoleCount(roleSearchParam);
        //查询当前页数据
        List<Role> rolePageList = roleMapper.findRolePageList(roleSearchParam);
        DataTableResult dataTableResult=new DataTableResult(roleSearchParam.getDraw(),totalCount,totalCount,rolePageList);
        return dataTableResult;
    }

    //新增角色
    @Override
    public void addRole(Role role,List<Long> resourceIdArr) {
        //新增角色 需要返回id
        roleMapper.addRole(role);
        //批量新增角色和资源中间表数据
        if (resourceIdArr != null){
            batchAddRoleResource(role, resourceIdArr);
        }
    }

    private void batchAddRoleResource(Role role, List<Long> resourceIdArr) {
        List<RoleResource> roleResourcesList=new ArrayList<>();
        for (Long rId : resourceIdArr) {
            RoleResource roleResource=new RoleResource();
            roleResource.setRoleId(role.getId());
            roleResource.setResourceId(rId);
            roleResourcesList.add(roleResource);
        }
        roleMapper.addRoleResource(roleResourcesList);
    }

    //通过id删除单个角色
    @Override
    public ServerResponse deleteRoleById(Long id) {
        //判断角色是否有用户在使用 如果是 不能删除
        List<UserRole> userRoleList=roleMapper.findUserRole(id);
        if (userRoleList.size() > 0){
            //被占用 不能删除
            return ServerResponse.error(ResponseEnum.DBY);
        }else{
            //删除中间表数据
            roleMapper.deleteRoleResource(id);
            //删除角色
            roleMapper.deleteRoleById(id);
            return ServerResponse.success();
        }

    }

    //通过id查询单个角色
    @Override
    public RoleVo findRole(Long id) {
        //查询角色信息
        Role role = roleMapper.findRole(id);
        RoleVo roleVo=new RoleVo();
        roleVo.setId(role.getId());
        roleVo.setRoleName(role.getRoleName());
        //查询相关的resourceId
        List<Long> resourceIdList=roleMapper.findResourceIdArr(id);
        roleVo.setResourceIdList(resourceIdList);
        return roleVo;
    }

    //修改角色
    @Override
    public void updateRole(Role role,List<Long> resourceIdArr) {
        //先删除中间表数据
        roleMapper.deleteRoleResource(role.getId());
        //批量新增中间表数据
        if (resourceIdArr != null) {
            batchAddRoleResource(role, resourceIdArr);
        }
    }


}
