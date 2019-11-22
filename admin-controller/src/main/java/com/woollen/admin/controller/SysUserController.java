package com.woollen.admin.controller;

import com.github.pagehelper.PageInfo;
import com.woollen.admin.annocation.NoLoginValidate;
import com.woollen.admin.base.BaseController;
import com.woollen.admin.dao.entry.SysUser;
import com.woollen.admin.exception.APException;
import com.woollen.admin.request.LoginRequest;
import com.woollen.admin.response.Result;
import com.woollen.admin.service.SysUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.io.IOException;
import java.util.List;


/**
 * @Info:
 * @ClassName: SysUserController
 * @Author: weiyang
 * @Data: 2019/10/12 5:22 PM
 * @Version: V1.0
 **/
@Controller
@RequestMapping("sysUser")
public class SysUserController extends BaseController {

    @Autowired
    private SysUserService sysUserService;

    @RequestMapping(value = "login",method = RequestMethod.POST)
    @NoLoginValidate
    @ResponseBody
    public Result login(HttpServletRequest request,@Valid LoginRequest loginRequest, BindingResult result){
        if(result.hasErrors()){
            for (ObjectError error : result.getAllErrors()) {
                throw new APException(error.getDefaultMessage());
            }
        }

        SysUser sysUser = sysUserService.selectNamaAndPassword(loginRequest.getName(),loginRequest.getPassword());
        if (sysUser == null){
            throw new APException("用户名或密码错误");
            //return "login";
        }
        request.getSession().setAttribute("sysUser",sysUser);
        return success("成功登陆！");
//        request.getSession().setAttribute("sysUser",sysUser);
//        return "/";
    }

    @GetMapping("logout")
    public Result loginOut(HttpServletRequest request,HttpServletResponse response){

        request.getSession().removeAttribute("sysUser");
        try {
            response.sendRedirect("/");
        } catch (IOException e) {
            e.printStackTrace();
        }
        return success("成功退出登陆！");
    }

    @RequestMapping(value = "/listByPage", method = RequestMethod.GET)
    @ResponseBody
    public Result listByPage(HttpServletRequest request, HttpServletResponse response,
                             @RequestParam Integer pageNum,
                             @RequestParam(required = false) Integer pageSize,
                             @RequestParam(required = false) String search) throws Exception {

        List<SysUser> userList = sysUserService.selectByCondition(search, pageNum, pageSize);


        return success(new PageInfo<>(userList));
    }

    @RequestMapping(value = "/modify", method = RequestMethod.POST)
    @ResponseBody
    public Result modify(HttpServletRequest request, HttpServletResponse response, @RequestBody SysUser sysUser) throws Exception {

        if (sysUser.getId() == null) {
            sysUser.insert();
        } else {
            sysUser.updateById();
        }

        return success(true);
    }

    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    @ResponseBody
    public Result delete(HttpServletRequest request, HttpServletResponse response, @RequestParam Integer id) throws Exception {

        Integer num = sysUserService.deleteById(id);

        return success(true);
    }

}
