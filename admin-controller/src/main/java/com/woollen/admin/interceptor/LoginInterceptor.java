package com.woollen.admin.interceptor;

import com.alibaba.fastjson.JSONObject;
import com.woollen.admin.annocation.NoLoginValidate;
import com.woollen.admin.dao.entry.SysMenu;
import com.woollen.admin.dao.entry.SysRole;
import com.woollen.admin.dao.entry.SysUser;
import com.woollen.admin.response.Result;
import com.woollen.admin.service.SysMenuService;
import com.woollen.admin.service.SysRoleService;
import com.woollen.admin.service.SysUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.List;

/**
 * @Info:
 * @ClassName: LoginInterceptor
 * @Author: weiyang
 * @Data: 2019/10/11 5:49 PM
 * @Version: V1.0
 **/
@Component
public class LoginInterceptor implements HandlerInterceptor {

    @Autowired
    private SysUserService sysUserService;

    @Autowired
    private SysRoleService sysRoleService;

    @Autowired
    private SysMenuService sysMenuService;

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
        Object user = session.getAttribute("sysUser");
        if(user == null){
            Result result = new Result("请登录！",false,"请登录！");
            PrintWriter writer = response.getWriter();
            writer.write(JSONObject.toJSONString(result));
            writer.close();
            return false;
        }
        SysUser sysUser = (SysUser)user;
        Integer roleId = sysUser.getRoleId();
        //获取用户角色
        SysRole sysRole = sysRoleService.getSysRoleById(roleId);
        List<String> ids = Arrays.asList(sysRole.getMenuIds().split(","));
        List<SysMenu> sysMenus = sysMenuService.getMenuByRoleIds(ids);


        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {

    }
}
