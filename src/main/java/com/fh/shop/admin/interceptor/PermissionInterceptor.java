package com.fh.shop.admin.interceptor;

import com.alibaba.fastjson.JSONObject;
import com.fh.shop.admin.po.resource.Resource;
import com.fh.shop.admin.util.SystemConstant;
import com.fh.shop.admin.vo.resource.ResourceVo;
import org.apache.commons.lang.StringUtils;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PermissionInterceptor extends HandlerInterceptorAdapter {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        //获取请求的uri
        String uri = request.getRequestURI();
        //获取当前登录的导航栏菜单集合
        List<Resource> menuList = (List<Resource>) request.getSession().getAttribute(SystemConstant.LOGIN_USER_RESOURCE);
        //获取所有的菜单集合
        List<ResourceVo> resourceList = (List<ResourceVo>) request.getSession().getAttribute(SystemConstant.RESOURCE_LIST);
        //取出当前登录用户的所有资源菜单
        List<Resource> userResourceList = (List<Resource>) request.getSession().getAttribute(SystemConstant.LOGIN_USER_ALL_RESOURCE);

        //判断是不是公共访问资源 是 继续  不是 验证下面是否拥有权限
        boolean isPublic = true;
        for (ResourceVo resourceVo : resourceList) {
            if (StringUtils.isNotEmpty(resourceVo.getMenuUrl()) && uri.contains(resourceVo.getMenuUrl())){
                isPublic = false;
                break;
            }
        }

        //是公共资源返回
        if(isPublic){
            return true;
        }

        //判断当前用户是否拥有此菜单
        boolean hasMenuPermission = false;

        for (Resource resource : userResourceList) {
            //是否包含此权限
            if (StringUtils.isNotEmpty(resource.getUrl()) && uri.contains(resource.getUrl())){
                hasMenuPermission = true;
                break;
            }
        }

        //判断是否被拦截
        if (!hasMenuPermission){
            //判断是否是按钮级别 是否是ajax请求
            String header = request.getHeader("X-Requested-With");
            if (StringUtils.isNotEmpty(header) && header.equals("XMLHttpRequest")){
                //是ajax请求
                Map resultMap = new HashMap<>();
                resultMap.put("code",-10000);
                resultMap.put("msg","您没有权限");
                String json = JSONObject.toJSONString(resultMap);
                outjson(json,response);
            }else{
                response.sendRedirect(SystemConstant.INTERCEPTOR);
            }

        }
        return hasMenuPermission;
    }

    private void outjson(String json,HttpServletResponse response){
        PrintWriter writer=null;
        try {
            response.setContentType("application/json;charset=utf-8");
            writer = response.getWriter();
            writer.write(json);
            writer.flush();
        } catch (IOException e) {
            e.printStackTrace();
        }finally {
            if (writer != null){
                writer.close();
                writer = null;
            }
        }

    }
}
