package com.woollen.admin.service;

import com.woollen.admin.request.RefundOrderRequest; /**
 * @Info:
 * @ClassName: RefundOrder
 * @Author: weiyang
 * @Data: 2019/11/18 5:34 PM
 * @Version: V1.0
 **/
public interface RefundOrderService {
    Boolean createRefund(RefundOrderRequest refundOrderRequest);
}
