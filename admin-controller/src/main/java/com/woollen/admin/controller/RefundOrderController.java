package com.woollen.admin.controller;

import com.woollen.admin.base.BaseController;
import com.woollen.admin.request.RefundOrderRequest;
import com.woollen.admin.response.Result;
import com.woollen.admin.service.RefundOrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
    public Result createRefund(RefundOrderRequest refundOrderRequest){

        Boolean flag =  refundOrderService.createRefund(refundOrderRequest);
        return success(flag);
    }
}
