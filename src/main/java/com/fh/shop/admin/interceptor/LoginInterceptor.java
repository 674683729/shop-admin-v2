package com.fh.shop.admin.interceptor;

import com.fh.shop.admin.po.resource.Resource;
import com.fh.shop.admin.po.user.User;
import com.fh.shop.admin.util.SystemConstant;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

public class LoginInterceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		User user=(User)request.getSession().getAttribute(SystemConstant.CUURREND_USER);


		List<Resource> resourceList = (List<Resource>)request.getSession().getAttribute(SystemConstant.LOGIN_USER_RESOURCE);


		if (user != null) {
			return true;
		}else{
			response.sendRedirect("/");
			return false;
		}
		
	}



}
