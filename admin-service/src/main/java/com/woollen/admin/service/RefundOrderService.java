package com.woollen.admin.service;

import com.github.pagehelper.PageInfo;
import com.woollen.admin.request.DoRefundRequest;
import com.woollen.admin.request.RefundOrderRequest;
import com.woollen.admin.request.RefundSearchRequest;

/**
 * @Info:
 * @ClassName: RefundOrder
 * @Author: weiyang
 * @Data: 2019/11/18 5:34 PM
 * @Version: V1.0
 **/
public interface RefundOrderService {
    Boolean createRefund(RefundOrderRequest refundOrderRequest);

    PageInfo getRefundOrderList(RefundSearchRequest request);

    Boolean doRefund(DoRefundRequest request);
}
