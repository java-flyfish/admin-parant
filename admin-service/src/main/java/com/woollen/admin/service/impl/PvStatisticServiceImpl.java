package com.woollen.admin.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.woollen.admin.dao.mapper.OrderInfoMapperExter;
import com.woollen.admin.dao.mapper.PvStatisticMapperExter;
import com.woollen.admin.dao.request.OrderStatisticRequest;
import com.woollen.admin.dao.response.OrderStatisticVo;
import com.woollen.admin.dao.response.PvStatisticVo;
import com.woollen.admin.dao.request.PvStatisticRequest;
import com.woollen.admin.service.PvStatisticService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    @Autowired
    private OrderInfoMapperExter orderInfoMapperExter;


    @Override
    public PageInfo statistic(PvStatisticRequest statisticRequest) {
        PageHelper.startPage(statisticRequest.getPageNum(),statisticRequest.getPageSize());

        List<PvStatisticVo> pvStatisticVos = pvStatisticMapperExter.statisticPv(statisticRequest);
        PageInfo pageInfo = new PageInfo(pvStatisticVos);

        List<String> sourceList = new ArrayList<>();
        List<String> dateList = new ArrayList<>();
        for (PvStatisticVo pvStatisticVo : pvStatisticVos) {
            if (!sourceList.contains(pvStatisticVo.getSource())){
                sourceList.add(pvStatisticVo.getSource());
            }
            if (!dateList.contains(pvStatisticVo.getTime())){
                dateList.add(pvStatisticVo.getTime());
            }
        }

        OrderStatisticRequest orderStatisticRequest = new OrderStatisticRequest();
        orderStatisticRequest.setType(statisticRequest.getType());
        orderStatisticRequest.setSourceList(sourceList);
        orderStatisticRequest.setDateList(dateList);
        List<OrderStatisticVo> orderStatisticVos = orderInfoMapperExter.statisticOrder(orderStatisticRequest);

        Map<String,OrderStatisticVo> map = new HashMap<>();
        for (OrderStatisticVo orderStatisticVo : orderStatisticVos) {
            map.put(orderStatisticVo.getSource() + ":" + orderStatisticVo.getTime(),orderStatisticVo);
        }

        for (PvStatisticVo pvStatisticVo : pvStatisticVos) {
            OrderStatisticVo orderStatisticVo = map.get(pvStatisticVo.getSource() + ":" + pvStatisticVo.getTime());
            if (orderStatisticVo != null){
                pvStatisticVo.setSumOrder(orderStatisticVo.getSumOrder());
                pvStatisticVo.setPayOrder(orderStatisticVo.getPayOrder());
                pvStatisticVo.setSumPay(orderStatisticVo.getSumPay());
            }else {
                pvStatisticVo.setSumOrder(0);
                pvStatisticVo.setPayOrder(0);
                pvStatisticVo.setSumPay(0);
            }
        }

        return pageInfo;
    }
}
