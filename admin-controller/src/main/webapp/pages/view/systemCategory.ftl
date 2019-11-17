<template id="systemCategory">
    <div class="auto-height">
        <Layout class="auto-height">
            <i-Header class="layout-header-content color-white">
                <i-form class="auto-height" ref="searchForm" :model="searchForm" :rules="searchRule" inline>
                    <form-item>
                        <i-Button type="primary" shape="circle" icon="ios-search" @click="listTree"
                                  :loading="treeLoading">
                            <span v-if="!treeLoading">刷新</span>
                            <span v-else>刷新中...</span>
                        </i-Button>
                    </form-item>

                    <form-item>
                        <i-ButtonGroup>
                            <i-Button icon="md-add" @click="modifyResource('add')">新增</i-Button>
                            <i-Button icon="md-create" @click="modifyResource('edit')">修改</i-Button>
                            <i-Button icon="md-trash" @click="deleteResource">删除</i-Button>
                            <i-Button icon="ios-git-compare" @click="relateResource">批量关联</i-Button>
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

                <form-item prop="title" label="中文名称">
                    <i-input type="text" v-model="formModal.title" placeholder="请输入中文名称">
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

        <modal v-model="relateModal"
               :title="relateModalNodesTitle"
               :mask-closable="false" fullscreen>

            <Transfer
                    :data="relateModalData"
                    :target-keys="relateModalKeys"
                    :render-format="relateModalRender"
                    :operations="['移除','加入']"
                    :titles="['商品源数据','节点中的商品']"
                    :list-style="{width: '40%',height: '100%',textAlign: 'left'}"
                    filterable
                    :filter-method="filterMethod"
                    @on-change="relateModalChange"
                    style="height: 100%;text-align: center">
            </Transfer>

            <div slot="footer">
                <i-col span="11">
                    <i-col span="11">
                        <i-Select v-model="relateAppId" @on-change="selectChange" style="text-align: left">
                            <i-Option v-for="item in appList" :value="item.id">{{ item.label }}</i-Option>
                        </i-Select>
                    </i-col>
                    <i-col span="11" offset="2">
                        <i-button type="error" long :loading="modalLoading" @click="goChange">
                            <span v-if="relateModalCheck">仅显示未关联商品</span>
                            <span v-else>显示全部商品</span>
                        </i-button>
                    </i-col>
                </i-col>
                <i-col span="11" offset="2">
                    <i-button type="primary" @click="confirmRelate" long :loading="modalLoading">
                        保存
                    </i-button>
                </i-col>
            </div>
        </modal>
    </div>
</template>

