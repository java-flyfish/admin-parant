package com.woollen.admin.dao.request;

import lombok.Data;

/**
 * @Info:
 * @ClassName: PvStatisticRequest
 * @Author: weiyang
 * @Data: 2019/10/16 3:03 PM
 * @Version: V1.0
 **/
@Data
public class PvStatisticRequest {
    //统计类型：1.日；2.周；3.月；4.年
    private Integer type = 1;
    //开始时间
    private Long beginTime;
    //结束时间
    private Long endTime;
}
