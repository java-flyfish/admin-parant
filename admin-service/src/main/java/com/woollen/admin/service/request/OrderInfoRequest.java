package com.woollen.admin.service.request;

import lombok.Data;

/**
 * @Info:
 * @ClassName: OrderInfoRequest
 * @Author: weiyang
 * @Data: 2019/10/13 3:52 PM
 * @Version: V1.0
 **/
@Data
public class OrderInfoRequest {
    /**
     * 订单号
     */
    private String seq;

    /**
     * 第三方交易单号
     */
    private String outSeq;

    /**
     * 姓名
     */
    private String name;

    /**
     * 手机号
     */
    private String phone;

    /**
     * 1:待付款，2:已付款，3:申请退款，4:退款审核中，5:退款完成，6:退款失败，9:订单过期
     */
    private Integer status;

    /**
     * 广告来源
     */
    private String adtSource;

    /**
     * 支付渠道
     */
    private Integer payChannel;

    /**
     * 支付时间开始
     */
    private Long begin;

    /**
     * 支付时间结束
     */
    private Long end;
}
