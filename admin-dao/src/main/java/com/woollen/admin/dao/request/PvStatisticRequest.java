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
    //统计类型：0.全局；1.年；2.月；3.周；4.日；5.小时
    private Integer type = 1;
    //渠道
    private String source;
    //页面url
    private String path;
    //开始时间
    private Long beginTime;
    //结束时间
    private Long endTime;

    private Integer pageNum = 1;

    private Integer pageSize = 10;
}
