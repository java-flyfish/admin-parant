package com.woollen.admin.dao.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.woollen.admin.dao.entry.OrderInfo;
import com.woollen.admin.dao.request.OrderStatisticRequest;
import com.woollen.admin.dao.request.PvStatisticRequest;
import com.woollen.admin.dao.response.OrderStatisticVo;
import com.woollen.admin.dao.response.PvStatisticVo;

import java.util.List;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author weiyang
 * @since 2019-10-13
 */
public interface OrderInfoMapperExter extends BaseMapper<OrderInfo> {

    List<OrderStatisticVo> statisticOrder(OrderStatisticRequest orderStatisticRequest);
}
