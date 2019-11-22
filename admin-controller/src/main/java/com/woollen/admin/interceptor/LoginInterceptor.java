package com.woollen.admin.interceptor;

import com.woollen.admin.annocation.NoLoginValidate;
import com.woollen.admin.dao.entry.SysUser;
import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * @Info:
 * @ClassName: LoginInterceptor
 * @Author: weiyang
 * @Data: 2019/10/11 5:49 PM
 * @Version: V1.0
 **/
@Component
public class LoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        if (handler instanceof HandlerMethod){
            HandlerMethod handlerMethod = (HandlerMethod) handler;
            NoLoginValidate noLoginValidate = handlerMethod.getMethodAnnotation(NoLoginValidate.class);
            // 无需校验
            if (noLoginValidate != null) {
                return true;
            }
        }
        HttpSession session = request.getSession();
        SysUser user = (SysUser)session.getAttribute("sysUser");
        if(user == null){
            String toLogin = request.getScheme() + "://" + request.getHeader("host") + "/login";
            response.sendRedirect(toLogin);
            return false;
        }
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {

    }
}
