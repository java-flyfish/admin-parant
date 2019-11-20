package com.woollen.admin.controller;

import com.github.pagehelper.PageInfo;
import com.woollen.admin.base.BaseController;
import com.woollen.admin.dao.entry.SysUser;
import com.woollen.admin.request.DoRefundRequest;
import com.woollen.admin.request.RefundOrderRequest;
import com.woollen.admin.request.RefundSearchRequest;
import com.woollen.admin.response.Result;
import com.woollen.admin.service.RefundOrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @Info:
 * @ClassName: RefundOrderController
 * @Author: weiyang
 * @Data: 2019/10/13 3:47 PM
 * @Version: V1.0
 **/
@RestController
@RequestMapping("orderRefund")
public class RefundOrderController extends BaseController {

    @Autowired
    private RefundOrderService refundOrderService;

    @PostMapping("createRefund")
    public Result createRefund(HttpServletRequest request, HttpServletResponse response,RefundOrderRequest refundOrderRequest) throws IOException {

        Object object = request.getSession().getAttribute("sysUser");
        if (object == null){
            response.sendRedirect("/");
            return error("请登录");
        }
        SysUser sysUser = (SysUser)object;
        refundOrderRequest.setApplyName(sysUser.getName());
        Boolean flag =  refundOrderService.createRefund(refundOrderRequest);
        return success(flag);
    }

    @GetMapping("listByPage")
    public Result list(RefundSearchRequest request){
        PageInfo pageInfo = refundOrderService.getRefundOrderList(request);
        return success(pageInfo);
    }

    @PostMapping("doRefund")
    public Result doRefund(HttpServletRequest request, HttpServletResponse response,DoRefundRequest refundRequest) throws IOException {
        Object object = request.getSession().getAttribute("sysUser");
        if (object == null){
            response.sendRedirect("/");
            return error("请登录");
        }
        SysUser sysUser = (SysUser)object;
        refundRequest.setCheckName(sysUser.getName());
        Boolean flag =  refundOrderService.doRefund(refundRequest);
        return success(flag);
    }
}
