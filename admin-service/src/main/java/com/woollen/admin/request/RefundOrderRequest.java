package com.woollen.admin.request;

import lombok.Data;

/**
 * @Info:
 * @ClassName: RefundOrderRequest
 * @Author: weiyang
 * @Data: 2019/11/18 5:36 PM
 * @Version: V1.0
 **/
@Data
public class RefundOrderRequest {
    private String seq;
    private Long refundFee;
    private String comment;
    private String applyName;
}
