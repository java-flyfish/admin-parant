<template id="supplier">
    <div class="auto-height">
        <Layout class="auto-height">
            <i-Header class="layout-header-content color-white">
                <i-form class="auto-height" ref="searchForm" :model="searchForm" :rules="searchRule" inline
                        @submit.native.prevent>

                    <form-item>
                        <i-input clearable type="text" v-model="searchForm.name" placeholder="搜索供应商名称"
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
                        <i-Button type="success" shape="circle" @click="showModal">
                            邮费模板
                        </i-Button>
                    </form-item>
                </i-form>
            </i-Header>
            <i-Content class="layout-body-content auto-overflow">
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
               fullscreen>

            <i-form :model="modalForm" inline
                    @submit.native.prevent>

                <form-item>
                    <i-Button type="success" shape="circle" @click="modify(-1)">
                        新增模板
                    </i-Button>
                </form-item>

            </i-form>

            <div class="table-container-supplier"
                 style="position: absolute;top: 70px;bottom: 10px;left: 15px;right: 15px">
                <super-table container=".table-container-supplier" :columns="modalTableColumns" :data="modalTableData"
                             :loading="modalLoading"></super-table>
            </div>

            <div slot="footer">
                <Page class="text-center custom-table-page" show-total :total="modalTableDataCount"
                      :current="modalForm.pageNum"
                      @on-change="modalListByPage"></Page>
            </div>
        </modal>

        <modal v-model="modifyModal"
               :title="modifyModalTitle"
               :mask-closable="false" @on-cancel="cancelModal">

            <i-form ref="modifyModalForm" :model="modifyModalForm" :rules="modifyRuleModal" @submit.native.prevent>

                <form-item prop="label" label="模板名称">
                    <i-input v-model="modifyModalForm.label" placeholder="模板名称">
                    </i-input>
                </form-item>

                <form-item label="是否开启">
                    <i-switch v-model="modifyModalForm.isEnable" size="large">
                        <span slot="open">是</span>
                        <span slot="close">否</span>
                    </i-switch>
                </form-item>

                <form-item label="规则">
                    <row v-for="(item,index) in modifyModalForm.ruleList" style="padding-bottom: 10px">

                        <Divider>规则{{index+1}}</Divider>

                        <i-col span="24">
                            <row>
                                <i-col span="12">
                                    是否包邮
                                    <i-switch v-model="item.isFreeShip" size="large">
                                        <span slot="open">是</span>
                                        <span slot="close">否</span>
                                    </i-switch>
                                </i-col>

                                <i-col span="12">
                                    <i-Button type="error" @click="deleteRule(item)">
                                        删除
                                    </i-Button>
                                </i-col>
                            </row>

                            <row style="margin-top: 10px;" v-if="!item.isFreeShip">
                                <i-col span="24">
                                    <i-Select v-model="item.areas" placeholder="请选择区域" class="auto-width" multiple>
                                        <i-Option v-for="item in dataList" :value="item.label">{{ item.label }}</i-Option>
                                    </i-Select>
                                </i-col>
                            </row>

                            <row style="margin-top: 10px;" v-if="!item.isFreeShip">
                                <i-col span="24">
                                    小于
                                    <Input-Number :min="1" v-model="item.limitPrice"></Input-Number>
                                    收取
                                    <Input-Number :min="1" v-model="item.postage"></Input-Number>
                                    邮费
                                </i-col>
                            </row>

                        </i-col>

                    </row>
                    <row>
                        <Divider></Divider>
                        <i-col span="24">
                            <i-Button type="success" icon="md-add" @click="addRule">
                                新增规则
                            </i-Button>
                        </i-col>
                    </row>
                </form-item>


            </i-form>

            <div slot="footer">
                <i-button type="primary" @click="asyncOK('modifyModalForm')" long :loading="modalLoading">
                    保存
                </i-button>
            </div>
        </modal>

        <modal v-model="relateModal"
               :title="relateModalTitle"
               :mask-closable="false">

            <i-form ref="relateModalForm" :model="relateModalForm" :rules="relateModalRule"
                    @submit.native.prevent>

                <form-item prop="postageTempletId" label="邮费模板">
                    <i-Select v-model="relateModalForm.postageTempletId" placeholder="请选择邮费模板" class="auto-width">
                        <i-Option v-for="item in store.state.postageTempletList" :value="item.id">{{ item.label }}
                        </i-Option>
                    </i-Select>
                </form-item>

            </i-form>

            <div slot="footer">
                <i-button type="primary" @click="saveRelate('relateModalForm')" long :loading="modalLoading">
                    保存
                </i-button>
            </div>
        </modal>
    </div>
