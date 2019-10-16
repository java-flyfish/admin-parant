package com.woollen.admin.dao.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.woollen.admin.dao.entry.UvStatistic;
import com.woollen.admin.dao.request.UvStatisticRequest;
import com.woollen.admin.dao.response.UvStatisticVo;

import java.util.List;

/**
 * <p>
 * uv表 Mapper 接口
 * </p>
 *
 * @author weiyang
 * @since 2019-10-16
 */
public interface UvStatisticMapperExter extends BaseMapper<UvStatistic> {
    List<UvStatisticVo> statisticUv(UvStatisticRequest statisticRequest);
}
