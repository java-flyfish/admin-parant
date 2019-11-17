/**
 * All rights reserved.
 */
package com.woollen.admin.service;


import com.woollen.admin.dao.entry.Resource;
import org.springframework.data.domain.Example;

import java.util.List;

/**
 * <p>
 * 请描述 (服务层接口)
 * </p>
 *
 * @author ajiang 2018-03-01
 */
public interface ResourceService {

    List<Resource> select(Resource root);

//    List<Resource> selectByExample(Example example);
//
    Resource selectByPrimaryKey(Integer id);

    Integer selectCount(Resource resource);

    Integer insertSelective(Resource resource);

    Integer updateByPrimaryKeySelective(Resource resource);


    List<Resource> selectByIds(List<Integer> ids);
}
