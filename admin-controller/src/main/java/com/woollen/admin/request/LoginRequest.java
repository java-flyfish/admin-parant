package com.woollen.admin.request;

import lombok.Data;

import javax.validation.constraints.NotBlank;

/**
 * @Info:
 * @ClassName: LoginRequest
 * @Author: weiyang
 * @Data: 2019/10/12 5:29 PM
 * @Version: V1.0
 **/
@Data
public class LoginRequest {

    @NotBlank(message = "请输入用户名！")
    private String name;
    @NotBlank(message = "请输入密码！")
    private String password;
}
