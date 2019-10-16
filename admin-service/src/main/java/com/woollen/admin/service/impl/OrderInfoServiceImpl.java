package com.woollen.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.woollen.admin.dao.entry.OrderInfo;
import com.woollen.admin.dao.mapper.OrderInfoMapper;
import com.woollen.admin.service.OrderInfoService;
import com.woollen.admin.request.OrderInfoRequest;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Info:
 * @ClassName: OrderInfoServiceImpl
 * @Author: weiyang
 * @Data: 2019/10/13 3:56 PM
 * @Version: V1.0
 **/
@Service
public class OrderInfoServiceImpl implements OrderInfoService {

    @Autowired
    private OrderInfoMapper orderInfoMapper;

    @Override
    public List<OrderInfo> getOrderInfoList(OrderInfoRequest request) {

        QueryWrapper<OrderInfo> wrapper = new QueryWrapper<>();

        if (StringUtils.isNotBlank(request.getSeq())){
            wrapper.eq("seq",request.getSeq().trim());
        }
        if (StringUtils.isNotBlank(request.getOutSeq())){
            wrapper.eq("out_seq",request.getOutSeq().trim());
        }
        if (StringUtils.isNotBlank(request.getName())){
            wrapper.eq("name",request.getName().trim());
        }
        if (StringUtils.isNotBlank(request.getPhone())){
            wrapper.eq("phone",request.getPhone().trim());
        }
        if (request.getStatus() != null){
            wrapper.eq("status",request.getStatus());
        }
        if (StringUtils.isNotBlank(request.getAdtSource())){
            wrapper.like("adt_source","%" + request.getAdtSource().trim() + "%");
        }
        if (request.getPayChannel() != null){
            wrapper.eq("pay_channel",request.getAdtSource().trim());
        }
        if (request.getBegin() != null && request.getEnd() != null){
            wrapper.between("pay_time",request.getBegin(),request.getEnd());
        }
        List<OrderInfo> orderInfos = orderInfoMapper.selectList(wrapper);
        return orderInfos;
    }
}
