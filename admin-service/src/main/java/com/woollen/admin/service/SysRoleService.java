package com.woollen.admin.service;

import com.woollen.admin.dao.entry.SysRole;

import java.util.List;

/**
 * @Info:
 * @ClassName: RoleService
 * @Author: weiyang
 * @Data: 2019/10/12 3:23 PM
 * @Version: V1.0
 **/
public interface SysRoleService {
    SysRole getSysRoleById(Integer roleId);

    List<SysRole> selectByPage(SysRole role);

    List<SysRole> selectAll(SysRole sysRole);

    Boolean updateByPrimaryKey(SysRole sysRole);

    Boolean insert(SysRole sysRole);
}
