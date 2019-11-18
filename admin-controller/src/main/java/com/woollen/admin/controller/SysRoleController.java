/**
 * All rights reserved.
 */
package com.woollen.admin.controller;

import com.github.pagehelper.PageInfo;
import com.woollen.admin.base.BaseController;
import com.woollen.admin.dao.entry.SysRole;
import com.woollen.admin.response.Result;
import com.woollen.admin.service.SysRoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * <p>
 * 请描述 (控制转发层)
 * </p>
 *
 * @author ajiang 2018-03-01
 */
@RestController
@RequestMapping("/role")
public class SysRoleController extends BaseController {

    @Autowired
    private SysRoleService sysRoleService;

    @RequestMapping(value = "/listByPage", method = RequestMethod.GET)
    public Result listByPage(HttpServletRequest request, HttpServletResponse response,
                             @RequestParam Integer pageNum,
                             @RequestParam(required = false) Integer pageSize) throws Exception {
        SysRole role = new SysRole();
        role.setIsDel(false);
        role.setPageNum(pageNum);
        role.setPageSize(pageSize);

        List<SysRole> roleList = sysRoleService.selectByPage(role);

        return success(new PageInfo<>(roleList));
    }

    @RequestMapping(value = "/listAll", method = RequestMethod.GET)
    public Result listAll(HttpServletRequest request, HttpServletResponse response) throws Exception {
        SysRole sysRole = new SysRole();
        sysRole.setIsDel(false);
        sysRole.setIsEnable(true);

        List<SysRole> roleList = sysRoleService.selectAll(sysRole);

        return success(roleList);
    }

    @RequestMapping(value = "/modify", method = RequestMethod.POST)
    public Result modify(HttpServletRequest request, HttpServletResponse response, @RequestBody SysRole sysRole) throws Exception {

        if (sysRole.getId() == null) {
            sysRoleService.insert(sysRole);
        } else {
            sysRoleService.updateByPrimaryKey(sysRole);
        }

        return success(true);
    }

    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    public Result delete(HttpServletRequest request, HttpServletResponse response, @RequestParam Integer id) throws Exception {

        SysRole sysRole = new SysRole();
        sysRole.setId(id);
        sysRole.setIsDel(true);
        sysRoleService.updateByPrimaryKey(sysRole);

        return success(true);
    }
}
