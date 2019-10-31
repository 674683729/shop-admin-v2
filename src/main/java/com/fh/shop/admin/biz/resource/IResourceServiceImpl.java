package com.fh.shop.admin.biz.resource;

import com.fh.shop.admin.mapper.resource.IResourceMapper;
import com.fh.shop.admin.vo.resource.ResourceVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service("resourceService")
public class IResourceServiceImpl implements IResourceService {
    @Autowired
    private IResourceMapper resourceMapper;

    //查询资源表集合
    public List<ResourceVo> findResourceList(){
        List<com.fh.shop.admin.po.resource.Resource> resourceList = resourceMapper.findResourceList();

        List<ResourceVo> resourceVoList=new ArrayList<>();
        //po转vo
        for (com.fh.shop.admin.po.resource.Resource resource : resourceList) {
            ResourceVo resourceVo = getResourceVo(resource);
            resourceVoList.add(resourceVo);
        }
        return resourceVoList;
    }

    private ResourceVo getResourceVo(com.fh.shop.admin.po.resource.Resource resource) {
        ResourceVo resourceVo = new ResourceVo();
        resourceVo.setId(resource.getId());
        resourceVo.setName(resource.getMenuName());
        resourceVo.setpId(resource.getFatherId());
        resourceVo.setMenuType(resource.getMenuType());
        resourceVo.setMenuUrl(resource.getUrl());
        return resourceVo;
    }

    //新增节点
    @Override
    public void addResource(com.fh.shop.admin.po.resource.Resource resource) {
        resourceMapper.addResource(resource);
    }

    //回显
    @Override
    public ResourceVo findResource(Long id) {
        com.fh.shop.admin.po.resource.Resource resource=resourceMapper.findResource(id);
        ResourceVo resourceVo = getResourceVo(resource);
        return resourceVo;
    }

    //修改
    @Override
    public void updateResource(com.fh.shop.admin.po.resource.Resource resource) {
        resourceMapper.updateResource(resource);
    }

    //删除节点数组
    @Override
    public void deleteResource(List<Integer> ids) {
        //批量删除节点
        resourceMapper.deleteResource(ids);
        //删除中间表数据
        resourceMapper.deleteRoleResource(ids);
    }

    //根据用户查询菜单树
    @Override
    public List<com.fh.shop.admin.po.resource.Resource> findResourceByUserId(Long id) {
        List<com.fh.shop.admin.po.resource.Resource> resourceList=resourceMapper.findResourceByUserId(id);
        return resourceList;
    }

    //查询当前用户的所有资源
    @Override
    public List<com.fh.shop.admin.po.resource.Resource> findUserAllResource(Long id) {
        final List<com.fh.shop.admin.po.resource.Resource> userAllResource = resourceMapper.findUserAllResource(id);
        return userAllResource;
    }

}
