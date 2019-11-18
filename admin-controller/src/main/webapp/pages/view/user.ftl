<template id="user">
    <div class="auto-height">
        <Layout class="auto-height">
            <i-Header class="layout-header-content color-white">
                <i-form class="auto-height" ref="searchForm" :model="searchForm" :rules="searchRule" inline
                        @submit.native.prevent>

                    <form-item>
                        <i-input clearable type="text" v-model="searchForm.search" placeholder="搜索姓名/昵称/邮箱"
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
                        <i-ButtonGroup>
                            <i-Button icon="md-add" @click="modifyUser(-1)">新增</i-Button>
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
            <i-form ref="formModal" :model="formModal" :rules="ruleModal" label-width="80" inline>

                <form-item prop="email" label="邮箱">
                    <i-input type="email" v-model="formModal.email" placeholder="请输入邮箱">
                    </i-input>
                </form-item>

                <form-item prop="password" label="密码">
                    <i-input type="password" v-model="formModal.password" placeholder="请输入密码">
                    </i-input>
                </form-item>

                <form-item prop="name" label="用户姓名">
                    <i-input type="text" v-model="formModal.name" placeholder="请输入用户姓名">
                    </i-input>
                </form-item>

                <form-item prop="nickName" label="用户昵称">
                    <i-input type="text" v-model="formModal.nickName" placeholder="请输入用户昵称">
                    </i-input>
                </form-item>

                <form-item prop="phone" label="手机号码">
                    <i-input type="text" v-model="formModal.phone" placeholder="请输入手机号码">
                    </i-input>
                </form-item>

                <form-item prop="roleId" label="角色">
                    <i-Select v-model="formModal.roleId" style="width:141px;">
                        <i-Option v-for="item in roleList" :value="item.id">{{ item.name }}</i-Option>
                    </i-Select>
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

        <modal v-model="thirdModal"
               :title="thirdModalTitle"
               :mask-closable="false">
            <i-form ref="thirdFormModal" :model="thirdFormModal" :rules="thirdRuleModal" label-width="80">

                <form-item prop="roleId" label="角色">
                    <i-Select v-model="thirdFormModal.roleId" transfer>
                        <i-Option v-for="item in roleList" :value="item.id">{{ item.name }}</i-Option>
                    </i-Select>
                </form-item>

                <form-item v-if="!thirdEdit" prop="departmentId" label="部门">
                    <i-Select v-model="thirdFormModal.departmentId" @on-change="thirdDeptChange" transfer>
                        <i-Option v-for="item in thirdDepartmentList" :value="item.id">{{ item.name }}</i-Option>
                    </i-Select>
                </form-item>

                <form-item v-if="!thirdEdit" prop="userId" label="用户姓名">
                    <i-Select v-model="thirdFormModal.userId" filterable @on-change="thirdUserChange" transfer>
                        <i-Option v-for="item in thirdUserList" :value="item.id" :key="item.id">{{ item.nickname }}</i-Option>
                    </i-Select>
                </form-item>

                <form-item prop="isEnable" label="是否开启">
                    <i-switch v-model="thirdFormModal.isEnable" size="large">
                        <span slot="open">开启</span>
                        <span slot="close">关闭</span>
                    </i-switch>
                </form-item>

            </i-form>

            <div slot="footer">
                <i-button type="primary" @click="asyncThirdOK('thirdFormModal')" long :loading="modalLoading">
                    确定
                </i-button>
            </div>
        </modal>
    </div>
</template>

