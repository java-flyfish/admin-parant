<template id="pvStatistic">
    <div class="auto-height">
        <Layout class="auto-height">
            <i-Header class="layout-header-content color-white">
                <i-form class="auto-height" ref="searchForm" :model="searchForm" :rules="searchRule" inline
                        @submit.native.prevent>
                    <form-item>
                        <i-input clearable type="text" v-model="searchForm.source" placeholder="搜索渠道"
                                 @on-enter="listByPage(1)">
                        </i-input>
                    </form-item>
                    <form-item>
                        <i-Select clearable v-model="searchForm.type" placeholder="请选择时间维度" style="width: 100px">
                            <i-Option v-for="item in typeList" :value="item.id">{{ item.name }}</i-Option>
                        </i-Select>
                    </form-item>

                    <form-item>
                        <Date-Picker type="daterange" v-model="searchForm.dateRange" placeholder="请选择时间范围"
                                     style="width:180px"></Date-Picker>
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
               title="订单详情"
               :mask-closable="false"
               fullscreen>
            <i-form :model="detailFormModal" label-width="80">
                <Card style="margin-bottom: 20px">
                    <p slot="title">
                        <Icon type="ios-list"></Icon>
                        基本信息
                    </p>

                    <row>
                        <i-col span="8">
                            <form-item label="订单id">
                                {{detailFormModal.id}}
                            </form-item>
                        </i-col>
                        <i-col span="8">
                            <form-item label="订单号">
                                {{detailFormModal.seq}}
                            </form-item>
                        </i-col>
                        <i-col span="8">
                            <form-item label="名字">
                                {{detailFormModal.name}}
                            </form-item>
                        </i-col>
                    </row>
                    <row>
                        <i-col span="8">
                            <form-item label="手机号">
                                {{detailFormModal.phone}}
                            </form-item>
                        </i-col>
                        <i-col span="8">
                            <form-item label="状态">
                                <div v-if="detailFormModalExtra.editable">
                                    <i-Select v-model="detailFormModal.status">
                                        <i-Option v-for="item in statusList" :value="item.id">{{ item.name }}</i-Option>
                                    </i-Select>
                                </div>
                                <div v-else>
                                    {{detailFormModal.statusLabel}}
                                </div>
                            </form-item>
                        </i-col>
                        <i-col span="8">
                            <form-item label="广告来源">
                                {{detailFormModal.adtSource}}
                            </form-item>
                        </i-col>
                    </row>

                </Card>

                <Card style="margin-bottom: 20px">
                    <p slot="title">
                        <Icon type="ios-list"></Icon>
                        支付信息
                    </p>

                    <row>
                        <i-col span="8">
                            <form-item label="支付渠道">
                                <form-item label="广告来源">
                                    {{detailFormModal.payChannelLabel}}
                                </form-item>
                            </form-item>
                        </i-col>
                        <i-col span="8">
                            <form-item label="交易流水号">
                                {{detailFormModal.outSeq}}
                            </form-item>
                        </i-col>
                        <i-col span="8">
                            <form-item label="支付时间">
                                    {{detailFormModal.payTime}}
                            </form-item>
                        </i-col>
                    </row>

                    <row>
                        <i-col span="8">
                            <form-item label="总金额">
                                {{detailFormModal.orderFeeYuan}}
                                <Tooltip max-width="500px" content="扣除优惠前的订单金额"
                                         placement="top">
                                    <Icon type="md-alert"></Icon>
                                </Tooltip>
                            </form-item>
                        </i-col>
                        <i-col span="8" style="font-weight: bold">
                            <form-item label="支付金额">
                                {{detailFormModal.payFeeYuan}}
                            </form-item>
                        </i-col>
                    </row>

                    <row>
                        <i-col span="8">
                            <form-item label="创建时间">
                                {{detailFormModal.created}}
                            </form-item>
                        </i-col>
                        <i-col span="8">
                            <form-item label="更新时间">
                                {{detailFormModal.updated}}
                            </form-item>
                        </i-col>
                    </row>
                </Card>
            </i-form>

            <div slot="footer">

                <row>
                    <i-button type="info" long :loading="modalLoading" @click="detailModal=false">
                        <span >确定</span>
                    </i-button>
                </row>

            </div>
        </modal>

        <modal v-model="modal"
               :title="modalTitle"
               :mask-closable="false"
               :styles="{top: '20px'}">
            <i-form ref="formModal" :model="formModal" :rules="ruleModal" label-width="80">

                <form-item label="订单号">
                    {{formModal.seq}}
                </form-item>

                <row>
                    <i-col span="8">
                        <form-item label="退款金额">
                            <#--{{formModal.refundFeeYuan}}-->
                            <i-input type="string" v-model="formModal.refundFeeYuan">
                            </i-input>
                        </form-item>
                    </i-col>
                </row>

                <form-item prop="comment" label="退款理由">
                    <i-input type="textarea" :autosize="{minRows: 2,maxRows: 5}"
                             v-model="formModal.comment">
                    </i-input>
                </form-item>

            </i-form>

            <div slot="footer">
                <i-button type="primary" @click="asyncOK('formModal')" long :loading="modalLoading">
                    确定
                </i-button>
            </div>
        </modal>
    </div>
