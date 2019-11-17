<template id="recommend">
    <div class="auto-height">
        <Layout class="auto-height">
            <i-Header class="layout-header-content color-white">
                <i-form class="auto-height" ref="searchForm" :model="searchForm" :rules="searchRule" inline
                        @submit.native.prevent>

                    <form-item>
                        <i-input clearable type="text" v-model="searchForm.title" placeholder="推文标题"
                                 @on-enter="listByPage(1)">
                        </i-input>
                    </form-item>

                    <form-item>
                        <i-input clearable type="text" v-model="searchForm.pid" placeholder="商品id"
                                 @on-enter="listByPage(1)">
                        </i-input>
                    </form-item>

                    <form-item>
                        <i-Select clearable v-model="searchForm.status" placeholder="状态" style="width: 100px">
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
                        <i-Button icon="md-add" @click="recommendAddTo">新增</i-Button>
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

        <modal v-model="recommendModal"
               :title="recommendMotifyModalTitle"
               :mask-closable="false"
               fullscreen>
            <i-form ref="recommendFormModal" :model="recommendFormModal" :rules="motifyRuleModal" label-width="80">

                <Card style="margin-bottom: 20px">
                    <p slot="title">
                        <Icon type="ios-list"></Icon>
                        基本信息
                    </p>

                    <row>
                        <i-col span="6">
                            <form-item prop="pid" label="商品id">
                                <i-input v-model="recommendFormModal.pid" type="text" placeholder="请输入商品id">
                                </i-input>
                            </form-item>
                        </i-col>
                    </row>
                    <row>
                        <i-col span="6">
                            <form-item prop="title" label="推文标题">
                                <i-input v-model="recommendFormModal.title" type="text" placeholder="请输入推文标题">
                                </i-input>
                            </form-item>
                        </i-col>
                    </row>
                    <row>
                        <i-col span="6">
                            <form-item prop="status" label="状态">
                                <i-Select clearable v-model="recommendFormModal.status" placeholder="状态" style="width: 100px">
                                    <i-Option v-for="item in statusList" :value="item.id">{{ item.name }}</i-Option>
                                </i-Select>
                            </form-item>
                        </i-col>
                    </row>
                    <row>
                        <i-col span="6">
                            <form-item prop="releaseTimeStr" label="上线时间">
                                <Date-Picker v-model="recommendFormModal.releaseTimeStr" type="datetime" placeholder="请选择上线时间"
                                             class="auto-width"></Date-Picker>
                            </form-item>
                        </i-col>
                    </row>
                    <row>
                        <i-col span="6">
                            <form-item v-if="isEdit" prop="created" label="创建时间">
                                <Date-Picker v-model="recommendFormModal.created" type="datetime" placeholder="创建时间"
                                             class="auto-width" disabled="false"></Date-Picker>
                            </form-item>
                        </i-col>
                    </row>
                    <row>
                        <i-col span="6">
                            <form-item v-if="isEdit" prop="updated" label="更新时间">
                                <Date-Picker v-model="recommendFormModal.updated" type="datetime" placeholder="更新时间"
                                             class="auto-width" disabled="false"></Date-Picker>
                            </form-item>
                        </i-col>
                    </row>
                    <row>
                        <i-col span="24">
                            <form-item label="添加推文：">
                            <row v-for="(item,index) in recommendFormModal.describeText" style="padding-bottom: 10px">

                                <Divider>推文{{index+1}}</Divider>

                                <i-col span="24">
                                    <row>
                                        <i-col span="12">
                                            <i-input clearable  v-model="item.text" type="textarea" :rows="4" placeholder="推文内容">
                                            </i-input>
                                        </i-col>
                                        <i-col span="12">
                                            <div style="float:left">
                                            <Upload :action="upload.action"
                                                    :format="upload.format"
                                                    :multiple="false"
                                                    :show-upload-list="false"
                                                    :on-success="(response, file, fileList)=>handleUploadSuccess(response, file, fileList,index)">
                                                <div  style="border:1px dashed #DCDCDC; ;width: 95px;height:95px;text-align: center;"  >
                                                    <Icon type="ios-cloud-upload" size="26" color="#3399ff" style="margin-top: 35px"></Icon>
                                                    <p>上传图片</p>
                                                </div>
                                            </Upload>
                                            </div>
                                            <div style="float:left">
                                                <div v-if="item.img" style="display: inline-block;">
                                                    <img :src="getImageUrl(item.img)" :height=95 :width=95>
                                                    <sup class="float-dot" @click="handleRemove(index)">x</sup>
                                                </div>
                                            </div>
                                        </i-col>
                                    </row>
                                    <row>
                                        <i-col span="12">
                                            <i-Button type="error" @click="deleteRuleRecommend(item)">
                                                删除
                                            </i-Button>
                                        </i-col>
                                    </row>
                                </i-col>
                            </row>
                            <row>
                                <i-col span="24">
                                    <i-Button type="success" icon="md-add" @click="addRuleRecommend">
                                        新增推文
                                    </i-Button>
                                </i-col>
                            </row>
                        </form-item>
                        </i-col>
                    </row>
                </Card>
            </i-form>
            <div slot="footer">
                <i-button type="primary" @click="modifyRecommend" long :loading="modalLoading">
                    保存推荐商品
                </i-button>
            </div>
        </modal>
    </div>