<script>
    var user = Vue.component('user', {
        template: '#user',
        data: function () {
            var vm = this;
            return {
                searchForm: {
                    search: null
                },
                searchRule: {},

                tableData: [],
                tableDataCount: 0,
                tableColumns: [{
                    type: 'index',
                    width: 60,
                    align: 'center'
                }, {
                    title: '用户姓名',
                    key: 'name'
                }, {
                    title: '用户昵称',
                    key: 'nickName'
                }, {
                    title: '角色',
                    key: 'roleId',
                    render: function (h, params) {
                        var item = utils.getItem(vm.roleList, 'id', params.row.roleId);
                        if (item) {
                            return h('div', item.name);
                        }

                        return;
                    }
                }, {
                    title: '邮箱',
                    key: 'email'
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
                                        vm.modifyUser(params.index);
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
                                        vm.deleteUser(params.index);
                                    }
                                }
                            }, '删除')
                        ]);
                    }
                }],
                searchLoading: false,

                modal: false,
                modalTitle: '添加用户',
                modalLoading: false,
                formModal: {
                    name: null,
                    nickName: null,
                    roleId: null,
                    password: null,
                    phone: null,
                    email: null,
                    isEnable: true
                },
                ruleModal: {
                    email: [
                        {required: true, message: '请填写邮箱', trigger: 'blur', type: 'email'}
                    ],
                    password: [
                        {required: true, message: '请填写密码', trigger: 'blur'}
                    ],
                    roleId: [
                        {required: true, message: '请选择角色', trigger: 'blur', type: 'number'}
                    ]
                },

                roleList: [],

                thirdModal: false,
                thirdModalTitle: '新增用户',
                thirdFormModal: {
                    isEnable: true,
                    roleId: null,
                    departmentId: null,
                    userId: null,
                    thirdUser: null
                },
                thirdRuleModal: {
                    roleId: [
                        {required: true, message: '请选择角色', trigger: 'blur', type: 'number'}
                    ],
                    userId: [
                        {required: true, message: '请选择用户', trigger: 'blur', type: 'number'}
                    ],
                    departmentId: [
                        {required: true, message: '请选择用户', trigger: 'blur', type: 'number'}
                    ]
                },
                thirdDepartmentList: [],
                thirdUserList: [],
                thirdEdit: false
            }
        },
        mounted: function () {
            this.init();
        },
        methods: {
            init: function () {
                with (this) {

                    utils.get('${contextPath}/role/listAll', {}, function (result) {
                        if (result.success) {
                            roleList = result.data;
                        }
                    });

                    utils.get('${contextPath}/managerUser/getThirdDeptList', {}, function (result) {
                        if (result.success) {
                            thirdDepartmentList = result.data;
                        }
                    });

                    listByPage(1);
                }
            },
            listByPage: function (pageNum) {
                with (this) {
                    currentRow = null;

                    if (pageNum) {
                        searchForm.pageNum = pageNum;
                    }

                    utils.get('${contextPath}/sysUser/listByPage', searchForm, function (result) {
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
                            utils.postJson('${contextPath}/managerUser/modify', formModal, function (result) {
                                if (result.success) {
                                    modal = false;
                                    $Message.success('操作成功');
                                    listByPage();
                                }
                                else {
                                    $Message.error(result.msg);
                                }
                            }, $data, 'modalLoading');

                        }
                    });
                }
            },
            deleteUser: function (index) {
                with (this) {
                    $Modal.confirm({
                        title: '提示',
                        content: '确认删除',
                        onOk: function () {
                            {
                                utils.post('${contextPath}/managerUser/delete', {
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
            modifyUser: function (index) {

                with (this) {
                    thirdFormModal = {
                        isEnable: true,
                        roleId: null,
                        departmentId: null,
                        userId: null,
                        thirdUser: null
                    };

                    thirdEdit = false;

                    if (index == -1) {
                        thirdModalTitle = '添加用户';
                    }
                    else {

                        thirdEdit = true;

                        var currentRow = tableData[index];

                        thirdModalTitle = '修改用户';

                        utils.copyModel(currentRow, thirdFormModal);

                        thirdFormModal.userId = currentRow.id;
                    }

                    thirdModal = true;
                }

            },
            thirdDeptChange: function (item) {
                with (this) {
                    if (utils.isNotEmpty(item)) {
                        utils.get('${contextPath}/managerUser/getThirdUserListByDept', {
                            id: item
                        }, function (result) {
                            if (result.success) {
                                thirdUserList = result.data;
                            }
                        });
                    }
                }
            },
            thirdUserChange: function (item) {
                with (this) {
                    if (utils.isNotEmpty(item)) {
                        var obj = utils.getItem(thirdUserList, 'id', item);
                        if (obj != null) {
                            thirdFormModal.thirdUser = obj;
                        }
                    }
                }

            },
            asyncThirdOK: function (name) {
                with (this) {
                    $refs[name].validate(function (valid) {
                        if (valid) {

                            var data = {
                                id: thirdFormModal.userId,
                                keyId: thirdFormModal.userId,
                                roleId: thirdFormModal.roleId,
                                isEnable: thirdFormModal.isEnable
                            };

                            if (thirdFormModal.thirdUser != null) {
                                data.name = thirdFormModal.thirdUser.name;
                                data.nickName = thirdFormModal.thirdUser.nickname;
                                data.cardNum = thirdFormModal.thirdUser.cardNum;
                                data.password = thirdFormModal.thirdUser.password;
                                data.email = thirdFormModal.thirdUser.email;
                                data.phone = thirdFormModal.thirdUser.tel;
                            }

                            utils.postJson('${contextPath}/managerUser/modifyThird', data, function (result) {
                                if (result.success) {
                                    thirdModal = false;
                                    $Message.success('操作成功');
                                    listByPage();
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