</template>

<script>
    var supplier = Vue.component('supplier', {
        template: '#supplier',
        data: function () {

            var vm = this;

            return {
                searchForm: {
                    name: null
                },
                searchRule: {},

                tableData: [],
                tableDataCount: 0,
                tableColumns: [{
                    title: '供应商id',
                    key: 'id',
                    width: 100
                }, {
                    title: '供应商名称',
                    key: 'name'
                }, {
                    title: '邮费模板',
                    key: 'postageTempletId',
                    render: function (h, params) {

                        var postageTemplet = store.state.postageTempletMap[params.row.postageTempletId];
                        if (postageTemplet == null) {
                            postageTemplet = {
                                label: ''
                            };
                        }

                        return h('div', postageTemplet.label);
                    }
                }, {
                    title: '合作方式',
                    width: 100,
                    render: function (h, params) {
                        if (params.row.operatorType == null) {
                            return;
                        }
                        return h('div', params.row.operatorType == 0 ? '返佣' : '采购');
                    }
                }, {
                    title: '操作人',
                    key: 'opName',
                    width: 120
                }, {
                    title: '操作时间',
                    width: 150,
                    key: 'created',
                    format: 'Time'
                }, {
                    title: '是否启用',
                    width: 100,
                    key: 'isEnable',
                    format: 'Boolean'
                }, {
                    title: '操作',
                    width: 150,
                    render: function (h, params) {
                        return h('Button', {
                            props: {
                                type: 'primary',
                                size: 'small'
                            },
                            style: {
                                marginRight: '5px'
                            },
                            on: {
                                click: function () {
                                    vm.relate(params);
                                }
                            }
                        }, '关联邮费模板');
                    }
                }],
                searchLoading: false,

                modal: false,
                modalForm: {},
                modalTitle: '邮费模板',
                modalTableColumns: [{
                    title: '模板id',
                    key: 'id',
                    width: 100
                }, {
                    title: '模板名称',
                    key: 'label'
                }, {
                    title: '是否启用',
                    key: 'isEnable',
                    format: 'Boolean',
                    width: 100
                }, {
                    title: '创建时间',
                    key: 'created',
                    format: 'Time',
                    width: 180
                }, {
                    title: '操作',
                    width: 100,
                    render: function (h, params) {
                        return h('Button', {
                            props: {
                                type: 'primary',
                                size: 'small'
                            },
                            style: {
                                marginRight: '5px'
                            },
                            on: {
                                click: function () {
                                    vm.modify(params);
                                }
                            }
                        }, '修改');
                    }
                }],
                modalTableData: [],
                modalLoading: false,
                modalTableDataCount: 0,

                modifyModal: false,
                modifyModalTitle: '',
                modifyModalForm: {
                    id: null,
                    postageTempletId: null,
                    label: null,
                    isEnable: true,
                    ruleList: []
                },

                dataList: [{
                    label: '新疆'
                }, {
                    label: '西藏'
                }, {
                    label: '宁夏'
                }, {
                    label: '甘肃'
                }, {
                    label: '青海'
                }, {
                    label: '内蒙古'
                }, {
                    label: '海南'
                }],
                modifyRuleModal: {
                    label: [
                        {required: true, message: '请填写模板名称', trigger: 'blur'}
                    ]
                },

                relateModal: false,
                relateModalTitle: '关联',
                relateModalForm: {
                    postageTempletId: null
                },
                relateModalRule: {
                    postageTempletId: [
                        {required: true, message: '请选择模板', trigger: 'blur', type: 'number'}
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
            listByPage: function (pageNum) {
                with (this) {


                    if (pageNum) {
                        searchForm.pageNum = pageNum;
                    }

                    utils.get('${contextPath}/supplier/listByPage', searchForm, function (result) {
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
            showModal: function () {
                with (this) {
                    modalListByPage(1);
                    modal = true;
                }
            },
            modalListByPage: function (pageNum) {
                with (this) {

                    if (pageNum) {
                        modalForm.pageNum = pageNum;
                    }

                    utils.get('${contextPath}/postageTemplet/listByPage', modalForm, function (result) {
                        if (result.success) {
                            modalTableData = result.data.list;
                            modalTableDataCount = result.data.total;
                        }
                        else {
                            $Message.error(result.msg);
                        }
                    }, $data, 'modalLoading');
                }
            },
            modify: function (params) {
                with (this) {
                    modifyModalForm = {
                        id: null,
                        postageTempletId: null,
                        label: null,
                        isEnable: true,
                        ruleList: []
                    };

                    if (params == -1) {
                        modifyModalTitle = '新增模板';
                    }
                    else {
                        modifyModalTitle = '修改模板';

                        utils.copyModel(params.row, modifyModalForm);

                        utils.get('${contextPath}/postageRule/listByModel', {
                            postageTempletId: modifyModalForm.id
                        }, function (result) {
                            if (result.success) {

                                result.data.forEach(function (t) {
                                    if (utils.isNotEmpty(t.areas)) {
                                        t.areas = JSON.parse(t.areas);
                                    }
                                })

                                modifyModalForm.ruleList = result.data;
                            }
                        });
                    }

                    modal = false;
                    modifyModal = true;
                }
            },
            asyncOK: function (name) {
                with (this) {
                    $refs[name].validate(function (valid) {
                        if (valid) {

                            if (modifyModalForm.ruleList.length == 0) {
                                $Message.error('请添加规则');
                                return;
                            }

                            var msg = null;
                            modifyModalForm.ruleList.forEach(function (t) {
                                if (!t.isFreeShip) {
                                    if (t.limitPrice == null || t.postage == null) {
                                        msg = '规则中额度及邮费不能为空';
                                        return;
                                    }
                                }
                            });

                            if (utils.isNotEmpty(msg)) {
                                $Message.error(msg);
                                return;
                            }

                            utils.postJson('${contextPath}/postageTemplet/modify', modifyModalForm, function (result) {
                                if (result.success) {
                                    modifyModal = false;
                                    $Message.success('操作成功');
                                    modalListByPage();
                                    modal = true;

                                    store.dispatch('loadPostageTempletList');
                                }
                                else {
                                    $Message.error(result.msg);
                                }
                            }, $data, 'modalLoading');


                        }
                    });
                }
            },
            addRule: function () {
                with (this) {
                    modifyModalForm.ruleList.push({
                        isFreeShip: false,
                        areas: [],
                        limitPrice: null,
                        postage: null
                    });
                }
            },
            deleteRule: function (item) {
                with (this) {
                    modifyModalForm.ruleList.splice(modifyModalForm.ruleList.indexOf(item), 1);
                }
            },
            cancelModal: function () {
                this.modal = true;
            },
            relate: function (params) {
                with (this) {
                    relateModalTitle = '为 ' + params.row.name + ' 关联邮费模板';

                    relateModal = true;

                    relateModalForm.postageTempletId = params.row.postageTempletId;

                    relateModalForm.id = params.row.id;
                }
            },
            saveRelate: function (name) {

                with (this) {
                    $refs[name].validate(function (valid) {
                        if (valid) {

                            utils.postJson('${contextPath}/supplier/modify', relateModalForm, function (result) {
                                if (result.success) {

                                    $Message.success('操作成功');
                                    listByPage();
                                    relateModal = false;
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