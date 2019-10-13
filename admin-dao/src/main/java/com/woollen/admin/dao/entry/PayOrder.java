package com.woollen.admin.dao.entry;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.extension.activerecord.Model;
import com.baomidou.mybatisplus.annotation.TableId;
import java.io.Serializable;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

/**
 * <p>
 * 
 * </p>
 *
 * @author weiyang
 * @since 2019-10-13
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
public class PayOrder extends Model<PayOrder> {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    /**
     * 订单号
     */
    private String seq;

    /**
     * 第三方交易单号
     */
    private String outSeq;

    /**
     * 2:已付款
     */
    private Integer status;

    /**
     * 单位分
     */
    private Long orderFee;

    /**
     * 实际支付金额，单位分
     */
    private Long payFee;

    /**
     * 支付渠道
     */
    private Integer payChannel;

    /**
     * 支付时间
     */
    private Long payTime;

    /**
     * 创建时间
     */
    private Long created;

    /**
     * 更新时间
     */
    private Long updated;


    @Override
    protected Serializable pkVal() {
        return this.id;
    }

}
