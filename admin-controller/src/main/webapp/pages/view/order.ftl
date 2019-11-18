<template id="order">
    <div class="auto-height">
        <Layout class="auto-height">
            <i-Header class="layout-header-content color-white">
                <i-form class="auto-height" ref="searchForm" :model="searchForm" :rules="searchRule" inline
                        @submit.native.prevent>

                    <form-item>
                        <i-input clearable type="text" v-model="searchForm.seqSearch" placeholder="搜索单号"
                                 @on-enter="listByPage(1)">
                        </i-input>
                    </form-item>
                    <form-item>
                        <i-input clearable type="text" v-model="searchForm.userSearch" placeholder="搜索用户id/卡号"
                                 @on-enter="listByPage(1)">
                        </i-input>
                    </form-item>

                    <form-item>
                        <Date-Picker type="daterange" v-model="searchForm.dateRange" placeholder="请选择创建时间"
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
                    <#--<row>

                        <i-col span="8">
                            <form-item label="是否删除">
                                <div v-if="detailFormModalExtra.editable">
                                    <i-switch v-model="detailFormModal.userDel" size="large">
                                        <span slot="open">是</span>
                                        <span slot="close">否</span>
                                    </i-switch>
                                </div>
                                <div v-else>
                                    {{detailFormModal.userDel?'是':'否'}}
                                </div>
                            </form-item>
                        </i-col>

                        <i-col span="8" v-if="detailFormModalExtra.editable">
                            <form-item label="修改原因">
                                <i-input type="textarea" :autosize="{minRows: 2,maxRows: 5}"
                                         v-model="detailFormModal.comment">
                                </i-input>
                            </form-item>
                        </i-col>
                    </row>-->
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

<#--
                <i-button type="error" long :loading="modalLoading" v-if="!detailFormModalExtra.refundAble"
                          @click="goEditOrder">
                    <span v-if="detailFormModalExtra.editable">保存</span>
                    <span v-else>更改</span>
                </i-button>
