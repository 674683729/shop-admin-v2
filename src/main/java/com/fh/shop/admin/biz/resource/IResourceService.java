package com.fh.shop.admin.biz.resource;

import com.fh.shop.admin.po.resource.Resource;
import com.fh.shop.admin.vo.resource.ResourceVo;

import java.util.List;

public interface IResourceService {
    List<ResourceVo> findResourceList();

    void addResource(Resource resource);

    ResourceVo findResource(Long id);

    void updateResource(Resource resource);


    void deleteResource(List<Integer> ids);

    List<Resource> findResourceByUserId(Long id);

    List<Resource> findUserAllResource(Long id);
}
