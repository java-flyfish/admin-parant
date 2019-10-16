package com.woollen.admin.service.impl;

import com.woollen.admin.dao.mapper.UvStatisticMapperExter;
import com.woollen.admin.dao.request.UvStatisticRequest;
import com.woollen.admin.dao.response.UvStatisticVo;
import com.woollen.admin.service.UvStatisticService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Info:
 * @ClassName: UvStatisticServiceImpl
 * @Author: weiyang
 * @Data: 2019/10/16 5:11 PM
 * @Version: V1.0
 **/
@Service
public class UvStatisticServiceImpl implements UvStatisticService {
    @Autowired
    private UvStatisticMapperExter uvStatisticMapperExter;

    @Override
    public List<UvStatisticVo> statistic(UvStatisticRequest statisticRequest) {
        List<UvStatisticVo> uvStatisticVos = uvStatisticMapperExter.statisticUv(statisticRequest);
        return uvStatisticVos;
    }
}
