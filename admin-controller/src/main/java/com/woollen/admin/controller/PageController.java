package com.woollen.admin.controller;

import com.woollen.admin.annocation.NoLoginValidate;
import com.woollen.admin.base.BaseController;
import com.woollen.admin.dao.entry.SysUser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

/*
 * title
 * @Author weiyang
 * @Date 7:15 AM 2019/11/23
 * @Param
 * @return
 **/
@Controller
public class PageController extends BaseController {

    private static final Logger log = LoggerFactory.getLogger(PageController.class);


    /**
     * 根目录
     *
     * @param model
     * @param request
     * @return
     */
    @RequestMapping("/")
    public String toIndex(Model model, HttpServletRequest request) {
        SysUser user = (SysUser)request.getSession().getAttribute("sysUser");
        model.addAttribute("contextPath", request.getContextPath());
        model.addAttribute("userName", user.getName());
        model.addAttribute("email", user.getEmail());
        return "index";
    }

    /**
     * 根目录
     *
     * @param model
     * @param request
     * @return
     */
    @RequestMapping("/login")
    @NoLoginValidate
    public String toLogin(Model model, HttpServletRequest request) {
        model.addAttribute("contextPath", request.getContextPath());
        SysUser user = (SysUser)request.getSession().getAttribute("sysUser");
        if(user != null){
            return "/";
        }
        return "login";
    }
}