-->

                <row>
                    <i-button type="info" long :loading="modalLoading" @click="detailModal=false">
                        <span >确定</span>
                    </i-button>
                </row>
                <row v-if="detailFormModalExtra.refundAble">
                    <i-col span="11">
                        <i-button type="error" long :loading="modalLoading" @click="goEditOrder">
                            <span v-if="detailFormModalExtra.editable">保存</span>
                            <span v-else>更改</span>
                        </i-button>
                    </i-col>
                    <i-col span="11" offset="2">
                        <i-button type="primary" long :loading="modalLoading" @click="goRefund"
                                  :disabled="detailFormModalExtra.editable">
                            退款
                        </i-button>
                    </i-col>
                </row>

            </div>
        </modal>

        <modal v-model="modal"
               :title="modalTitle"
               :mask-closable="false"
               :styles="{top: '20px'}">
            <i-form ref="formModal" :model="formModal" :rules="ruleModal" label-width="80">

                <form-item label="供应商">
                    {{detailFormModal.supplierId}}
                </form-item>

                <row>
                    <i-col span="8">
                        <form-item label="退支付金额">
                            {{detailFormModal.price}}
                        </form-item>
                    </i-col>
                    <i-col span="8">

                        <form-item label="退邮费">
                            {{formModal.postage}}
                            <Tooltip :content="formModal.tip" placement="top">
                                <Icon type="md-alert"></Icon>
                            </Tooltip>
                        </form-item>
                    </i-col>
                    <i-col span="8">
                        <form-item label="合计退款" style="color:crimson">
                            {{formModal.totalRefund}}
                        </form-item>
                    </i-col>
                </row>

                <row>
                    <i-col span="8">
                        <form-item label="退自由币">
                            {{detailFormModal.discount}}
                        </form-item>
                    </i-col>
                    <i-col span="8">
                        <form-item label="收回自由币">
                            {{detailFormModal.goldAmount}}
                        </form-item>
                    </i-col>
                </row>

                <form-item prop="type" label="退款类型">
                    <i-Select v-model="formModal.type">
                        <i-Option value="0">退款</i-Option>
                        <i-Option value="1" disabled>退货</i-Option>
                        <i-Option value="2">退货退款</i-Option>
                    </i-Select>
                </form-item>

                <form-item prop="describeText" label="退款描述">
                    <i-Select v-model="formModal.describeText">
                        <i-Option value="30天无理由退货">30天无理由退货</i-Option>
                        <i-Option value="尺寸拍错/不喜欢/效果不好">尺寸拍错/不喜欢/效果不好</i-Option>
                        <i-Option value="质量问题">质量问题</i-Option>
                        <i-Option value="材质与商品描述不符">材质与商品描述不符</i-Option>
                        <i-Option value="大小尺寸与商品描述不符">大小尺寸与商品描述不符</i-Option>
                        <i-Option value="做工瑕疵">做工瑕疵</i-Option>
                        <i-Option value="颜色/款式/型号等描述不符">颜色/款式/型号等描述不符</i-Option>
                        <i-Option value="配件破损">配件破损</i-Option>
                        <i-Option value="发错货">发错货</i-Option>
                        <i-Option value="商品少件/破损/污渍等">商品少件/破损/污渍等</i-Option>
                        <i-Option value="其他">其他</i-Option>
                    </i-Select>
                </form-item>

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

        <modal v-model="exportModal"
               title="导出订单,数据量大请耐心等待30秒时间"
               :mask-closable="false"
               :styles="{top: '20px'}">

            <i-form ref="exportFormModal" :model="exportFormModal" :rules="exportRuleModal" label-width="80">

                <form-item prop="timeType" label="时间类型">
                    <i-Select v-model="exportFormModal.timeType">
                        <i-Option value="1">订单创建时间</i-Option>
                        <i-Option value="2">支付时间</i-Option>
                    </i-Select>
                </form-item>

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
    var order = Vue.component('order', {
        template: '#order',
        data: function () {
            var vm = this;

            return {
                searchForm: {
                    seqSearch: null,
                    userSearch: null,
                    title: null,
                    dateRange: [],
                    status: null,
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
                statusList: [{
                    name: '待付款',
                    id: 1
                },{
                    name: '已付款',
                    id: 2
                },{
                    name: '申请退款',
                    id: 3
                },{
                    name: '退款审核中',
                    id: 4
                },{
                    name: '退款完成',
                    id: 5
                },{
                    name: '退款失败',
                    id: 6
                },{
                    name: '订单过期',
                    id: 7
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
                    title: '本地单号',
                    width: 150,
                    key: 'seq',
                },{
                    title: '第三方交易单号',
                    width: 150,
                    key: 'outSeq',
                }, {
                    title: '姓名',
                    width: 120,
                    key: 'name',
                }, {
                    title: '手机号',
                    width: 120,
                    key: 'phone',
                }, {
                    title: '订单状态',
                    render: function (h, params) {
                        /*var statusList = [{
                            name: '待付款',
                            id: 1
                        },{
                            name: '已付款',
                            id: 2
                        },{
                            name: '申请退款',
                            id: 3
                        },{
                            name: '退款审核中',
                            id: 4
                        },{
                            name: '退款完成',
                            id: 5
                        },{
                             name: '退款失败',
                              id: 6
                        },{
                            name: '订单过期',
                            id: 7
                        }];*/
                        var status = utils.getItem(vm.statusList, 'id', params.row.status);
                        if(!status){
                            status = {
                                name: '未知'
                            };
                        }
                        return h('div', status.name);
                    }
                }, {
                    title: '订单来源',
                    width: 160,
                    key: 'adtSource',

                }, {
                    title: '订单价格',
                    width: 160,
                    render: function (h, params) {
                        return h('div', params.row.orderFee/100);
                    }
                },{
                    title: '支付',
                    width: 160,
                    render: function (h, params) {
                        return h('div', params.row.payFee/100);
                    }
                },{
                    title: '支付渠道',
                    render: function (h, params) {
                        /*var payChannelList = [{
                            name: '微信',
                            id: 1
                        },{
                            name: '支付宝',
                            id: 2
                        },{
                            name: '银联',
                            id: 3
                        }];*/
                        var payChannel = utils.getItem(vm.payChannelList, 'id', params.row.payChannel);
                        if(!payChannel){
                            payChannel = {
                                name: '未知'
                            };
                        }
                        return h('div', payChannel.name);
                    }
                },{
                    title: '创建时间',
                    width: 150,
                    key: 'created',
                    format: 'Time'
                }, {
                    title: '操作',
                    key: 'action',
                    width: 160,
                    render: function (h, params) {

                        if (utils.isEmpty(params.row.seq)) {
                            return;
                        }

                        return h('div',[
                            h('Button', {
                            props: {
                                type: 'primary',
                                size: 'small'
                            },
                            on: {
                                click: function () {
                                    vm.goDetail(params);
                                }
                            }
                        }, '详情'),
                            h('Button', {
                                props: {
                                    type: 'warning',
                                    size: 'small'
                                },
                                on: {
                                    click: function () {
                                        vm.goRefund(params);
                                    }
                                }
                            }, '退款')
                        ]);
                    }
                }],
                searchLoading: false,

                modal: false,
                modalTitle: '发起退款',
                modalLoading: false,
                formModal: {
                    type: null,
                    amt: null,
                    describeText: null,
                    comment: null
                },
                ruleModal: {
                    type: [
                        {required: true, message: '请选择退款类型', trigger: 'blur'}
                    ],
                    describeText: [
                        {required: true, message: '请选择退款描述', trigger: 'blur'}
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
                        searchForm.startTime = Date.parse(searchForm.dateRange[0]);

                        var nextDate = searchForm.dateRange[1];
                        nextDate.setDate(nextDate.getDate() + 1);
                        searchForm.endTime = Date.parse(nextDate);
                    }
                    else {
                        searchForm.startTime = null;
                        searchForm.endTime = null;
                    }

                    utils.get('${contextPath}/orderInfo/listByPage', searchForm, function (result) {
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

                            utils.post('${contextPath}/orderRefund/createRefund', formModal, function (result) {
                                if (result.success) {
                                    modal = false;
                                    $Message.success('操作成功');
                                    loadDetail(detailFormModal.supplierSeq, detailFormModal.uid);
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
            goRefund: function (params) {
                with (this) {
                    var expressStatus = detailFormModal.expressStatus;

                    var type = null;

                    if (expressStatus == null || expressStatus == 0 || expressStatus == 3) {
                        type = '0';
                    }

                    if (expressStatus == 2 || expressStatus == 4) {
                        type = '2';
                    }

                    if (type == null) {
                        $Message.error('订单为已发货状态，不能退款');
                        return;
                    }

                    var tip = '支付邮费:' + detailFormModal.postage;
                    var postage = detailFormModal.postage;
                    if (expressStatus != null && expressStatus != 0) {
                        postage = 0;
                        tip = '该订单已发货，不退邮费';
                    }

                    var totalRefund = (Number(detailFormModal.price + postage)).toFixed(2);

                    formModal = {
                        supplierSeq: detailFormModal.supplierSeq,
                        uid: detailFormModal.uid,
                        type: type,
                        describeText: null,
                        comment: null,
                        totalRefund: totalRefund,
                        postage: postage,
                        tip: tip
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

//                        if (detailFormModal.tranId != null) {
//                            if (detailFormModal.tranId.length < 20) {
//                                $Message.error('交易流水号不正确');
//                                return
//                            }
//                        }

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

                    detailFormModalExtra.editable = false;

                    loadDetail(params.row);
                }
            },
            loadDetail: function (data) {
                with (this) {
                    modalLoading = true;

                    detailFormModal = data;

                    // detailFormModal.comment = null;

                    /*if (detailFormModal.status == 2) {
                        detailFormModalExtra.refundAble = true;
                    }
                    else {
                        detailFormModalExtra.refundAble = false;
                    }

                    if (detailFormModal.status == 10 || detailFormModal.status == 13) {
                        detailFormModal.tranFlag = true;
                    } else {
                        detailFormModal.tranFlag = false;
                    }

                    detailFormModal.recordList.forEach(function (t, number) {
                        t.time = utils.dateFormat(t.created);
                    });

                    detailFormModalExtra.stepCurrent = detailFormModal.recordList.length - 1;

                    var expressStatus = utils.getItem(expressStatusList, 'id', detailFormModal.expressStatus);

                    if (expressStatus == null) {
                        expressStatus = {
                            name: '未发货'
                        };
                    }

                    detailFormModal.expressStatusLabel = expressStatus.name;

                    var supplier = store.state.supplierMap[detailFormModal.supplierId];

                    if (supplier == null) {
                        supplier = {
                            name: ''
                        };
                    }

                    detailFormModal.supplierId = supplier.name;*/

                    var status = utils.getItem(statusList, 'id', detailFormModal.status);
                    detailFormModal.statusLabel = status.name;

                    var payChannel = utils.getItem(payChannelList, 'id', detailFormModal.status);
                    if (!payChannel){
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