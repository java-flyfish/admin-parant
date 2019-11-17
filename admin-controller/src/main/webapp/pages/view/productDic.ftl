<template id="productDic">
    <div class="auto-height">
        <Layout class="auto-height">
            <i-Header class="layout-header-content color-white">
                <i-form class="auto-height" ref="searchForm" :model="searchForm" :rules="searchRule" inline
                        @submit.native.prevent>

                    <form-item>
                        <i-input clearable type="text" v-model="searchForm.label" placeholder="搜索属性名称"
                                 @on-enter="listAll">
                        </i-input>
                    </form-item>

                    <form-item>
                        <i-Button type="primary" shape="circle" icon="ios-search" @click="listAll"
                                  :loading="searchLoading">
                            <span v-if="!searchLoading">查询</span>
                            <span v-else>查询中...</span>
                        </i-Button>
                    </form-item>

                    <form-item>
                        <i-Button icon="md-add" @click="modifyLabel(-1)">新增</i-Button>
                    </form-item>
                </i-form>
            </i-Header>
            <i-Content class="layout-body-content">
                <row>
                    <i-Col span="5">
                        <super-Table :columns="parentTableColumns" :data="parentTableData"
                                     :loading="searchLoading" @on-current-change="tableRowChange"></super-Table>
                    </i-Col>
                    <i-Col span="18" offset="1">
                        <super-Table :columns="tableColumns" :data="tableData"
                                     :loading="searchLoading"></super-Table>
                    </i-Col>
                </row>

            </i-Content>

            <i-footer class="layout-footer-content color-white">
                <row>
                    <i-Col span="18" offset="6">
                        <Page class="text-center custom-table-page" show-total :total="tableDataCount"
                              :current="searchForm.pageNum"
                              @on-change="listByPage"></Page>
                    </i-Col>
                </row>
            </i-footer>
        </Layout>

        <modal v-model="modal"
               :title="modalTitle"
               :mask-closable="false"
               :styles="{top: '20px'}">
            <i-form ref="formModal" :model="formModal" :rules="ruleModal" label-width="80">

                <form-item prop="label" label="参数名称">
                    <i-input v-model="formModal.label" placeholder="请输入参数名称">
                    </i-input>
                </form-item>

                <form-item label="参数值">
                    <i-input type="textarea" :autosize="{minRows: 3,maxRows: 6}"
                             v-model="formModal.value">
                    </i-input>
                </form-item>

                <form-item label="图片">
                    <super-upload v-model="formModal.pic" :action="upload.action" mode="image" keyword="url"
                                  size="58">
                    </super-upload>
                </form-item>

                <form-item label="备注">
                    <i-input type="textarea" :autosize="{minRows: 2,maxRows: 5}"
                             v-model="formModal.comment">
                    </i-input>
                </form-item>

                <form-item label="是否开启">
                    <i-switch v-model="formModal.isEnable" size="large">
                        <span slot="open">开启</span>
                        <span slot="close">关闭</span>
                    </i-switch>
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
    var productDic = Vue.component('productDic', {
        template: '#productDic',
        data: function () {
            var vm = this;

            return {
                searchForm: {
                    label: null
                },
                searchRule: {},

                parentTableColumns: [{
                    title: '属性名称',
                    key: 'label'
                }],
                parentTableData: [],
                search: {},

                tableData: [],
                tableDataCount: 0,
                tableColumns: [{
                    title: '参数名称',
                    key: 'label',
                    width: 200
                }, {
                    title: '参数值',
                    key: 'value'
                }, {
                    title: '备注',
                    key: 'comment',
                    width: 100
                }, {
                    title: '是否启用',
                    width: 100,
                    key: 'isEnable',
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
                                    vm.modifyLabel(params.index);
                                }
                            }
                        }, '修改');
                    }
                }],
                searchLoading: false,

                modal: false,
                modalTitle: '添加参数',
                modalLoading: false,
                formModal: {
                    type: null,
                    pic: null,
                    name: null,
                    label: null,
                    value: null,
                    parentId: null,
                    content: null,
                    comment: null,
                    isEnable: true
                },
                ruleModal: {
                    label: [
                        {required: true, message: '请填写名称', trigger: 'blur'}
                    ]
                },

                upload: {
                    action: '${contextPath}/system/uploadImg'
                },
                currentLabel: null
            }
        },
        mounted: function () {
            this.init();
        },
        methods: {
            init: function () {
                with (this) {
                    listAll();
                }
            },
            listAll: function () {
                with (this) {

                    tableData = [];
                    tableDataCount = 0;

                    search = {};

                    utils.get('${contextPath}/productDic/listAll', searchForm, function (result) {
                        if (result.success) {
                            parentTableData = result.data;
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
                        search.pageNum = pageNum;
                    }

                    utils.get('${contextPath}/productDic/listByPage', search, function (result) {
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

                            utils.postJson('${contextPath}/productDic/modify', formModal, function (result) {
                                if (result.success) {
                                    modal = false;
                                    $Message.success('操作成功');
                                    listByPage();

                                    store.dispatch('loadProductDicList');
                                }
                                else {
                                    $Message.error(result.msg);
                                }
                            }, $data, 'modalLoading');

                        }
                    });
                }
            },
            tableRowChange: function (currentRow) {
                with (this) {
                    search.parentId = currentRow.id;
                    search.type = currentRow.type;
                    currentLabel = currentRow.label;
                    listByPage(1);
                }

            },
            modifyLabel: function (index) {

                with (this) {
                    if (search.parentId == null) {
                        $Message.error('请选择属性名称');
                        return;
                    }

                    formModal = {
                        type: search.type,
                        pic: null,
                        name: null,
                        label: null,
                        value: null,
                        parentId: search.parentId,
                        content: null,
                        comment: null,
                        isEnable: true
                    };

                    if (index == -1) {
                        modalTitle = '为' + currentLabel + "添加参数";
                    }
                    else {
                        modalTitle = '修改参数';

                        var currentRow = tableData[index];

                        formModal.id = currentRow.id;
                        utils.copyModel(currentRow, formModal);

                    }

                    modal = true;

                }

            }
        }
    });

</script>