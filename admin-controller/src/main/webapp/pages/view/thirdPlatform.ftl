<template id="thirdPlatform">
    <div class="auto-height">
        <Layout class="auto-height">
            <i-Header class="layout-header-content color-white" style="height: 55px">
                <i-form class="auto-height" ref="searchForm" :model="searchForm" :rules="searchRule" inline
                        @submit.native.prevent>

                    <form-item prop="appId" label="第三方平台" label-width="100">
                        <i-Select v-model="searchForm.appId" style="width: 100px">
                            <i-Option v-for="item in store.state.appList" :value="item.id">{{ item.label }}</i-Option>
                        </i-Select>
                    </form-item>

                    <form-item label="推送类型" label-width="70">
                        <i-Select v-model="searchForm.apiId" style="width: 100px" clearable>
                            <i-Option v-for="item in apiMap[searchForm.appId]" :value="item.id">{{ item.label }}</i-Option>
                        </i-Select>
                    </form-item>

                    <form-item label="推送状态" label-width="70">
                        <i-Select v-model="searchForm.status" style="width: 100px" clearable>
                            <i-Option v-for="item in statusList" :value="item.id">{{ item.name }}</i-Option>
                        </i-Select>
                    </form-item>

                    <form-item>
                        <i-input clearable type="text" v-model="searchForm.keyId" placeholder="搜索数据id"
                                 @on-enter="listByPage(1)">
                        </i-input>
                    </form-item>

                    <form-item>
                        <i-Button type="primary" shape="circle" icon="ios-search" @click="search"
                                  :loading="searchLoading">
                            <span v-if="!searchLoading">查询</span>
                            <span v-else>查询中...</span>
                        </i-Button>
                    </form-item>

                    <form-item v-if="account.isShow">
                        <Tag type="dot" :color="account.color">余额: {{ account.price }} 元</Tag>
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
    </div>
</template>

