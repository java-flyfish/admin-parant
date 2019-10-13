package com.woollen.admin.response;

import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.List;

/**
 * @Info:
 * @ClassName: SysMenuVo
 * @Author: weiyang
 * @Data: 2019/10/13 1:53 PM
 * @Version: V1.0
 **/
@Data
public class SysMenuVo implements Serializable {
    private Integer id;

    /**
     * 上级菜单ID
     */
    private Integer parentId;

    /**
     * 是否父菜单
     */
    private Integer isParent;

    /**
     * 菜单名称
     */
    private String name;

    /**
     * 菜单地址
     */
    private String url;

    /**
     * 类型     0：目录   1：菜单   2：按钮
     */
    private Integer type;

    /**
     * 菜单图标
     */
    private String icon;

    /**
     * 排序
     */
    private Integer sort;

    /**
     * 子菜单
     */
    List<SysMenuVo> subSysMenuVo;
}
