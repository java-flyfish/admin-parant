package com.woollen.admin.dao.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.woollen.admin.dao.entry.PvStatistic;
import com.woollen.admin.dao.request.PvStatisticRequest;
import com.woollen.admin.dao.response.PvStatisticVo;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * <p>
 * pv表 Mapper 接口
 * </p>
 *
 * @author weiyang
 * @since 2019-10-16
 */
public interface PvStatisticMapperExter extends BaseMapper<PvStatistic> {

    List<PvStatisticVo> statisticPv(PvStatisticRequest pvStatisticRequest);
}
