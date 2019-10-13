package com.woollen.admin.service;

import com.woollen.admin.dao.entry.SysMenu;

import java.util.List;

/**
 * @Info:
 * @ClassName: MenuService
 * @Author: weiyang
 * @Data: 2019/10/12 3:32 PM
 * @Version: V1.0
 **/
public interface SysMenuService {

    List<SysMenu> getMenuByRoleIds(List<String> ids);
}
