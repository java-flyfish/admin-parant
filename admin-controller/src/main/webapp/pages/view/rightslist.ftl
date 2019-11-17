<template id="rightslist">
    <div class="auto-height">
        <Layout class="auto-height">
            <i-Header class="layout-header-content color-white">
                <i-form class="auto-height" ref="searchForm" :model="searchForm" :rules="searchRule" inline
                        @submit.native.prevent>

                    <form-item>
                        <i-input clearable type="text" v-model="searchForm.userId" placeholder="用户id"
                                 @on-enter="listByPage(1)">
                        </i-input>
                    </form-item>

                    <form-item>
                        <i-input clearable type="text" v-model="searchForm.cardNum" placeholder="搜索用户卡号"
                                 @on-enter="listByPage(1)">
                        </i-input>
                    </form-item>

                    <form-item>
                        <Date-Picker type="daterange" v-model="searchForm.dateRange" placeholder="请选择创建时间"
                                     style="width:180px"></Date-Picker>
                    </form-item>

                    <form-item>
                        <i-Select clearable v-model="searchForm.type" placeholder="请选择用户状态" style="width: 100px">
                            <i-Option v-for="item in isRightsList" :value="item.id">{{ item.name }}</i-Option>
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
                        <i-Button icon="md-add" @click="rightsListAddTo">新增</i-Button>
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
        <modal v-model="rightsListEditModal"
               title="黑白名单编辑"
               :mask-closable="false">
            <i-form ref="rightsListFormModal" :model="rightsListFormModal" :rules="editRuleModal" label-width="80">

                <Card style="margin-bottom: 20px">
                    <p slot="title">
                        <Icon type="ios-list"></Icon>
                        基本信息
                    </p>

                    <row>
                        <i-col span="24">
                            <form-item prop="userId" label="用户id">
                                <i-input v-model="rightsListFormModal.userId" type="text" placeholder="请输入用户id">
                                </i-input>
                            </form-item>
                        </i-col>
                    </row>
                    <row>
                        <i-col span="24">
                            <form-item prop="cardNum" label="用户卡号">
                                <i-input v-model="rightsListFormModal.cardNum" type="text" placeholder="请输入用户卡号">
                                </i-input>
                            </form-item>
                        </i-col>
                    </row>
                    <row>
                        <i-col span="24">
                            <form-item prop="type" label="用户状态">
                                <i-Select clearable v-model="rightsListFormModal.type" placeholder="请选择用户状态" style="width: 100px">
                                    <i-Option v-for="item in typeList" :value="item.id">{{ item.name }}</i-Option>
                                </i-Select>
                            </form-item>
                        </i-col>
                    </row>
                    <row>
                        <i-col span="24">
                            <form-item prop="comment" label="备注">
                                <i-input v-model="rightsListFormModal.comment" type="text" placeholder="不超过100个字">
                                </i-input>
                            </form-item>
                        </i-col>
                    </row>
                    <row>
                        <i-col span="24">
                            <form-item prop="created" label="创建时间">
                                <i-input v-model="rightsListFormModal.created" disabled type="text" placeholder="">
                                </i-input>
                            </form-item>
                        </i-col>
                    </row>
                    <row>
                        <i-col span="24">
                            <form-item prop="updated" label="更新时间">
                                <i-input v-model="rightsListFormModal.updated" disabled type="text" placeholder="">
                                </i-input>
                            </form-item>
                        </i-col>
                    </row>
                </Card>
            </i-form>
            <div slot="footer">
                <i-button type="primary" @click="rightsListEdit" long :loading="modalLoading">
                    保存用户
                </i-button>
            </div>
        </modal>
        <modal v-model="rightsListAddModal"
               title="添加黑白名单"
               :mask-closable="false">
            <i-form ref="rightsListFormModal" :model="rightsListFormModal" :rules="addRuleModal" label-width="80">

                <Card style="margin-bottom: 20px">
                    <p slot="title">
                        <Icon type="ios-list"></Icon>
                        基本信息
                    </p>

                    <row>
                        <i-col span="24">
                            <form-item prop="userId" label="用户id">
                                <i-input v-model="rightsListFormModal.userId" type="text" placeholder="请输入用户id">
                                </i-input>
                            </form-item>
                        </i-col>
                    </row>
                    <row>
                        <i-col span="24">
                            <form-item prop="cardNum" label="用户卡号">
                                <i-input v-model="rightsListFormModal.cardNum" type="text" placeholder="请输入用户卡号">
                                </i-input>
                            </form-item>
                        </i-col>
                    </row>
                    <row>
                        <i-col span="24">
                            <form-item prop="type" label="用户状态">
                                <i-Select clearable v-model="rightsListFormModal.type" placeholder="请选择用户状态" style="width: 100px">
                                    <i-Option v-for="item in typeList" :value="item.id">{{ item.name }}</i-Option>
                                </i-Select>
                            </form-item>
                        </i-col>
                    </row>
                    <row>
                        <i-col span="24">
                            <form-item prop="comment" label="备注">
                                <i-input v-model="rightsListFormModal.comment" type="text" placeholder="不超过100个字">
                                </i-input>
                            </form-item>
                        </i-col>
                    </row>
                </Card>
            </i-form>
            <div slot="footer">
                <i-button type="primary" @click="rightsListAdd" long :loading="modalLoading">
                    保存用户
                </i-button>
            </div>
        </modal>
    </div>

