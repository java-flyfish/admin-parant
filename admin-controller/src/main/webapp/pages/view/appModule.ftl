<template id="appModule">
    <div class="auto-height">
        <Layout class="auto-height">
            <i-Header class="layout-header-content color-white">
                <i-form class="auto-height" ref="searchForm" :model="searchForm" :rules="searchRule" inline
                        @submit.native.prevent>

                    <form-item>
                        <i-input clearable type="text" v-model="searchForm.title" placeholder="搜索模块标题"
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
                        <i-Button icon="md-add" @click="modify(-1)">新增</i-Button>
                    </form-item>
                </i-form>
            </i-Header>

            <i-Content class="layout-body-content">
                <super-table :columns="tableColumns" :data="tableData" :loading="searchLoading" draggable
                             @on-end="dragUpdate" handle=".dragButton"></super-table>
            </i-Content>

            <i-footer class="layout-footer-content color-white">
                <Page class="text-center custom-table-page" show-total :total="tableDataCount"
                      :current="searchForm.pageNum" :page-size="searchForm.pageSize"
                      @on-change="listByPage"></Page>
            </i-footer>
        </Layout>

        <modal v-model="modal"
               :title="modalTitle"
               :mask-closable="false"
               :styles="{top: '20px',width:'800px'}">
            <i-form ref="formModal" :model="formModal" :rules="ruleModal" label-width="80">

                <row>
                    <i-col span="12">
                        <form-item prop="type" label="模块类型">
                            <i-Select v-model="formModal.type" filterable transfer="true" placeholder="请选择类型"
                                      class="auto-width">
                                <i-Option v-for="item in typeList" :value="item.value">{{ item.label }}</i-Option>
                            </i-Select>
                        </form-item>
                    </i-col>

                    <i-col span="12">
                        <form-item label="是否启用">
                            <i-switch v-model="formModal.isEnable" size="large">
                                <span slot="open">是</span>
                                <span slot="close">否</span>
                            </i-switch>
                        </form-item>
                    </i-col>
                </row>

                <row>
                    <i-col span="12">
                        <form-item prop="title" label="标题">
                            <i-input v-model="formModal.title" placeholder="标题">
                            </i-input>
                        </form-item>
                    </i-col>

                    <i-col span="12">
                        <form-item prop="subTitle" label="副标题">
                            <i-input v-model="formModal.subTitle" placeholder="副标题">
                            </i-input>
                        </form-item>
                    </i-col>
                </row>

                <row>
                    <i-col span="12">
                        <form-item prop="jumpLink" label="跳转链接">
                            <i-input v-model="formModal.jumpLink" placeholder="跳转链接或商品id">
                            </i-input>
                        </form-item>
                    </i-col>

                    <i-col span="12">
                        <form-item prop="img" label="图标">
                            <super-upload v-model="formModal.img" :action="upload.action" mode="image" keyword="url"
                                          size="58">
                            </super-upload>
                        </form-item>
                    </i-col>
                </row>

                <form-item label="banner配置">
                    <row v-for="item in bannerList" style="padding-bottom: 10px">

                        <i-col span="10" style="padding-bottom: 10px">
                            <i-input v-model="item.title" placeholder="标题">
                            </i-input>
                        </i-col>

                        <i-col span="9" offset="1" style="padding-bottom: 10px">
                            <i-input v-model="item.subTitle" placeholder="副标题">
                            </i-input>
                        </i-col>

                        <i-col span="1" offset="1">
                            <i-Button type="error" @click="deleteItem(item)">
                                删除
                            </i-Button>
                        </i-col>

                        <i-col span="10">
                            <i-input v-model="item.jumpLink" placeholder="跳转链接或商品id">
                            </i-input>
                        </i-col>

                        <i-col span="10" offset="1">
                            <super-upload v-model="item.img" :action="upload.action" mode="image" size="58">
                            </super-upload>
                        </i-col>

                    </row>
                    <row>
                        <i-col span="24">
                            <i-Button type="success" icon="plus-round" @click="addItem">
                                新增banner
                            </i-Button>
                        </i-col>
                    </row>
                </form-item>

                <form-item prop="items" label="商品id列表">
                    <i-input type="textarea" :autosize="{minRows: 2,maxRows: 5}"
                             v-model="formModal.items" placeholder="英文逗号分隔">
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
    var appModule = Vue.component('appModule', {
        template: '#appModule',
        data: function () {

            var vm = this;

            return {
                searchForm: {
                    title: null,
                    pageSize: 20
                },
                searchRule: {},
                typeList: [{
                    value: 1,
                    label: 'banner轮播图'
                }, {
                    value: 2,
                    label: '聚合区'
                }, {
                    value: 3,
                    label: '特权活动'
                }, {
                    value: 4,
                    label: '黑卡专享'
                }, {
                    value: 5,
                    label: '人气推荐'
                }, {
                    value: 6,
                    label: 'banner单图'
                }],

                tableData: [],
                tableDataCount: 0,
                tableColumns: [{
                    title: '模块id',
                    key: 'id',
                    width: 100
                }, {
                    title: '模块标题',
                    key: 'title'
                }, {
                    title: '排序',
                    key: 'sort',
                    width: 100
                }, {
                    title: '是否启用',
                    key: 'isEnable',
                    width: 100,
                    format: 'Boolean'
                }, {
                    title: '创建时间',
                    key: 'created',
                    width: 150,
                    format: 'Time'
                }, {
                    title: '更新时间',
                    key: 'updated',
                    width: 150,
                    format: 'Time'
                }, {
                    title: '操作',
                    key: 'action',
                    width: 150,
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
                                        vm.modify(params);
                                    }
                                }
                            }, '修改'),
                            h('Button', {
                                props: {
                                    type: 'info',
                                    icon: 'md-move',
                                    shape: 'circle'
                                },
                                class: 'dragButton'
                            })
                        ]);
                    }
                }],
                searchLoading: false,

                modal: false,
                modalTitle: '新增',
                modalLoading: false,
                formModal: {
                    id: null,
                    type: null,
                    title: null,
                    subTitle: null,
                    jumpLink: null,
                    img: null,
                    banners: null,
                    items: null,
                    isEnable: true
                },
                ruleModal: {
                    type: [
                        {required: true, message: '请选择类型', trigger: 'blur', type: 'number'}
                    ],
                    title: [
                        {required: true, message: '请填写标题', trigger: 'blur'}
                    ]
                },

                upload: {
                    action: '${contextPath}/system/uploadImg'
                },

                bannerList: []
            }
        },
        mounted: function () {
            this.init();
        },
        methods: {
            init: function () {
                this.listByPage(1);
            },
            listByPage: function (pageNum) {
                with (this) {

                    if (pageNum) {
                        searchForm.pageNum = pageNum;
                    }

                    utils.get('${contextPath}/appModule/listByPage', searchForm, function (result) {
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
            modify: function (params) {
                with (this) {

                    formModal = {
                        id: null,
                        type: '',
                        title: null,
                        subTitle: null,
                        jumpLink: null,
                        img: null,
                        banners: null,
                        items: null,
                        isEnable: true
                    };

                    bannerList = [];

                    if (params == -1) {
                        modalTitle = '新增';
                    }
                    else {
                        modalTitle = '修改';

                        utils.copyModel(params.row, formModal);

                        if (utils.isNotEmpty(formModal.banners)) {
                            var array = JSON.parse(formModal.banners);

                            array.forEach(function (t) {

                                bannerList.push({
                                    title: t.title,
                                    subTitle: t.subTitle,
                                    jumpLink: t.jumpLink,
                                    img: t.img == null ? null : {
                                        url: t.img,
                                        width: t.width,
                                        height: t.height
                                    },
                                    width: t.width,
                                    height: t.height,
                                });

                            });

                        }

                    }

                    modal = true;

                }
            },
            asyncOK: function (name) {
                with (this) {

                    $refs[name].validate(function (valid) {
                        if (valid) {

                            var array = [];
                            bannerList.forEach(function (t) {

                                array.push({
                                    title: t.title,
                                    subTitle: t.subTitle,
                                    jumpLink: t.jumpLink,
                                    img: t.img == null ? null : t.img.url,
                                    width: t.img == null ? null : t.img.width,
                                    height: t.img == null ? null : t.img.height
                                });

                            });

                            formModal.banners = JSON.stringify(array);

                            utils.postJson('${contextPath}/appModule/modify', formModal, function (result) {
                                if (result.success) {
                                    modal = false;
                                    listByPage();
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
            addItem: function () {
                with (this) {
                    bannerList.push({
                        title: null,
                        subTitle: null,
                        jumpLink: null,
                        img: null,
                        pic: null,
                        width: null,
                        height: null
                    });
                }
            },
            deleteItem: function (item) {
                with (this) {
                    bannerList.splice(bannerList.indexOf(item), 1);
                }
            },
            dragUpdate: function (e) {

                with (this) {
                    if (e.from != e.to) {
                        var data = {
                            ids: [],
                            id: e.row.id,
                            sort: e.to
                        };

                        if (e.from > e.to) {
                            //上移,from 和 to 之间的元素加 1
                            var list = tableData.slice(e.to + 1, e.from + 1);

                            data.type = 1;

                            list.forEach(function (t) {
                                data.ids.push(t.id);
                            });
                        }
                        else {
                            //下移,from 和 to 之间的元素减 1
                            var list = tableData.slice(e.from, e.to);

                            data.type = -1;

                            list.forEach(function (t) {
                                data.ids.push(t.id);
                            });
                        }

                        data.ids = data.ids.join(',');

                        utils.post('${contextPath}/appModule/sort', data, function (result) {
                            if (result.success) {
                                $Message.success('排序成功');
                                listByPage();
                            }
                            else {
                                $Message.error(result.msg);
                            }
                        }, $data, 'searchLoading');

                    }
                }

            }
        }
    });


</script>