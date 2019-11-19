package com.woollen.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.sun.org.apache.xpath.internal.operations.Bool;
import com.woollen.admin.dao.entry.SysRole;
import com.woollen.admin.dao.mapper.SysRoleMapper;
import com.woollen.admin.service.SysRoleService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Info:
 * @ClassName: RoleServiceImpl
 * @Author: weiyang
 * @Data: 2019/10/12 3:23 PM
 * @Version: V1.0
 **/
@Service
public class SysRoleServiceImpl implements SysRoleService {

    @Autowired
    private SysRoleMapper sysRoleMapper;

    @Override
    public SysRole getSysRoleById(Integer roleId) {
        SysRole sysRole = sysRoleMapper.selectById(roleId);
        return sysRole;
    }

    @Override
    public List<SysRole> selectByPage(SysRole role) {
        QueryWrapper<SysRole> wrapper = new QueryWrapper<>();
        wrapper.eq("is_del",false);
        if (role.getId() != null){
            wrapper.eq("id",role.getId());
        }
        if (StringUtils.isNotBlank(role.getName())){
            wrapper.like("name","%" + role.getName() + "%");
        }
        if (role.getIsEnable() != null){
            wrapper.eq("is_enable",role.getIsEnable());

        }
        List<SysRole> sysRoles = sysRoleMapper.selectList(wrapper);
        return sysRoles;
    }

    @Override
    public List<SysRole> selectAll(SysRole sysRole) {

        QueryWrapper<SysRole> wrapper = new QueryWrapper<>();

        wrapper.eq("is_del",false)
                .eq("is_enable",sysRole.getIsEnable());

        List<SysRole> sysRoles = sysRoleMapper.selectList(wrapper);
        return sysRoles;
    }

    @Override
    public Boolean updateByPrimaryKey(SysRole sysRole) {

        return sysRole.updateById();
    }

    @Override
    public Boolean insert(SysRole sysRole) {
        return sysRole.insert();
    }
}
