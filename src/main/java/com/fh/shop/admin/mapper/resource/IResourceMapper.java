package com.fh.shop.admin.mapper.resource;

import com.fh.shop.admin.po.resource.Resource;
import com.fh.shop.admin.po.role.Role;

import java.util.List;

public interface IResourceMapper {
    List<Resource> findResourceList();

    void addResource(Resource resource);

    com.fh.shop.admin.po.resource.Resource findResource(Long id);

    void updateResource(Resource resource);

    void deleteResource(List<Integer> ids);

    List<Resource> findResourceByUserId(Long id);

    void deleteRoleResource(List<Integer> ids);

    List<Resource> findUserAllResource(Long id);
}
