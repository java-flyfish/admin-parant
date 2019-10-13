package com.woollen.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.woollen.admin.dao.entry.SysMenu;
import com.woollen.admin.dao.mapper.SysMenuMapper;
import com.woollen.admin.service.SysMenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Info:
 * @ClassName: MenuServiceImpl
 * @Author: weiyang
 * @Data: 2019/10/12 3:32 PM
 * @Version: V1.0
 **/
@Service
public class SysMenuServiceImpl implements SysMenuService {

    @Autowired
    private SysMenuMapper sysMenuMapper;

    @Override
    public List<SysMenu> getMenuByRoleIds(List<String> ids) {

        QueryWrapper<SysMenu> wrapper = new QueryWrapper<>();
        wrapper.in("id",ids);
        List<SysMenu> sysMenus = sysMenuMapper.selectList(wrapper);
        return sysMenus;
    }
}
