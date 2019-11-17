<template id="role">
    <div class="auto-height">
        <Layout class="auto-height">
            <i-Header class="layout-header-content color-white">
                <i-form class="auto-height" ref="searchForm" :model="searchForm" :rules="searchRule" inline>
                    <form-item>
                        <i-Button type="primary" shape="circle" icon="ios-search" @click="listByPage(1)"
                                  :loading="searchLoading">
                            <span v-if="!searchLoading">查询</span>
                            <span v-else>查询中...</span>
                        </i-Button>
                    </form-item>

                    <form-item>
                        <i-ButtonGroup>
                            <i-Button icon="md-add" @click="modifyRole(-1)">新增</i-Button>
                        </i-ButtonGroup>
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
               :mask-closable="false">
            <i-form ref="formModal" :model="formModal" :rules="ruleModal" label-width="80">

                <form-item prop="name" label="角色名称">
                    <i-input type="text" v-model="formModal.name" placeholder="请输入角色名称">
                    </i-input>
                </form-item>

                <form-item prop="isEnable" label="是否开启">
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

        <modal v-model="treeModal"
               title="关联资源"
               :mask-closable="false">
            <Tree show-checkbox :data="resourceTree" ref="resourceTree" style="height:200px;overflow: auto"></Tree>

            <div slot="footer">
                <i-button type="primary" @click="asyncOK('resourceTree')" long :loading="modalLoading">
                    确定
                </i-button>
            </div>
        </modal>
    </div>
</template>

<script>
    var role = Vue.component('role', {
        template: '#role',
        data: function () {
            var vm = this;
            return {
                searchForm: {},
                searchRule: {},

                tableHeight: 330,
                tableData: [],
                tableDataCount: 0,
                tableColumns: [{
                    type: 'index',
                    width: 60,
                    align: 'center'
                }, {
                    title: '角色名称',
                    key: 'name'
                }, {
                    title: '是否开启',
                    key: 'isEnable',
                    format: 'Boolean'
                }, {
                    title: '操作',
                    key: 'action',
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
                                        vm.modifyRole(params.index);
                                    }
                                }
                            }, '修改'),
                            h('Button', {
                                props: {
                                    type: 'success',
                                    size: 'small'
                                },
                                style: {
                                    marginRight: '5px'
                                },
                                on: {
                                    click: function () {
                                        vm.relateResource(params.index);
                                    }
                                }
                            }, '关联资源'),
                            h('Button', {
                                props: {
                                    type: 'error',
                                    size: 'small'
                                },
                                on: {
                                    click: function () {
                                        vm.deleteRole(params.index);
                                    }
                                }
                            }, '删除')
                        ]);
                    }
                }],
                searchLoading: false,

                modal: false,
                modalTitle: '添加角色',
                modalLoading: false,
                formModal: {
                    name: null,
                    isEnable: true
                },
                ruleModal: {
                    name: [
                        {required: true, message: '请填写角色名称', trigger: 'blur'}
                    ]
                },

                treeModal: false,
                resourceTree: [],
                currentRole: null
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

                    currentRow = null;

                    if (pageNum) {
                        searchForm.pageNum = pageNum;
                    }

                    utils.get('${contextPath}/role/listByPage', searchForm, function (result) {
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
                    switch (name) {
                        case 'formModal':
                            $refs[name].validate(function (valid) {
                                if (valid) {

                                    utils.postJson('${contextPath}/role/modify', formModal, function (result) {
                                        if (result.success) {
                                            modal = false;
                                            $Message.success('操作成功');
                                            listByPage();
                                        }
                                        else {
                                            $Message.error(result.msg);
                                        }
                                    }, $data, 'modalLoading')

                                }
                            });
                            break;
                        case 'resourceTree':
                            var nodes = $refs[name].getCheckedNodes();
                            var array = [];
                            nodes.forEach(function (item) {
                                if (item.isLeaf) {
                                    array.push(item.id);
                                }

                            });

                            var data = {
                                id: currentRole.id,
                                relates: array.join()
                            };

                            utils.postJson('${contextPath}/role/modify', data, function (result) {
                                currentRole = null;
                                if (result.success) {
                                    treeModal = false;
                                    $Message.success('操作成功');
                                    listByPage();
                                }
                                else {
                                    $Message.error(result.msg);
                                }
                            }, $data, 'modalLoading');

                            break;
                        default:
                            break;
                    }
                }
            },
            deleteRole: function (index) {
                with (this) {
                    $Modal.confirm({
                        title: '提示',
                        content: '确认删除',
                        onOk: function () {
                            {
                                utils.post('${contextPath}/role/delete', {
                                    id: tableData[index].id
                                }, function (result) {
                                    if (result.success) {
                                        $Message.success('删除成功');
                                        listByPage(1);
                                    }
                                    else {
                                        $Message.error(result.msg);
                                    }
                                });
                            }
                        }
                    });
                }
            },
            modifyRole: function (index) {

                with (this) {
                    formModal = {
                        name: null,
                        isEnable: true
                    };

                    if (index == -1) {
                        modalTitle = '添加角色';
                        formModal.id = null;
                    }
                    else {

                        var currentRow = tableData[index];

                        modalTitle = '修改角色';
                        formModal.id = currentRow.id;

                        utils.copyModel(currentRow, formModal);
                    }

                    modal = true;
                }

            },
            relateResource: function (index) {
                with (this) {
                    var data = tableData[index];

                    resourceTree = [];

                    utils.get('${contextPath}/resource/listTree', {}, function (result) {
                        if (result.success) {
                            if (data.relates) {
                                utils.setTreeCheck(result.data, data.relates.split(','));
                            }
                            resourceTree = result.data;
                            currentRole = data;
                        }
                        else {
                            $Message.error(result.msg);
                        }
                    }, $data, 'modalLoading');
                    treeModal = true;
                }
            }
        }
    });

</script>