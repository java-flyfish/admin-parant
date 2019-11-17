<template id="comment">
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
                        <i-input clearable type="text" v-model="searchForm.orderId" placeholder="订单号"
                                 @on-enter="listByPage(1)">
                        </i-input>
                    </form-item>
                    <form-item>
                        <i-input clearable type="text" v-model="searchForm.sId" placeholder="搜索商品id"
                                 @on-enter="listByPage(1)">
                        </i-input>
                    </form-item>
                    <form-item>
                        <Date-Picker type="daterange" v-model="searchForm.dateRange" placeholder="请选择评论时间范围"
                                     style="width:180px"></Date-Picker>
                    </form-item>
                    <form-item>
                        <i-Select clearable v-model="searchForm.sort" placeholder="是否置顶" style="width: 100px">
                            <i-Option v-for="item in isSortList" :value="item.id">{{ item.name }}</i-Option>
                        </i-Select>
                    </form-item>
                    <form-item>
                        <i-Select clearable v-model="searchForm.status" placeholder="请选择状态" style="width: 100px">
                            <i-Option v-for="item in isShowList" :value="item.id">{{ item.name }}</i-Option>
                        </i-Select>
                    </form-item>

                    <form-item>
                        <i-Button type="primary" shape="circle" icon="ios-search" @click="listByPage(1)"
                                  :loading="searchLoading">
                            <span v-if="!searchLoading">查询</span>
                            <span v-else>查询中...</span>
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
               title="评论详情"
               :mask-closable="false"
               fullscreen>
            <i-form :model="detailFormModal" label-width="80">
                <Card style="margin-bottom: 20px">
                    <p slot="title">
                        <Icon type="ios-list"></Icon>
                        基本信息
                    </p>

                    <row>
                        <i-col span="6">
                            <form-item label="id:">
                                {{detailFormModal.id}}
                            </form-item>
                        </i-col>
                        <i-col span="6">
                            <form-item label="商品id:">
                                {{detailFormModal.sid}}
                            </form-item>
                        </i-col>
                        <i-col span="6">
                            <form-item label="用户id:">
                                {{detailFormModal.userId}}
                            </form-item>
                        </i-col>
                        <i-col span="6">
                            <form-item label="评论人卡号:">
                                {{detailFormModal.cardNum}}
                            </form-item>
                        </i-col>
                    </row>
                    <row>
                        <i-col span="6">
                            <form-item label="昵称:">
                                {{detailFormModal.nickName}}
                            </form-item>
                        </i-col>
                        <i-col span="6">
                            <form-item label="会籍等级:">
                                <div v-if="detailFormModal.membershipId==0">优先</div>
                                <div v-if="detailFormModal.membershipId==1">至尊</div>
                                <div v-if="detailFormModal.membershipId==2">总裁</div>
                                <div v-if="detailFormModal.membershipId==3">总统</div>
                                <div v-else></div>
                            </form-item>
                        </i-col>

                        <i-col span="6">
                            <form-item label="订单号:">
                                {{detailFormModal.orderId}}
                            </form-item>
                        </i-col>

                        <#--<i-col span="6">
                            <form-item label="平均评分:">
                                {{detailFormModal.avgScore}}
                            </form-item>
                        </i-col>-->
                    </row>
                    <row>
                        <i-col span="6">
                            <form-item label="点赞数量:">
                                {{detailFormModal.praiseCount}}
                            </form-item>
                        </i-col>
                        <i-col span="6">
                            <form-item label="评论来源:">
                                <div v-if="detailFormModal.source==1">环球黑卡</div>
                                <div v-else-if="detailFormModal.source==2">途牛</div>
                                <div v-else>未知</div>
                            </form-item>
                        </i-col>
                        <i-col span="6">
                            <form-item label="图片:">
                                <div v-if="detailFormModal.hasImg">
                                    是
                                </div>
                                <div v-else>
                                    否
                                </div>
                            </form-item>
                        </i-col>
                        <i-col span="6">
                            <form-item label="是否展示:">
                                <div v-if="detailFormModal.status==0">否</div>
                                <div v-if="detailFormModal.status==1">是</div>
                            </form-item>
                        </i-col>
                    </row>
                    <row>
                        <i-col span="6">
                            <form-item label="创建时间:">
                                {{detailFormModal.created}}
                            </form-item>
                        </i-col>
                        <i-col span="6">
                            <form-item label="评论时间:">
                                {{detailFormModal.commentTime}}
                            </form-item>
                        </i-col>
                        <i-col span="6">
                            <form-item label="审核时间:">
                                {{detailFormModal.auditTime}}
                            </form-item>
                        </i-col>
                        <i-col span="6">
                            <form-item label="审核人:">
                                {{detailFormModal.auditorName}}
                            </form-item>
                        </i-col>
                    </row>
                    <row>
                        <i-col span="24">
                            <form-item label="评论内容:">
                                {{detailFormModal.content}}
                            </form-item>
                        </i-col>
                    </row>
                </Card>

                <Card style="margin-bottom: 20px">
                    <p slot="title">
                        <Icon type="ios-list"></Icon>
                        图片
                    </p>
                        <#--<div v-for="item in detailFormModal.commentImgVos"&lt;#&ndash; class= "height:500px;" style="float:left;"&ndash;&gt;>-->
                            <#--<img :src="getCommentImageUrl(item)" height="450" width="550">-->
                            <#--<img v-for="item in detailFormModal.commentImgVos" :src="item.img" height="350" width="400">-->
                            <img v-for="item in detailFormModal.commentImgVos" :src="getCommentImageUrl(item)" height="350" width="400">
                        <#--</div>-->
                </Card>

                <Card style="margin-bottom: 20px">
                    <p slot="title">
                        <Icon type="ios-list"></Icon>
                        回复评论
                    </p>
                    <i-table stripe :columns="replyTable" :data="replyTableData"></i-table>
                </Card>
            </i-form>

            <div slot="footer">
                <i-button type="primary" @click="detailModal = false">确定</i-button>
            </div>
        </modal>

        <modal
                v-model="imgModal"
                title="图片详情">
            <Carousel v-if="imgModal" v-model="imgValue">
                <Carousel-Item v-for="item in imagesValue">
                        <img :src="getCommentImageUrl(item)" height="450" width="550">
                </Carousel-Item>
            </Carousel>
        </modal>

        <modal v-model="commentReplyModel"
                title="回复评论"
                @on-ok="commentReply">
            <i-input clearable type="text" v-model="commentReplyForm.content" placeholder="请输入评论内容。。。">
            </i-input>
        </modal>

        <modal v-model="commentReplyEditModel"
               title="修改评论"
               @on-ok="commentReplyEdit"
               @on-cancel="commentReplyEditCancel">
            <i-input clearable type="text" v-model="commentReplyForm.content" placeholder="请输入评论内容。。。">
            </i-input>
        </modal>
    </div>
