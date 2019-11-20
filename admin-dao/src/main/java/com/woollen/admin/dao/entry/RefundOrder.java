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
public class RefundOrder extends Model<RefundOrder> {

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
     * 第三方交易单号
     */
    private String refundSeq;

    /**
     * 1:申请退款，2:退款审核中，3:退款完成，4:退款失败
     */
    private Integer status;

    /**
     * 退款金额，单位分
     */
    private Long refundFee;

    /**
     * 实际支付金额，单位分
     */
    private Long payFee;

    /**
     * 支付渠道
     */
    private Integer payChannel;

    /**
     * 退款完成时间
     */
    private Long refundTime;

    /**
     * 申请人
     */
    private String applyName;

    /**
     * 审核人
     */
    private String checkName;

    /**
     * 退款描述
     */
    private String comment;

    /**
     * 退款拒绝
     */
    private String reason;

    /**
     * 创建时间，即申请退款实际
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
