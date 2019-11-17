<template id="refund">
    <div class="auto-height">
        <Layout class="auto-height">
            <i-Header class="layout-header-content color-white">
                <i-form class="auto-height" ref="searchForm" :model="searchForm" :rules="searchRule" inline
                        @submit.native.prevent>

                    <form-item>
                        <i-input clearable type="text" v-model="searchForm.seqSearch" placeholder="搜索供应商单号"
                                 @on-enter="listByPage(1)">
                        </i-input>
                    </form-item>

                <#--<form-item>-->
                <#--<i-input clearable type="text" v-model="searchForm.title" placeholder="搜索商品名称"-->
                <#--@on-enter="listByPage(1)">-->
                <#--</i-input>-->
                <#--</form-item>-->

                    <form-item>
                        <Date-Picker type="daterange" v-model="searchForm.dateRange" placeholder="请选择申请退款时间"
                                     style="width:180px"></Date-Picker>
                    </form-item>

                    <form-item>
                        <i-Select clearable v-model="searchForm.type" placeholder="请选择类型" style="width: 100px">
                            <i-Option v-for="item in typeList" :value="item.id">{{ item.name }}</i-Option>
                        </i-Select>
                    </form-item>

                    <form-item>
                        <i-Select clearable v-model="searchForm.status" placeholder="请选择状态" style="width: 100px">
                            <i-Option v-for="item in statusList" :value="item.id">{{ item.name }}</i-Option>
                        </i-Select>
                    </form-item>

                    <form-item>
                        <i-Button type="primary" shape="circle" icon="ios-search" @click="listByPage(1)"
                                  :loading="searchLoading">
                            <span v-if="!searchLoading">查询</span>
                            <span v-else>查询中...</span>
                        </i-Button>
                    </form-item>

                    <form-item>
                        <i-Button type="success" shape="circle" icon="ios-cloud-upload-outline" @click="exportExcel">导出
                        </i-Button>
                    </form-item>
                </i-form>
            </i-Header>
            <i-Content class="layout-body-content">
                <super-Table :columns="tableColumns" :data="tableData"
                             :loading="searchLoading"></super-Table>
            </i-Content>

            <i-footer class="layout-footer-content color-white">
                <Page class="text-center custom-table-page" show-total :total="tableDataCount"
                      :current="searchForm.pageNum"
                      @on-change="listByPage"></Page>
            </i-footer>
        </Layout>

        <modal v-model="detailModal"
               title="退单详情"
               :mask-closable="false"
               fullscreen>
            <i-form ref="detailFormModal" :model="detailFormModal" label-width="80">
                <Card style="margin-bottom: 20px">
                    <p slot="title">
                        <Icon type="ios-list"></Icon>
                        基本信息
                    </p>

                    <row>
                        <i-col span="8">
                            <form-item label="供应商单号">
                                {{detailFormModal.supplierSeq}}
                            </form-item>
                        </i-col>
                        <i-col span="8">
                            <form-item label="供应商">
                                {{detailFormModal.supplierId}}
                            </form-item>
                        </i-col>

                        <i-col span="8">
                            <form-item label="退款类型">
                                {{detailFormModal.typeLabel}}
                            </form-item>
                        </i-col>
                    </row>

                    <row>
                        <i-col span="8">
                            <form-item label="状态">
                                {{detailFormModal.statusLabel}}
                            </form-item>
                        </i-col>

                        <i-col span="8">
                            <form-item label="物流状态">
                                {{detailFormModal.expressStatusLabel}}
                            </form-item>
                        </i-col>

                        <i-col span="8">
                            <form-item label="支付渠道">
                                {{detailFormModal.payChannelLabel}}
                            </form-item>
                        </i-col>
                    </row>

                    <row>
                        <i-col span="8">
                            <form-item label="支付时间">
                                {{detailFormModal.payTime}}
                            </form-item>
                        </i-col>

                        <i-col span="8">
                            <form-item label="退款描述">
                                {{detailFormModal.describeText}}
                            </form-item>
                        </i-col>

                        <i-col span="8">
                            <form-item label="退款理由">
                                {{detailFormModal.comment}}
                            </form-item>
                        </i-col>
                    </row>
                </Card>

                <Card style="margin-bottom: 20px">
                    <p slot="title">
                        <Icon type="ios-list"></Icon>
                        金额信息
                    </p>

                    <row>
                        <i-col span="8">
                            <form-item label="退支付金额">
                                {{detailFormModal.amt}}
                            </form-item>
                        </i-col>
                        <i-col span="8">
                            <form-item label="退邮费">
                                {{detailFormModal.postage}}
                            </form-item>
                        </i-col>
                        <i-col span="8">
                            <form-item label="合计退款" style="color:crimson">
                                {{detailFormModal.totalRefund}}
                            </form-item>
                        </i-col>
                    </row>

                    <row>
                        <i-col span="8">
                            <form-item label="退金币">
                                {{detailFormModal.discount}}
                            </form-item>
                        </i-col>
                        <i-col span="8">
                            <form-item label="收回金币">
                                {{detailFormModal.goldAmount}}
                            </form-item>
                        </i-col>

                    </row>
                </Card>

                <Card style="margin-bottom: 20px">
                    <p slot="title">
                        <Icon type="ios-list"></Icon>
                        商品信息
                    </p>
                    <i-table :columns="detailFormModalExtra.columns" :data="detailFormModal.productList">

                    </i-table>
                </Card>

                <Card style="margin-bottom: 20px" v-if="detailFormModal.type!=0">
                    <p slot="title">
                        <Icon type="ios-list"></Icon>
                        退货信息
                    </p>

                    <row>
                        <i-col span="8">
                            <form-item label="快递公司">
                                {{detailFormModal.refundEName}}
                            </form-item>
                        </i-col>
                        <i-col span="8">
                            <form-item label="快递单号">
                                {{detailFormModal.refundEcode}}
                            </form-item>
                        </i-col>
                        <i-col span="8">
                            <form-item label="退货理由">
                                {{detailFormModal.refundComment}}
                            </form-item>
                        </i-col>
                    </row>

                    <row>
                        <i-col span="8">
                            <form-item label="图片凭证">
                                <div v-for="item in detailFormModal.refundProofs" style="display: inline-block">
                                    <img :src="getImage(item)" width="58px" height="58px" style="margin-right: 5px">
                                </div>
                            </form-item>
                        </i-col>
                    </row>
                </Card>

                <Card v-if="detailFormModalExtra.refundFlag">
                    <p slot="title">
                        <Icon type="ios-list"></Icon>
                        操作面板
                    </p>

                    <row>
                        <i-col span="24">
                            <form-item label="是否同意">
                                <i-switch v-model="detailFormModal.isAgree" size="large" @on-change="onChange">
                                    <span slot="open">同意</span>
                                    <span slot="close"></span>
                                </i-switch>
                            </form-item>
                        </i-col>
                    </row>

                    <row>
                        <i-col span="24">
                            <form-item label="不同意理由" v-if="!detailFormModal.isAgree">
                                <i-Select clearable v-model="detailFormModal.reason" placeholder="请选择理由" style="width: 100px" >
                                    <i-Option v-for="item in reasonList" :value="item.id">{{ item.name }}</i-Option>
                                </i-Select>
                            </form-item>
                        </i-col>
                    </row>

                    <row>
                        <i-col span="24">
                            <form-item label="请输入理由" <#--v-if="!detailFormModal.isAgree"-->v-if="detailFormModal.reason=='其他（要写拒绝说明）'"<#-- class="no-margin"-->>
                                <i-input type="textarea" :autosize="{minRows: 2,maxRows: 5}"
                                         v-model="detailFormModal.disagreeComment">
                                </i-input>
                            </form-item>
                        </i-col>
                    </row>

                    <row v-if="detailFormModal.type!=0">
                        <i-col span="8">
                            <form-item label="退货地址" v-if="detailFormModal.isAgree">
                                <i-Input v-model="detailFormModal.addressInfo" placeholder="请输入退货地址"></i-Input>
                            </form-item>
                        </i-col>

                        <i-col span="8">
                            <form-item label="退货联系人" v-if="detailFormModal.isAgree">
                                <i-Input v-model="detailFormModal.userInfo" placeholder="请输入退货联系人"></i-Input>
                            </form-item>

                        </i-col>

                        <i-col span="8">
                            <form-item label="手机号码" v-if="detailFormModal.isAgree">
                                <i-Input v-model="detailFormModal.phoneInfo" placeholder="请输入手机号码"></i-Input>
                            </form-item>
                        </i-col>
                    </row>

                </Card>

                <Card v-if="detailFormModal.status==3">
                    <p slot="title">
                        <Icon type="ios-list"></Icon>
                        不同意理由
                    </p>

                    <row>
                        <i-col span="24">
                            {{detailFormModal.disagreeComment}}
                        </i-col>
                    </row>

                </Card>

            </i-form>

            <div slot="footer">

                <i-button type="primary" long :loading="modalLoading" @click="asyncOK('detailFormModal')"
                          v-if="detailFormModalExtra.refundFlag">
                    审核
                </i-button>

            </div>
        </modal>

        <modal v-model="exportModal"
               title="导出订单,数据量大请耐心等待30秒时间"
               :mask-closable="false"
               :styles="{top: '20px'}">

            <i-form ref="exportFormModal" :model="exportFormModal" :rules="exportRuleModal" label-width="80">

                <form-item prop="dateRange" label="时间区间">
                    <Date-Picker type="daterange" v-model="exportFormModal.dateRange" placeholder="请选择时间区间"
                                 class="auto-width"></Date-Picker>
                </form-item>
            </i-form>

            <div slot="footer">
                <i-button type="primary" @click="syncExportOrder('exportFormModal')" long :loading="modalLoading">
                    确定导出
                </i-button>
            </div>
        </modal>
    </div>