</template>

<script>
    var recommend = Vue.component('recommend', {
        template: '#recommend',
        data: function () {
            var vm = this;
            return {
                isOnloneId: null,
                upload: {
                    action: '${contextPath}/recommendProduct/uploadImg',
                    format: ['jpg', 'jpeg', 'png']
                },
                isEdit: false,
                modalLoading: false,
                recommendModal: false,
                recommendMotifyModalTitle: '',
                recommendFormModal: {
                    pid: '',
                    title: '',
                    describeText: [],
                    releaseTime: '',
                    status: 1,
                    created: '',
                    updated: '',
                },
                searchForm: {
                    status: null,
                    title: null,
                    pid: '',
                    dateRange: [],
                    beginTime: null,
                    endTime: null,
                    pageNum: 1
                },
                statusList: [{
                    id: 0,
                    name: '下架'
                }, {
                    id: 1,
                    name: '上架'
                }],
                searchRule: {},
                searchLoading: false,
                tableColumns: [{
                    title: '推荐ID',
                    key: 'id',
                    width: 80,

                }, {
                    title: '商品ID',
                    key: 'pid',
                    width: 100
                }, {
                    title: '推荐标题',
                    key: 'title',
                    width: 250
                }, {
                    title: '状态',
                    key: 'isLine',
                    width: 60
                }, {
                    title: '上架',
                    key: 'status',
                    width: 60,
                    render: function (h, params) {
                        var text = '';
                        if (params.row.status){
                            text = '上架';
                        }else {
                            text = '下架';
                        }
                        return h('div',text);
                    }
                }, {
                    title: '上线时间',
                    key: 'releaseTime',
                    width: 150,
                    format: 'Time'
                }, {
                    title: '创建时间',
                    key: 'created',
                    width: 150,
                    format: 'Time'
                }, {
                    title: '更新时间',
                    key: 'updated',
                    width: 150,
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
                                        vm.gotoModifyRecommend(params);
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
                                        vm.deleteRecommend(params);
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
                motifyRuleModal: {
                    pid: [
                        {required: true, message: '请填写商品id', trigger: 'blur'},
                        {type: 'string', max: 100, message: '', trigger: 'blur'}
                    ],
                    title: [
                        {required: true, message: '请填写推文标题', trigger: 'blur'},
                        {type: 'string', max: 100, message: '请填写推文标题', trigger: 'blur'}
                    ],
                    status: [
                        {required: true, message: '请选择状态', trigger: 'blur'},
                        {type: 'string', max: 100, message: '请选择状态', trigger: 'blur'}
                    ],
                    releaseTimeStr: [
                        {required: true, message: '请选择上线时间', trigger: 'blur', type: 'date'}
                    ]
                }
            }
        },
        mounted: function () {
            this.init();
        },
        methods: {

            getImageUrl: function (item) {
                return store.imgUrl + item;
            },
            handleRemove: function (index) {
                with (this) {
                    recommendFormModal.describeText[index].img = '';
                }
            },
            handleUploadSuccess: function (response, file, fileList,index) {
                with (this) {
                    if (response.success) {
                        recommendFormModal.describeText[index].img = response.data;
                    }
                }
            },
            addRuleRecommend: function () {
                with (this) {
                    recommendFormModal.describeText.push({
                        text: '',
                        img: ''
                    });
                }
            },
            deleteRuleRecommend: function (item) {
                with (this) {
                    recommendFormModal.describeText.splice(recommendFormModal.describeText.indexOf(item), 1);
                }
            },
            init: function () {
                with (this) {
                    listByPage(1);
                }
            },
            recommendAddTo: function () {
                with (this) {
                    isEdit = false;
                    modalLoading = false;
                    recommendFormModal = {
                        pid: '',
                        title: '',
                        describeText: [],
                        releaseTime: '',
                        releaseTimeStr: '',
                        status: 1,
                        created: '',
                        updated: ''
                    };
                    recommendMotifyModalTitle = '新增每日推荐';
                    var html = recommendFormModal.describeText;
                    $("#editor").html(html);
                    recommendModal = true;
                }
            },
            //创建富文本编辑区域
            gotoModifyRecommend: function (params) {
                with (this) {
                    isEdit = true;
                    recommendMotifyModalTitle = '编辑每日推荐';
                    modalLoading = false;
                    utils.get('${contextPath}/recommendProduct/getRecommendById',{id:params.row.id}, function (result) {
                        if (result.success) {
                            recommendFormModal = result.data;
                            if (recommendFormModal.status){
                                recommendFormModal.status = 1;
                            }else{
                                recommendFormModal.status = 0;
                            }
                            recommendFormModal.releaseTimeStr = new Date(recommendFormModal.releaseTime);
                            recommendFormModal.created = new Date(recommendFormModal.created);
                            recommendFormModal.updated = new Date(recommendFormModal.updated);
                            recommendFormModal.describeText = JSON.parse( recommendFormModal.describeText );
                            if(recommendFormModal.describeText.length > 0){
                                for(var i=0; i<recommendFormModal.describeText.size; i++){
                                    if(utils.isNotEmpty(recommendFormModal.describeText.img)){
                                        recommendFormModal.describeText.img = imgUrl + recommendFormModal.describeText.img;
                                    }
                                }

                            }
                            recommendModal = true;
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

                    utils.get('${contextPath}/recommendProduct/listByPage', searchForm, function (result) {
                        if (result.success) {
                            tableData = result.data.list;
                            tableDataCount = result.data.total;
                            var recommendProduct = result.recommendProduct;
                            var hasLine = false;
                            for(var i=0; i<tableData.length; i++){
                                if (recommendProduct != null && recommendProduct.id == tableData[i].id){
                                    tableData[i].isLine = '上线';
                                }else {
                                    tableData[i].isLine = '下线';
                                }
                            }
                            /*for(var i=0; i<tableData.length; i++){
                                if (recommendProduct != null || recommendProduct.id != tableData[i].id){
                                    tableData[i].isLine = '下线';
                                }else {
                                    if(tableData[i].status && tableData[i].releaseTime < new Date()){
                                        /!*status: null,
                                            title: null,
                                            pid: '',
                                            beginTime: null,
                                            endTime: null,*!/
                                        if (utils.isEmpty(searchForm.pid)
                                                && searchForm.title == null
                                                && searchForm.status== null
                                                && searchForm.beginTime == null
                                                && searchForm.endTime == null){
                                            //没有按条件查询
                                            isOnloneId = tableData[i].id;
                                            //上线
                                            tableData[i].isLine = '上线';
                                            hasLine = true;
                                        }else {
                                            if (isOnloneId == tableData[i].id){
                                                tableData[i].isLine = '上线';
                                            }else{
                                                tableData[i].isLine = '下线';
                                            }
                                        }
                                    }else {
                                        tableData[i].isLine = '下线';
                                    }
                                }
                            }*/
                        }
                        else {
                            $Message.error(result.msg);
                        }
                    }, $data, 'searchLoading');
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
            modifyRecommend: function () {
                with (this) {
                    if (utils.isEmpty(recommendFormModal.pid)){
                        $Message.error('请输入商品id！');
                        return;
                    }
                    if (utils.isEmpty(recommendFormModal.title)){
                        $Message.error('请输入推文标题！');
                        return;
                    }
                    /*if (utils.isEmpty(recommendFormModal.describeText)){
                        $Message.error('请输入推文内容！');
                        return;
                    }*/
                    if (utils.isEmpty(recommendFormModal.releaseTimeStr)){
                        $Message.error('请选择上线时间！');
                        return;
                    }

                    modalLoading = true;
                    recommendFormModal.releaseTime = Date.parse(recommendFormModal.releaseTimeStr);
                    var resultData;
                    utils.get('${contextPath}/recommendProduct/checkHasProduct', {id:recommendFormModal.id, pid:recommendFormModal.pid,releaseTime:recommendFormModal.releaseTime}, function (result) {
                        resultData = result;
                        if (!result.success) {
                            $Message.error(result.msg);
                            modalLoading = false;
                            return;
                        }

                        if (!result.data){
                            $Modal.confirm({
                                title: '提示',
                                content: '该商品已参与过，是否继续保存？',
                                onOk: function () {
                                    utils.postJson('${contextPath}/recommendProduct/motifyRecommend', recommendFormModal, function (result) {
                                        if (result.success) {
                                            $Message.success(result.data);
                                            recommendModal = false;
                                            listByPage(searchForm.pageNum);
                                        }
                                        else {
                                            $Message.error(result.data);
                                        }
                                    }, $data, 'searchLoading');
                                },
                                onCancel: function () {
                                    modalLoading = false;
                                }
                            });
                        }else {

                            utils.postJson('${contextPath}/recommendProduct/motifyRecommend', recommendFormModal, function (result) {
                                if (result.success) {
                                    $Message.success(result.data);
                                    recommendModal = false;
                                    listByPage(searchForm.pageNum);
                                }
                                else {
                                    $Message.error(result.data);
                                }
                            }, $data, 'searchLoading');

                        }
                    }, $data, 'searchLoading');
                }
            },
            deleteRecommend: function (params) {
                with (this) {
                    $Modal.confirm({
                        title: '提示',
                        content: '确认 [  删除  ] 这条推荐商品？',
                        onOk: function () {
                            utils.post('${contextPath}/recommendProduct/deleteById', {id:params.row.id}, function (result) {
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