package com.woollen.admin.service;

import com.woollen.admin.dao.request.UvStatisticRequest;
import com.woollen.admin.dao.response.UvStatisticVo;

import java.util.List;

/**
 * @Info:
 * @ClassName: UvStatisticService
 * @Author: weiyang
 * @Data: 2019/10/16 5:11 PM
 * @Version: V1.0
 **/
public interface UvStatisticService {
    List<UvStatisticVo> statistic(UvStatisticRequest statisticRequest);
}