</template>

<script>
    var comment = Vue.component('comment', {
        template: '#comment',
        data: function () {
            var vm = this;

            return {
                commentReplyEditModel: false,
                commentReplyModel: false,
                commentReplyForm: {
                    cid: '',//评论编号
                    type: 1,//系统后台回复
                    content: '',//回复内容
                    replyerNickname: '',//回复人昵称
                    toCardNum: '',//回复对象卡号
                    toNickname: '',//回复对象昵称
                    status: 1,//1-通过
                    sid: '',//商品id
                    orderId: ''//订单号
                },
                auditorName: '${userName}',
                imgValue: 0,
                imgModal: false,
                imagesValue: [],
                replyTableData: [],
                replyTable: [{
                        title: '类型',
                        key: 'type',
                        width: 120,
                        render: function (h, params) {
                            var text = "";
                            if(!utils.isEmpty(params.row.type)){
                                if(params.row.type == 1){
                                    text = "系统后台回复";
                                }else if(params.row.type == 2){
                                    text = "用户回复楼主";
                                }else{
                                    text = "用户回复用户";
                                }
                            }
                            return h('div',text);
                        }
                    },
                    {
                        title: '卡号',
                        key: 'replyerCardNum',
                        width: 100,
                    },
                    {
                        title: '昵称',
                        key: 'replyerNickname',
                        width: 100,
                    },
                    {
                        title: '回复时间',
                        key: 'replyTime',
                        width: 200,
                        render: function (h, params) {
                            var text = new Date(params.row.replyTime).toLocaleString();
                            return h('div',text);
                        }
                    },
                    {
                        title: '内容',
                        key: 'content',
                        width: 385,
                    },
                    {
                        title: '是否展示',
                        key: 'status',
                        width: 100,
                        render: function (h, params) {
                            return h('div',params.row.status ? '展示' : '隐藏');
                        }
                    },
                    {
                        title: '回复人',
                        key: 'replyerNickname',
                        width: 100,
                    },
                    {
                        title: '审核时间',
                        key: 'auditTime',
                        width: 200,
                        render: function (h, params) {
                            var text = new Date(params.row.auditTime).toLocaleString();
                            return h('div',text);
                        }
                    },{
                        title: '操作',
                        key: 'action',
                        width: 120,
                        render: function (h, params) {

                            if (utils.isEmpty(params.row.status)) {
                                return;
                            }
                            /*var text = '展示';
                            if(params.row.status){
                                text = '隐藏';
                            }*/
                            return h('div',[
                                h('Button', {
                                    props: {
                                        type: 'info',
                                        size: 'small'
                                    },
                                    style: {
                                        marginRight: '5px'
                                    },
                                    on: {
                                        click: function () {
                                            vm.updateStatus(params,'删除',1);//0是商品评论，1是评论的回复
                                        }
                                    }
                                }, '删除'),
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
                                            // vm.goDetail(params);
                                            vm.commentReplyForm.cid = vm.detailFormModal.id;//评论编号
                                            vm.commentReplyForm.type = 1;//系统后台回复
                                            vm.commentReplyForm.replyerNickname = vm.auditorName;//回复人昵称
                                            vm.commentReplyForm.toCardNum = vm.detailFormModal.cardNum;//回复对象卡号
                                            vm.commentReplyForm.toNickname = vm.detailFormModal.nickName;//回复对象昵称
                                            vm.commentReplyForm.status = 1,//1-通过
                                            vm.commentReplyForm.sid = vm.detailFormModal.sid;//商品id
                                            vm.commentReplyForm.content = params.row.content;
                                            vm.commentReplyForm.orderId = vm.detailFormModal.orderId;//订单号
                                            vm.commentReplyEditModel = true;
                                        }
                                    }
                                }, '修改'),
                            ])
                        }
                    }
                ],
                searchForm: {
                    userId: null,
                    sort: 2,
                    sId: null,
                    status: 2,
                    orderId: null,
                    dateRange: [],
                    status: null,
                    pageNum: 1
                },
                isShowList: [{
                    id: 2,
                    name: '全部'
                }, {
                    id: 0,
                    name: '隐藏'
                }, {
                    id: 1,
                    name: '展示'
                }],
                isSortList: [{
                    id: 2,
                    name: '全部'
                }, {
                    id: 0,
                    name: '不置顶'
                }, {
                    id: 1,
                    name: '置顶'
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
                    title: '用户ID',
                    key: 'userId',
                    width: 80,

                }, {
                    title: '商品ID',
                    key: 'sid',
                    width: 80,
                }, {
                    title: '评论内容',
                    width: 400,
                    key: 'content',
                },{
                    title: '图片',
                    width: 100,
                    key: 'imgs',
                    render: function (h, params) {
                        return h('div',params.row.hasImg ? '是' : '否');
                    }
                },{
                    title: '置顶',
                    width: 100,
                    key: 'sort',
                    render: function (h, params) {
                        return h('div',params.row.sort == 1 ? '是' : '否');
                    }
                },{
                    title: '状态',
                    width: 80,
                    key: 'status',
                    render: function (h, params) {
                        return h('div',params.row.status ? '展示' : '隐藏');
                    }
                }, {
                    title: '评论时间',
                    width: 150,
                    key: 'commentTime',
                    format: 'Time'
                }, {
                    title: '操作',
                    key: 'action',
                    width: 240,
                    render: function (h, params) {

                        if (utils.isEmpty(params.row.id)) {
                            return;
                        }
                        var imgText = '展示';
                        if(params.row.status){
                            imgText = '隐藏';
                        }
                        var topText = '置顶';
                        if(params.row.sort == 1){
                            topText = '取消置顶';
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
                                        vm.goDetail(params);
                                    }
                                }
                            }, '详情'),
                            h('Button', {
                                props: {
                                    type: 'info',
                                    size: 'small'
                                },
                                style: {
                                    marginRight: '5px'
                                },
                                on: {
                                    click: function () {
                                        vm.updateStatus(params,imgText,0);
                                    }
                                }
                            }, imgText),
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
                                        vm.commentReplyForm.cid = params.row.id;//评论编号
                                        vm.commentReplyForm.type = 1;//系统后台回复
                                        vm.commentReplyForm.replyerNickname = vm.auditorName;//回复人昵称
                                        vm.commentReplyForm.toCardNum = params.row.cardNum;//回复对象卡号
                                        vm.commentReplyForm.toNickname = params.row.nickName;//回复对象昵称
                                        vm.commentReplyForm.status = 1,//1-通过
                                        vm.commentReplyForm.sid = params.row.sid;//商品id
                                        vm.commentReplyForm.orderId = params.row.orderId;
                                        vm.commentReplyModel = true;
                                        // 设置回复评论的相关数据
                                    }
                                }
                            }, '回复'),
                            h('Button', {
                                props: {
                                    type: 'info',
                                    size: 'small'
                                },
                                style: {
                                    marginRight: '5px'
                                },
                                on: {
                                    click: function () {
                                        vm.toCmtTop(params,topText);
                                    }
                                }
                            }, topText)
                        ])
                    }
                }],
                searchLoading: false,

                detailModal: false,
                detailFormModal: {
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

                    utils.get('${contextPath}/productCmt/listByPage', searchForm, function (result) {
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
            toCmtTop: function (params, text){
                with (this) {
                    $Modal.confirm({
                        title: '提示',
                        content: '确认 [ ' + text + ' ] 这条评论？',
                        onOk: function () {
                            var id = params.row.id;
                            var appId = params.row.appId;
                            var userId = params.row.userId;
                            var pid = params.row.sid;
                            var sort;
                            if (utils.isNotEmpty(params.row.sort)){
                                sort = params.row.sort == 0? 1 : 0;
                            }else {
                                sort = 1;
                            }
                            utils.post('${contextPath}/productCmt/toCmtTop', {
                                id: id,
                                appId: appId,
                                userId: userId,
                                pid: pid,
                                sort: sort
                            }, function (result) {
                                if (result.success) {
                                    $Message.success(text + '成功');
                                        listByPage();
                                }
                                else {
                                    $Message.error(result.msg);
                                }
                            }, $data, 'searchLoading');
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
                                auditorName: auditorName,
                                userId: params.row.userId
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
            goDetail: function (params) {
                with (this) {

                    modalLoading = true;
                    detailModal = true;

                    // detailFormModalExtra.editable = false;

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
                            if (utils.isNotEmpty(detailFormModal.auditTime)){
                                detailFormModal.auditTime = new Date(detailFormModal.auditTime).toLocaleString();
                            }else {
                                detailFormModal.auditTime = '';
                            }
                            detailFormModal.updated = new Date(detailFormModal.updated).toLocaleString();
                            detailFormModal.comment = null;
                            replyTableData = detailFormModal.commentReplyVoList;
                        }
                    });
                }
            },
            showImgs: function (params) {
                with (this) {
                    imagesValue = params.split(",");
                    imgModal = true;
                }
            },
            getCommentImageUrl: function (item) {
                if (utils.isNotEmpty(item.img) && item.img.indexOf('http')>-1){
                    return item.img;
                }
                if (item.img) {
                    return store.imgUrl + item.img;
                }
                return '';
            },
            commentReply: function () {
                with (this) {
                    if (utils.isEmpty(commentReplyForm.content)){
                        $Message.error('回复内容不能为空！');
                        return;
                    }
                    utils.post('${contextPath}/productCmt/reply', commentReplyForm, function (result) {
                        if (result.success) {
                            $Message.success(result.msg);
                            commentReplyForm.content = '';
                        }
                        else {
                            $Message.error(result.msg);
                        }
                        commentReplyForm.content = '';
                    }, $data, 'searchLoading');
                }
            },
            commentReplyEdit: function () {
                with (this) {
                    utils.post('${contextPath}/productCmt/edit', commentReplyForm, function (result) {
                        if (result.success) {
                            loadDetail(commentReplyForm.cid,commentReplyForm.sid);
                            $Message.success('回复修改成功');
                        }
                        else {
                            $Message.error(result.msg);
                        }
                        commentReplyForm.content = '';
                    }, $data, 'searchLoading');
                }
            },
            commentReplyEditCancel: function () {
                with (this) {
                    commentReplyForm.content = '';
                }
            }
        }
    });

</script>