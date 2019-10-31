package com.fh.shop.admin.common;

import org.omg.CORBA.ServerRequest;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

public class WebContextFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain){
        //存值
        WebContext.setRequest((HttpServletRequest) servletRequest);
        try {
            //继续后续执行  相当于拦截器return ture
            filterChain.doFilter(servletRequest,servletResponse);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ServletException e) {
            e.printStackTrace();
        }
        finally {
            //释放资源
            WebContext.remove();
        }
    }

    @Override
    public void destroy() {

    }
}
