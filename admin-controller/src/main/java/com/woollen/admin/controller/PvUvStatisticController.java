package com.woollen.admin.controller;

import com.github.pagehelper.PageInfo;
import com.woollen.admin.base.BaseController;
import com.woollen.admin.dao.request.PvStatisticRequest;
import com.woollen.admin.dao.request.UvStatisticRequest;
import com.woollen.admin.dao.response.PvStatisticVo;
import com.woollen.admin.dao.response.UvStatisticVo;
import com.woollen.admin.response.Result;
import com.woollen.admin.service.PvStatisticService;
import com.woollen.admin.service.UvStatisticService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * @Info:
 * @ClassName: PvUvStatisticController
 * @Author: weiyang
 * @Data: 2019/10/16 2:56 PM
 * @Version: V1.0
 **/
@RestController
@RequestMapping("statistic")
public class PvUvStatisticController extends BaseController{

    @Autowired
    private PvStatisticService pvStatisticService;

    @Autowired
    private UvStatisticService uvStatisticService;

    @GetMapping("pv")
    public Result pvStatistic(PvStatisticRequest statisticRequest){
        PageInfo pageInfo = pvStatisticService.statistic(statisticRequest);
        return success(pageInfo);
    }

    @GetMapping("uv")
    public Result uvStatistic(UvStatisticRequest statisticRequest){
        List<UvStatisticVo> statistic = uvStatisticService.statistic(statisticRequest);
        return success(statistic);
    }

}
