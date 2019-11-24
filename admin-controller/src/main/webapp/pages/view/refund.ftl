<template id="refund">
    <div class="auto-height">
        <Layout class="auto-height">
            <i-Header class="layout-header-content color-white">
                <i-form class="auto-height" ref="searchForm" :model="searchForm" :rules="searchRule" inline
                        @submit.native.prevent>

                    <form-item>
                        <i-input clearable type="text" v-model="searchForm.seq" placeholder="搜索本地单号"
                                 @on-enter="listByPage(1)">
                        </i-input>
                    </form-item>
                    <form-item>
                        <i-input clearable type="text" v-model="searchForm.refundSeq" placeholder="搜索退款单号"
                                 @on-enter="listByPage(1)">
                        </i-input>
                    </form-item>

                    <form-item>
                        <Date-Picker type="daterange" v-model="searchForm.dateRange" placeholder="请选择申请退款时间"
                                     style="width:180px"></Date-Picker>
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

                    <#--<form-item>
                        <i-Button type="success" shape="circle" icon="ios-cloud-upload-outline" @click="exportExcel">导出
                        </i-Button>
                    </form-item>-->
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
                            <form-item label="本地单号">
                                {{detailFormModal.seq}}
                            </form-item>
                        </i-col>
                        <i-col span="8">
                            <form-item label="交易单号">
                                {{detailFormModal.outSeq}}
                            </form-item>
                        </i-col>

                        <i-col span="8">
                            <form-item label="退款单号">
                                {{detailFormModal.refundSeq}}
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
                            <form-item label="退款金额">
                                {{detailFormModal.refundFee}}
                            </form-item>
                        </i-col>

                        <i-col span="8">
                            <form-item label="支付金额">
                                {{detailFormModal.payFee}}
                            </form-item>
                        </i-col>

                    </row>
                    <row>
                        <i-col span="8">
                            <form-item label="支付渠道">
                                {{detailFormModal.payChannelLabel}}
                            </form-item>
                        </i-col>

                        <i-col span="8">
                            <form-item label="申请时间">
                                {{detailFormModal.created}}
                            </form-item>
                        </i-col>
                        <i-col span="8">
                            <form-item label="退款时间">
                                {{detailFormModal.refundTime}}
                            </form-item>
                        </i-col>
                    </row>
                </Card>

                <Card v-if="detailFormModal.refundFlag">
                    <p slot="title">
                        <Icon type="ios-list"></Icon>
                        操作面板
                    </p>

                    <row>
                        <i-col span="24">
                            <form-item label="是否同意">
                                <i-switch v-model="detailFormModal.isAgree" size="large" @on-change="onChange">
                                    <span slot="open">同意</span>
                                    <span slot="close">不同意</span>
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

                </Card>

                <Card v-if="detailFormModal.status==4">
                    <p slot="title">
                        <Icon type="ios-list"></Icon>
                        失败理由
                    </p>

                    <row>
                        <i-col span="24">
                            {{detailFormModal.reason}}
                        </i-col>
                    </row>

                </Card>

            </i-form>

            <div slot="footer">

                <i-button type="warning" long :loading="modalLoading" @click="asyncOK('detailFormModal')"
                          v-if="detailFormModal.refundFlag">
                    审核
                </i-button>
                <i-button type="primary" long :loading="modalLoading" @click="detailModal=false"
                          v-else="detailFormModal.refundFlag">
                    确定
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
                        id: '已超过退款期限',
                        name: '已超过退款期限'
                    },{
                        id: '用户无理取闹',
                        name: '用户无理取闹'
                    },{
                        id: '其他（要写拒绝说明）',
                        name: '其他（要写拒绝说明）'
                    }
                ],
                searchForm: {
                    seq: null,
                    refundSeq: null,
                    dateRange: [],
                    status: null,
                    begin: null,
                    end: null,
                    pageNum: 1
                },
                statusList: [{
                    id: 1,
                    name: '申请退款'
                }, {
                    id: 2,
                    name: '退款审核中'
                }, {
                    id: 3,
                    name: '退款完成'
                }, {
                    id: 4,
                    name: '退款失败'
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
                payChannelList: [{
                    name: '微信',
                    id: 1
                },{
                    name: '支付宝',
                    id: 2
                },{
                    name: '银联',
                    id: 3
                }],
                searchRule: {},

                tableData: [],
                tableDataCount: 0,
                tableColumns: [{
                    title: '本地单号',
                    width: 200,
                    key: 'seq'
                },{
                    title: '退款单号',
                    width: 180,
                    key: 'refundSeq'
                }, {
                    title: '退款状态',
                    width: 120,
                    render: function (h, params) {

                        if (utils.isEmpty(params.row.status)) {
                            return;
                        }

                        var status = utils.getItem(vm.statusList, 'id', params.row.status);

                        if (status == null) {
                            status = {
                                name: ''
                            };
                        }
                        return h('div', status.name);
                    }
                }, {
                    title: '退款金额',
                    // width: 80,
                    render: function (h, params) {
                        var refundFee = params.row.refundFee/100;
                        return h('div', refundFee);
                    }
                },{
                    title: '支付渠道',
                    width: 120,
                    render: function(h,params){
                        var payChannel = utils.getItem(vm.payChannelList, 'id', params.row.payChannel);
                        if (!payChannel){
                            payChannel = {
                                name: ''
                            }
                        }
                        return h('div', payChannel.name);
                    }
                },{
                    title: '申请退款时间',
                    width: 150,
                    key: 'created',
                    format: 'Time'
                }, {
                    title: '申请人/审核人',
                    width: 150,
                    render: function (h, params) {

                        var applyName = params.row.applyName;

                        if (applyName == null) {
                            applyName = '';
                        }

                        var checkName = params.row.checkName;

                        if (checkName == null) {
                            checkName = '';
                        }

                        return h('div', [h('h4', '申请人 : ' + applyName), h('div', '审核人 : ' + checkName)]);
                    }
                }, {
                    title: '操作',
                    key: 'action',
                    width: 80,
                    render: function (h, params) {

                        if (utils.isEmpty(params.row.refundSeq)) {
                            return;
                        }

                        return h('Button', {
                            props: {
                                type: 'primary',
                                size: 'small'
                            },
                            on: {
                                click: function () {
                                    vm.goDetail(params.row);
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
                    id: null,
                    seq: null,
                    outSeq: null,
                    refundSeq: null,
                    status: null,
                    statusLabel: null,
                    payChannel: null,
                    payChannelLabel: null,
                    refundFee: null,
                    payFee: null,
                    refundTime: null,
                    comment: null,
                    created: null,
                    updated: null,
                    refundFlag: true,
                    isAgree: null,
                    disagreeComment: null,
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

                        searchForm.begin = Date.parse(searchForm.dateRange[0]);

                        var nextDate = searchForm.dateRange[1];
                        nextDate.setDate(nextDate.getDate() + 1);
                        searchForm.end = Date.parse(nextDate);
                    }
                    else {
                        searchForm.begin = null;
                        searchForm.end = null;
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

                    if (!detailFormModal.isAgree && utils.isEmpty(detailFormModal.reason)) {
                        $Message.error("请选择不同意理由");
                        return;
                    }

                    if (!detailFormModal.isAgree && detailFormModal.reason == '其他（要写拒绝说明）' && utils.isEmpty(detailFormModal.disagreeComment)) {
                        $Message.error("不同意理由不能为空");
                        return;
                    }

                    auditRefund();
                }
            },
            auditRefund: function () {
                with (this) {
                    if (detailFormModal.isAgree){
                        detailFormModal.reason = '';
                    }else {
                        if(detailFormModal.reason == '其他（要写拒绝说明）'){
                            detailFormModal.reason = '其他：' + detailFormModal.disagreeComment;
                        }
                    }
                    utils.post('${contextPath}/orderRefund/doRefund', detailFormModal, function (result) {
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

                    loadDetail(params);
                }
            },
            loadDetail: function (params) {
                with (this) {
                    modalLoading = true;
                    utils.copyBean(params, detailFormModal);
                    detailFormModal.isAgree = false;
                    var status = utils.getItem(statusList, 'id', detailFormModal.status);

                    if (status == null) {
                        status = {
                            name: ''
                        };
                    }
                    detailFormModal.statusLabel = status.name;

                    detailFormModal.orderFee = detailFormModal.orderFee/100;
                    detailFormModal.payFee = detailFormModal.payFee/100;
                    detailFormModal.refundFee = detailFormModal.refundFee/100;
                    detailFormModal.refundTime = utils.dateFormat(detailFormModal.refundTime);
                    detailFormModal.created = utils.dateFormat(detailFormModal.created);
                    detailFormModal.updated = utils.dateFormat(detailFormModal.updated);


                    var payChannel = utils.getItem(payChannelList, 'id', detailFormModal.payChannel);
                    if (payChannel){
                        detailFormModal.payChannelLabel = payChannel.name;
                    }else {
                        detailFormModal.payChannelLabel = '';
                    }

                    if (detailFormModal.status == 3 || detailFormModal.status == 4){
                        detailFormModal.refundFlag = false;
                    }else {
                        detailFormModal.reason = '';
                        detailFormModal.refundFlag = true;
                    }
                    modalLoading = false;
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