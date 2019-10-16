package com.woollen.admin;

import com.woollen.admin.base.BaseController;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @Info:
 * @ClassName: HelloController
 * @Author: weiyang
 * @Data: 2019/10/10 10:24 AM
 * @Version: V1.0
 **/
@RestController
public class HelloController extends BaseController {

    @GetMapping("hello")
    public String hello() {
        return "hello";
    }
}
