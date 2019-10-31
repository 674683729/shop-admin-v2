package com.fh.shop.admin.biz;

import com.fh.shop.admin.biz.resource.IResourceService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractJUnit4SpringContextTests;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;


@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"classpath:spring/spring-common.xml"})
public class TestResource extends AbstractJUnit4SpringContextTests {

    @Resource(name="resourceService")
    private IResourceService resourceService;

    //新增菜单
    @Test
    public void addResource(){
        com.fh.shop.admin.po.resource.Resource resource = new com.fh.shop.admin.po.resource.Resource();
        resource.setFatherId(1L);
        resource.setMenuName("dsadas");
        resource.setMenuType(1);
        resource.setUrl("555");
        resourceService.addResource(resource);
    }

    //删除菜单
    @Test
    public void deleteResource(){
        List<Integer> list=new ArrayList<>();
        list.add(88);
        list.add(99);
        resourceService.deleteResource(list);
    }

    //修改菜单
    @Test
    public void updateResource(){
        com.fh.shop.admin.po.resource.Resource resource = new com.fh.shop.admin.po.resource.Resource();
        resource.setId(88L);
        resource.setFatherId(1L);
        resource.setMenuName("大萨达所");
        resource.setMenuType(1);
        resource.setUrl("666");
        resourceService.updateResource(resource);
    }
}
