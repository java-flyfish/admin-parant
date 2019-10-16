package com.woollen.admin;

import com.woollen.admin.annocation.NoLoginValidate;
import com.woollen.admin.base.BaseController;
import com.woollen.admin.dao.entry.SysUser;
import com.woollen.admin.exception.APException;
import com.woollen.admin.request.LoginRequest;
import com.woollen.admin.response.Result;
import com.woollen.admin.service.SysUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;


/**
 * @Info:
 * @ClassName: SysUserController
 * @Author: weiyang
 * @Data: 2019/10/12 5:22 PM
 * @Version: V1.0
 **/
@RestController
@RequestMapping("sysUser")
public class SysUserController extends BaseController {

    @Autowired
    private SysUserService sysUserService;

    @PostMapping("login")
    @NoLoginValidate
    public Result login(HttpServletRequest request,@Valid LoginRequest loginRequest, BindingResult result){
        if(result.hasErrors()){
            for (ObjectError error : result.getAllErrors()) {
                throw new APException(error.getDefaultMessage());
            }
        }

        SysUser sysUser = sysUserService.selectNamaAndPassword(loginRequest.getName(),loginRequest.getPassword());
        if (sysUser == null){
            throw new APException("用户名或密码错误！");
        }
        request.getSession().setAttribute("sysUser",sysUser);
        return success("登陆成功！");
    }

    @PostMapping("loginOut")
    public Result loginOut(HttpServletRequest request){

        request.getSession().removeAttribute("sysUser");
        return success("成功退出登陆！");
    }
}
