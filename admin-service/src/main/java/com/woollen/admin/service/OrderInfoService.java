package com.woollen.admin.service;

import com.woollen.admin.dao.entry.OrderInfo;
import com.woollen.admin.request.OrderInfoRequest;

import java.util.List;

/**
 * @Info:
 * @ClassName: OrderInfoService
 * @Author: weiyang
 * @Data: 2019/10/13 3:56 PM
 * @Version: V1.0
 **/
public interface OrderInfoService {
    List<OrderInfo> getOrderInfoList(OrderInfoRequest request);
}
