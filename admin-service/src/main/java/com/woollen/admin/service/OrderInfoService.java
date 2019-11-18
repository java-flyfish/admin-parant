package com.woollen.admin.service;

import com.github.pagehelper.PageInfo;
import com.woollen.admin.request.OrderInfoRequest;


/**
 * @Info:
 * @ClassName: OrderInfoService
 * @Author: weiyang
 * @Data: 2019/10/13 3:56 PM
 * @Version: V1.0
 **/
public interface OrderInfoService {
    PageInfo getOrderInfoList(OrderInfoRequest request);
}
