package com.fh.shop.admin.aspect;

import org.aspectj.lang.ProceedingJoinPoint;

//aop切面类
public class InfoAspect {

    //自定义一个横切逻辑[非核心代码]
    public Object doInfo(ProceedingJoinPoint pjp){
        Object result = null;
        try {
            //实际执行方法
            result = pjp.proceed();
            //输出
            System.out.println("============横切了");
        } catch (Throwable throwable) {
            throwable.printStackTrace();
            //抛异常
            throw new RuntimeException(throwable);

        }
        return result;
    }
}
