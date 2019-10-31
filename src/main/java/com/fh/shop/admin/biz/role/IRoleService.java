package com.fh.shop.admin.biz.role;

import com.fh.shop.admin.common.DataTableResult;
import com.fh.shop.admin.common.ServerResponse;
import com.fh.shop.admin.param.role.RoleSearchParam;
import com.fh.shop.admin.po.role.Role;
import com.fh.shop.admin.vo.role.RoleVo;

import java.util.List;

public interface IRoleService {
    List<Role> roleList();

    RoleVo findRole(Long id);

    void updateRole(Role role,List<Long> resourceIdArr);

    void addRole(Role role,List<Long> resourceIdArr);

    ServerResponse deleteRoleById(Long id);

    DataTableResult findRolePageList(RoleSearchParam roleSearchParam);
}
