package com.woollen.admin.request;

import lombok.Data;

/**
 * @Info:
 * @ClassName: RefundSearchRequest
 * @Author: weiyang
 * @Data: 2019/11/20 9:46 AM
 * @Version: V1.0
 **/
@Data
public class RefundSearchRequest {

    //订单号
    private String seq;

    //退款单号
    private String refundSeq;

    /**
     * 申请退款时间开始
     */
    private Long begin;

    /**
     * 申请退款时间结束
     */
    private Long end;

    private Integer pageNum = 1;

    private Integer pageSize = 10;
}
