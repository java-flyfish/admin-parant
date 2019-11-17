<template id="resource">
    <div class="auto-height">
        <Layout class="auto-height">
            <i-Header class="layout-header-content color-white">
                <i-form class="auto-height" ref="searchForm" :model="searchForm" :rules="searchRule" inline>
                    <form-item>
                        <i-Button type="primary" shape="circle" icon="ios-search" @click="listTree"
                                  :loading="treeLoading">
                            <span v-if="!treeLoading">查询</span>
                            <span v-else>查询中...</span>
                        </i-Button>
                    </form-item>

                    <form-item>
                        <i-ButtonGroup>
                            <i-Button icon="md-add" @click="modifyResource('add')">新增</i-Button>
                            <i-Button icon="md-create" @click="modifyResource('edit')">修改</i-Button>
                            <i-Button icon="md-trash" @click="deleteResource">删除</i-Button>
                        </i-ButtonGroup>
                    </form-item>
                </i-form>
            </i-Header>
            <i-Content class="layout-body-content auto-overflow">
                <Tree :data="treeData" ref="tree"></Tree>
            </i-Content>
            <i-footer class="layout-footer-content color-white">

            </i-footer>
        </Layout>

        <modal v-model="modal"
               :title="modalTitle"
               :mask-closable="false">
            <i-form ref="formModal" :model="formModal" :rules="ruleModal" label-width="80">

                <form-item prop="name" label="英文名称">
                    <i-input type="text" v-model="formModal.name" placeholder="请输入英文名称">
                    </i-input>
                </form-item>

                <form-item prop="title" label="中文名称">
                    <i-input type="text" v-model="formModal.title" placeholder="请输入中文名称">
                    </i-input>
                </form-item>

                <form-item prop="url" label="链接地址">
                    <i-input type="text" v-model="formModal.url" placeholder="请输入链接地址">
                    </i-input>
                </form-item>

                <form-item prop="icon" label="图标">
                    <i-input type="text" v-model="formModal.icon" placeholder="请输入图标">
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
    </div>
</template>

<script>
    var resource = Vue.component('resource', {
        template: '#resource',
        data: function () {
            return {
                searchForm: {},
                searchRule: {},
                treeData: [],
                treeLoading: false,

                modal: false,
                modalTitle: '添加资源',
                modalLoading: false,
                formModal: {
                    name: null,
                    title: null,
                    url: null,
                    icon: null,
                    isEnable: true
                },
                ruleModal: {
                    name: [
                        {required: true, message: '请填写英文名称', trigger: 'blur'}
                    ],
                    title: [
                        {required: true, message: '请填写中文名称', trigger: 'blur'}
                    ]
                }
            }
        },
        mounted: function () {
            this.init();
        },
        methods: {
            init: function () {
                this.listTree();
            },
            listTree: function () {
                with (this) {

                    utils.get('${contextPath}/resource/listTree', {}, function (result) {
                        if (result.success) {
                            treeData = result.data;
                        }
                        else {
                            $Message.error(result.msg);
                        }
                    }, $data, 'treeLoading');

                }

            },
            asyncOK: function (name) {
                with (this) {
                    $refs[name].validate(function (valid) {
                        if (valid) {

                            utils.postJson('${contextPath}/resource/modify', formModal, function (result) {
                                modalLoading = false;
                                listTree();
                                if (result.success) {
                                    modal = false;
                                    $Message.success('操作成功');
                                }
                                else {
                                    $Message.error(result.msg);
                                }
                            }, $data, 'modalLoading');

                        }
                    });
                }
            },
            deleteResource: function () {
                with (this) {
                    var nodes = $refs.tree.getSelectedNodes();

                    if (nodes.length == 0) {
                        $Message.error('请选择一个节点');
                        return;
                    }

                    var node = nodes[0];

                    $Modal.confirm({
                        title: '提示',
                        content: '确认删除',
                        onOk: function () {
                            {
                                utils.post('${contextPath}/resource/delete', {
                                    id: node.id
                                }, function (result) {
                                    if (result.success) {
                                        $Message.success('删除成功');
                                    }
                                    else {
                                        $Message.error(result.msg);
                                    }
                                    listTree();
                                })
                            }
                        }
                    });
                }
            },
            modifyResource: function (method) {

                with (this) {
                    var nodes = $refs.tree.getSelectedNodes();

                    if (nodes.length == 0) {
                        $Message.error('请选择一个节点');
                        return;
                    }

                    var node = nodes[0];

                    formModal = {
                        name: null,
                        title: null,
                        url: null,
                        icon: null,
                        isEnable: true
                    };

                    if (method == 'add') {
                        modalTitle = '添加资源';
                        formModal.id = null;
                        formModal.parentId = node.id;
                    }
                    else {
                        modalTitle = '修改资源';
                        formModal.id = node.id;
                        formModal.parentId = node.parentId;

                        utils.copyModel(node, formModal);
                    }

                    modal = true;
                }

            }
        }
    });

</script>