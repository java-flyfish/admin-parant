<template id="topic">
    <div class="auto-height">
        <Layout class="auto-height">
            <i-Header class="layout-header-content color-white">
                <i-form class="auto-height" ref="searchForm" :model="searchForm" :rules="searchRule" inline
                        @submit.native.prevent>

                    <form-item>
                        <i-input clearable type="text" v-model="searchForm.title" placeholder="搜索专题标题"
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
                        <i-Button icon="md-add" @click="modifyTopic(-1)">新增</i-Button>
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
               :mask-closable="false"
               :styles="{top: '20px'}">
            <i-form ref="formModal" :model="formModal" :rules="ruleModal" label-width="80">

                <form-item prop="title" label="专题标题">
                    <i-input v-model="formModal.title" placeholder="请填写专题标题">
                    </i-input>
                </form-item>

                <form-item prop="subtitle" label="副标题">
                    <i-input v-model="formModal.subtitle" placeholder="请填写副标题">
                    </i-input>
                </form-item>

                <form-item label="专题图">
                    <super-upload v-model="formModal.img" :action="upload.action" mode="image" keyword="url"
                                  size="58">
                    </super-upload>
                </form-item>

                <form-item label="是否上架" class="no-margin">
                    <i-switch v-model="formModal.status" size="large">
                        <span slot="open">是</span>
                        <span slot="close">否</span>
                    </i-switch>
                </form-item>
            </i-form>

            <div slot="footer">
                <i-button type="primary" @click="asyncOK('formModal')" long :loading="modalLoading">
                    确定
                </i-button>
            </div>
        </modal>

        <modal v-model="productModal"
               :title="productModalTitle"
               :mask-closable="false"
               fullscreen>

            <i-form :model="productSearchForm" inline
                    @submit.native.prevent>

                <form-item>
                    <i-input clearable type="text" v-model="productSearchForm.pid" placeholder="搜索商品id"
                             @on-enter="listProductByPage(1)">
                    </i-input>
                </form-item>

                <form-item>
                    <i-input clearable type="text" v-model="productSearchForm.title" placeholder="搜索商品名称"
                             @on-enter="listProductByPage(1)">
                    </i-input>
                </form-item>

                <form-item>
                    <i-Button type="primary" shape="circle" icon="ios-search" @click="listProductByPage(1)"
                              :loading="productSearchLoading">
                        <span v-if="!productSearchLoading">查询</span>
                        <span v-else>查询中...</span>
                    </i-Button>
                </form-item>

                <form-item>
                    <Poptip placement="bottom" @on-popper-show="popperShow">
                        <i-Button type="success" shape="circle" icon="ios-cloud-download-outline">
                            快速导入
                        </i-Button>
                        <div slot="content" style="width: 800px;">

                            <row>
                                <i-Col span="11">
                                    <h4>方式一：Excel上传</h4>
                                    <super-upload ref="upload" v-model="upload.file" :action="upload.fileAction"
                                                  mode="excel" :auto="false"
                                                  :simple="false" @on-success="handleUploadFileSuccess">
                                    </super-upload>
                                </i-Col>
                                <i-Col span="12" offset="1">
                                    <h4>方式二：按条件导入</h4>

                                    <p style="margin-top: 10px">1、输入商品id，以逗号隔开</p>
                                    <i-input type="textarea" :autosize="{minRows: 2,maxRows: 5}"
                                             v-model="upload.productIds">
                                    </i-input>
                                </i-Col>
                            </row>
                            <br>
                            <row>
                                <i-Col span="24" class="text-center" style="margin-top: 50px">
                                    <i-Button type="warning" shape="circle" icon="checkmark" @click="uploadProduct"
                                              :loading="productSearchLoading">
                                        <span v-if="!productSearchLoading">确认导入</span>
                                        <span v-else>导入中...</span>
                                    </i-Button>
                                </i-Col>
                            </row>
                        </div>
                    </Poptip>
                </form-item>
            </i-form>

            <div class="table-container-topic" style="position: absolute;top: 70px;bottom: 10px;left: 15px;right: 15px">
                <super-Table container=".table-container-topic" :columns="productTableColumns"
                             :data="productTableData"
                             :loading="productSearchLoading" draggable @on-end="dragUpdate"
                             handle=".dragButton"></super-Table>
            </div>

            <div slot="footer">
                <Page class="text-center custom-table-page" show-total :total="productTableDataCount"
                      @on-change="listProductByPage"></Page>
            </div>
        </modal>
    </div>
