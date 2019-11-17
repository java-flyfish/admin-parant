package com.woollen.admin.service.impl;

import com.woollen.admin.dao.entry.SysRole;
import com.woollen.admin.dao.mapper.SysRoleMapper;
import com.woollen.admin.service.SysRoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
}
