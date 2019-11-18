package com.woollen.admin.dao.entry;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.extension.activerecord.Model;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableField;
import java.io.Serializable;
import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

/**
 * <p>
 * 
 * </p>
 *
 * @author weiyang
 * @since 2019-11-16
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
public class Resource extends Model<Resource> {

    private static final long serialVersionUID = 1L;

    /**
     * 主键
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    /**
     * 名称
     */
    private String name;

    /**
     * 中文名称
     */
    private String title;

    /**
     * url地址
     */
    private String url;

    /**
     * 图标
     */
    private String icon;

    /**
     * 创建时间
     */
    private Long created;

    /**
     * 更新时间
     */
    private Long updated;

    /**
     * 是否删除
     */
    @TableField("isDel")
    private Boolean isDel;

    /**
     * 是否启用
     */
    @TableField("isEnable")
    private Boolean isEnable;

    /**
     * 是否叶子节点
     */
    @TableField("isLeaf")
    private Boolean isLeaf;

    /**
     * 父级id
     */
    @TableField("parentId")
    private Integer parentId;

    /**
     * 排序
     */
    private Integer sort;

    @TableField(exist = false)
    private Boolean expand = true;

    /**
     * 子节点
     */
    @TableField(exist = false)
    private List<Resource> children;


    @Override
    protected Serializable pkVal() {
        return this.id;
    }

}
