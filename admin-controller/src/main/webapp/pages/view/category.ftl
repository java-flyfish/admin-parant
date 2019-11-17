<template id="category">
    <div class="auto-height">
        <Layout class="auto-height">
            <i-Header class="layout-header-content color-white">
                <i-form class="auto-height" ref="searchForm" :model="searchForm" :rules="searchRule" inline
                        @submit.native.prevent>

                    <form-item>
                        <i-input clearable type="text" v-model="searchForm.name" placeholder="搜索一级分类名称"
                                 @on-enter="parentListByPage(1)">
                        </i-input>
                    </form-item>

                    <form-item>
                        <i-Button type="primary" shape="circle" icon="ios-search" @click="parentListByPage(1)"
                                  :loading="searchLoading">
                            <span v-if="!searchLoading">查询</span>
                            <span v-else>查询中...</span>
                        </i-Button>
                    </form-item>

                    <form-item>
                        <i-Button icon="md-add" @click="modifyLabel(-1)">新增一级分类</i-Button>
                    </form-item>
                </i-form>
            </i-Header>
            <i-Content class="layout-body-content">
                <row>
                    <i-Col span="12">
                        <super-Table :columns="parentTableColumns" :data="parentTableData"
                                     :loading="searchLoading" @on-current-change="tableRowChange"></super-Table>
                    </i-Col>
                    <i-Col span="11" offset="1">
                        <super-Table :columns="tableColumns" :data="tableData"
                                     :loading="searchLoading"></super-Table>
                    </i-Col>
                </row>

            </i-Content>

            <i-footer class="layout-footer-content color-white">
                <row>
                    <i-Col span="12">
                        <Page class="text-center custom-table-page" show-total :total="parentTableDataCount"
                              :current="searchForm.pageNum"
                              @on-change="parentListByPage"></Page>
                    </i-Col>
                    <i-Col span="11" offset="1">
                        <Page class="text-center custom-table-page" show-total :total="tableDataCount"
                              :current="search.pageNum"
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

                <form-item prop="name" label="名称">
                    <i-input v-model="formModal.name" placeholder="请输入名称">
                    </i-input>
                </form-item>

                <form-item label="简介">
                    <i-input v-model="formModal.brief" placeholder="请输入简介">
                    </i-input>
                </form-item>

                <form-item label="图片">
                    <super-upload v-model="formModal.img" :action="upload.action" mode="image" keyword="url"
                                  size="58">
                    </super-upload>
                </form-item>

                <form-item label="首页是否显示" label-width="100">
                    <row>
                        <i-col span="12">
                            <i-switch v-model="formModal.isRec" size="large">
                                <span slot="open">是</span>
                                <span slot="close">否</span>
                            </i-switch>
                        </i-col>
                        <i-col span="12">
                            分类模块是否显示
                            <i-switch v-model="formModal.isShow" size="large">
                                <span slot="open">是</span>
                                <span slot="close">否</span>
                            </i-switch>
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
    var category = Vue.component('category', {
        template: '#category',
        data: function () {
            var vm = this;
            return {
                searchForm: {
                    name: null,
                    parentId: 0
                },
                searchRule: {},

                parentTableColumns: [{
                    title: 'id',
                    key: 'id',
                    width: 50
                }, {
                    title: '名称',
                    key: 'name',
                    width: 100
                }, {
                    title: '图片',
                    render: function (h, params) {

                        if (utils.isEmpty(params.row.img)) {
                            return;
                        }

                        return h('img', {
                            attrs: {
                                src: store.imgUrl + params.row.img,
                                width: '50px',
                                height: '50px'
                            }
                        });
                    }
                }, {
                    title: '状态',
                    width: 120,
                    render: function (h, params) {

                        var rec = params.row.isRec;

                        if (rec) {
                            rec = '显示';
                        }
                        else {
                            rec = '隐藏';
                        }

                        var show = params.row.isShow;

                        if (show) {
                            show = '显示';
                        }
                        else {
                            show = '隐藏';
                        }

                        return h('div', [h('div', '首页' + rec), h('div', '分类模块' + show)]);
                    }
                }, {
                    title: '操作',
                    key: 'action',
                    width: 160,
                    render: function (h, params) {

                        return h('div', [
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
                                        vm.modifyLabel(params);
                                    }
                                }
                            }, '修改'),
                            h('Button', {
                                props: {
                                    type: 'success',
                                    size: 'small'
                                },
                                on: {
                                    click: function () {
                                        vm.modify(params, -1);
                                    }
                                }
                            }, '新增二级')
                        ]);
                    }
                }],
                parentTableData: [],
                parentTableDataCount: 0,

                search: {},
                tableData: [],
                tableDataCount: 0,
                tableColumns: [{
                    title: 'id',
                    key: 'id',
                    width: 50
                }, {
                    title: '名称',
                    key: 'name',
                    width: 100
                }, {
                    title: '图片',
                    render: function (h, params) {

                        if (utils.isEmpty(params.row.img)) {
                            return;
                        }

                        return h('img', {
                            attrs: {
                                src: store.imgUrl + params.row.img,
                                width: '50px',
                                height: '50px'
                            }
                        });
                    }
                }, {
                    title: '状态',
                    width: 120,
                    render: function (h, params) {
                        var show = params.row.isShow;

                        if (show) {
                            show = '显示';
                        }
                        else {
                            show = '隐藏';
                        }
                        return h('div', '分类模块' + show);
                    }
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
                modalTitle: '新增分类',
                modalLoading: false,
                formModal: {
                    name: null,
                    brief: null,
                    img: null,
                    isRec: false,
                    isShow: true
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
                    parentListByPage(1);
                }
            },
            parentListByPage: function (pageNum) {
                with (this) {

                    if (pageNum) {
                        searchForm.pageNum = pageNum;
                    }

                    tableData = [];
                    tableDataCount = 0;

                    utils.get('${contextPath}/category/listByPage', searchForm, function (result) {
                        if (result.success) {
                            parentTableData = result.data.list;
                            parentTableDataCount = result.data.total;
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

                    utils.get('${contextPath}/category/listByPage', search, function (result) {
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

                            utils.postJson('${contextPath}/category/modify', formModal, function (result) {
                                if (result.success) {
                                    modal = false;
                                    $Message.success('操作成功');
                                    parentListByPage();

                                    store.dispatch('loadCategoryList');
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
                    listByPage(1);
                }

            },
            modifyLabel: function (params) {

                with (this) {

                    formModal = {
                        pid: 0,
                        name: null,
                        brief: null,
                        img: null,
                        isRec: false,
                        isShow: true
                    };

                    if (params == -1) {
                        modalTitle = '新增一级分类';
                    }
                    else {
                        modalTitle = '修改一级分类';

                        formModal.id = params.row.id;
                        utils.copyModel(params.row, formModal);

                    }

                    modal = true;

                }

            },
            modify: function (params, index) {

                with (this) {

                    formModal = {
                        pid: params.row.id,
                        name: null,
                        brief: null,
                        img: null,
                        isRec: false,
                        isShow: true
                    };

                    if (index == -1) {
                        modalTitle = '为[' + params.row.name + ']添加二级分类';
                    }
                    else {
                        modalTitle = '修改二级分类';

                        formModal.id = params.row.id;
                        utils.copyModel(params.row, formModal);

                    }

                    modal = true;

                }

            }
        }
    });

</script>