</template>

<script>
    var refund = Vue.component('refund', {
        template: '#refund',
        data: function () {
            var vm = this;
            return {
                reasonList: [
                    {
                        id: '已超过无理由退货时限',
                        name: '已超过无理由退货时限'
                    },{
                        id: '影响二次销售',
                        name: '影响二次销售'
                    },{
                        id: '未上传凭证',
                        name: '未上传凭证'
                    },{
                        id: '其他（要写拒绝说明）',
                        name: '其他（要写拒绝说明）'
                    }
                ],
                searchForm: {
                    seqSearch: null,
                    title: null,
                    dateRange: [],
                    status: null,
                    type: null,
                    pageNum: 1
                },
                statusList: [{
                    id: 1,
                    name: '申请退款'
                }, {
                    id: 2,
                    name: '同意退款'
                }, {
                    id: 3,
                    name: '不同意退款'
                }, {
                    id: 4,
                    name: '退款中'
                }, {
                    id: 5,
                    name: '退款成功'
                }, {
                    id: 6,
                    name: '退款失败'
                }, {
                    id: 7,
                    name: '取消退款'
                }, {
                    id: 8,
                    name: '第三方审核中'
                }, {
                    id: 9,
                    name: '一审通过'
                }],
                typeList: [{
                    id: 0,
                    name: '退款'
                }, {
                    id: 1,
                    name: '换货'
                }, {
                    id: 2,
                    name: '退货退款'
                }],
                expressStatusList: [{
                    id: 0,
                    name: '未发货'
                }, {
                    id: 1,
                    name: '已发货'
                }, {
                    id: 2,
                    name: '已签收'
                }, {
                    id: 3,
                    name: '已拒收'
                }, {
                    id: 4,
                    name: '已收货'
                }],
                searchRule: {},

                tableData: [],
                tableDataCount: 0,
                tableColumns: [{
                    title: '供应商单号',
                    width: 160,
                    key: 'supplierSeq'
                }, {
                    title: '供应商',
                    width: 150,
                    render: function (h, params) {

                        if (utils.isEmpty(params.row.supplierSeq)) {
                            return;
                        }

                        var supplier = store.state.supplierMap[params.row.supplierId];

                        if (supplier == null) {
                            supplier = {
                                name: ''
                            };
                        }
                        return h('div', supplier.name);
                    }
                }, {
                    title: '名称',
                    render: function (h, params) {
                        var count = params.row.count;

                        if (count == 1) {
                            return h('div', params.row.title);
                        }

                        return h('div', params.row.title + '等' + count + '件商品');
                    }
                }, {
                    title: '状态/类型',
                    width: 120,
                    render: function (h, params) {
                        var status = utils.getItem(vm.statusList, 'id', params.row.status);

                        if (status == null) {
                            return;
                        }

                        var type = utils.getItem(vm.typeList, 'id', params.row.type);

                        if (type == null) {
                            return;
                        }

                        return h('div', [h('h4', status.name), h('div', '类型 : ' + type.name)]);
                    }
                }, {
                    title: '用户id',
                    width: 100,
                    key: 'uid'
                }, {
                    title: '申请退款时间',
                    width: 150,
                    key: 'applyTime',
                    format: 'Time'
                }, {
                    title: '申请人/审核人',
                    width: 120,
                    render: function (h, params) {
                        var auditorName = params.row.auditorName;

                        if (auditorName == null) {
                            auditorName = '';
                        }

                        return h('div', [h('h4', '申请人 : ' + params.row.applyName), h('div', '审核人 : ' + auditorName)]);
                    }
                }, {
                    title: '操作',
                    key: 'action',
                    width: 80,
                    render: function (h, params) {

                        if (utils.isEmpty(params.row.supplierSeq)) {
                            return;
                        }

                        return h('Button', {
                            props: {
                                type: 'primary',
                                size: 'small'
                            },
                            on: {
                                click: function () {
                                    vm.goDetail(params);
                                }
                            }
                        }, '详情');
                    }
                }],
                searchLoading: false,

                exportModal: false,
                exportFormModal: {
                    dateRange: []
                },
                exportRuleModal: {
                    dateRange: [
                        {required: true, message: '请选择时间区间', trigger: 'blur', type: 'array'}
                    ]
                },
                modalLoading: false,

                detailModal: false,
                detailFormModal: {
                    uid: null,
                    supplierSeq: null,
                    supplierId: null,
                    type: null,
                    typeLabel: null,
                    status: null,
                    statusLabel: null,
                    payChannel: null,
                    payChannelLabel: null,
                    applyTime: null,
                    payTime: null,
                    describeText: null,
                    comment: null,
                    amt: null,
                    postage: null,
                    totalRefund: null,
                    discount: null,
                    goldAmount: null,
                    productList: [],
                    refundEid: null,
                    refundEName: null,
                    refundEcode: null,
                    refundComment: null,
                    refundProofs: [],
                    disagreeComment: null,
                    addressInfo: null,
                    userInfo: null,
                    phoneInfo: null,
                    isAgree: true,
                    reason: null
                },
                detailFormModalExtra: {
                    columns: [{
                        title: '订单号',
                        width: 180,
                        key: 'orderSeq'
                    }, {
                        title: '退款单号',
                        width: 180,
                        key: 'refundSeq'
                    }, {
                        title: 'skuId',
                        width: 100,
                        key: 'skuId'
                    }, {
                        title: '商品id',
                        width: 100,
                        key: 'pid'
                    }, {
                        title: '商品标题',
                        key: 'title'
                    }, {
                        title: 'sku属性',
                        key: 'attr'
                    }, {
                        title: '数量',
                        width: 80,
                        key: 'quantity'
                    }, {
                        title: '支付金额',
                        width: 100,
                        key: 'price'
                    }],
                    refundFlag: false,
                    continueRefund: false,
                    msg: null
                }
            }
        },
        mounted: function () {
            this.init();
        },
        methods: {
            init: function () {
                with (this) {
                    listByPage(1);
                }
            },
            listByPage: function (pageNum) {
                with (this) {

                    if (pageNum) {
                        searchForm.pageNum = pageNum;
                    }

                    if (searchForm.dateRange.length != 0 && utils.isNotEmpty(searchForm.dateRange[0]) && utils.isNotEmpty(searchForm.dateRange[1])) {

                        searchForm.startTime = Date.parse(searchForm.dateRange[0]);

                        var nextDate = searchForm.dateRange[1];
                        nextDate.setDate(nextDate.getDate() + 1);
                        searchForm.endTime = Date.parse(nextDate);
                    }
                    else {
                        searchForm.startTime = null;
                        searchForm.endTime = null;
                    }

                    utils.get('${contextPath}/orderRefund/listByPage', searchForm, function (result) {
                        if (result.success) {
                            tableData = result.data.list;
                            tableDataCount = result.data.total;
                        }
                        else {
                            $Message.error(result.msg);
                        }
                    }, $data, 'searchLoading');
                }

            },
            exportExcel: function () {
                with (this) {
                    exportFormModal = {
                        dateRange: []
                    };
                    exportModal = true;
                }
            },
            syncExportOrder: function (name) {
                with (this) {
                    $refs[name].validate(function (valid) {
                        if (valid) {

                            var dateRange = exportFormModal.dateRange;

                            if (utils.isEmpty(dateRange[0]) || utils.isEmpty(dateRange[1])) {
                                $Message.error('请选择时间区间');
                                return;
                            }

                            var startTime = Date.parse(dateRange[0]);
                            var endTime = Date.parse(dateRange[1]);

                            if (endTime - startTime > 2592000000) {
                                $Message.error('时间区间不能超过一个月');
                                return;
                            }

                            var data = {
                                method: 'post',
                                action: '${contextPath}/orderRefund/export?startTime=' + startTime + '&endTime=' + endTime
                            };

                            utils.download(data, $data, 'modalLoading');
                        }
                    })
                }
            },
            asyncOK: function (name) {
                with (this) {

                    if (detailFormModal.type != 0 && detailFormModal.isAgree) {
                        if (utils.isEmpty(detailFormModal.addressInfo) || utils.isEmpty(detailFormModal.userInfo) || utils.isEmpty(detailFormModal.phoneInfo)) {
                            $Message.error("请填写完整的退货信息");
                            return;
                        }
                    }

                    if (!detailFormModal.isAgree && utils.isEmpty(detailFormModal.reason)) {
                        $Message.error("请选择不同意理由");
                        return;
                    }

                    if (!detailFormModal.isAgree && detailFormModal.reason == '其他（要写拒绝说明）' && utils.isEmpty(detailFormModal.disagreeComment)) {
                        $Message.error("不同意理由不能为空");
                        return;
                    }

                    if (!detailFormModal.isAgree) {
                        auditRefund();
                        return;
                    }

                    if (utils.isNotEmpty(detailFormModalExtra.msg)) {
                        if (detailFormModalExtra.continueRefund) {
                            $Modal.confirm({
                                title: '校验结果',
                                content: detailFormModalExtra.msg,
                                okText: '继续退款',
                                onOk: function () {
                                    auditRefund();
                                }
                            });
                        }
                        else {
                            $Modal.info({
                                title: '校验结果',
                                content: detailFormModalExtra.msg
                            });
                        }
                    }
                    else {
                        auditRefund();
                    }

                }
            },
            auditRefund: function () {
                with (this) {
                    if (detailFormModal.isAgree){
                        detailFormModal.disagreeComment = null;
                        detailFormModal.reason = '';
                    }else {
                        if(detailFormModal.reason == '其他（要写拒绝说明）'){
                            detailFormModal.disagreeComment = '其他：' + detailFormModal.disagreeComment;
                        }else{
                            detailFormModal.disagreeComment = detailFormModal.reason;
                        }
                    }
                    utils.postJson('${contextPath}/orderRefund/auditRefund', detailFormModal, function (result) {
                        if (result.success) {
                            detailModal = false;
                            $Message.success('操作成功');
                            listByPage();
                            //loadDetail(detailFormModal.supplierSeq, detailFormModal.uid, detailFormModal.applyTime);
                        }
                        else {
                            $Message.error(result.msg);
                        }
                    }, $data, 'modalLoading');
                }
            },
            goDetail: function (params) {
                with (this) {
                    modalLoading = true;
                    detailModal = true;

                    loadDetail(params.row.supplierSeq, params.row.uid, params.row.applyTime);
                }
            },
            loadDetail: function (supplierSeq, uid, applyTime) {
                with (this) {
                    modalLoading = true;
                    utils.get('${contextPath}/orderRefund/orderDetail', {
                        supplierSeq: supplierSeq,
                        uid: uid,
                        applyTime: applyTime
                    }, function (result) {
                        if (result.success) {

                            utils.copyBean(result.data, detailFormModal);
                            detailFormModal.isAgree = true;

                            var expressStatus = utils.getItem(expressStatusList, 'id', detailFormModal.expressStatus);

                            if (expressStatus == null) {
                                expressStatus = {
                                    name: '未发货'
                                };
                            }

                            detailFormModal.expressStatusLabel = expressStatus.name;

                            var type = utils.getItem(typeList, 'id', detailFormModal.type);

                            if (type == null) {
                                type = {
                                    name: ''
                                };
                            }

                            detailFormModal.typeLabel = type.name;


                            var supplier = store.state.supplierMap[detailFormModal.supplierId];

                            if (supplier == null) {
                                supplier = {
                                    name: ''
                                };
                            }

                            detailFormModal.supplierId = supplier.name;

                            var status = utils.getItem(statusList, 'id', detailFormModal.status);

                            detailFormModal.statusLabel = status.name;

                            var payChannel = store.state.payChannelMap[detailFormModal.payChannel];

                            if (payChannel == null) {
                                payChannel = {
                                    label: ''
                                };
                            }

                            var express = store.state.expressMap[detailFormModal.refundEid];

                            if (express == null) {
                                express = {
                                    name: ''
                                };
                            }

                            detailFormModal.refundEName = express.name;

                            detailFormModal.payChannelLabel = payChannel.label;

                            if (detailFormModal.payTime != null) {
                                detailFormModal.payTime = utils.dateFormat(detailFormModal.payTime);
                            }

                            if (detailFormModal.status == 1 || detailFormModal.status == 9) {
                                detailFormModalExtra.refundFlag = true;
                            }
                            else {
                                detailFormModalExtra.refundFlag = false;
                            }

                            detailFormModalExtra.continueRefund = false;
                            detailFormModalExtra.msg = null;
                            if (detailFormModal.type == 0) {
                                //仅退款
                                switch (detailFormModal.expressStatus) {
                                    case 0:
                                        //未发货
                                        break;
                                    case 1:
                                        //已发货
                                        detailFormModalExtra.continueRefund = true;
                                        detailFormModalExtra.msg = "该订单已发货，请联系用户拒收后再退款";
                                        break;
                                    case 2:
                                        //已收货
                                        detailFormModalExtra.continueRefund = true;
                                        detailFormModalExtra.msg = "该订单用户已收货，请联系用户核实后继续退款";
                                        break;
                                    case 3:
                                        //已拒收
                                        break;
                                    case 4:
                                        //已确认收货
                                        detailFormModalExtra.continueRefund = true;
                                        detailFormModalExtra.msg = "该订单用户已收货，请联系用户核实后继续退款";
                                        break;
                                    default:
                                        break;
                                }

                            }
                            else if (detailFormModal.type == 2) {
                                //退货退款

                                //二审
                                if (detailFormModal.status == 9 && detailFormModal.refundEid == null) {
                                    detailFormModalExtra.continueRefund = false;
                                    detailFormModalExtra.msg = "用户未填写退货物流，请联系用户填写";
                                }

                            }

                            modalLoading = false;
                        }
                    });
                }
            },
            getImage: function (url) {
                return store.imgUrl + url;
            },
            onChange: function () {
                with (this) {
                    detailFormModal.disagreeComment = null;
                    detailFormModal.reason = '';
                }
            }
        }
    });

</script>