</template>

<script>
    var pvStatistic = Vue.component('pvStatistic', {
        template: '#pvStatistic',
        data: function () {
            var vm = this;

            return {
                searchForm: {
                    source: null,
                    type: 1,
                    dateRange: null,
                    beginTime: null,
                    endTime: null,
                    pageNum: 1
                },
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
                typeList: [{
                    name: '年',
                    id: 1
                },{
                    name: '月',
                    id: 2
                },{
                    name: '周',
                    id: 3
                },{
                    name: '日',
                    id: 4
                },{
                    name: '小时',
                    id: 5
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
                    title: '渠道',
                    // width: 200,
                    key: 'source',
                },{
                    title: 'pv',
                    width: 120,
                    key: 'click',
                }, {
                    title: '点击下单',
                    width: 120,
                    key: 'order',
                }, {
                    title: '点击支付',
                    width: 120,
                    key: 'pay',
                }, {
                    title: '订单数',
                    width: 120,
                    key: 'sumOrder'
                }, {
                    title: '支付数',
                    width: 160,
                    key: 'payOrder',

                }, {
                    title: '支付金额',
                    width: 100,
                    render: function (h, params) {
                        var sumPay = 0;
                        if(params.row.sumPay){
                            sumPay = params.row.sumPay/100;
                        }
                        return h('div', sumPay);
                    }
                },{
                    title: '时间',
                    width: 140,
                    key: 'time'
                }],
                searchLoading: false,

                modal: false,
                modalTitle: '发起退款',
                modalLoading: false,
                formModal: {
                    seq: null,
                    refundFee: null,
                    comment: null
                },
                ruleModal: {
                    comment: [
                        {required: true, message: '请输入退款描述', trigger: 'blur'}
                    ]
                },

                exportModal: false,
                exportFormModal: {
                    timeType: '1',
                    dateRange: []
                },
                exportRuleModal: {
                    timeType: [
                        {required: true, message: '请选择时间类型', trigger: 'blur'}
                    ],
                    dateRange: [
                        {required: true, message: '请选择时间区间', trigger: 'blur', type: 'array'}
                    ]
                },

                detailModal: false,
                detailFormModal: {
                    seq: null,
                    outSeq: null,
                    name: null,
                    phone: null,
                    status: null,
                    adtSource: null,
                    orderFee: null,
                    payFee: null,
                    Integer: null,
                    payTime: null,
                    created: null,
                    updated: null
                },
                detailFormModalExtra: {
                    stepCurrent: 0,
                    columns: [{
                        title: '订单号',
                        width: 160,
                        key: 'seq'
                    }, {
                        title: 'skuId',
                        width: 80,
                        key: 'skuId'
                    }, {
                        title: '商品id',
                        width: 80,
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
                    }, {
                        title: '备注',
                        key: 'comment'
                    }, {
                        title: '物流',
                        width: 180,
                        render: function (h, params) {
                            return h('div', [
                                h('h3', params.row.eName),
                                h('div', params.row.logisticsNo)
                            ]);
                        }
                    }],
                    refundAble: false,
                    editable: false
                },
                //源 1:微信公众号 2:支付宝服务窗 3:PC网站 4:WAP网站 5:APP 12:思域
                sourceList: [{
                    name: '微信小程序',
                    id: 1
                },{
                    name: '支付宝服务窗',
                    id: 2
                },{
                    name: 'PC网站',
                    id: 3
                },{
                    name: 'WAP网站',
                    id: 4
                },{
                    name: 'APP',
                    id: 5
                },{
                    name: '骑士会员',
                    id: 9
                },{
                    name: '微信小程序',
                    id: 10
                },{
                    name: '私域',
                    id: 12
                }],
                memberShipList: [{
                    name: '优先会籍V0',
                    id: 0
                }, {
                    name: '至尊会籍V1',
                    id: 1
                }, {
                    name: '总裁会籍V2',
                    id: 2
                }, {
                    name: '总统会籍V3',
                    id: 3
                }]
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
                        searchForm.beginTime = Date.parse(searchForm.dateRange[0]);

                        var nextDate = searchForm.dateRange[1];
                        nextDate.setDate(nextDate.getDate() + 1);
                        searchForm.endTime = Date.parse(nextDate);
                    }
                    else {
                        searchForm.beginTime = null;
                        searchForm.endTime = null;
                    }

                    utils.get('${contextPath}/statistic/pv', searchForm, function (result) {
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
            asyncOK: function (name) {
                with (this) {
                    $refs[name].validate(function (valid) {
                        if (valid) {

                            if (formModal.refundFeeYuan * 100 > formModal.refundFee){
                                $Message.error('实际退款金额不能大于支付金额');
                                return
                            }

                            if (formModal.comment.length>50){
                                $Message.error('退款描述请小于50个字');
                                return
                            }

                            formModal.refundFee = formModal.refundFeeYuan * 100;
                            utils.post('${contextPath}/orderRefund/createRefund', formModal, function (result) {
                                if (result.success) {
                                    modal = false;
                                    $Message.success('操作成功');
                                    // loadDetail(detailFormModal.supplierSeq, detailFormModal.uid);
                                    listByPage();
                                }
                                else {
                                    $Message.error(result.msg);
                                }
                            }, $data, 'modalLoading');
                        }
                    });
                }
            },
            goRefund: function (data) {
                with (this) {

                    if (data.status != 2) {
                        $Message.error('订单状态不能退款');
                        return;
                    }

                    formModal = {
                        seq: data.seq,
                        refundFee: data.payFee,
                        refundFeeYuan: data.payFee/100,
                        comment: null
                    };

                    modal = true;
                }
            },
            goEditOrder: function () {
                with (this) {
                    if (detailFormModalExtra.editable) {

                        //保存动作
                        if (utils.isEmpty(detailFormModal.comment)) {
                            $Message.error('请填写修改原因');
                            return
                        }

                        if (detailFormModal.payChannel != null || detailFormModal.tranId != null || utils.isNotEmpty(detailFormModal.endTime)) {
                            if (detailFormModal.payChannel == null || detailFormModal.tranId == null || utils.isEmpty(detailFormModal.endTime)) {
                                $Message.error('请填写完整的支付信息：支付渠道、交易流水号、支付时间');
                                return
                            }
                        }

                        if (utils.isNotEmpty(detailFormModal.endTime)) {
                            if (!utils.isDate(detailFormModal.endTime)) {
                                $Message.error('支付时间格式不正确,例:2018-10-11 16:37:42');
                                return
                            }
                        }

                        $Modal.confirm({
                            title: '确认更改订单数据？',
                            content: '请确保无误，以免造成严重后果',
                            onOk: function () {
                                utils.postJson('${contextPath}/order/editOrder', detailFormModal, function (result) {
                                    if (result.success) {
                                        $Message.success('操作成功');
                                        listByPage();
                                        loadDetail(detailFormModal.supplierSeq, detailFormModal.uid);
                                    }
                                    else {
                                        $Message.error(result.msg);
                                    }
                                }, $data, 'modalLoading')
                            }
                        });

                        detailFormModalExtra.editable = false;
                    }
                    else {
                        detailFormModalExtra.editable = true;
                    }
                }
            },
            exportExcel: function () {
                with (this) {
                    exportFormModal = {
                        timeType: '1',
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
                                action: '${contextPath}/order/export?timeType=' + exportFormModal.timeType + '&startTime=' + startTime + '&endTime=' + endTime
                            };

                            utils.download(data, $data, 'modalLoading');
                        }
                    })
                }
            },
            goDetail: function (params) {
                with (this) {
                    modalLoading = true;
                    detailModal = true;

                    loadDetail(params.row);
                }
            },
            loadDetail: function (data) {
                with (this) {
                    modalLoading = true;

                    detailFormModal = data;

                    var status = utils.getItem(statusList, 'id', detailFormModal.status);
                    detailFormModal.statusLabel = status.name;

                    var payChannel = utils.getItem(payChannelList, 'id', detailFormModal.payChannel);
                    if (payChannel){
                        detailFormModal.payChannelLabel = payChannel.name;
                    }else {
                        detailFormModal.payChannelLabel = '';
                    }

                    detailFormModal.orderFeeYuan = detailFormModal.orderFee/100;
                    detailFormModal.payFeeYuan = detailFormModal.payFee/100;
                    detailFormModal.payTime = utils.dateFormat(detailFormModal.payTime);
                    detailFormModal.created = utils.dateFormat(detailFormModal.created);
                    detailFormModal.updated = utils.dateFormat(detailFormModal.updated);

                    modalLoading = false;
                }
            }
        }
    });

</script>