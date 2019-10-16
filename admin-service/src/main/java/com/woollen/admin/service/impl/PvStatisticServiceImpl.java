package com.woollen.admin.service.impl;

import com.woollen.admin.dao.mapper.PvStatisticMapperExter;
import com.woollen.admin.dao.response.PvStatisticVo;
import com.woollen.admin.dao.request.PvStatisticRequest;
import com.woollen.admin.service.PvStatisticService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Info:
 * @ClassName: PvStatisticServiceImpl
 * @Author: weiyang
 * @Data: 2019/10/16 3:28 PM
 * @Version: V1.0
 **/
@Service
public class PvStatisticServiceImpl implements PvStatisticService {

    @Autowired
    private PvStatisticMapperExter pvStatisticMapperExter;

    @Override
    public List<PvStatisticVo> statistic(PvStatisticRequest statisticRequest) {
        List<PvStatisticVo> pvStatisticVos = pvStatisticMapperExter.statisticPv(statisticRequest);
        return pvStatisticVos;
    }
}
