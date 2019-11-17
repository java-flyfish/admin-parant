<template id="marketActivity">
    <div class="auto-height">
        <Layout class="auto-height">
            <i-Header class="layout-header-content color-white">
                <i-form class="auto-height" ref="searchForm" :model="searchForm" :rules="searchRule" inline
                        @submit.native.prevent>

                    <form-item>
                        <i-input clearable type="text" v-model="searchForm.label" placeholder="搜索活动名称"
                                 @on-enter="listByPage(1)">
                        </i-input>
                    </form-item>

                    <form-item>
                        <i-Select clearable v-model="searchForm.type" placeholder="请选择类型" style="width: 100px">
                            <i-Option v-for="item in typeList" :value="item.id">{{ item.name }}</i-Option>
                        </i-Select>
                    </form-item>

                    <form-item>
                        <i-Select clearable v-model="searchForm.status" placeholder="请选择状态" style="width: 100px">
                            <i-Option v-for="item in statusList" :value="item.id">{{ item.name }}</i-Option>
                        </i-Select>
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
                            <i-Button icon="md-add" @click="modifyMarketActivity(-1)">新增</i-Button>
                        </i-ButtonGroup>
                    </form-item>
                </i-form>
            </i-Header>
            <i-Content class="layout-body-content auto-overflow">
                <super-Table :columns="tableColumns"
                             :data="tableData"
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
               :styles="{top: '20px'}" @on-cancel="cancelModal">
            <i-form ref="formModal" :model="formModal" :rules="ruleModal" label-width="80" inline>

                <form-item prop="label" label="活动名称">
                    <i-input v-model="formModal.label">
                    </i-input>
                </form-item>

                <form-item prop="url" label="活动链接" v-if="formModal.showUrl">
                    <i-input v-model="formModal.url">
                    </i-input>
                </form-item>

                <form-item prop="timeRange" label="活动时间" class="auto-width">
                    <Date-Picker type="datetimerange" v-model="formModal.timeRange" class="auto-width"
                                 placeholder="请选择活动时间"></Date-Picker>
                </form-item>

                <form-item prop="status" label="活动状态">
                    <i-Select v-model="formModal.status" style="width: 100px">
                        <i-Option v-for="item in statusList" :value="item.id">{{ item.name }}</i-Option>
                    </i-Select>
                </form-item>

                <form-item prop="type" label="活动类型">
                    <i-Select v-model="formModal.type" placeholder="请选择类型" @on-change="formTypeChange"
                              style="width: 100px">
                        <i-Option v-for="item in typeList" :value="item.id">{{ item.name }}</i-Option>
                    </i-Select>
                </form-item>

                <form-item label-width="20">
                    <row>
                        <i-Col span="24" v-if="formModal.isDiscountType">
                            活动力度：
                            <Input-Number :max="10" :min="1" v-model="formModal.discount"></Input-Number>
                            折
                        </i-Col>
                        <i-Col span="24" v-if="formModal.isFillType">
                            活动力度：满
                            <Input-Number :min="1" v-model="formModal.fill"></Input-Number>
                            减
                            <Input-Number :min="1" v-model="formModal.subtract"></Input-Number>
                        </i-Col>
                    </row>
                </form-item>

                <form-item label="活动标签" class="auto-width">
                    <row>
                        <i-Col span="6">
                            字体颜色
                            <Color-Picker v-model="formModal.labelTextColor" recommend/>
                        </i-Col>
                        <i-Col span="6">
                            背景颜色
                            <Color-Picker v-model="formModal.labelBackgroundColor" recommend/>
                        </i-Col>
                        <i-Col span="12">
                            文案内容
                            <i-input v-model="formModal.labelName" placeholder="请填写文案内容">
                            </i-input>
                        </i-Col>
                    </row>
                </form-item>

                <form-item label="活动说明" class="auto-width">
                    <row>
                        <i-Col span="6">
                            字体颜色
                            <Color-Picker v-model="formModal.textColor" recommend/>
                        </i-Col>
                        <i-Col span="6">
                            背景颜色
                            <Color-Picker v-model="formModal.backgroundColor" recommend/>
                        </i-Col>
                        <i-Col span="12">
                            文案内容
                            <i-input v-model="formModal.name" placeholder="请填写文案内容">
                            </i-input>
                        </i-Col>
                    </row>
                </form-item>
                <form-item class="auto-width" label="优惠活动">
                    <row>
                        <i-Col span="10">
                            可使用礼券
                            <i-Switch v-model="formModal.isGift"/>
                        </i-Col>
                    </row>
                <#--<row>
                    <i-Col span="10">
                        可使用自由币
                        <i-Switch v-model="formModal.isGold"/>
                    </i-Col>
                    </row>-->
                </form-item>

                <form-item class="auto-width" label="无优惠会籍" >
                    <row>
                        <Checkbox-Group v-model="formModal.membershipIds" @on-change="showPreferentialAttr">
                            <Checkbox label="0" span="6">
                                <span>优先</span>
                            </Checkbox>
                            <Checkbox label="1" span="6">
                                <span>至尊</span>
                            </Checkbox>
                            <Checkbox label="2" span="6">
                                <span>总裁</span>
                            </Checkbox>
                            <Checkbox label="3" span="6">
                                <span>总统</span>
                            </Checkbox>
                        </Checkbox-Group>
                    </row>
                    <row>
                        <font color="#FF0000">{{preferentialAttr}}</font>
                    </row>
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
               fullscreen @on-cancel="cancelModal">

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
                                    <super-upload ref="upload" v-model="upload.file" :action="upload.action"
                                                  mode="excel" :auto="false"
                                                  :simple="false" @on-success="handleUploadSuccess">
                                    </super-upload>
                                <#--<Upload ref="upload"-->
                                <#--type="drag"-->
                                <#--:action="upload.action"-->
                                <#--:format="upload.format"-->
                                <#--:show-upload-list="false"-->
                                <#--:before-upload="handleUpload"-->
                                <#--:on-success="handleUploadSuccess"-->
                                <#--:on-format-error="handleUploadFormatError">-->
                                <#--<div style="padding: 20px">-->
                                <#--<Icon type="ios-cloud-upload" size="52" color="#3399ff"></Icon>-->
                                <#--<p>点击或拖拽上传</p>-->
                                <#--</div>-->
                                <#--</Upload>-->
                                <#--<Tag v-if="upload.file !== null" type="dot" closable color="blue"-->
                                <#--@on-close="clearUpload">{{ upload.file.name }}-->
                                <#--</Tag>-->
                                </i-Col>
                                <i-Col span="12" offset="1">
                                    <h4>方式二：按条件导入</h4>

                                    <p style="margin-top: 10px">1、选择分类</p>
                                    <Cascader v-model="conditionImport.categoryId" :data="categoryList" change-on-select
                                              filterable transfer="true" trigger="hover"></Cascader>

                                    <p style="margin-top: 10px">2、选择供应商</p>
                                    <i-Select v-model="conditionImport.supplierId" filterable clearable transfer="true">
                                        <i-Option v-for="item in supplierList" :value="item.id" :key="item.id">{{item.name }}</i-Option>
                                    </i-Select>

                                    <p style="margin-top: 10px">3、选择买手</p>
                                    <i-Select v-model="conditionImport.buyerId" filterable clearable transfer="true">
                                        <i-Option v-for="item in buyerList" :value="item.id" :key="item.id">{{item.name}}</i-Option>
                                    </i-Select>

                                    <p style="margin-top: 10px">4、输入商品id，以逗号隔开</p>
                                    <i-input type="textarea" :autosize="{minRows: 2,maxRows: 5}"
                                             v-model="conditionImport.productIds">
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

            <div class="table-container-marketActivity"
                 style="position: absolute;top: 70px;bottom: 10px;left: 15px;right: 15px">
                <super-table container=".table-container-marketActivity" :columns="productTableColumns"
                             :data="productTableData"
                             :loading="productSearchLoading" draggable @on-end="dragUpdate"
                             handle=".dragButton"></super-table>
            </div>

            <div slot="footer">
                <Page class="text-center custom-table-page" show-total :total="productTableDataCount"
                      :current="productSearchForm.pageNum" :page-size="productSearchForm.pageSize"
                      @on-change="listProductByPage"></Page>
            </div>
        </modal>

        <modal v-model="childModal"
               :title="childModalTitle"
               :mask-closable="false"
               fullscreen>

            <i-Button type="primary" @click="addChild">
                新增子活动
            </i-Button>

            <div class="table-container-marketActivityChild"
                 style="position: absolute;top: 70px;bottom: 10px;left: 15px;right: 15px">
                <super-table container=".table-container-marketActivityChild" :columns="childTableColumns"
                             :data="childTableData"
                             :loading="childSearchLoading"></super-table>
            </div>

            <div slot="footer">
                <Page class="text-center custom-table-page" show-total :total="childTableDataCount"
                      :current="childSearchForm.pageNum"
                      @on-change="listChildByPage"></Page>
            </div>
        </modal>
    </div>
