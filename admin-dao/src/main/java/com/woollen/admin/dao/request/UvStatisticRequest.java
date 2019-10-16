package com.woollen.admin.dao.request;

import lombok.Data;

/**
 * @Info:
 * @ClassName: UvStatisticRequest
 * @Author: weiyang
 * @Data: 2019/10/16 5:05 PM
 * @Version: V1.0
 **/
@Data
public class UvStatisticRequest {
    //统计类型：1.日；2.周；3.月；4.年
    private Integer uvType = 1;
    //类型，1:登陆，2:注册，3：其他',
    private Integer type;
    //开始时间
    private Long beginTime;
    //结束时间
    private Long endTime;
}
