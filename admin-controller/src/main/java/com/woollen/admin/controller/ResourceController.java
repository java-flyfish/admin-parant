/**
 * All rights reserved.
 */
package com.woollen.admin.controller;

import com.woollen.admin.base.BaseController;
import com.woollen.admin.dao.entry.Resource;
import com.woollen.admin.dao.entry.SysRole;
import com.woollen.admin.dao.entry.SysUser;
import com.woollen.admin.response.Result;
import com.woollen.admin.service.ResourceService;
import com.woollen.admin.service.SysRoleService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import java.util.stream.Collectors;


/**
 * <p>
 * 请描述 (控制转发层)
 * </p>
 *
 * @author ajiang 2018-03-01
 */
@RestController
@RequestMapping("/resource")
public class ResourceController extends BaseController {

    @Autowired
    private ResourceService resourceService;

    @Autowired
    private SysRoleService roleService;

    /**
     * 获取树形资源数据
     *
     * @param request
     * @param response
     * @param isEnable
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/listTree", method = RequestMethod.GET)
    public Result listTree(HttpServletRequest request, HttpServletResponse response, @RequestParam(required = false) Boolean isEnable) throws Exception {

        Resource root = new Resource();

        if (isEnable != null) {
            root.setIsEnable(isEnable);
        }

        root.setIsDel(false);
        List<Resource> source = resourceService.select(root);

        List<Resource> roots = new ArrayList<>();

        for (Resource item : source) {
            if (item.getParentId() == 0) {
                roots.add(item);
            }
        }

        for (Resource item : roots) {
            item.setChildren(getChild(item.getId(), source));
        }

        return success(roots);
    }

    @RequestMapping(value = "/listTreeByRole", method = RequestMethod.GET)
    public Result listTreeByRole(HttpServletRequest request, HttpServletResponse response) throws Exception {

        SysUser sysUser = getLoginUser(request);

        List<Resource> roots = new ArrayList<>();

        if (sysUser.getRoleId() == null) {
            return success(roots);
        }


        SysRole role = roleService.getSysRoleById(sysUser.getRoleId());

        if (role == null) {
            return success(roots);
        }

        String relates = role.getRelates();

        if (StringUtils.isEmpty(relates)) {
            return success(roots);
        }

        List<String> ids = Arrays.asList(relates.split(","));

        List<Integer> idList = ids.stream().map(id-> Integer.valueOf(id)).collect(Collectors.toList());

        List<Resource> resourceList = resourceService.selectByIds(idList);

        if (resourceList.size() == 0) {
            return success(roots);
        }

        List<Integer> parentIds = new ArrayList<>();

        for (Resource item : resourceList) {
            parentIds.add(item.getParentId());
        }

        List<Resource> parents = resourceService.selectByIds(parentIds);

        for (Resource item : parents) {
            item.setChildren(getChild(item.getId(), resourceList));
        }

        Resource root = new Resource();
        root.setParentId(0);
        roots = resourceService.select(root);

        for (Resource item : roots) {
            item.setChildren(parents);
        }

        return success(roots);
    }

    private List<Resource> initTree(List<Resource> resourceList) {

        List<Integer> parentIds = new ArrayList<>();

        for (Resource item : resourceList) {
            if (item.getParentId() != 0) {
                parentIds.add(item.getParentId());
            }
        }

        if (parentIds.size() == 0) {
            return resourceList;
        } else {
            Map<Integer, List<Resource>> map = new LinkedHashMap<>();

            for (Resource item : resourceList) {
                List<Resource> list = map.get(item.getParentId());

                if (list == null) {
                    list = new ArrayList<>();
                }

                list.add(item);

                map.put(item.getParentId(), list);
            }

            List<Resource> list = resourceService.selectByIds(parentIds);

            for (Resource item : list) {
                List<Resource> children = map.get(item.getId());

                item.setChildren(children);
            }

            List<Resource> datas = initTree(list);

            return datas;
        }

    }

    /**
     * 修改
     *
     * @param request
     * @param response
     * @param resource
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/modify", method = RequestMethod.POST)
    public Result modify(HttpServletRequest request, HttpServletResponse response, @RequestBody Resource resource) throws Exception {

        if (resource.getId() == null) {
            Resource children = new Resource();
            children.setParentId(resource.getParentId());
            children.setIsDel(false);
            int count = resourceService.selectCount(children);

            resource.setIsLeaf(true);
            resource.setCreated(System.currentTimeMillis());
            resource.setUpdated(System.currentTimeMillis());
            resource.setSort(count);
            resourceService.insertSelective(resource);

            if (count == 0) {
                Resource parent = new Resource();
                parent.setIsLeaf(false);
                parent.setUpdated(System.currentTimeMillis());
                parent.setId(resource.getParentId());
                resourceService.updateByPrimaryKeySelective(parent);
            }

        } else {
            resource.setUpdated(System.currentTimeMillis());
            resourceService.updateByPrimaryKeySelective(resource);
        }

        return success(true);
    }

    /**
     * 软删除
     *
     * @param request
     * @param response
     * @param id
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    public Result delete(HttpServletRequest request, HttpServletResponse response, @RequestParam Integer id) throws Exception {

        Resource resource = resourceService.selectByPrimaryKey(id);
        resource.setIsDel(true);

        resourceService.updateByPrimaryKeySelective(resource);

        Resource children = new Resource();
        children.setParentId(resource.getParentId());
        int count = resourceService.selectCount(children);

        if (count == 0) {
            Resource parent = new Resource();
            parent.setIsLeaf(true);
            parent.setUpdated(System.currentTimeMillis());
            parent.setId(resource.getParentId());
            resourceService.updateByPrimaryKeySelective(parent);
        }

        return success(true);
    }

    private List<Resource> getChild(Integer id, List<Resource> source) {
        // 子菜单
        List<Resource> childList = new ArrayList<>();
        for (Resource resource : source) {
            // 遍历所有节点，将父菜单id与传过来的id比较
            if (resource.getParentId().equals(id)) {
                childList.add(resource);
            }
        }
        // 把子菜单的子菜单再循环一遍
        for (Resource resource : childList) {
            if (!resource.getIsLeaf()) {
                // 递归
                resource.setChildren(getChild(resource.getId(), source));
            }
        }
        // 递归退出条件
        if (childList.size() == 0) {
            return childList;
        }
        return childList;
    }

    public SysUser getLoginUser(HttpServletRequest request) {
        Object obj = request.getSession().getAttribute("sysUser");

        if (obj == null) {
            return null;
        }
        return (SysUser) obj;
    }
}
