package com.woollen.admin.service;

import com.github.pagehelper.PageInfo;
import com.woollen.admin.dao.response.PvStatisticVo;
import com.woollen.admin.dao.request.PvStatisticRequest;

import java.util.List;

/**
 * @Info:
 * @ClassName: PvStatisticService
 * @Author: weiyang
 * @Data: 2019/10/16 3:27 PM
 * @Version: V1.0
 **/
public interface PvStatisticService {
    PageInfo statistic(PvStatisticRequest statisticRequest);
}
