<template id="buyer">
    <div class="auto-height">
        <Layout class="auto-height">
            <i-Header class="layout-header-content color-white">
                <i-form class="auto-height" ref="searchForm" :model="searchForm" :rules="searchRule" inline
                        @submit.native.prevent>

                    <form-item>
                        <i-input clearable type="text" v-model="searchForm.name" placeholder="搜索买手名称"
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
                        <i-Button icon="md-add" @click="modifyBuyer(-1)">新增</i-Button>
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

                <form-item label="头像">
                    <super-upload v-model="formModal.avatar" :action="upload.action" mode="image" keyword="url"
                                  size="58">
                    </super-upload>
                </form-item>

                <form-item label="背景图">
                    <super-upload v-model="formModal.pic" :action="upload.action" mode="image" keyword="url"
                                  size="58">
                    </super-upload>
                </form-item>

                <form-item prop="name" label="买手名称">
                    <i-input v-model="formModal.name" placeholder="买手名称">
                    </i-input>
                </form-item>

                <form-item label="性别">
                    <row>
                        <i-col span="12">
                            <Radio-Group v-model="formModal.sex">
                                <Radio v-for="item in sexList" :label="item.value">{{item.label}}</Radio>
                            </Radio-Group>
                        </i-col>
                        <i-col span="12">
                            是否显示
                            <i-switch v-model="formModal.isShow" size="large">
                                <span slot="open">是</span>
                                <span slot="close">否</span>
                            </i-switch>
                        </i-col>
                    </row>
                </form-item>

                <form-item label="标签">
                    <i-input v-model="formModal.tags">
                    </i-input>
                </form-item>

                <form-item label="slogan">
                    <i-input v-model="formModal.slogan">
                    </i-input>
                </form-item>

                <form-item label="签名" class="no-margin">
                    <i-input type="textarea" :autosize="{minRows: 2,maxRows: 5}"
                             v-model="formModal.signature">
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
    var buyer = Vue.component('buyer', {
        template: '#buyer',
        data: function () {
            var vm = this;

            return {
                searchForm: {
                    name: null
                },
                searchRule: {},
                sexList: [{
                    label: '男',
                    value: 1
                }, {
                    label: '女',
                    value: 2
                }],

                tableData: [],
                tableDataCount: 0,
                tableColumns: [{
                    title: '买手id',
                    key: 'id',
                    width: 100
                }, {
                    title: '买手头像',
                    width: 150,
                    render: function (h, params) {

                        if (utils.isEmpty(params.row.avatar)) {
                            return;
                        }

                        return h('img', {
                            attrs: {
                                src: store.imgUrl + params.row.avatar,
                                width: '50px',
                                height: '50px'
                            }
                        });
                    }
                }, {
                    title: '买手名称',
                    key: 'name',
                    width: 150
                }, {
                    title: '性别',
                    width: 100,
                    render: function (h, params) {
                        var sex = utils.getItem(vm.sexList, 'value', params.row.sex);

                        return h('div', sex.label);
                    }
                }, {
                    title: '标签',
                    key: 'tags'
                }, {
                    title: '是否显示',
                    width: 100,
                    key: 'isShow',
                    format: 'Boolean'
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
                                    vm.modifyBuyer(params.index);
                                }
                            }
                        }, '修改');
                    }
                }],
                searchLoading: false,

                modal: false,
                modalTitle: '新增买手',
                modalLoading: false,
                formModal: {
                    avatar: null,
                    name: null,
                    sex: 1,
                    tags: null,
                    slogan: null,
                    signature: null,
                    isShow: true,
                    pic: null
                },
                ruleModal: {
                    name: [
                        {required: true, message: '请填写名称', trigger: 'blur'}
                    ]
                },
                upload: {
                    action: '${contextPath}/system/uploadImg'
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

                    utils.get('${contextPath}/buyer/listByPage', searchForm, function (result) {
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
            modifyBuyer: function (index) {
                with (this) {

                    if (index == -1) {

                        formModal.avatar = null;
                        formModal.name = null;
                        formModal.sex = 1;
                        formModal.tags = null;
                        formModal.slogan = null;
                        formModal.signature = null;
                        formModal.isShow = true;
                        formModal.pic = null;
                        formModal.id = null;

                        modalTitle = '新增买手';
                    }
                    else {
                        modalTitle = '修改买手';

                        var currentRow = tableData[index];

                        formModal.id = currentRow.id;
                        utils.copyModel(currentRow, formModal);
                    }

                    modal = true;

                }
            },
            asyncOK: function (name) {
                with (this) {
                    $refs[name].validate(function (valid) {
                        if (valid) {

                            utils.postJson('${contextPath}/buyer/modify', formModal, function (result) {
                                if (result.success) {
                                    modal = false;
                                    $Message.success('操作成功');
                                    listByPage();

                                    store.dispatch('loadBuyerList');
                                }
                                else {
                                    $Message.error(result.msg);
                                }
                            }, $data, 'modalLoading');


                        }
                    });
                }
            }
        }
    });

</script>