</template>

<script>
    var rightslist = Vue.component('rightslist', {
        template: '#rightslist',
        data: function () {
            var vm = this;
            return {
                modalLoading: false,
                rightsListFormModal: {
                    userId: '',
                    cardNum: '',
                    type: '',
                    comment: '',
                },
                rightsListEditModal: false,
                rightsListAddModal: false,
                searchForm: {
                    appId: 2,
                    userId: null,
                    cardNum: '',
                    type: null,
                    dateRange: [],
                    beginTime: null,
                    endTime: null,
                    pageNum: null,
                    pageSize: null
                },
                isRightsList: [{
                    id: 2,
                    name: '全部'
                }, {
                    id: 0,
                    name: '黑名单'
                }, {
                    id: 1,
                    name: '白名单'
                }],
                searchRule: {},
                searchLoading: false,
                tableColumns: [{
                    title: '用户ID',
                    key: 'userId',
                    width: 80,

                }, {
                    title: '卡号',
                    key: 'cardNum',
                    width: 80
                }, {
                    title: '黑白名单',
                    key: 'type',
                    width: 80,
                    render: function (h, params) {
                        return h('div',params.row.type == 0 ? '黑名单' : '白名单');
                    }
                }, {
                    title: '备注',
                    key: 'comment',
                    width: 280
                }, {
                    title: '创建时间',
                    key: 'created',
                    width: 180,
                    format: 'Time'

                }, {
                    title: '更新时间',
                    key: 'updated',
                    width: 180,
                    format: 'Time'
                },{
                    title: '操作',
                    key: 'action',
                    width: 240,
                    render: function (h, params) {

                        if (utils.isEmpty(params.row.id)) {
                            return;
                        }
                        return h('div',[
                            h('Button', {
                                props: {
                                    type: 'primary',
                                    size: 'small'
                                },
                                style: {
                                    marginRight: '5px'
                                },
                                on: {
                                    click: function () {
                                        vm.modifyRightslist(params);
                                    }
                                }
                            }, '编辑'),
                            h('Button', {
                                props: {
                                    type: 'primary',
                                    size: 'small'
                                },
                                style: {
                                    marginRight: '5px'
                                },
                                on: {
                                    click: function () {
                                        vm.deleteRightslist(params);
                                    }
                                }
                            }, '删除')
                        ])
                    }
                }],
                tableData: [],
                tableDataCount: 0,
                typeList: [{
                    id: 0,
                    name: '黑名单'
                }, {
                    id: 1,
                    name: '白名单'
                }],
                editRuleModal: {
                    userId: [
                        {required: true, message: '请填写用户id', trigger: 'blur'},
                        {type: 'string', max: 100, message: '不能超过100个字', trigger: 'blur'}
                    ],
                    /*cardNum: [
                        {required: true, message: '请填写用户卡号', trigger: 'blur'},
                        {type: 'string', max: 100, message: '不能超过100个字', trigger: 'blur'}
                    ],*/
                    type: [
                        {required: true, message: '请选择用户状态', trigger: 'blur'},
                        {type: 'string', max: 100, message: '请选择用户状态', trigger: 'blur'}
                    ]
                },
                addRuleModal: {
                    userId: [
                        {required: true, message: '请填写用户id', trigger: 'blur'},
                        {type: 'string', max: 100, message: '不能超过100个字', trigger: 'blur'}
                    ],
                    /*cardNum: [
                        {required: true, message: '请填写用户卡号', trigger: 'blur'},
                        {type: 'string', max: 100, message: '不能超过100个字', trigger: 'blur'}
                    ],*/
                    type: [
                        {required: true, message: '请选择用户状态', trigger: 'blur'},
                        {type: 'string', max: 100, message: '请选择用户状态', trigger: 'blur'}
                    ]
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
            modifyRightslist: function (params) {
                with (this) {
                    rightsListEditModal = true;
                    utils.get('${contextPath}/rightslist/getRightslistById',{id:params.row.id}, function (result) {
                        if (result.success) {
                            rightsListFormModal = result.data;
                            rightsListFormModal.created = new Date(rightsListFormModal.created).toLocaleString();
                            rightsListFormModal.updated = new Date(rightsListFormModal.updated).toLocaleString();
                        }
                        else {
                            $Message.error(result.msg);
                        }
                    }, $data, 'searchLoading');
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

                    utils.get('${contextPath}/rightslist/getRightslistByPage', searchForm, function (result) {
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
            updateStatus: function (params, text,type) {
                //type = 0是商品评论，1是评论的回复
                with (this) {
                    $Modal.confirm({
                        title: '提示',
                        content: '确认 [ ' + text + ' ] 这条评论？',
                        onOk: function () {
                            var status = params.row.status? 0 : 1;
                            var sId;
                            var cid;
                            if(type == 0){
                                sId = params.row.sid;
                            }else {
                                cid = params.row.cid;
                            }
                            utils.post('${contextPath}/productCmt/updateStatus', {
                                id: params.row.id,
                                status: status,
                                sId: sId,
                                cid: cid,
                                type: type,
                                auditorName: auditorName
                            }, function (result) {
                                if (result.success) {
                                    $Message.success(text + '成功');
                                    if(type == 0){
                                        listByPage();
                                    }else {
                                        loadDetail(detailFormModal.id,detailFormModal.sid);
                                        // replyTableData = result.data;
                                    }
                                }
                                else {
                                    $Message.error(result.msg);
                                }
                            }, $data, 'searchLoading');
                        }
                    });
                }

            },
            goDetail: function (params) {
                with (this) {
                    modalLoading = true;
                    detailModal = true;

                    detailFormModalExtra.editable = false;

                    loadDetail(params.row.id,params.row.sid);
                }
            },
            loadDetail: function (id,sId) {
                with (this) {
                    modalLoading = true;
                    utils.get('${contextPath}/productCmt/getById',{id:id,sId:sId}, function (result) {
                        if (result.success) {
                            detailFormModal = result.data;
                            detailFormModal.commentTime = new Date(detailFormModal.commentTime).toLocaleString();
                            detailFormModal.created = new Date(detailFormModal.created).toLocaleString();
                            detailFormModal.auditTime = new Date(detailFormModal.auditTime).toLocaleString();
                            detailFormModal.updated = new Date(detailFormModal.updated).toLocaleString();
                            detailFormModal.comment = null;
                            replyTableData = detailFormModal.commentReplyVoList;
                        }
                    });
                }
            },
            rightsListEdit: function () {
                with (this) {
                    if (utils.isEmpty(rightsListFormModal.userId)){
                        $Message.error('请输入用户id！');
                        return;
                    }
                    /*if (utils.isEmpty(rightsListFormModal.cardNum)){
                        $Message.error('请输入用户卡号！');
                        return;
                    }*/
                    if (utils.isEmpty(rightsListFormModal.type)){
                        $Message.error('请选择用户类型！');
                        return;
                    }
                    utils.post('${contextPath}/rightslist/modifyRightslist', rightsListFormModal, function (result) {
                        if (result.success) {
                            $Message.success(result.data);
                            rightsListEditModal = false;
                            listByPage(searchForm.pageNum);
                        }
                        else {
                            $Message.error(result.data);
                        }
                    }, $data, 'searchLoading');
                }
            },

            rightsListAddTo: function () {
                with (this) {
                    rightsListFormModal.id = '';
                    rightsListFormModal.userId = '';
                    rightsListFormModal.cardNum = '';
                    rightsListFormModal.type = '';
                    rightsListFormModal.comment = '';
                    rightsListAddModal = true;
                }
            },
            rightsListAdd: function () {
                with (this) {
                    if (utils.isEmpty(rightsListFormModal.userId)){
                        $Message.error('请输入用户id！');
                        return;
                    }
                    /*if (utils.isEmpty(rightsListFormModal.cardNum)){
                        $Message.error('请输入用户卡号！');
                        return;
                    }*/
                    if (utils.isEmpty(rightsListFormModal.type)){
                        $Message.error('请选择用户类型！');
                        return;
                    }

                    utils.post('${contextPath}/rightslist/modifyRightslist', rightsListFormModal, function (result) {
                        if (result.success) {
                            $Message.success(result.data);
                            rightsListAddModal = false;
                            listByPage(searchForm.pageNum);
                        }
                        else {
                            $Message.error(result.msg);
                        }
                    }, $data, 'searchLoading');
                }
            },
            deleteRightslist: function (params) {
                with (this) {
                    $Modal.confirm({
                        title: '提示',
                        content: '确认 [  删除  ] 这条名单？',
                        onOk: function () {
                            utils.post('${contextPath}/rightslist/deleteRightslist', {id:params.row.id}, function (result) {
                                if (result.success) {
                                    $Message.success(result.data);
                                    listByPage(searchForm.pageNum);
                                }
                                else {
                                    $Message.error(result.data);
                                }
                            }, $data, 'searchLoading');
                        }
                    });
                }
            }
        }
    });

</script>