<script>
    var systemCategory = Vue.component('systemCategory', {
        template: '#systemCategory',
        data: function () {
            return {
                searchForm: {},
                searchRule: {},
                treeData: [],
                treeLoading: false,
                treeMap: {},

                modal: false,
                modalTitle: '添加分类',
                modalLoading: false,
                formModal: {
                    title: null,
                    isEnable: true
                },
                ruleModal: {
                    title: [
                        {required: true, message: '请填写中文名称', trigger: 'blur'}
                    ]
                },

                relateModal: false,
                relateModalNodes: [],
                relateModalNodesTitle: null,

                relateModalData: [],
                relateModalKeys: [],

                relateModalCheck: false,

                relateAppId: 115,

                appList: [{
                    id: 115,
                    label: '自营平台'
                }]
            }
        },
        mounted: function () {
            this.init();
        },
        methods: {
            init: function () {
                with (this)
                {
                    store.state.appList.forEach(function (t) {
                        appList.push(t);
                    });

                    listTree();
                }
            },
            listTree: function () {
                with (this) {

                    utils.get('${contextPath}/systemCategory/listTree', {}, function (result) {
                        if (result.success) {
                            treeData = result.data;

                            toTreeMap(result.data,treeMap);
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

                            utils.postJson('${contextPath}/systemCategory/modify', formModal, function (result) {
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
                        content: '确认删除 ' + node.title,
                        onOk: function () {
                            {
                                utils.post('${contextPath}/systemCategory/delete', {
                                    id: node.id
                                }, function (result) {
                                    if (result.success) {
                                        $Message.success('删除成功');
                                    }
                                    else {
                                        $Message.error(result.msg);
                                    }
                                    listTree();
                                }, $data, 'modalLoading')
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
                        title: null,
                        isEnable: true
                    };

                    if (method == 'add') {
                        modalTitle = '为[' + node.title + ']添加子分类';
                        formModal.id = null;
                        formModal.parentId = node.id;
                    }
                    else {
                        modalTitle = '修改分类';
                        formModal.id = node.id;
                        formModal.parentId = node.parentId;

                        utils.copyModel(node, formModal);
                    }

                    modal = true;
                }

            },
            relateResource: function () {
                with (this)
                {
                    var nodes = $refs.tree.getSelectedNodes();

                    if (nodes.length == 0) {
                        $Message.error('请选择一个节点');
                        return;
                    }

                    var node = nodes[0];

                    if(!node.isLeaf)
                    {
                        $Message.error('请选择最后一级节点');
                        return;
                    }

                    var arrays = [];

                    getNodes(node,arrays);

                    arrays.push(node);

                    relateModalNodesTitle = '';

                    relateModalNodes = [];

                    arrays.forEach(function (t,index) {
                        relateModalNodes.push(t.id);

                        relateModalNodesTitle += t.title;
                        if(index != arrays.length -1)
                        {
                            relateModalNodesTitle += '/';
                        }
                    });

                    relateModal = true;

                    goRelate();

                }
            },

            confirmRelate: function () {
                with (this)
                {

                    utils.post('${contextPath}/systemCategory/saveRelate',{
                        appId: relateAppId,
                        nodes: JSON.stringify(relateModalNodes),
                        keys: JSON.stringify(relateModalKeys)
                    },function (result) {
                        relateModal = false;
                        if (result.success) {
                            $Message.success('关联成功');
                        }
                        else {
                            $Message.error(result.msg);
                        }

                    },$data, 'modalLoading');
                }
            },

            toTreeMap: function (data,map) {
                with (this)
                {
                    data.forEach(function (t) {
                        if(t.isLeaf)
                        {
                            map[t.id] = t;
                        }
                        else
                        {
                            map[t.id] = t;
                            toTreeMap(t.children,map);
                        }
                    })
                }

            },

            getNodes: function (node,arrays) {
                with (this)
                {
                    if(node.parentId != 1)
                    {
                        var parent = treeMap[node.parentId];

                        if(parent)
                        {
                            arrays.unshift(parent);

                            getNodes(parent,arrays);

                        }

                    }
                }
            },

            relateModalRender: function (item) {
                return '<span style="font-weight: bold">' + item.title + '</span><br>' + item.subtitle + ' <br> ' + item.cTitle + ' || 标签: ' + item.tag;
            },

            relateModalChange: function (newTargetKeys) {
                this.relateModalKeys = newTargetKeys;
            },

            filterMethod: function (data, query) {
                if(query)
                {
                    var text = data.cTitle + '-' + data.title + '-' + data.subtitle + '-' + data.tag;

                    return text.indexOf(query) > -1;
                }

                return true;
            },

            goChange: function () {
                with (this)
                {
                    relateModalCheck = !relateModalCheck;

                    goRelate();
                }
            },

            selectChange: function () {
              this.goRelate();
            },

            goRelate: function () {
                with (this)
                {
                    relateModalData = [];
                    relateModalKeys = [];

                    utils.post('${contextPath}/systemCategory/relate',{
                        appId: relateAppId,
                        isAll: relateModalCheck,
                        nodes: JSON.stringify(relateModalNodes)
                    },function (result) {

                        if (result.success) {

                            var data = result.data.data;

                            data.forEach(function (t) {
                                t.key = t.id.toString();

                                if(t.cid)
                                {
                                    var second = store.state.categoryMap[t.cid];

                                    if (second) {
                                        var first = store.state.categoryMap[second.pid];

                                        if(first)
                                        {
                                            t.cTitle = first.label + ' / ' + second.label;
                                        }
                                    }
                                }

                            });

                            var keys = result.data.keys;

                            relateModalData = data;
                            relateModalKeys = keys;
                        }
                        else {
                            $Message.error(result.msg);
                        }

                    },$data, 'modalLoading');
                }
            }
        }
    });

</script>