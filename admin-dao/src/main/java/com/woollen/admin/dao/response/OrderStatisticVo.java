package com.woollen.admin.dao.response;

import lombok.Data;

/**
 * @Info:
 * @ClassName: OrderStatisticVo
 * @Author: weiyang
 * @Data: 2019/11/24 8:38 AM
 * @Version: V1.0
 **/
@Data
public class OrderStatisticVo {
    private String source;
    private Integer sumOrder;
    private Integer payOrder;
    private Integer sumPay;
    private String time;
}