</template>

<script>
    var topic = Vue.component('topic', {
        template: '#topic',
        data: function () {
            var vm = this;
            return {
                searchForm: {
                    title: null
                },
                searchRule: {},

                tableData: [],
                tableDataCount: 0,
                tableColumns: [{
                    title: '专题id',
                    key: 'id',
                    width: 100
                }, {
                    title: '专题标题',
                    key: 'title'
                }, {
                    title: '图片',
                    width: 150,
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
                    width: 80,
                    render: function (h, params) {
                        return h('div', params.row.status ? '已上架' : '已下架')
                    }
                }, {
                    title: '创建时间',
                    width: 150,
                    key: 'created',
                    format: 'Time'
                }, {
                    title: '操作',
                    key: 'action',
                    width: 180,
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
                                        vm.modifyTopic(params);
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
                                        vm.viewProducts(params);
                                    }
                                }
                            }, '查看商品')
                        ]);
                    }
                }],
                searchLoading: false,

                modal: false,
                modalTitle: '新增专题',
                modalLoading: false,
                formModal: {
                    title: null,
                    subtitle: null,
                    status: false,
                    img: null
                },
                ruleModal: {
                    title: [
                        {required: true, message: '请填写专题名称', trigger: 'blur'}
                    ]
                },
                upload: {
                    action: '${contextPath}/system/uploadImg',
                    file: null,
                    productIds: null,
                    fileAction: '${contextPath}/topicProduct/upload'
                },

                productModal: false,
                productModalTitle: '专题商品',
                productModalId: null,
                productTableData: [],
                productTableDataTemp: [],
                productTableDataCount: 0,
                productSearchLoading: false,
                productSearchForm: {
                    pid: null,
                    title: null
                },

                productTableColumns: [{
                    title: '商品id',
                    key: 'pid',
                    width: 80,
                    align: 'center'
                }, {
                    title: '商品名称',
                    key: 'title'
                } , {
                    title: '排序',
                    key: 'sort',
                    width: 90
                }, {
                    title: '商品状态',
                    width: 90,
                    render: function (h, params) {
                        var product = params.row.product;

                        if (product) {
                            return h('div', product.status ? '上架' : '下架');
                        }
                        else {
                            return;
                        }

                    }
                }, {
                    title: '操作',
                    width: 150,
                    render: function (h, params) {
                        return h('div', [
                            h('Poptip', {
                                props: {
                                    confirm: true,
                                    title: '确认删除 ' + params.row.title,
                                    placement: 'left'
                                },
                                on: {
                                    'on-ok': function () {
                                        vm.deleteProduct(params);
                                    }
                                }
                            }, [
                                h('Button', {
                                    props: {
                                        type: 'error',
                                        size: 'small'
                                    }
                                }, '删除')
                            ]),
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
                }]
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

                    utils.get('${contextPath}/topic/listByPage', searchForm, function (result) {
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
            modifyTopic: function (params) {
                with (this) {

                    formModal = {
                        title: null,
                        subtitle: null,
                        status: false,
                        img: null
                    };

                    if (params == -1) {
                        modalTitle = '新增专题';
                    }
                    else {
                        modalTitle = '修改专题';

                        formModal.id = params.row.id;
                        utils.copyModel(params.row, formModal);
                    }

                    modal = true;

                }
            },
            asyncOK: function (name) {
                with (this) {
                    $refs[name].validate(function (valid) {
                        if (valid) {

                            utils.postJson('${contextPath}/topic/modify', formModal, function (result) {
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
                }
            },

            popperShow: function () {
                with (this) {
                    upload.file = null;
                    upload.productIds = null;
                }
            },
            handleUploadFileSuccess: function (response, file, fileList) {
                with (this) {
                    productSearchLoading = false;
                    if (response.success) {
                        $Message.success('操作成功，共导入' + response.data + '个商品');
                        listProductByPage(1);
                    }
                    else {
                        $Message.error(response.msg);
                    }
                }
            },
            uploadProduct: function () {

                with (this) {
                    if (upload.file) {
                        productSearchLoading = true;
                        $refs.upload.upload({
                            topicId: productModalId
                        });
                    }
                    else {

                        if (utils.isEmpty(upload.productIds)) {
                            $Message.error('请选择一种导入方式');
                            return;
                        }

                        utils.post(upload.fileAction, {
                            productIds: upload.productIds,
                            topicId: productModalId
                        }, function (result) {
                            if (result.success) {
                                $Message.success('操作成功，共导入' + result.data + '个商品');
                                listProductByPage(1);
                            }
                            else {
                                $Message.error(result.msg);
                            }
                        }, $data, 'productSearchLoading');
                    }
                }
            },
            dragUpdate: function (e) {
                with (this) {
                    var rowFrom = productTableDataTemp[e.from].id;
                    var sort = e.to;
                    var rowTo = productTableDataTemp[e.to].id;
                    var topicId = productModalId
                    var idList = new Array();
                    var change;
                    if (e.from < e.to) {
                        //下移,from 和 to 之间的元素减 1
                        change = -1;
                        for (var i = e.from+1; i <= e.to; i++) {
                            idList.push(productTableDataTemp[i].id);
                        }
                    } else {
                        //上移,from 和 to 之间的元素加 1
                        change = 1;
                        for (var i = e.to; i < e.from; i++) {
                            idList.push(productTableDataTemp[i].id);
                        }
                    }
                    var ids = idList.join(",");
                    utils.post('${contextPath}/topicProduct/sort', {from:rowFrom,sort:sort,ids: ids,change: change,topicId:topicId}, function (result) {
                        if (result.success) {
                            $Message.success('排序成功');
                            listProductByPage();
                        }
                        else {
                            $Message.error(result.msg);
                        }
                    }, $data, 'productSearchLoading')
                }
            },
            deleteProduct: function (params) {
                with (this) {

                    utils.post('${contextPath}/topicProduct/delete', {
                        id: params.row.id,
                        topicId: params.row.tid,
                        sort: params.row.sort
                    }, function (result) {
                        if (result.success) {
                            $Message.success('删除成功');
                            listProductByPage(1);
                        }
                        else {
                            $Message.error(result.msg);
                        }
                    }, $data, 'productSearchLoading');

                }
            },
            listProductByPage: function (pageNum) {
                with (this) {

                    if (pageNum) {
                        productSearchForm.pageNum = pageNum;
                    }

                    productSearchForm.topicId = productModalId;

                    utils.get('${contextPath}/topicProduct/listByPage', productSearchForm, function (result) {
                        if (result.success) {
                            productTableData = result.data.list;
                            utils.copyBean(productTableData,productTableDataTemp);
                            productTableDataCount = result.data.total;
                        }
                        else {
                            $Message.error(result.msg);
                        }
                    }, $data, 'productSearchLoading');
                }
            },
            viewProducts: function (params) {
                with (this) {

                    productModal = true;

                    productModalTitle = params.row.title + '的商品列表';

                    productModalId = params.row.id;

                    productSearchForm = {
                        pid: null,
                        title: null
                    };

                    listProductByPage(1);
                }
            }
        }
    });

</script>