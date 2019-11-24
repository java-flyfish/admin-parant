package com.woollen.admin;

import com.github.pagehelper.PageInfo;
import com.woollen.admin.dao.request.PvStatisticRequest;
import com.woollen.admin.dao.request.UvStatisticRequest;
import com.woollen.admin.dao.response.PvStatisticVo;
import com.woollen.admin.dao.response.UvStatisticVo;
import com.woollen.admin.service.PvStatisticService;
import com.woollen.admin.service.UvStatisticService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.List;

@RunWith(SpringRunner.class)
@SpringBootTest
public class AdminControllerApplicationTests {

	@Autowired
	PvStatisticService pvStatisticService;

    @Autowired
    private UvStatisticService uvStatisticService;

	@Test
	public void testPv() {
        PageInfo pageInfo = pvStatisticService.statistic(new PvStatisticRequest());
        System.out.println(pageInfo);
    }

    @Test
    public void testUv() {
        List<UvStatisticVo> statistic = uvStatisticService.statistic(new UvStatisticRequest());
        System.out.println(statistic);
    }
}
