package com.woollen.admin.dao.request;

import lombok.Data;

import java.util.List;

/**
 * @Info:
 * @ClassName: OrderStatisticRequest
 * @Author: weiyang
 * @Data: 2019/11/24 8:39 AM
 * @Version: V1.0
 **/
@Data
public class OrderStatisticRequest {
    private Integer type = 1;
    private List<String> sourceList;
    private List<String> dateList;
}
