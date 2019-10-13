package com.woollen.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.woollen.admin.dao.entry.SysUser;
import com.woollen.admin.dao.mapper.SysUserMapper;
import com.woollen.admin.service.SysUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Info:
 * @ClassName: ManagerUserServiceImpl
 * @Author: weiyang
 * @Data: 2019/10/12 3:20 PM
 * @Version: V1.0
 **/
@Service
public class SysUserServiceImpl implements SysUserService {

    @Autowired
    private SysUserMapper sysUserMapper;

    @Override
    public SysUser selectNamaAndPassword(String name, String password) {

        QueryWrapper<SysUser> wrapper = new QueryWrapper<>();
        wrapper.eq("name",name);
        wrapper.eq("password",password);
        SysUser sysUser = sysUserMapper.selectOne(wrapper);
        return sysUser;
    }
}
