package com.woollen.admin.dao.response;

import lombok.Data;

/**
 * @Info:
 * @ClassName: PvStatisticVo
 * @Author: weiyang
 * @Data: 2019/10/16 3:32 PM
 * @Version: V1.0
 **/
@Data
public class PvStatisticVo {

    //渠道
    private String source;

    //页面打开量
    private Integer click;

    //点击下单量
    private Integer order;

    //点击支付数量
    private Integer pay;

    //订单总数
    private Integer sumOrder;

    //支付订单总数
    private Integer payOrder;

    //支付订单总金额
    private Integer sumPay;

    //时间
    private String time;
}