<script>
    var thirdPlatform = Vue.component('thirdPlatform', {
        template: '#thirdPlatform',
        data: function () {
            var vm = this;
            return {
                account: {
                    isShow: false,
                    color: '#19be6b',
                    price: 0
                },
                searchForm: {
                    appId: 1,
                    apiId: null,
                    status: null,
                    keyId: null
                },
                searchRule: {
                    appId: [
                        {required: true, message: '请选择接口平台', trigger: 'blur', type: 'number'}
                    ]
                },
                apiMap: {
                    1: [{
                        id: 4,
                        label: '订单推送'
                    }, {
                        id: 5,
                        label: '退款推送'
                    }, {
                        id: 13,
                        label: '退款回调'
                    }, {
                        id: 14,
                        label: '订单物流回调'
                    }, {
                        id: 15,
                        label: '订单异常取消'
                    }, {
                        id: 16,
                        label: '库存划拨'
                    }, {
                        id: 17,
                        label: '库存校准'
                    }, {
                        id: 18,
                        label: '库存停售'
                    }],
                    2: [{
                        id: 14,
                        label: '订单推送'
                    }, {
                        id: 17,
                        label: '退款推送'
                    }],
                    3: [{
                        id: 39,
                        label: '订单推送'
                    }],
                    4: [{
                        id: 47,
                        label: '订单推送'
                    }, {
                        id: 48,
                        label: '退款推送'
                    }],
                    5: [{
                        id: 54,
                        label: '订单推送'
                    }]
                },
                statusList: [{
                    id: 0,
                    name: '推送失败'
                }, {
                    id: 1,
                    name: '推送成功'
                }, {
                    id: 2,
                    name: '已处理'
                }],

                tableData: [],
                tableDataCount: 0,
                tableColumns: [{
                    title: '数据id',
                    key: 'keyId',
                    width: 220
                }, {
                    title: '推送类型',
                    key: 'apiId',
                    width: 120,
                    render: function (h, params) {
                        if (vm.apiMap[params.row.appId] == null) {
                            return;
                        }

                        var type = utils.getItem(vm.apiMap[params.row.appId], 'id', params.row.apiId);

                        return h('div', type.label);
                    }
                }, {
                    title: '推送状态',
                    key: 'status',
                    width: 100,
                    render: function (h, params) {
                        var status = utils.getItem(vm.statusList, 'id', params.row.status);

                        return h('div', status.name);
                    }
                }, {
                    title: '创建时间',
                    width: 150,
                    key: 'created',
                    format: 'Time'
                }, {
                    title: '详情',
                    key: 'metaData'
                }, {
                    title: '操作',
                    key: 'action',
                    width: 150,
                    align: 'center',
                    render: function (h, params) {

                        if (params.row.status != 0) {

                            if (params.row.status == 2) {
                                return;
                            }

                            return h('Button', {
                                props: {
                                    type: 'error',
                                    size: 'small'
                                },
                                on: {
                                    click: function () {
                                        vm.updateStatus(params);
                                    }
                                }
                            }, '处理');
                        }

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
                                        vm.reRequest(params);
                                    }
                                }
                            }, '一键推送'),
                            h('Button', {
                                props: {
                                    type: 'error',
                                    size: 'small'
                                },
                                on: {
                                    click: function () {
                                        vm.updateStatus(params);
                                    }
                                }
                            }, '处理')
                        ]);
                    }
                }],
                searchLoading: false
            }
        },
        mounted: function () {
            this.init();
        },
        methods: {
            init: function () {
                with (this) {
                    listByPage(1)
                }
            },
            listByPage: function (pageNum) {
                with (this) {

                    $refs['searchForm'].validate(function (valid) {
                        if (valid) {

                            if (pageNum) {
                                searchForm.pageNum = pageNum;
                            }

                            utils.get('${contextPath}/thirdPlatform/list', searchForm, function (result) {
                                if (result.success) {
                                    tableData = result.data.list;
                                    tableDataCount = result.data.total;
                                }
                                else {
                                    $Message.error(result.msg);
                                }
                            }, $data, 'searchLoading');
                        }
                    });
                }

            },
            reRequest: function (params) {
                with (this) {
                    $Modal.confirm({
                        title: '提示',
                        content: '<h4>用于接口推送失败后 重新推送数据给第三方</h4><br><div>是否重新推送？</div>',
                        onOk: function () {
                            utils.post('${contextPath}/thirdPlatform/reRequest', {
                                id: params.row.id
                            }, function (result) {
                                if (result.success) {
                                    $Message.success('操作成功');
                                    listByPage();
                                }
                                else {
                                    $Message.error(result.msg);
                                }
                            });
                        }
                    });
                }
            },
            updateStatus: function (params) {
                with (this) {
                    $Modal.confirm({
                        title: '提示',
                        content: '<h4>用于特殊情况下 真选需要绕过第三方进行退款操作</h4><br><div>是否标记处理？</div>',
                        onOk: function () {
                            utils.post('${contextPath}/thirdPlatform/updateStatus', {
                                id: params.row.id
                            }, function (result) {
                                if (result.success) {
                                    $Message.success('操作成功');
                                    listByPage();
                                }
                                else {
                                    $Message.error(result.msg);
                                }
                            });
                        }
                    });
                }
            },
            search: function () {
                with (this) {
                    listByPage(1);

                    if (searchForm.appId == 3) {
                        $.post('${contextPath}/thirdPlatform/queryAccount', {
                            appId: searchForm.appId
                        }, function (result) {
                            if (result.success) {
                                $Message.success('操作成功');

                                if (result.data != null) {
                                    if (result.data > 10000) {
                                        account = {
                                            isShow: true,
                                            color: '#19be6b',
                                            price: result.data
                                        };
                                    }
                                    else {
                                        account = {
                                            isShow: true,
                                            color: '#ed3f14',
                                            price: result.data
                                        };
                                    }
                                }

                            }
                            else {
                                $Message.error(result.msg);
                            }
                        });
                    }
                    else {
                        account = {
                            isShow: false,
                            color: '#19be6b',
                            price: 0
                        };
                    }
                }
            }
        }
    });

</script>