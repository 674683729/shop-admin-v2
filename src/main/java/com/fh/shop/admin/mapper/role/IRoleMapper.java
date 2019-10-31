package com.fh.shop.admin.mapper.role;

import com.fh.shop.admin.param.role.RoleSearchParam;
import com.fh.shop.admin.po.role.Role;
import com.fh.shop.admin.po.role.RoleResource;
import com.fh.shop.admin.po.role.UserRole;

import java.util.List;

public interface IRoleMapper {
    List<Role> roleList();

    Long findRoleCount(RoleSearchParam roleSearchParam);

    List<Role> findRolePageList(RoleSearchParam roleSearchParam);

    void addRole(Role role);

    void deleteRoleById(Long id);

    Role findRole(Long id);

    void updateRole(Role role);

    void addRoleResource(List<RoleResource> roleResourcesList);

    List<Long> findResourceIdArr(Long id);

    void deleteRoleResource(Long id);

    List<UserRole> findUserRole(Long id);
}
