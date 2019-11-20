package com.woollen.admin.request;

import lombok.Data;

/**
 * @Info:
 * @ClassName: DoRefundRequest
 * @Author: weiyang
 * @Data: 2019/11/18 5:36 PM
 * @Version: V1.0
 **/
@Data
public class DoRefundRequest {
    private String seq;
    private String outSeq;
    private String refundSeq;
    private Integer status;
    private String reason;
    private Boolean isAgree;
    private String checkName;
}
