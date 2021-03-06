package com.woollen.admin.controller;

import com.woollen.admin.base.BaseController;
import com.woollen.admin.dao.entry.SysMenu;
import com.woollen.admin.dao.entry.SysRole;
import com.woollen.admin.dao.entry.SysUser;
import com.woollen.admin.response.Result;
import com.woollen.admin.response.SysMenuVo;
import com.woollen.admin.service.SysMenuService;
import com.woollen.admin.service.SysRoleService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * @Info:
 * @ClassName: SysMenuController
 * @Author: weiyang
 * @Data: 2019/10/12 5:17 PM
 * @Version: V1.0
 **/
@RestController
@RequestMapping("sysMenu")
public class SysMenuController extends BaseController {

    @Autowired
    private SysRoleService sysRoleService;

    @Autowired
    private SysMenuService sysMenuService;

    @GetMapping("getSysMenu")
    public Result getSysMenu(HttpServletRequest request, HttpServletResponse response){
        HttpSession session = request.getSession();
        Object user = session.getAttribute("sysUser");

        SysUser sysUser = (SysUser)user;
        Integer roleId = sysUser.getRoleId();
        //获取用户角色
        SysRole sysRole = sysRoleService.getSysRoleById(roleId);
        List<String> ids = Arrays.asList(sysRole.getRelates().split(","));
        List<SysMenu> sysMenus = sysMenuService.getMenuByRoleIds(ids);

        List<SysMenuVo> sysMenuVoList = new ArrayList<>();

        Map<Integer,SysMenuVo> sysMenuVoMap = new HashMap<>();

        sysMenus.stream().forEach(sysMenu->{
            if (sysMenu.getIsParent()){
                SysMenuVo parent = Optional.ofNullable(sysMenuVoMap.get(sysMenu.getId()))
                        .orElseGet(()->{
                            SysMenuVo vo = new SysMenuVo();
                            BeanUtils.copyProperties(sysMenu,vo);
                            vo.setSubSysMenuVo(new ArrayList<>());
                            return vo;
                        });
                sysMenuVoMap.put(sysMenu.getId(),parent);
            }else {
                SysMenuVo parent = sysMenuVoMap.get(sysMenu.getParentId());
                SysMenuVo child = new SysMenuVo();
                BeanUtils.copyProperties(sysMenu,child);
                parent.getSubSysMenuVo().add(child);
            }
        });
        Set<Map.Entry<Integer, SysMenuVo>> entries = sysMenuVoMap.entrySet();
        entries.stream().forEach(entry->sysMenuVoList.add(entry.getValue()));
        return success(sysMenuVoList);
    }
}
