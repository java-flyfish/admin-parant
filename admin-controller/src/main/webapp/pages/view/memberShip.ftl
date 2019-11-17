<template id="memberShip">
    <div class="auto-height">
        <Layout class="auto-height">
            <i-Header class="layout-header-content color-white">
                <i-form class="auto-height" ref="searchForm" :model="searchForm" :rules="searchRule" inline
                        @submit.native.prevent>

                    <form-item>
                        <i-input clearable type="text" v-model="searchForm.name" placeholder="搜索会籍名称"
                                 @on-enter="listByPage(1)">
                        </i-input>
                    </form-item>

                    <form-item>
                        <i-Button type="primary" shape="circle" icon="ios-search" @click="listByPage(1)"
                                  :loading="searchLoading">
                            <span v-if="!searchLoading">查询</span>
                            <span v-else>查询中...</span>
                        </i-Button>
                    </form-item>

                    <form-item>
                        <i-Button icon="md-add" @click="modify(-1)">新增</i-Button>
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

        <modal v-model="modal"
               :title="modalTitle"
               :mask-closable="false"
               :styles="{top: '20px'}">
            <i-form ref="formModal" :model="formModal" :rules="ruleModal" label-width="80">

                <form-item prop="id" label="会籍名称">
                    <i-Select v-model="formModal.id" placeholder="请选择会籍" class="auto-width">
                        <i-Option v-for="item in dataList" :value="item.id">{{ item.name }}</i-Option>
                    </i-Select>
                </form-item>

                <form-item label="是否启用">
                    <i-switch v-model="formModal.isEnable" size="large">
                        <span slot="open">是</span>
                        <span slot="close">否</span>
                    </i-switch>
                </form-item>

                <form-item label="商品折扣">
                    <row v-for="item in formModal.ruleList" style="padding-bottom: 10px">
                        <i-col span="10">
                            <i-input type="text" v-model="item.discount">
                                <i-Select transfer v-model="item.appId" slot="prepend" style="width: 100px">
                                    <i-Option v-for="item in appList" :value="item.id">{{ item.label }}</i-Option>
                                </i-Select>
                                <span slot="append">折</span>
                            </i-input>
                        </i-col>

                        <i-col span="10" offset="1">
                            <Cascader v-model="item.cid" :data="store.state.categoryList" style="width: 150px"
                                      change-on-select
                                      filterable transfer trigger="hover" placeholder="选择类目除外"></Cascader>
                        </i-col>

                        <i-col span="1">
                            <i-Button type="error" @click="deleteRule(item)">
                                删除
                            </i-Button>
                        </i-col>
                    </row>
                    <row>
                        <i-col span="24">
                            <i-Button type="success" icon="md-add" @click="addRule">
                                新增规则
                            </i-Button>
                        </i-col>
                    </row>
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
    var memberShip = Vue.component('memberShip', {
        template: '#memberShip',
        data: function () {
            var vm = this;
            return {
                searchForm: {
                    name: null
                },
                searchRule: {},
                dataList: [{
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
                }],
                appList: [{
                    id: 115,
                    label: '自营平台'
                }],

                tableData: [],
                tableDataCount: 0,
                tableColumns: [{
                    title: '会籍id',
                    key: 'id',
                    width: 100
                }, {
                    title: '会籍名称',
                    key: 'name'
                }, {
                    title: '是否启用',
                    width: 100,
                    key: 'isEnable',
                    format: 'Boolean'
                }, {
                    title: '创建时间',
                    width: 150,
                    key: 'created',
                    format: 'Time'
                }, {
                    title: '更新时间',
                    width: 150,
                    key: 'updated',
                    format: 'Time'
                }, {
                    title: '创建人',
                    width: 100,
                    key: 'uname'
                }, {
                    title: '操作',
                    key: 'action',
                    width: 80,
                    render: function (h, params) {

                        return h('Button', {
                            props: {
                                type: 'primary',
                                size: 'small'
                            },
                            on: {
                                click: function () {
                                    vm.modify(params);
                                }
                            }
                        }, '修改');
                    }
                }],
                searchLoading: false,

                modal: false,
                modalTitle: '新增会籍',
                modalLoading: false,
                formModal: {
                    id: null,
                    name: null,
                    rules: null,
                    ruleList: [],
                    isEnable: true
                },
                ruleModal: {
                    id: [
                        {required: true, message: '请选择会籍', trigger: 'blur', type: 'number'}
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

                    store.state.appList.forEach(function (t) {
                        appList.push(t);
                    });

                    listByPage(1);
                }
            },
            listByPage: function (pageNum) {
                with (this) {

                    if (pageNum) {
                        searchForm.pageNum = pageNum;
                    }

                    utils.get('${contextPath}/memberShip/listByPage', searchForm, function (result) {
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
            modify: function (params) {
                with (this) {

                    formModal = {
                        id: null,
                        name: null,
                        rules: null,
                        ruleList: [],
                        isEnable: true
                    };

                    if (params == -1) {
                        modalTitle = '新增会籍';
                    }
                    else {
                        modalTitle = '修改会籍';

                        utils.copyModel(params.row, formModal);

                        if (utils.isNotEmpty(formModal.rules)) {
                            formModal.ruleList = JSON.parse(formModal.rules);
                        }

                    }

                    modal = true;

                }
            },
            addRule: function () {
                with (this) {
                    formModal.ruleList.push({
                        appId: 115,
                        discount: 10,
                        cid: []
                    });
                }
            },
            deleteRule: function (item) {
                with (this) {
                    formModal.ruleList.splice(formModal.ruleList.indexOf(item), 1);
                }
            },
            asyncOK: function (name) {
                with (this) {
                    $refs[name].validate(function (valid) {
                        if (valid) {

                            formModal.name = utils.getItem(dataList, 'id', formModal.id).name;

                            if (formModal.ruleList.length != 0) {
                                var array = [];

                                for (var i = 0; i < formModal.ruleList.length; i++) {
                                    var obj = formModal.ruleList[i];

                                    for (var j = i + 1; j < formModal.ruleList.length; j++) {
                                        if (obj.appId == formModal.ruleList[j].appId) {
                                            $Message.error('平台规则重复');
                                            return;
                                        }
                                    }

                                    var item = {
                                        appId: obj.appId,
                                        cid: []
                                    };
                                    if (Number(obj.discount)) {
                                        item.discount = obj.discount;
                                    }
                                    else {
                                        $Message.error('抵扣比例必须为数字');
                                        return;
                                    }

                                    if (obj.cid.length != 0) {
                                        if (obj.cid.length == 1) {
                                            if (obj.cid[0] != null) {
                                                item.cid = obj.cid;
                                            }
                                        }
                                        else {
                                            if (obj.cid[1] != null) {
                                                item.cid = obj.cid;
                                            }
                                        }
                                    }

                                    array.push(item);
                                }

                                formModal.rules = JSON.stringify(array);
                            }
                            else {
                                formModal.rules = '';
                            }

                            utils.postJson('${contextPath}/memberShip/modify', formModal, function (result) {
                                modalLoading = false;
                                listByPage(1);
                                if (result.success) {
                                    modal = false;
                                    $Message.success('操作成功');
                                }
                                else {
                                    $Message.error(result.msg);
                                }
                            }, $data, 'modalLoading')

                        }
                    });
                }
            }
        }
    });

</script>