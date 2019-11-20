package com.woollen.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.woollen.admin.dao.entry.OrderInfo;
import com.woollen.admin.dao.entry.RefundOrder;
import com.woollen.admin.dao.mapper.OrderInfoMapper;
import com.woollen.admin.dao.mapper.RefundOrderMapper;
import com.woollen.admin.exception.APSException;
import com.woollen.admin.request.DoRefundRequest;
import com.woollen.admin.request.RefundOrderRequest;
import com.woollen.admin.request.RefundSearchRequest;
import com.woollen.admin.service.RefundOrderService;
import com.woollen.admin.utils.SeqUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * @Info:
 * @ClassName: RefundOrderServiceImpl
 * @Author: weiyang
 * @Data: 2019/11/18 5:34 PM
 * @Version: V1.0
 **/
@Service
public class RefundOrderServiceImpl implements RefundOrderService {

    @Autowired
    private RefundOrderMapper refundOrderMapper;

    @Autowired
    private OrderInfoMapper orderInfoMapper;

    @Override
    @Transactional
    public Boolean createRefund(RefundOrderRequest refundOrderRequest) {
        QueryWrapper<OrderInfo> wrapper = new QueryWrapper<>();
        wrapper.eq("seq",refundOrderRequest.getSeq());
        wrapper.eq("status",2);

        List<OrderInfo> orderInfos = orderInfoMapper.selectList(wrapper);
        if (orderInfos.isEmpty()){
            throw new APSException("订单不存在或者已经退款");
        }

        OrderInfo orderInfo = orderInfos.get(0);
        orderInfo.setStatus(4);

        UpdateWrapper<OrderInfo> updateWrapper = new UpdateWrapper<>();
        updateWrapper
                .eq("id",orderInfo.getId())
                .le("updated",orderInfo.getUpdated());
        boolean update = orderInfo.update(updateWrapper);
        if (!update){
            throw new APSException("请刷新重试");
        }
        RefundOrder refundOrder = new RefundOrder();
        refundOrder.setSeq(refundOrderRequest.getSeq());
        refundOrder.setRefundFee(refundOrderRequest.getRefundFee());
        refundOrder.setComment(refundOrderRequest.getComment());
        refundOrder.setPayChannel(orderInfo.getPayChannel());
        refundOrder.setOutSeq(orderInfo.getOutSeq());
        refundOrder.setPayFee(orderInfo.getPayFee());
        Long now = System.currentTimeMillis();
        refundOrder.setCreated(now);
        refundOrder.setUpdated(now);
        refundOrder.setRefundTime(now);
        refundOrder.setStatus(1);//申请退款
        refundOrder.setRefundSeq(SeqUtils.generatorSeq());
        refundOrder.setApplyName(refundOrderRequest.getApplyName());
        boolean insert = refundOrder.insert();
        return insert;
    }

    @Override
    public PageInfo getRefundOrderList(RefundSearchRequest request) {
        QueryWrapper<RefundOrder> wrapper = new QueryWrapper<>();

        if (StringUtils.isNotBlank(request.getSeq())){
            wrapper.eq("seq",request.getSeq().trim());
        }
        if (StringUtils.isNotBlank(request.getRefundSeq())){
            wrapper.eq("refund_seq",request.getRefundSeq().trim());
        }
        if (request.getBegin() != null && request.getEnd() != null){
            wrapper.between("created",request.getBegin(),request.getEnd());
        }
        PageHelper.startPage(request.getPageNum(),request.getPageSize());
        List<RefundOrder> orderInfos = refundOrderMapper.selectList(wrapper);
        PageInfo pageInfo = new PageInfo(orderInfos);
        return pageInfo;
    }

    @Override
    public Boolean doRefund(DoRefundRequest request) {
        QueryWrapper<RefundOrder> wrapper = new QueryWrapper<>();
        wrapper.eq("refund_seq",request.getRefundSeq())
                .eq("status",request.getStatus());
        RefundOrder refundOrder = refundOrderMapper.selectOne(wrapper);
        if (refundOrder == null){
            throw new APSException("订单已经退款");
        }
        if (request.getIsAgree()){
            refundOrder.setStatus(3);//退款完成
        } else {
            refundOrder.setStatus(4);//退款失败，拒绝退款
            refundOrder.setReason(request.getReason());
        }

        Long updated = refundOrder.getUpdated();
        UpdateWrapper<RefundOrder> updateWrapper = new UpdateWrapper<>();
        updateWrapper.eq("refund_seq",request.getRefundSeq()).le("updated",updated);
        refundOrder.setCheckName(request.getCheckName());
        refundOrder.setUpdated(System.currentTimeMillis());
        int update = refundOrderMapper.update(refundOrder, wrapper);
        if (update<1){
            throw new APSException("请刷新重试");
        }
        return true;
    }
}
