package com.fh.shop.admin.aspect;

import com.fh.shop.admin.biz.log.ILogService;
import com.fh.shop.admin.common.WebContext;
import com.fh.shop.admin.po.log.Log;
import com.fh.shop.admin.po.user.User;
import com.fh.shop.admin.util.SystemConstant;
import org.apache.commons.lang.StringUtils;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.reflect.MethodSignature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.lang.annotation.Annotation;
import java.lang.reflect.Method;
import java.util.Date;
import java.util.Iterator;
import java.util.Map;

//日志切面类
public class LogAspect {
    @Resource(name="logService")
    private ILogService logService;

    private static final Logger LOGGER=LoggerFactory.getLogger(LogAspect.class);

    //横切逻辑 [非核心业务代码]
    public Object doLog(ProceedingJoinPoint pjp){
        //获取类名
        String className = pjp.getTarget().getClass().getCanonicalName();
        //获取方法名
        String methodName = pjp.getSignature().getName();
        //获取用户
        HttpServletRequest request = WebContext.getRequest();
        User userInfo = (User) request.getSession().getAttribute(SystemConstant.CUURREND_USER);
        //获取参数详情
        StringBuffer detail = getParamDetail(request);
        //获取方法签名
        MethodSignature methodSignature = (MethodSignature) pjp.getSignature();
        //通过方法签名获取method
        Method method = methodSignature.getMethod();
        String value="";
        if (method.isAnnotationPresent(com.fh.shop.admin.common.Log.class)){
            Annotation annotation = method.getAnnotation(com.fh.shop.admin.common.Log.class);
            value = ((com.fh.shop.admin.common.Log) annotation).value();
        }
        //实际执行的方法
        Object result = null;
        try {
            //实际执行的方法
            result = pjp.proceed();
            //获取session中的用户信息
            //输出日志信息
            LOGGER.info(userInfo.getRealName()+"执行了"+className+"中的"+methodName+"方法成功");
            //存储到数据库
            Log log = new Log();
            log.setUserName(userInfo.getUserName());
            log.setRealName(userInfo.getRealName());
            log.setCurrTime(new Date());
            log.setInfo("执行了"+className+"中的"+methodName+"方法成功");
            log.setStatus(SystemConstant.LOG_STATTUS_SUCCESS);
            log.setDetail(detail.toString());
            log.setContext(value);
            logService.addLog(log);

        } catch (Throwable throwable) {
            throwable.printStackTrace();
            //记录异常信息到日志
            LOGGER.error(userInfo.getRealName()+"执行了"+className+"中的"+methodName+"方法失败:"+throwable.getMessage());
            //存储到数据库
            Log log = new Log();
            log.setUserName(userInfo.getUserName());
            log.setRealName(userInfo.getRealName());
            log.setCurrTime(new Date());
            log.setStatus(SystemConstant.LOG_STATTUS_ERROR);
            log.setErrorMsg(throwable.getMessage());
            log.setDetail(detail.toString());
            log.setContext(value);
            logService.addLog(log);
            //抛异常
            throw new RuntimeException(throwable);
        }
        return result;
    }

    //获取参数详情
    private StringBuffer getParamDetail(HttpServletRequest request) {
        Map<String, String[]> detailMap = request.getParameterMap();
        Iterator<Map.Entry<String, String[]>> iterator = detailMap.entrySet().iterator();
        StringBuffer detail=new StringBuffer();
        while (iterator.hasNext()){
            Map.Entry<String, String[]> next = iterator.next();
            String key = next.getKey();
            String[] value = next.getValue();
            detail.append(",").append(key).append(":").append(StringUtils.join(value,","));
        }
        return detail;
    }
}