</template>

<script>
    var marketActivity = Vue.component('marketActivity', {
        template: '#marketActivity',
        data: function () {
            var vm = this;

            return {
                preferentialAttr : '',
                searchForm: {
                    label: null,
                    type: null,
                    status: null
                },
                supplierList: [],
                buyerList: [],
                categoryList: [],
                typeList: [{
                    id: 0,
                    name: '普通活动'
                }, {
                    id: 1,
                    name: '限时直降'
                }
//            , {
//                id: 2,
//                name: '限量直降'
//            }
                    , {
                        id: 3,
                        name: '比例折扣'
                    }
//            , {
//                id: 4,
//                name: '满减'
//            }
                ],
                statusList: [{
                    id: 0,
                    name: '不显示'
                }, {
                    id: 1,
                    name: '预热'
                }, {
                    id: 2,
                    name: '开卖'
                }, {
                    id: 3,
                    name: '结束'
                }],

                searchRule: {},

                tableData: [],
                tableDataCount: 0,
                tableColumns: [{
                    title: '活动id',
                    key: 'id',
                    width: 80,
                    align: 'center'
                }, {
                    title: '活动类型',
                    width: 100,
                    render: function (h, params) {
                        var item = utils.getItem(vm.typeList, 'id', params.row.type);
                        if (item) {
                            return h('div', item.name);
                        }

                        return;
                    }
                }, {
                    title: '活动名称',
                    key: 'label'
                }, {
                    title: '活动说明',
                    render: function (h, params) {
                        var showContent = params.row.showContent;

                        if (showContent) {
                            var obj = JSON.parse(showContent);
                            return h('div', obj.name);
                        }

                        return;
                    }
                }, {
                    title: '活动时间',
                    width: 170,
                    render: function (h, params) {

                        var startTime = params.row.startTime;
                        var endTime = params.row.endTime;

                        var str = '';
                        if (startTime) {
                            str += utils.dateFormat(startTime);
                        }
                        else {
                            return '永久';
                        }

                        if (endTime) {
                            str += ' 至 ' + utils.dateFormat(endTime);
                        }
                        else {
                            str += ' 至 永久';
                        }

                        return h('div', str);
                    }
                }, {
                    title: '活动状态',
                    width: 90,
                    render: function (h, params) {
                        var item = utils.getItem(vm.statusList, 'id', params.row.status);
                        if (item) {
                            return h('div', item.name);
                        }

                        return;
                    }
                }, {
                    title: '操作',
                    key: 'action',
                    width: 195,
                    render: function (h, params) {

                        if (!params.row.isLeaf) {
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
                                        vm.viewChild(params);
                                    }
                                }
                            }, '查看子活动');
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
                                        vm.modifyMarketActivity(params);
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
                                        vm.viewProducts(params);
                                    }
                                }
                            }, '查看商品'),
                            h('Button', {
                                props: {
                                    type: 'info',
                                    size: 'small'
                                },
                                on: {
                                    click: function () {
                                        vm.exportOrder(params);
                                    }
                                }
                            }, '导出')
                        ]);
                    }
                }],
                searchLoading: false,

                modal: false,
                modalTitle: '添加活动',
                modalLoading: false,
                formModal: {
                    parentId: null,
                    label: null,
                    type: null,
                    status: 0,
                    timeRange: null,
                    url: null,
                    discount: 10,
                    isDiscountType: false,
                    fill: null,
                    subtract: null,
                    isFillType: false,
                    labelName: null,
                    name: null,
                    labelTextColor: '#FFFFFF',
                    labelBackgroundColor: '#FF4040',
                    textColor: '#C6AE70',
                    backgroundColor: '#FFF9E7',
                    skipPage: null,
                    showUrl: true,
                    isGift: true,
                    isGold: true,
                    membershipIds: []
                },
                ruleModal: {
                    label: [
                        {required: true, message: '请填写活动名称', trigger: 'blur'}
                    ],
                    status: [
                        {required: true, message: '请选择状态', trigger: 'blur', type: 'number'}
                    ],
                    type: [
                        {required: true, message: '请选择类型', trigger: 'blur', type: 'number'}
                    ]
                },

                productModal: false,
                productModalTitle: '活动商品',
                productModalId: null,

                productTableColumns: [{
                    type: 'expand',
                    width: 50,
                    render: function (h, params) {

                        var skuList = params.row.skuList;

                        return h('Table', {
                            props: {
                                columns: [{
                                    title: '商品skuId',
                                    key: 'id'
                                }, {
                                    title: 'sku属性',
                                    key: 'attrs',
                                    render: function (h, params) {
                                        var attrs = params.row.attrs;

                                        if (attrs) {
                                            var array = [];

                                            attrs = JSON.parse(attrs);

                                            attrs.forEach(function (t) {
                                                array.push(t.label + ' : ' + t.value);
                                            });

                                            return h('div', array.join(' ; '));
                                        }

                                        return;

                                    }
                                }, {
                                    title: '成本价',
                                    key: 'costPrice'
                                }, {
                                    title: '售价',
                                    key: 'price'
                                }, {
                                    title: '活动价',
                                    key: 'activePrice',
                                    render: function (h, params) {

                                        if (vm.productType == 1 || vm.productType == 2) {

                                            return h('InputNumber', {
                                                props: {
                                                    value: params.row.activePrice,
                                                    min: 0
                                                },
                                                on: {
                                                    'on-change': function (value) {
                                                        params.row.activePrice = value;

                                                    },
                                                    'on-blur': function () {
                                                        skuList[params.index].activePrice = params.row.activePrice
                                                    }
                                                }
                                            });

                                        }

                                        return h('div', params.row.activePrice);

                                    }
                                }, {
                                    title: '库存',
                                    key: 'stock'
                                }],
                                data: params.row.skuList,
                                size: 'small'
                            }
                        });
                    }
                }, {
                    title: '商品id',
                    key: 'pid',
                    width: 80,
                    align: 'center'
                }, {
                    title: '商品名称',
                    key: 'title'
                }, {
                    title: '排序',
                    key: 'sort',
                    width: 90
                }, {
                    title: '总库存',
                    key: 'totalStock',
                    width: 90
                }, {
                    title: '限量',
                    key: 'totalLimit',
                    width: 100,
                    render: function (h, params) {
                        return h('InputNumber', {
                            props: {
                                value: params.row.totalLimit,
                                min: 0
                            },
                            on: {
                                'on-change': function (value) {
                                    params.row.totalLimit = value;
                                }
                            }
                        });
                    }
                }, {
                    title: '个人限购',
                    key: 'limited',
                    width: 100,
                    render: function (h, params) {
                        return h('InputNumber', {
                            props: {
                                value: params.row.limited,
                                min: 0
                            },
                            on: {
                                'on-change': function (value) {
                                    params.row.limited = value;
                                }
                            }
                        });
                    }
                }, {
                    title: '状态',
                    width: 90,
                    render: function (h, params) {
                        var item = utils.getItem(vm.statusList, 'id', params.row.status);
                        if (item) {
                            return h('div', item.name);
                        }

                        return;
                    }
                }, {
                    title: '操作',
                    width: 190,
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
                                        vm.modifyProduct(params);
                                    }
                                }
                            }, '提交更改'),
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
                                    },
                                    style: {
                                        marginRight: '5px'
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
                }],
                productTableData: [],
                productSearchLoading: false,
                productTableDataCount: 0,
                productType: 0,
                productSearchForm: {
                    pid: null,
                    title: null,
                    pageSize: 20
                },
                upload: {
                    action: '${contextPath}/marketActivityProduct/upload',
                    file: null
                },
                conditionImport: {
                    categoryId: [],
                    supplierId: null,
                    buyerId: null,
                    productIds: null
                },

                childModal: false,
                childModalTitle: '子活动',
                jumpChild: false,
                childTableColumns: [{
                    title: '活动id',
                    key: 'id',
                    width: 80,
                    align: 'center'
                }, {
                    title: '活动名称',
                    key: 'label'
                }, {
                    title: '活动说明',
                    render: function (h, params) {
                        var showContent = params.row.showContent;

                        if (showContent) {
                            var obj = JSON.parse(showContent);
                            return h('div', obj.name);
                        }

                        return;
                    }
                }, {
                    title: '活动时间',
                    width: 170,
                    render: function (h, params) {

                        var startTime = params.row.startTime;
                        var endTime = params.row.endTime;

                        var str = '';
                        if (startTime) {
                            str += utils.dateFormat(startTime);
                        }
                        else {
                            return '永久';
                        }

                        if (endTime) {
                            str += ' 至 ' + utils.dateFormat(endTime);
                        }
                        else {
                            str += ' 至 永久';
                        }

                        return h('div', str);
                    }
                }, {
                    title: '活动状态',
                    width: 90,
                    render: function (h, params) {
                        var item = utils.getItem(vm.statusList, 'id', params.row.status);
                        if (item) {
                            return h('div', item.name);
                        }

                        return;
                    }
                }, {
                    title: '操作',
                    key: 'action',
                    width: 195,
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
                                        vm.modifyMarketActivity(params);
                                        vm.childModal = false;
                                        vm.jumpChild = true;
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
                                        vm.viewProducts(params);
                                        vm.childModal = false;
                                        vm.jumpChild = true;
                                    }
                                }
                            }, '查看商品'),
                            h('Button', {
                                props: {
                                    type: 'info',
                                    size: 'small'
                                },
                                on: {
                                    click: function () {
                                        vm.exportOrder(params);
                                    }
                                }
                            }, '导出')
                        ]);
                    }
                }],
                childTableData: [],
                childSearchLoading: false,
                childTableDataCount: 0,
                childSearchForm: {}
            }
        },
        mounted: function () {
            this.init();
        },
        methods: {
            init: function () {
                with (this) {

                    utils.get('${contextPath}/supplier/listAll', {}, function (result) {
                        if (result.success) {
                            supplierList = result.data;
                        }
                    });

                    utils.get('${contextPath}/buyer/listAll', {}, function (result) {
                        if (result.success) {
                            buyerList = result.data;
                        }
                    });

                    utils.get('${contextPath}/category/listTree', {}, function (result) {
                        if (result.success) {
                            categoryList = result.data;
                        }
                    });

                    listByPage(1);
                }
            },
            listByPage: function (pageNum) {
                with (this) {

                    if (pageNum) {
                        searchForm.pageNum = pageNum;
                    }

                    utils.get('${contextPath}/marketActivity/listByPage', searchForm, function (result) {
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

                            var data = {
                                id: formModal.id,
                                type: formModal.type,
                                status: formModal.status,
                                label: formModal.label,
                                parentId: formModal.parentId,
                                isGift: formModal.isGift,
                                isGold: formModal.isGold,
                                membershipIds: formModal.membershipIds
                            };
                            data.membershipIds = formModal.membershipIds.join(',');

                            if (formModal.url != null && formModal.url != '') {
                                data.url = formModal.url;
                            }

                            if (formModal.timeRange) {
                                var startTime = formModal.timeRange[0];
                                var endTime = formModal.timeRange[1];

                                if (startTime != null && endTime != null) {
                                    data.startTime = Date.parse(startTime);
                                    data.endTime = Date.parse(endTime);
                                }

                            }

                            if (data.type == 3) {

                                if (formModal.discount == null || formModal.discount == '') {
                                    $Message.error('请填写优惠力度');
                                    modalLoading = false;
                                    return;
                                }

                                var skuDiscount = {
                                    type: 3,
                                    discout: formModal.discount / 10
                                };

                                data.skuDiscount = JSON.stringify(skuDiscount);
                            }

                            if (data.type == 4) {

                            }

                            var showContent = null;

                            if (formModal.name) {
                                showContent = {};

                                showContent.name = formModal.name;
                                //showContent.textColor = '#FF' + formModal.textColor.substring(1, 7);
                                //showContent.backgroundColor = '#FF' + formModal.backgroundColor.substring(1, 7);

                                showContent.textColor = formModal.textColor;
                                showContent.backgroundColor = formModal.backgroundColor;
                            }

                            if (formModal.labelName) {
                                if (!showContent) {
                                    showContent = {};
                                }

                                showContent.labelName = formModal.labelName;
                                //showContent.labelTextColor = '#FF' + formModal.labelTextColor.substring(1, 7);
                                //showContent.labelBackgroundColor = '#FF' + formModal.labelBackgroundColor.substring(1, 7);

                                showContent.labelTextColor = formModal.labelTextColor;
                                showContent.labelBackgroundColor = formModal.labelBackgroundColor;
                            }

                            if (showContent) {
                                if (formModal.skipPage) {
                                    showContent.skipPage = formModal.skipPage;
                                }

                                if (data.url) {
                                    showContent.skipPage = {
                                        type: 2,
                                        nativeType: 0,
                                        url: data.url,
                                        param: {}
                                    };
                                }

                                if (showContent.skipPage == null) {
                                    showContent.skipPage = {
                                        type: 0,
                                        nativeType: 0,
                                        url: null,
                                        param: {}
                                    };
                                }

                                data.showContent = JSON.stringify(showContent);
                            }

                            utils.postJson('${contextPath}/marketActivity/modify', data, function (result) {
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
            viewProducts: function (params) {
                with (this) {
                    var currentRow = params.row;

                    productModal = true;

                    productModalTitle = currentRow.label + '的活动商品列表';

                    productModalId = currentRow.id;

                    productType = currentRow.type;

                    productSearchForm = {
                        pid: null,
                        title: null,
                        pageSize: 20
                    };

                    listProductByPage(1);
                }
            },
            formTypeChange: function (index) {
                with (this) {
                    formModal.isDiscountType = false;
                    formModal.isFillType = false;
                    if (index == 3) {
                        formModal.isDiscountType = true;
                    }
                    else if (index == 4) {
                        formModal.isFillType = true;
                    }
                }
            },
            modifyMarketActivity: function (params) {

                with (this) {
                    formModal = {
                        parentId: null,
                        label: null,
                        type: null,
                        status: 0,
                        timeRange: null,
                        url: null,
                        discount: 10,
                        isDiscountType: false,
                        fill: null,
                        subtract: null,
                        isFillType: false,
                        labelName: null,
                        name: null,
                        labelTextColor: '#FFFFFF',
                        labelBackgroundColor: '#FF4040',
                        textColor: '#C6AE70',
                        backgroundColor: '#FFF9E7',
                        skipPage: null,
                        showUrl: true,
                        isGift: true,
                        isGold: true,
                        membershipIds: []
                    };

                    if (params == -1) {
                        modalTitle = '添加活动';
                    }
                    else {

                        var currentRow = params.row;

                        modalTitle = '修改活动';
                        formModal.id = currentRow.id;
                        formModal.parentId = currentRow.parentId;
                        formModal.label = currentRow.label;
                        formModal.type = currentRow.type;
                        formModal.status = currentRow.status;
                        formModal.url = currentRow.url;
                        formModal.isGift = currentRow.isGift;
                        formModal.isGold = currentRow.isGold;
                        if (utils.isNotEmpty(currentRow.membershipIds)){
                            formModal.membershipIds = currentRow.membershipIds.split(",");
                        }
                        if (currentRow.skuDiscount) {
                            var skuDiscount = JSON.parse(currentRow.skuDiscount);

                            if (formModal.type == 3) {
                                formModal.discount = Number(skuDiscount.discout) * 10;
                                formModal.isDiscountType = true;
                            }

                            if (formModal.type == 4) {
                                formModal.isFillType = true;
                            }
                        }

                        if (currentRow.showContent) {
                            var showContent = JSON.parse(currentRow.showContent);

                            formModal.labelName = showContent.labelName;
                            formModal.name = showContent.name;

                            if (showContent.labelTextColor) {
                                formModal.labelTextColor = showContent.labelTextColor;
                            }

                            if (showContent.labelBackgroundColor) {
                                formModal.labelBackgroundColor = showContent.labelBackgroundColor;
                            }

                            if (showContent.textColor) {
                                formModal.textColor = showContent.textColor;
                            }

                            if (showContent.backgroundColor) {
                                formModal.backgroundColor = showContent.backgroundColor;
                            }
//                            if (showContent.labelTextColor) {
//                                formModal.labelTextColor = '#' + showContent.labelTextColor.substring(3, 9);
//                            }
//                            if (showContent.labelBackgroundColor) {
//                                formModal.labelBackgroundColor = '#' + showContent.labelBackgroundColor.substring(3, 9);
//                            }
//                            if (showContent.textColor) {
//                                formModal.textColor = '#' + showContent.textColor.substring(3, 9);
//                            }
//                            if (showContent.backgroundColor) {
//                                formModal.backgroundColor = '#' + showContent.backgroundColor.substring(3, 9);
//                            }

                            if (showContent.skipPage) {
                                formModal.skipPage = showContent.skipPage;
                            }
                        }

                        if (currentRow.startTime && currentRow.endTime) {
                            formModal.timeRange = [new Date(currentRow.startTime), new Date(currentRow.endTime)];
                        }

                        if (currentRow.id == 1 || currentRow.id == 3) {
                            formModal.showUrl = false;
                        }
                    }
                    showPreferentialAttr();
                    modal = true;
                }

            },
            listProductByPage: function (pageNum) {
                with (this) {

                    if (pageNum) {
                        productSearchForm.pageNum = pageNum;
                    }

                    productSearchForm.activeId = productModalId;

                    utils.get('${contextPath}/marketActivityProduct/listByPage', productSearchForm, function (result) {
                        if (result.success) {
                            productTableData = result.data.list;
                            productTableDataCount = result.data.total;
                        }
                        else {
                            $Message.error(result.msg);
                        }
                    }, $data, 'productSearchLoading');
                }
            },
            modifyProduct: function (params) {
                with (this) {
                    var data = {
                        id: params.row.id,
                        limited: params.row.limited,
                        totalLimit: params.row.totalLimit
                    };

                    if (productType == 1 || productType == 2) {
                        var skuList = params.row.skuList;

                        var list = [];

                        var size = false;
                        for (var i = 0; i < skuList.length; i++) {
                            if (skuList[i].activePrice) {
                                var item = {
                                    sid: skuList[i].id,
                                    price: skuList[i].activePrice
                                };

                                list.push(item);

                                size = true;
                            }
                        }

                        if (size) {
                            var obj = {
                                type: productType,
                                skuList: list
                            };

                            data.skuDiscount = JSON.stringify(obj);
                        }

                    }
                    else {
                        data.skuDiscount = params.row.skuDiscount
                    }

                    utils.postJson('${contextPath}/marketActivityProduct/modify', data, function (result) {
                        if (result.success) {
                            $Message.success('操作成功');
                            listProductByPage();
                        }
                        else {
                            $Message.error(result.msg);
                        }
                    }, $data, 'productSearchLoading')

                }
            },
            popperShow: function () {
                with (this) {
                    upload.file = null;
                    conditionImport.categoryId = [];
                    conditionImport.productIds = null;
                }
            },
            handleUploadSuccess: function (response, file, fileList) {
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
                            activeId: productModalId
                        });
                    }
                    else {
                        var categoryId = null;

                        if (conditionImport.categoryId.length != 0) {
                            categoryId = conditionImport.categoryId[conditionImport.categoryId.length - 1];
                        }

                        var supplierId = null;
                        var buyerId = null;
                        var productIds = null;

                        if (utils.isNotEmpty(conditionImport.supplierId)) {
                            supplierId = conditionImport.supplierId;
                        }

                        if (utils.isNotEmpty(conditionImport.buyerId)) {
                            buyerId = conditionImport.buyerId;
                        }

                        if (utils.isNotEmpty(conditionImport.productIds)) {
                            productIds = conditionImport.productIds;
                        }

                        if (categoryId == null && supplierId == null && buyerId == null && productIds == null) {
                            $Message.error('请选择一种导入方式');
                            return;
                        }

                        utils.post(upload.action, {
                            categoryId: categoryId,
                            supplierId: supplierId,
                            buyerId: buyerId,
                            productIds: productIds,
                            activeId: productModalId
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
            deleteProduct: function (params) {
                with (this) {
                    utils.post('${contextPath}/marketActivityProduct/delete', {
                        id: params.row.id,
                        activeId: params.row.activeId
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
            exportOrder: function (params) {
                with (this) {
                    $Modal.confirm({
                        title: '提示',
                        content: '<div>确认导出 [ ' + params.row.label + ' ] 的订单数据？</div>',
                        onOk: function () {
                            var data = {
                                method: 'post',
                                action: '${contextPath}/order/export?activeId=' + params.row.id
                            };
                            utils.download(data, $data, 'searchLoading');
                        }
                    });
                }
            },
            addChild: function (params) {
                with (this) {
                    formModal = {
                        parentId: childSearchForm.parentId,
                        label: null,
                        type: childSearchForm.parentType,
                        status: 0,
                        timeRange: null,
                        url: null,
                        discount: 10,
                        isDiscountType: false,
                        fill: null,
                        subtract: null,
                        isFillType: false,
                        labelName: null,
                        name: null,
                        labelTextColor: '#FFFFFF',
                        labelBackgroundColor: '#FF4040',
                        textColor: '#C6AE70',
                        backgroundColor: '#FFF9E7',
                        skipPage: null,
                        showUrl: true,
                        membershipIds: []
                    };

                    modalTitle = '为 ' + childSearchForm.parentLabel + ' 新增子活动';

                    childModal = false;
                    jumpChild = true;

                    modal = true;
                }
            },
            viewChild: function (params) {
                with (this) {
                    childSearchForm.parentId = params.row.id;
                    childSearchForm.parentType = params.row.type;
                    childSearchForm.parentLabel = params.row.label;
                    childModalTitle = params.row.label + ' 的子活动列表';

                    childModal = true;

                    listChildByPage(1);
                }
            },
            listChildByPage: function (pageNum) {
                with (this) {

                    if (pageNum) {
                        childSearchForm.pageNum = pageNum;
                    }

                    utils.get('${contextPath}/marketActivity/listChildByPage', childSearchForm, function (result) {
                        if (result.success) {
                            childTableData = result.data.list;
                            childTableDataCount = result.data.total;
                        }
                        else {
                            $Message.error(result.msg);
                        }
                    }, $data, 'childSearchLoading');
                }
            },
            cancelModal: function () {
                with (this) {
                    if (jumpChild) {
                        childModal = true;
                        jumpChild = false;
                    }
                }
            },
            dragUpdate: function (e) {
                with (this) {
                    if (e.from != e.to) {
                        var data = {
                            ids: [],
                            id: e.row.id,
                            sort: e.to,
                            activeId: productModalId
                        };

                        if (e.from > e.to) {
                            //上移,from 和 to 之间的元素加 1
                            var list = productTableData.slice(e.to + 1, e.from + 1);

                            data.type = 1;

                            list.forEach(function (t) {
                                data.ids.push(t.id);
                            });
                        }
                        else {
                            //下移,from 和 to 之间的元素减 1
                            var list = productTableData.slice(e.from, e.to);

                            data.type = -1;

                            list.forEach(function (t) {
                                data.ids.push(t.id);
                            });
                        }

                        data.ids = data.ids.join(',');


                        utils.post('${contextPath}/marketActivityProduct/sort', data, function (result) {
                            if (result.success) {
                                $Message.success('排序成功');
                                listProductByPage();
                            }
                            else {
                                $Message.error(result.msg);
                            }
                        }, $data, 'productSearchLoading')

                    }
                }
            },
            showPreferentialAttr: function () {
                with (this) {
                    var text = '';
                    var ids = formModal.membershipIds.sort(function(a,b){
                        if(a<b){
                            return -1;
                        }
                        if(a>b){
                            return 1;
                        }
                        return 0;
                    });

                    ids.forEach(function (value) {
                        if (value == 0) {
                            text = text + '[优先],';
                        }
                        if (value == 1) {
                            text = text + '[至尊],';
                        }
                        if (value == 2) {
                            text = text + '[总裁],';
                        }
                        if (value == 3) {
                            text = text + '[总统],';
                        }
                    });
                    if(utils.isNotEmpty(text)) {
                        text = text + '不能参加该活动优惠'
                    }
                    preferentialAttr = text;
                }
            }
        }
    });

</script>