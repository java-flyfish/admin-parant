package com.woollen.admin.controller;

import com.woollen.admin.base.BaseController;
import com.woollen.admin.dao.entry.OrderInfo;
import com.woollen.admin.response.Result;
import com.woollen.admin.service.OrderInfoService;
import com.woollen.admin.request.OrderInfoRequest;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * @Info:
 * @ClassName: OrderInfoController
 * @Author: weiyang
 * @Data: 2019/10/13 3:45 PM
 * @Version: V1.0
 **/
@RestController
@RequestMapping("orderInfo")
public class OrderInfoController extends BaseController {

    @Autowired
    private OrderInfoService orderInfoService;

    @GetMapping("list")
    public Result list(OrderInfoRequest request){
        OrderInfo orderInfo = new OrderInfo();
        BeanUtils.copyProperties(request,orderInfo);
        List<OrderInfo> list = orderInfoService.getOrderInfoList(request);
        return success(list);
    }
}
