<template id="taskRule">
    <div class="auto-height">
        <Layout class="auto-height">
            <i-Header class="layout-header-content color-white">

                <i-form class="auto-height" @submit.native.prevent inline>
                    <form-item>
                        <i-button shape="circle" icon="ios-search" @click="toLoading" :loading="loading">
                            <span v-if="!loading">刷新</span>
                            <span v-else>刷新中...</span>
                        </i-button>
                    </form-item>

                    <form-item>
                        <i-button type="primary" shape="circle" icon="md-add" @click="toAdd">
                            新增订阅
                        </i-button>
                    </form-item>
                </i-form>
            </i-Header>
            <i-Content class="layout-body-content">
                <super-table :loading="loading" :columns="columns" :data="tableData">
                </super-table>
            </i-Content>

            <i-footer class="layout-footer-content color-white">

            </i-footer>
        </Layout>

        <modal v-model="modal"
               :title="modalTitle"
               :mask-closable="false"
               :styles="{top: '20px'}">
            <i-form ref="formModal" :model="formModal" :rules="ruleModal" label-width="80">

                <form-item prop="ruleId" label="规则">
                    <i-Select v-model="formModal.ruleId">
                        <i-Option v-for="item in ruleList" :value="item.id">{{ item.comment + item.title }}</i-Option>
                    </i-Select>
                </form-item>

                <form-item prop="type" label="通知方式">
                    <i-Select v-model="formModal.type">
                        <i-Option value="0">邮箱通知</i-Option>
                        <i-Option value="1">邮箱通知(EXCEL附件)</i-Option>
                        <i-Option disabled value="3">短信通知</i-Option>
                    </i-Select>
                </form-item>

                <form-item prop="email" label="通知邮箱">
                    <i-input type="email" v-model="formModal.email" placeholder="请输入邮箱">
                    </i-input>
                </form-item>

                <form-item prop="noFazeTime" label="免打扰时间">
                    <Slider v-model="formModal.noFazeTime" range @on-change="formatText" max="23" step="1"
                            show-stops></Slider>
                    <i-input readonly type="text" v-model="noFazeTimeTip">
                    </i-input>
                </form-item>

                <form-item prop="isEnable" label="是否开启">
                    <i-switch v-model="formModal.isEnable" size="large">
                        <span slot="open">开启</span>
                        <span slot="close">关闭</span>
                    </i-switch>
                </form-item>

                <form-item prop="comment" label="备注">
                    <i-input type="textarea" :autosize="{minRows: 2,maxRows: 5}" v-model="formModal.comment"
                             placeholder="请输入备注">
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
    var taskRule = Vue.component('taskRule', {
        template: '#taskRule',
        data: function () {
            var vm = this;
            return {
                loading: false,
                modal: false,
                modalTitle: '添加订阅',
                modalLoading: false,
                formModal: {
                    ruleId: '',
                    type: '0',
                    noFazeTime: [0, 0],
                    isEnable: true,
                    comment: '',
                    email: store.email
                },
                ruleModal: {
                    ruleId: [
                        {required: true, message: '请选择规则', trigger: 'blur'}
                    ],
                    type: [
                        {required: true, message: '请选择通知方式', trigger: 'blur'}
                    ],
                    email: [
                        {required: true, message: '请填写邮箱', trigger: 'blur'},
                        {type: 'email', message: '请填写邮箱', trigger: 'blur'}
                    ],
                    comment: [
                        {type: 'string', max: 50, message: '备注不能超过50个字', trigger: 'blur'}
                    ]
                },
                ruleList: [],
                noFazeTimeTip: '',

                columns: [
                    {
                        title: '描述',
                        key: 'describeText'
                    },
                    {
                        title: '通知方式',
                        width: 200,
                        key: 'type',
                        render: function (h, params) {
                            if (params.row.type == 0) {
                                return h('div', '邮箱通知：' + params.row.email);
                            }

                            if (params.row.type == 1) {
                                return h('div', '邮箱通知(EXCEL附件)：' + params.row.email);
                            }

                        }
                    },
                    {
                        title: '免打扰时间',
                        width: 180,
                        key: 'noFazeTime',
                        render: function (h, params) {
                            var noFazeTime = params.row.noFazeTime;
                            if (noFazeTime) {
                                var times = noFazeTime.split(",");

                                return h('div', '每天 ' + times[0] + '点 至 ' + times[1] + '点 不通知');
                            }
                        }
                    },
                    {
                        title: '是否开启',
                        width: 100,
                        key: 'isEnable',
                        format: 'Boolean'
                    }, {
                        title: '备注',
                        width: 150,
                        key: 'comment'
                    },
                    {
                        title: '操作',
                        key: 'action',
                        width: 150,
                        align: 'center',
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
                                            vm.toEdit(params.index);
                                        }
                                    }
                                }, '修改'),
                                h('Button', {
                                    props: {
                                        type: 'error',
                                        size: 'small'
                                    },
                                    on: {
                                        click: function () {
                                            vm.toDelete(params.index);
                                        }
                                    }
                                }, '删除')
                            ]);
                        }
                    }
                ],
                tableData: []
            }
        },
        mounted: function () {
            this.init();
        },
        methods: {
            init: function () {
                with (this) {

                    utils.get('${contextPath}/taskRule/listByPage', {
                        pageNum: 1,
                        pageSize: 100
                    }, function (result) {
                        if (result.success) {
                            var data = result.data;
                            ruleList = data.list;
                        }
                        else {
                            $Message.error(result.msg);
                        }
                    });

                    toLoading();
                }
            },
            formatText: function () {
                with (this) {
                    var times = formModal.noFazeTime;

                    noFazeTimeTip = '每天 ' + times[0] + '点 至 ' + times[1] + '点 不通知';

                }
            },
            toAdd: function () {
                with (this) {
                    $refs['formModal'].resetFields();
                    formModal.id = null;
                    noFazeTimeTip = '';
                    modalTitle = '新增订阅';
                    modal = true;
                }
            },
            toEdit: function (index) {

                with (this) {
                    $refs['formModal'].resetFields();
                    formModal.id = null;
                    noFazeTimeTip = '';

                    modalTitle = '修改订阅';

                    var data = tableData[index];

                    formModal.id = data.id;
                    formModal.ruleId = data.ruleId;
                    formModal.comment = data.comment;
                    formModal.isEnable = data.isEnable;
                    formModal.type = data.type + '';
                    formModal.email = data.email;

                    if (data.noFazeTime) {
                        var times = data.noFazeTime.split(",");
                        formModal.noFazeTime = times;
                        noFazeTimeTip = '每天 ' + times[0] + '点 至 ' + times[1] + '点 不通知';
                    }

                    modal = true;
                }

            },
            toDelete: function (index) {
                with (this) {

                    $Modal.confirm({
                        title: '提示',
                        content: '确认删除',
                        onOk: function () {
                            {
                                var data = tableData[index];

                                utils.post('${contextPath}/taskRuleSubscriber/delete', {
                                    id: data.id
                                }, function (result) {
                                    if (result.success) {
                                        $Message.success('操作成功');
                                        toLoading();
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
            asyncOK: function (name) {
                with (this) {
                    if (formModal.ruleId != null) {
                        formModal.ruleId = formModal.ruleId + '';
                    }
                    $refs[name].validate(function (valid) {
                        if (valid) {

                            var obj = {};

                            if (formModal.noFazeTime != null) {
                                obj.noFazeTime = formModal.noFazeTime[0] + ',' + formModal.noFazeTime[1];
                            }
                            obj.id = formModal.id;
                            obj.ruleId = formModal.ruleId;
                            obj.comment = formModal.comment;
                            obj.isEnable = formModal.isEnable;
                            obj.type = formModal.type;
                            obj.email = formModal.email;

                            for (var i = 0; i < ruleList.length; i++) {
                                if (ruleList[i].id == obj.ruleId) {
                                    obj.describeText = ruleList[i].comment + " " + ruleList[i].title;
                                }
                            }

                            utils.postJson('${contextPath}/taskRuleSubscriber/modify', obj, function (result) {
                                if (result.success) {
                                    modal = false;
                                    toLoading();
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
            toLoading: function () {
                with (this) {

                    utils.get('${contextPath}/taskRuleSubscriber/listByPage', {
                        pageNum: 1,
                        pageSize: 100
                    }, function (result) {
                        if (result.success) {
                            var data = result.data;

                            tableData = data.list;

                        }
                        else {
                            $Message.error(result.msg);
                        }
                    }, $data, 'loading');

                }
            }
        }
    });

</script>