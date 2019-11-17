/**
 * All rights reserved.
 */
package com.woollen.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.woollen.admin.dao.entry.Resource;
import com.woollen.admin.dao.mapper.ResourceMapper;
import com.woollen.admin.service.ResourceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <p>
 * 请描述 (服务层实现类)
 * </p>
 *
 * @author ajiang 2018-03-01
 */
@Service("resourceService")
public class ResourceServiceImpl implements ResourceService {
    @Autowired
    private ResourceMapper resourceMapper;

    @Override
    public List<Resource> select(Resource root) {
        QueryWrapper<Resource> wrapper = new QueryWrapper<>();
        wrapper.eq("isDel",false);
        if (root.getIsEnable() != null){
            wrapper.eq("isEnable",root.getIsEnable());
        }

        if (root.getParentId() != null){
            wrapper.eq("parentId",root.getParentId());
        }
        List<Resource> select = resourceMapper.selectList(wrapper);
        return select;
    }

    /*@Override
    public List<Resource> selectByExample(Example example) {
        return resourceMapper.selectByExample(example);
    }*/

    @Override
    public Resource selectByPrimaryKey(Integer id) {
        return resourceMapper.selectById(id);
    }

    @Override
    public Integer selectCount(Resource resource) {
        QueryWrapper<Resource> wrapper = new QueryWrapper<>();
        wrapper.eq("isDel",false);
        if (resource.getParentId() != null){
            wrapper.eq("parentId",resource.getParentId());
        }
        return resourceMapper.selectCount(wrapper);
    }

    @Override
    public Integer insertSelective(Resource resource) {
        return resourceMapper.insert(resource);
    }

    @Override
    public Integer updateByPrimaryKeySelective(Resource resource) {
        return resourceMapper.updateById(resource);
    }

    @Override
    public List<Resource> selectByIds(List<Integer> ids) {

        QueryWrapper<Resource> wrapper = new QueryWrapper<>();
        wrapper.in("id",ids).eq("isEnable",true).eq("isDel",false);
        List<Resource> resources = resourceMapper.selectList(wrapper);
        return resources;
    }
}
