<template id="product">
    <div class="auto-height">
        <Layout class="auto-height">
            <i-Header class="layout-header-content color-white">
                <i-form class="auto-height" ref="searchForm" :model="searchForm" :rules="searchRule" inline
                        @submit.native.prevent>

                    <form-item>
                        <i-input clearable type="text" v-model="searchForm.search" placeholder="搜索商品id、型号、标题"
                                 @on-enter="listByPage(1)" style="width: 160px">
                        </i-input>
                    </form-item>

                    <form-item>
                        <Cascader v-model="searchForm.categoryIds" :data="store.state.categoryList"
                                  filterable trigger="hover" placeholder="请选择类目"></Cascader>
                    </form-item>

                    <form-item>
                        <i-Select v-model="searchForm.supplierId" filterable clearable
                                  placeholder="请选择供应商"
                                  style="width: 120px">
                            <i-Option v-for="item in store.state.supplierList" :value="item.id" :key="item.id">{{item.name }}</i-Option>
                        </i-Select>
                    </form-item>

                    <form-item>
                        <i-Select v-model="searchForm.buyerId" filterable clearable placeholder="请选择买手"
                                  style="width: 100px">
                            <i-Option v-for="item in store.state.buyerList" :value="item.id" :key="item.id">{{item.name}}</i-Option>
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
                        <i-Button icon="md-add" @click="modifyProduct(-1)">新增</i-Button>
                    </form-item>

                    <form-item>
                        <Poptip placement="left">
                            <i-Button icon="ios-briefcase">工具箱</i-Button>
                            <div slot="content" style="padding: 10px">
                            <#--<i-Button icon="ios-cloud-upload">从excel导入商品</i-Button>-->
                            <#--<i-Button icon="ios-cloud-upload">从excel导入商品sku</i-Button>-->
                                <i-Button icon="ios-cloud-upload" @click="showThirdModal">第三方接口导入</i-Button>
                                <i-Button icon="ios-cloud-upload" @click="showMatterModal">从素材包导入</i-Button>
                                <i-Button icon="ios-cloud-download" @click="exportProduct">导出商品</i-Button>
                            </div>
                        </Poptip>
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
               fullscreen @on-cancel="cancelModal">
            <i-form ref="formModal" :model="formModal" :rules="ruleModal" label-width="80">

                <Card style="margin-bottom: 20px">
                    <p slot="title">
                        <Icon type="ios-list"></Icon>
                        基本信息
                    </p>

                    <row>
                        <i-col span="8">
                            <form-item prop="title" label="标题">
                                <i-input v-model="formModal.title" type="text" placeholder="不超过100个字">
                                </i-input>
                            </form-item>
                        </i-col>

                        <i-col span="8">
                            <form-item prop="subtitle" label="副标题">
                                <i-input v-model="formModal.subtitle" type="text" placeholder="不超过100个字">
                                </i-input>
                            </form-item>
                        </i-col>

                        <i-col span="8">
                            <form-item prop="tag" label="型号">
                                <i-input v-model="formModal.tag" type="text" placeholder="不超过100个字">
                                </i-input>
                            </form-item>
                        </i-col>
                    </row>

                    <row>
                        <i-col span="8">
                            <form-item prop="categoryIds" label="前台分类">
                                <Cascader v-model="formModal.categoryIds" :data="store.state.categoryList"
                                          filterable trigger="hover" placeholder="请选择前台分类"
                                          @on-change="cidChange"></Cascader>
                            </form-item>
                        </i-col>

                        <i-col span="8">
                            <form-item prop="buyerId" label="买手">
                                <i-Select v-model="formModal.buyerId" filterable placeholder="请选择买手"
                                          class="auto-width">
                                    <i-Option v-for="item in store.state.buyerList" :value="item.id" :key="item.id">{{item.name }}</i-Option>
                                </i-Select>
                            </form-item>
                        </i-col>

                        <i-col span="8">
                            <form-item prop="expressIds" label="快递">
                                <i-Select v-model="formModal.expressIds" multiple placeholder="请选择快递"
                                          class="auto-width">
                                    <i-Option v-for="item in store.state.expressList" :value="item.id">{{ item.name }}</i-Option>
                                </i-Select>
                            </form-item>
                        </i-col>
                    </row>

                    <row>
                        <i-col span="12">
                            <form-item label="后台分类">
                                <Cascader v-model="formModal.scid" :data="store.state.systemCategoryList"
                                          filterable trigger="hover" placeholder="请选择后台分类"
                                          @on-change="scidChange"></Cascader>
                            </form-item>
                        </i-col>
                        <i-col span="6">
                            <form-item label="标签">
                                <i-Input v-model="formModal.labels" placeholder="请输入商品标签"></i-Input>
                            </form-item>
                        </i-col>

                        <i-col span="3">
                            <form-item label="特权号">
                                <i-Input v-model="formModal.privilegeId" placeholder="请输入特权号id"></i-Input>
                            </form-item>
                        </i-col>

                        <i-col span="3">
                            <form-item label="生产周期">
                                <i-Input v-model="formModal.cycle" placeholder="请输入生产周期"></i-Input>
                            </form-item>
                        </i-col>
                    </row>

                    <row>
                        <i-col span="8">
                            <form-item prop="supplierId" label="供应商">
                                <i-Select v-model="formModal.supplierId" filterable placeholder="请选择供应商"
                                          class="auto-width" @on-change="supplierChange">
                                    <i-Option v-for="item in store.state.supplierList" :value="item.id" :key="item.id">{{ item.name }}</i-Option>
                                </i-Select>
                            </form-item>
                        </i-col>

                        <i-col span="8">
                            <form-item label="合作方式">
                                <Radio-Group v-model="formModal.operatorType">
                                    <Radio v-for="item in operatorTypeList" :label="item.value">{{item.label}}</Radio>
                                </Radio-Group>
                            </form-item>
                        </i-col>

                        <i-col span="8">
                            <form-item prop="discount" label="金币比索">
                                <Input-Number v-model="formModal.discount" :min="0"></Input-Number>
                            </form-item>
                        </i-col>
                    </row>

                    <row>
                        <i-col span="8">
                            <form-item label="退货地址">
                                <i-Input v-model="formModal.addressInfo" placeholder="请输入退货地址"></i-Input>
                            </form-item>
                        </i-col>

                        <i-col span="8">
                            <form-item label="退货联系人">
                                <i-Input v-model="formModal.userInfo" placeholder="请输入联系人"></i-Input>
                            </form-item>
                        </i-col>

                        <i-col span="8">
                            <form-item label="退货手机号">
                                <i-Input v-model="formModal.phoneInfo" placeholder="请输入手机号码"></i-Input>
                            </form-item>
                        </i-col>
                    </row>

                    <row>
                        <i-col span="6">
                            <form-item prop="releaseTime" label="开售时间">
                                <Date-Picker v-model="formModal.releaseTime" type="datetime" placeholder="请选择开售时间"
                                             class="auto-width" @on-change="dateChange"></Date-Picker>
                            </form-item>
                        </i-col>

                        <i-col span="6">
                            <form-item label="结束时间">
                                <Date-Picker v-model="formModal.closeTime" type="datetime" placeholder="请选择结束时间"
                                             class="auto-width"></Date-Picker>
                            </form-item>
                        </i-col>

                        <i-col span="6">
                            <form-item prop="shelfTime" label="上架时间">
                                <Date-Picker v-model="formModal.shelfTime" type="datetime" placeholder="请选择上架时间"
                                             class="auto-width"></Date-Picker>
                            </form-item>
                        </i-col>

                        <i-col span="6">
                            <form-item label="个人限购">
                                <Input-Number v-model="formModal.limited" :min="-1"></Input-Number>
                            </form-item>
                        </i-col>
                    </row>

                    <row>
                        <i-col span="12">
                            <form-item label="售后说明">
                                <text-editor v-model="formModal.instruction"></text-editor>
                            </form-item>
                        </i-col>

                        <i-col span="12">
                            <form-item label="商品描述">
                                <text-editor v-model="formModal.describeText"></text-editor>
                            </form-item>
                        </i-col>

                    </row>

                    <form-item label="商品属性">
                        <Collapse accordion value="specialService">
                            <Panel v-for="item in store.state.productDicList" :name="item.name">
                                {{item.label}}
                                <div slot="content" v-if="item.type==0">
                                    <Checkbox-Group v-model="upload.checks">
                                        <Checkbox v-for="child in item.children" :label="child.id">{{child.label}}
                                        </Checkbox>
                                    </Checkbox-Group>
                                </div>
                                <div slot="content" v-else>
                                    <i-Select v-model="upload.selects" multiple filterable placeholder="请选择"
                                              class="auto-width" @on-change="productDicChange">
                                        <i-Option v-for="child in item.children" :value="child.id">{{ child.label }}</i-Option>
                                    </i-Select>

                                    <div v-for="dic in productDicInitList" v-if="dic.parentId==item.id"
                                         style="margin-top: 10px">
                                        <i-input v-model="dic.value" type="text">
                                            <span slot="prepend">{{dic.label}}</span>
                                        </i-input>
                                    </div>
                                </div>
                            </Panel>
                        </Collapse>
                    </form-item>
                    <form-item label="销售渠道">
                        <Checkbox-Group v-model="formModal.platformFlagList">
                            <Checkbox v-for="child in platformFlagElement" :label="child.id">{{child.comment}}
                            </Checkbox>
                        </Checkbox-Group>
                    </form-item>

                </Card>

                <Card style="margin-bottom: 20px">
                    <p slot="title">
                        <Icon type="images"></Icon>
                        图片信息
                    </p>

                    <form-item prop="img" label="列表图(690*440)">
                        <row>
                            <i-col span="4">
                                <Upload :action="upload.productAction"
                                        :format="upload.format"
                                        :show-upload-list="false"
                                        :on-success="handleUploadSuccess"
                                        :on-format-error="handleUploadFormatError">
                                    <i-Button icon="ios-cloud-upload-outline">上传图片</i-Button>
                                </Upload>
                            </i-col>
                            <i-col span="4" offset="1" v-if="upload.img1 != null">
                                图一 (400*256)
                                <img :src="upload.img1" height="58" width="58">
                            </i-col>
                            <i-col span="4" offset="1" v-if="upload.img2 != null">
                                图二 (690*440)
                                <img :src="upload.img2" height="58" width="58">
                            </i-col>
                            <i-col span="4" offset="1" v-if="upload.img3 != null">
                                图三 (690*440)
                                <img :src="upload.img3" height="58" width="58">
                            </i-col>
                        </row>
                    </form-item>

                    <form-item label="轮播图">
                        <super-upload v-model="formModal.images" :action="upload.action" mode="image" keyword="url"
                                      size="58" multiple draggable>
                        </super-upload>
                    </form-item>

                    <form-item label="大图">
                        <super-upload v-model="formModal.bigImg" :action="upload.action" mode="image" keyword="url"
                                      size="58">
                        </super-upload>
                    </form-item>

                    <form-item label="全图">
                        <super-upload v-model="formModal.detailImgMode" :action="upload.action" mode="image"
                                      keyword="url"
                                      size="58">
                        </super-upload>
                    </form-item>

                    <form-item label="视频(MP4<10M)">
                        <super-upload v-model="formModal.videos" :action="upload.action" mode="video" keyword="url"
                                      :maxsize="10240">
                        </super-upload>
                    </form-item>

                    <form-item label="详情图">
                        <super-upload v-model="formModal.details" :action="upload.action" mode="image"
                                      :simple="false" multiple draggable>
                        </super-upload>
                    </form-item>
                </Card>

                <Card>
                    <p slot="title">
                        <Icon type="podium"></Icon>
                        库存信息
                    </p>

                    <form-item label="商品sku图">
                        <super-upload v-model="formModal.skuImgs" :action="upload.action" mode="image" keyword="url"
                                      :simple="false" multiple @on-success="handleUploadSkuImgsSuccess">
                        </super-upload>
                    </form-item>

                    <form-item label="sku属性" v-if="modifyStatus==1">

                        <row>
                            <i-col span="3">
                                <i-Select filterable clearable placeholder="请选择sku属性" @on-change="skuAttrChange"
                                          class="auto-width">
                                    <i-Option v-for="item in store.state.skuAttrList" :value="item.label">{{ item.label}}</i-Option>
                                </i-Select>
                            </i-col>
                            <i-col span="21">
                                <i-input search enter-button="添加" placeholder="直接输入属性,可回车添加" @on-search="skuAttrChange">
                                </i-input>
                            </i-col>
                        </row>

                        <row v-for="item in skuAttrInitList">
                            <i-col span="3" style="padding-top: 10px">
                                <Tag type="dot" closable color="primary"
                                     @on-close="handleSkuAttrRemove(item)">{{item.label}}
                                </Tag>
                            </i-col>

                            <i-col span="21">
                                <row>
                                    <i-col v-for="check in item.list" span="4"
                                           style="padding-top: 10px;padding-left: 10px">
                                        <row>
                                            <i-col span="6">
                                                <Checkbox v-model="check.checked">
                                                </Checkbox>
                                            </i-col>
                                            <i-col span="18">
                                                <i-input v-model="check.value" type="text">
                                                </i-input>
                                            </i-col>
                                        </row>
                                    </i-col>
                                </row>
                                <Divider dashed></Divider>
                            </i-col>
                        </row>

                        <i-button type="success" @click="createSkuTable()" long :loading="modalLoading"
                                  style="margin-top: 10px">
                            生成sku表格
                        </i-button>
                    </form-item>

                    <form-item label="sku表格" class="sku-container" style="height: 350px">
                        <super-Table :columns="skuTableColumns" :data="skuTableData"
                                     :loading="modalLoading" container=".sku-container" editable></super-Table>
                    </form-item>
                </Card>
            </i-form>

            <div slot="footer">
                <i-button type="primary" @click="asyncOK('formModal')" long :loading="modalLoading"
                          v-if="cache ==null || modifyStatus!=1">
                    保存商品
                </i-button>

                <row v-if="cache !=null && modifyStatus==1">
                    <i-col span="11">
                        <i-button type="primary" @click="asyncOK('formModal')" long :loading="modalLoading">
                            保存商品
                        </i-button>
                    </i-col>
                    <i-col span="11" offset="2">
                        <i-button type="primary" long @click="loadCache" :loading="modalLoading">
                            {{cacheTitle}}
                        </i-button>
                    </i-col>
                </row>
            </div>
        </modal>


        <modal v-model="thirdModal"
               title="第三方商品管理"
               :mask-closable="false"
               fullscreen>
            <i-form ref="thirdFormModal" :model="thirdFormModal" :rules="thirdRuleModal" label-width="80" inline>
                <form-item prop="appId" label="第三方平台" label-width="100">
                    <i-Select v-model="thirdFormModal.appId" style="width: 100px"
                              @on-change="thirdFormModalSelectChange">
                        <i-Option v-for="item in store.state.appList" :value="item.id">{{ item.label }}</i-Option>
                    </i-Select>
                </form-item>
                <form-item label="第三方商品id" label-width="100">
                    <i-input v-model="thirdFormModal.keyId" type="text" clearable>
                    </i-input>
                </form-item>
                <form-item label="是否同步">
                    <i-Select v-model="thirdFormModal.status" style="width: 100px" clearable>
                        <i-Option value="1">
                            是
                        </i-Option>
                        <i-Option value="0">
                            否
                        </i-Option>
                    </i-Select>
                </form-item>

                <form-item label-width="10">
                    <i-Button type="primary" shape="circle" icon="ios-search" @click="listThirdByPage(1)"
                              :loading="modalLoading">
                        <span v-if="!modalLoading">查询</span>
                        <span v-else>查询中...</span>
                    </i-Button>
                </form-item>

                <form-item label-width="10">
                    <Poptip placement="bottom" @on-popper-show="popperShow">
                        <i-Button type="success" shape="circle" icon="ios-cloud-download-outline">
                            通过第三方id同步商品
                        </i-Button>
                        <div slot="content" style="width: 400px;">
                            <p style="margin-top: 10px">输入商品id，以逗号隔开</p>
                            <i-input type="textarea" :autosize="{minRows: 2,maxRows: 5}"
                                     v-model="conditionImport.productIds">
                            </i-input>

                            <br>
                            <row>
                                <i-Col span="24" class="text-center" style="margin-top: 20px">
                                    <i-Button type="warning" shape="circle" icon="md-checkmark"
                                              @click="syncThirdProduct"
                                              :loading="modalLoading">
                                        <span v-if="!modalLoading">确认同步</span>
                                        <span v-else>请稍候...</span>
                                    </i-Button>
                                </i-Col>
                            </row>
                        </div>
                    </Poptip>
                </form-item>
            </i-form>

            <div class="table-container" style="position: absolute;top: 70px;bottom: 10px;left: 15px;right: 15px">
                <row>
                    <i-col span="5">
                        <super-Table :columns="thirdIdTableColumns" :data="thirdIdTableData"
                                     :loading="modalLoading" container=".table-container"></super-Table>
                    </i-col>
                    <i-col span="18" offset="1">
                        <super-Table :columns="thirdTableColumns" :data="thirdTableData"
                                     :loading="modalLoading" container=".table-container"></super-Table>

                    </i-col>
                </row>
            </div>

            <div slot="footer">
                <row>
                    <i-col span="5">
                        <Page simple class="text-center custom-table-page" :total="thirdIdTableDataCount"
                              @on-change="listThirdIdByPage"></Page>
                    </i-col>
                    <i-col span="18" offset="1">
                        <Page class="text-center custom-table-page" show-total :total="thirdTableDataCount"
                              :current="thirdFormModal.pageNum"
                              @on-change="listThirdByPage"></Page>
                    </i-col>
                </row>
            </div>
        </modal>

        <modal v-model="matterModal"
               title="从素材包导入"
               :mask-closable="false" @on-visible-change="cancelMatterModal">
            <Carousel v-model="matterModalForm.carouselValue"
                      dots="none"
                      radius-dot="false"
                      arrow="never" v-if="matterModal" style="max-height: 300px" class="auto-overflow">
                <Carousel-Item>
                    <h3 class="text-center">
                        素材包格式:
                        <br>
                        1:[主图]文件夹 名称可以是[主图]
                        <br>
                        2:[轮播图]文件夹 名称可以是[轮播图]
                        <br>
                        3:[详情图]文件夹 名称可以是[详情]、[详情图]、[切片]
                        <br>
                        4:[sku图]文件夹 名称可以是[sku]、[sku图]
                        <br>
                        5:[txt]文件 文件是txt文本格式,内容中要包含[主标题]、[副标题]
                    </h3>
                    <Divider>
                        <i-Button type="primary" shape="circle" @click="selectDirectory">
                            选择素材文件夹
                        </i-Button>
                    </Divider>

                    <input ref="fileDirectory" type='file' name="file" webkitdirectory hidden @change="directoryChange">

                    <h2 class="text-center">已选文件夹: {{matterModalForm.directory}}</h2>
                </Carousel-Item>
                <Carousel-Item>
                    <Upload ref="img"
                            :action="upload.productAction"
                            :on-success="handleUploadSuccess1" hidden>
                    </Upload>

                    <Upload ref="images"
                            :action="upload.action"
                            :on-success="handleUploadSuccess4" hidden>
                    </Upload>

                    <Upload ref="details"
                            :action="upload.action"
                            :on-success="handleUploadSuccess2" hidden>
                    </Upload>

                    <Upload ref="skuImgs"
                            :action="upload.action"
                            :on-success="handleUploadSuccess3" hidden>
                    </Upload>

                    <div v-if="matterModalForm.title != null">
                        <h3>商品信息</h3>
                        <h4>标题: {{matterModalForm.title}}</h4>
                        <h4>副标题: {{matterModalForm.subtitle}}</h4>
                    <#--<br>-->
                    <#--<h4>sku属性: {{matterModalForm.attr}}</h4>-->
                    <#--<h4 v-for="item in matterModalForm.sku">sku: {{item}}</h4>-->
                        <Divider>
                        </Divider>
                    </div>

                    <h3>主图</h3>
                    <row>
                        <i-col span="4" v-if="matterModalForm.img1 != null">
                            图一 (400*256)
                            <img :src="matterModalForm.img1" height="58" width="58">
                        </i-col>
                        <i-col span="4" offset="1" v-if="matterModalForm.img2 != null">
                            图二 (690*440)
                            <img :src="matterModalForm.img2" height="58" width="58">
                        </i-col>
                        <i-col span="4" offset="1" v-if="matterModalForm.img3 != null">
                            图三 (690*440)
                            <img :src="matterModalForm.img3" height="58" width="58">
                        </i-col>
                    </row>

                    <Divider>
                    </Divider>

                    <h3>轮播图</h3>
                    <row>
                        <i-col span="24">
                            <div style="display: inline-block;">
                                <div v-for="item in matterModalForm.images" style="display: inline-block;">
                                    <img :src="getImageUrl(item)" height="150" width="150">
                                </div>
                            </div>
                        </i-col>
                    </row>

                    <Divider>
                    </Divider>

                    <h3>详情图</h3>
                    <row>
                        <i-col span="24">
                            <div style="display: inline-block;">
                                <div v-for="item in matterModalForm.details" style="display: inline-block;">
                                    <img :src="getImageUrl(item)" height="150" width="150">
                                </div>
                            </div>
                        </i-col>
                    </row>

                    <Divider>
                    </Divider>

                    <h3>sku图</h3>
                    <row>
                        <i-col span="24">
                            <div style="display: inline-block;">
                                <div v-for="item in matterModalForm.skuImgs" style="display: inline-block;">
                                    <img :src="getImageUrl(item)" height="150" width="150">
                                </div>
                            </div>
                        </i-col>
                    </row>
                </Carousel-Item>
            </Carousel>

            <div slot="footer" class="text-center">
                <i-Button type="primary" shape="circle" @click="carouselChange(1)" v-if="matterModalForm.afterButton">
                    下一步
                </i-Button>

                <i-Button type="primary" shape="circle" @click="syncMatterProduct" v-if="matterModalForm.syncButton">
                    同步到商品
                </i-Button>
            </div>
        </modal>

        <modal v-model="exportModal"
               title="导出商品,数据量大请耐心等待30秒时间"
               :mask-closable="false"
               :styles="{top: '20px'}">

            <i-form ref="exportFormModal" :model="exportFormModal" :rules="exportRuleModal" label-width="80">
                <form-item label="供应商">
                    <i-Select v-model="exportFormModal.supplierId" filterable placeholder="请选择供应商" clearable
                              class="auto-width">
                        <i-Option v-for="item in store.state.supplierList" :value="item.id" :key="item.id">{{ item.name }}</i-Option>
                    </i-Select>
                </form-item>

                <form-item label="状态">
                    <i-Select v-model="exportFormModal.status" placeholder="请选择状态" clearable
                              class="auto-width">
                        <i-Option value="0">
                            下架
                        </i-Option>
                        <i-Option value="1">
                            上架
                        </i-Option>
                    </i-Select>
                </form-item>
            </i-form>

            <div slot="footer">
                <i-button type="primary" @click="syncExport('exportFormModal')" long :loading="modalLoading">
                    确定导出
                </i-button>
            </div>
        </modal>

        <modal v-model="wetCodeModel"
                title="商品小程序二维码"
                @on-ok="wetCodeModelOk">
            <div style="text-align:center;" v-if="wetCodeImg">
                <p><img :src="getImageUrl(wetCodeImg)"></p>
            </div>
        </modal>
    </div>
</template>

<script>

    var product = Vue.component('product', {
        template: '#product',
        data: function () {
            var vm = this;

            return {
                platformFlagElement: [],
                wetCodeModel: false,
                wetCodeImg: null,
                searchForm: {
                    search: null,
                    categoryIds: [],
                    supplierId: null,
                    buyerId: null,
                    status: null
                },
                searchRule: {},

                productDicInitList: [],
                skuAttrInitList: [],

                operatorTypeList: [{
                    value: 0,
                    label: '返佣'
                }, {
                    value: 1,
                    label: '采购'
                }],
                statusList: [{
                    id: 1,
                    name: '上架'
                }, {
                    id: 0,
                    name: '下架'
                }],

                tableData: [],
                tableDataCount: 0,
                tableColumns: [{
                    type: 'expand',
                    width: 35,
                    render: function (h, params) {

                        var skuList = params.row.skuList;

                        return h('Table', {
                            props: {
                                columns: [{
                                    title: 'skuId',
                                    width: 80,
                                    key: 'id'
                                }, {
                                    title: '第三方编号',
                                    key: 'keyId',
                                    width: 100
                                }, {
                                    title: 'sku属性',
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
                                    key: 'costPrice',
                                    width: 100
                                }, {
                                    title: '市场参考价',
                                    key: 'refPrice',
                                    width: 100
                                }, {
                                    title: '售价',
                                    key: 'price',
                                    width: 100
                                }, {
                                    title: '库存',
                                    key: 'stock',
                                    render: function (h, params) {

                                        return h('InputNumber', {
                                            props: {
                                                value: params.row.stock,
                                                min: 0
                                            },
                                            on: {
                                                'on-change': function (value) {
                                                    params.row.stock = value;

                                                },
                                                'on-blur': function () {
                                                    skuList[params.index].stock = params.row.stock;
                                                }
                                            }
                                        });
                                    }
                                }, {
                                    title: '操作',
                                    width: 100,
                                    align: 'center',
                                    render: function (h, params) {
                                        return h('Button', {
                                            props: {
                                                type: 'primary',
                                                size: 'small'
                                            },
                                            on: {
                                                click: function () {
                                                    vm.updateStock(params);
                                                }
                                            }
                                        }, '提交更改');
                                    }
                                }],
                                data: params.row.skuList,
                                size: 'small'
                            }
                        });
                    }
                }, {
                    title: '商品id',
                    key: 'id',
                    width: 80
                }, {
                    title: '标题/型号',
                    render: function (h, params) {

                        return h('div', [
                            h('h4', '标题： ' + params.row.title),
                            h('div', '型号： ' + params.row.tag)
                        ]);
                    }
                }, {
                    title: '类目',
                    width: 100,
                    render: function (h, params) {

                        var second = store.state.categoryMap[params.row.cid];

                        if (second) {
                            var first = store.state.categoryMap[second.pid];
                            return h('div', first.label + ' / ' + second.label);
                        }

                    }
                }, {
                    title: '供应商/买手',
                    width: 150,
                    render: function (h, params) {

                        var supplier = store.state.supplierMap[params.row.supplierId];
                        if (supplier == null) {
                            supplier = {
                                name: ''
                            };
                        }

                        var buyer = store.state.buyerMap[params.row.buyerId];
                        if (buyer == null) {
                            buyer = {
                                name: ''
                            };
                        }

                        return h('div', [
                            h('h4', '供应商： ' + supplier.name),
                            h('div', '买手： ' + buyer.name)
                        ]);
                    }
                }, {
                    title: '状态',
                    width: 60,
                    render: function (h, params) {
                        return h('div', params.row.status ? '上架' : '下架');
                    }
                }, {
                    title: '发布时间',
                    width: 150,
                    key: 'releaseTime',
                    format: 'Time'
                }, {
                    title: '已售',
                    width: 60,
                    key: 'quantity'
                }, {
                    title: '操作',
                    width: 170,
                    align: 'center',
                    render: function (h, params) {

                        var text = '';

                        if (params.row.status) {
                            text = '下架';
                        }
                        else {
                            text = '上架';
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
                                        vm.modifyProduct(params);
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
                                        vm.updateStatus(params, text);
                                    }
                                }
                            }, text),
                            h('Poptip', {
                                props: {
                                    placement: 'left'
                                }
                            }, [
                                h('Button', {
                                    props: {
                                        type: 'info',
                                        size: 'small'
                                    }
                                }, '工具'),
                                h('div', {
                                    slot: 'content',
                                    style: {
                                        padding: '10px'
                                    },
                                }, [
                                    h('Button', {
                                        props: {
                                            type: 'info',
                                            size: 'small'
                                        },
                                        style: {
                                            marginRight: '10px'
                                        },
                                        on: {
                                            click: function () {
                                                vm.getWetCode(params);
                                            }
                                        }
                                    }, '生成二维码'),
                                    h('Button', {
                                        props: {
                                            type: 'info',
                                            size: 'small'
                                        },
                                        style: {
                                            marginRight: '10px'
                                        },
                                        on: {
                                            click: function () {
                                                vm.makeLinkMe(params);
                                            }
                                        }
                                    }, '生成深度链接'),
                                    h('Button', {
                                        props: {
                                            type: 'info',
                                            size: 'small'
                                        },
                                        style: {
                                            marginRight: '10px'
                                        },
                                        on: {
                                            click: function () {
                                                vm.exportOrder(params);
                                            }
                                        }
                                    }, '导出订单'),
                                    h('Button', {
                                        props: {
                                            type: 'info',
                                            size: 'small'
                                        },
                                        on: {
                                            click: function () {
                                                vm.clearCache(params);
                                            }
                                        }
                                    }, '清除缓存')
                                ])
                            ])
                        ]);
                    }
                }],
                searchLoading: false,

                modal: false,
                modalTitle: '新增商品',
                modalLoading: false,
                formModal: {
                    appId: null,
                    title: null,
                    subtitle: null,
                    img: null,
                    sales: null,
                    labels: null,
                    cycle: null,
                    images: [],
                    tag: null,
                    categoryIds: [],
                    buyerId: null,
                    expressIds: [],
                    releaseTime: null,
                    closeTime: null,
                    shelfTime: null,
                    limited: null,
                    supplierId: null,
                    operatorType: 0,
                    discount: 20,
                    instruction: '<p class="p1">订单修改或取消</p>\n' +
                    '<p class="p1"><span class="s1">1</span>）当天<span class="s1">16</span>点前下单的商品，当天<span class="s1">16</span>点前可修改或取消订单，超出该时间不能修改或取消订单。</p>\n' +
                    '<p class="p1"><span class="s1">2</span>）当天<span class="s1">16</span>点后下单的商品，第二天<span class="s1">16</span>点前可修改或取消订单，超出该时间不能修改或取消订单。</p>\n' +
                    '<p class="p2">&nbsp;</p>\n' +
                    '<p class="p3"><span class="s2">退换货</span> <span class="Apple-converted-space">&nbsp; &nbsp; &nbsp; &nbsp;</span></p>\n' +
                    '<p class="p1"><span class="s1">不影响2次销售前提下，30</span>天内无理由退换货（少数特殊商品例外），质量问题我司承担邮费，非质量问题会员承担邮费。</p>\n' +
                    '<p class="p1">注：少数特殊商品指</p>\n' +
                    '<p class="p1"><span class="s1">1</span>）个人订制类商品（可换不可退），<span class="s1">2</span>）无质量问题的生鲜产品，<span class="s1">3</span>）内衣、泳装、贴身裤袜等涉及个人卫生的产品。</p>',
                    describeText: '',
                    videos: null,
                    detailImgMode: null,
                    bigImg: null,
                    details: [],
                    skuImgs: [],
                    addressInfo: null,
                    userInfo: null,
                    phoneInfo: null,
                    keyId: null,
                    status: null,
                    privilegeId: null,
                    scid: [],
                    platformFlag: null,
                    platformFlagList: []
                },
                ruleModal: {
                    title: [
                        {required: true, message: '请填写标题', trigger: 'blur'},
                        {type: 'string', max: 100, message: '不能超过100个字', trigger: 'blur'}
                    ],
                    subtitle: [
                        {required: true, message: '请填写副标题', trigger: 'blur'},
                        {type: 'string', max: 100, message: '不能超过100个字', trigger: 'blur'}
                    ],
                    tag: [
                        {required: true, message: '请填写型号', trigger: 'blur'},
                        {type: 'string', max: 100, message: '不能超过100个字', trigger: 'blur'}
                    ],
                    categoryIds: [
                        {required: true, message: '请选择分类', trigger: 'blur', type: 'array'}
                    ],
                    buyerId: [
                        {required: true, message: '请选择买手', trigger: 'blur', type: 'number'}
                    ],
                    expressIds: [
                        {required: true, message: '请选择快递', trigger: 'blur', type: 'array'}
                    ],
                    supplierId: [
                        {required: true, message: '请选择供应商', trigger: 'blur', type: 'number'}
                    ],
                    releaseTime: [
                        {required: true, message: '请选择开售时间', trigger: 'blur', type: 'date'}
                    ],
                    shelfTime: [
                        {required: true, message: '请选择上架时间', trigger: 'blur', type: 'date'}
                    ],
                    img: [
                        {required: true, message: '请选择列表图片', trigger: 'blur'}
                    ],
                    images: [
                        {required: true, message: '请选择轮播图', trigger: 'blur'}
                    ]
                },
                upload: {
                    action: '${contextPath}/system/uploadImg',
                    productAction: '${contextPath}/product/uploadImg',

                    format: ['jpg', 'jpeg', 'png'],

                    img1: null,
                    img2: null,
                    img3: null,
                    checks: [],
                    selects: [],

                    skuImgs: []
                },
                skuTableColumns: [],
                skuTableData: [],
                thirdModal: false,
                thirdFormModal: {
                    appId: null,
                    keyId: null,
                    status: null
                },
                thirdRuleModal: {
                    appId: [
                        {required: true, message: '请选择第三方平台', trigger: 'blur', type: 'number'}
                    ]
                },
                thirdTableColumns: [{
                    title: '第三方商品id',
                    width: 120,
                    key: 'keyId'
                }, {
                    title: '第三方商品名称',
                    render: function (h, params) {

                        var data = JSON.parse(params.row.data);

                        return h('div', data.title);
                    }
                }, {
                    title: '同步时间',
                    width: 150,
                    key: 'created',
                    format: 'Time'
                }, {
                    title: '是否同步',
                    width: 100,
                    key: 'status',
                    format: 'Boolean'
                }, {
                    title: '操作',
                    width: 100,
                    render: function (h, params) {

                        if (params.row.status != 0) {
                            return;
                        }

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
                                    vm.modifyThirdProduct(params);
                                }
                            }
                        }, '编辑');
                    }
                }],
                thirdTableData: [],
                thirdTableDataCount: 0,

                apiDataId: null,

                conditionImport: {
                    productIds: null
                },

                thirdIdTableColumns: [{
                    title: '第三方商品id',
                    width: 120,
                    key: 'keyId'
                }, {
                    title: '跳转',
                    render: function (h, params) {

                        if (vm.thirdFormModal.appId != 3) {
                            return;
                        }

                        return h('Button', {
                            props: {
                                type: 'primary',
                                size: 'small'
                            },
                            on: {
                                click: function () {
                                    var keyId = params.row.keyId;

                                    window.open("https://item.jd.com/" + keyId + ".html");
                                }
                            }
                        }, '前往京东');
                    }
                }],
                thirdIdTableData: [],
                thirdIdTableDataCount: 0,

                modifyStatus: 1,

                cacheAble: false,
                cache: null,
                cacheTitle: '载入缓存',

                matterModal: false,
                matterModalForm: {
                    carouselValue: 0,
                    directory: null,
                    afterButton: false,
                    syncButton: false,

                    title: null,
                    subtitle: null,
                    img: null,
                    details: [],
                    skuImgs: [],
                    img1: null,
                    img2: null,
                    img3: null,
                    detailObjs: [],
                    skuImgObjs: [],
                    detailsLength: 0,
                    skuImgsLength: 0,
                    attr: null,
                    sku: [],
                    images: [],
                    imageObjs: [],
                    imageLength: 0
                },
                matterFlag: false,

                exportModal: false,
                exportFormModal: {
                    supplierId: null,
                    status: null
                },
                exportRuleModal: {}
            }
        },
        mounted: function () {
            this.init();
        },
        methods: {
            init: function () {
                with (this) {
                    listByPage(1);
                    initPlatformFlag();
                }
            },
            initPlatformFlag: function () {
                with (this) {
                    utils.get('${contextPath}/config/getPlatformFlag', null, function (result) {
                        if (result.success) {
                            platformFlagElement = result.data;
                        }
                        else {
                            $Message.error(result.msg);
                        }
                    }, $data, '');
                }
            },
            listByPage: function (pageNum) {
                with (this) {

                    if (pageNum) {
                        searchForm.pageNum = pageNum;
                    }

                    searchForm.categoryId = null;

                    if (searchForm.categoryIds.length == 2) {
                        if (searchForm.categoryIds[1] != null) {
                            searchForm.categoryId = searchForm.categoryIds[1];
                        }
                    }

                    utils.get('${contextPath}/product/listByPage', searchForm, function (result) {
                        if (result.success) {
                            tableData = result.data.list;
                            tableDataCount = result.data.total;

                            if (tableDataCount == 1) {
                                tableData[0]._expanded = true;
                            }
                        }
                        else {
                            $Message.error(result.msg);
                        }
                    }, $data, 'searchLoading');
                }

            },
            updateStock: function (params) {

                with (this) {
                    if (params.row.stock == null) {
                        $Message.error('库存数量不能为空');
                        return;
                    }

                    utils.post('${contextPath}/productSku/updateStock', {
                        id: params.row.id,
                        stock: params.row.stock
                    }, function (result) {
                        if (result.success) {
                            $Message.success('更改库存成功');
                        }
                        else {
                            $Message.error(result.msg);
                        }
                    }, $data, 'searchLoading');
                }

            },
            updateStatus: function (params, text) {

                with (this) {
                    $Modal.confirm({
                        title: '提示',
                        content: '确认 [ ' + text + ' ] ' + params.row.title,
                        onOk: function () {
                            utils.post('${contextPath}/product/updateStatus', {
                                id: params.row.id,
                                status: !params.row.status
                            }, function (result) {
                                if (result.success) {
                                    $Message.success(text + '成功');
                                    listByPage();
                                }
                                else {
                                    $Message.error(result.msg);
                                }
                            }, $data, 'searchLoading');
                        }
                    });
                }

            },
            makeLinkMe: function (params) {
                with (this) {

                    $Modal.confirm({
                        title: '提示',
                        content: params.row.linkMe == null ? '<div>确认为 [ ' + params.row.title + ' ] 生成深度链接？</div>' : '<div>确认为 [ ' + params.row.title + ' ] 重新生成深度链接？</div>' + '<br><div> 当前商品已有深度链接: ' + params.row.linkMe + '，此链接将被替换 </div>',
                        onOk: function () {
                            utils.post('${contextPath}/product/makeLinkMe', {
                                ids: params.row.id
                            }, function (result) {
                                if (result.success) {
                                    listByPage();
                                    $Modal.confirm({
                                        title: '生成深度链接成功',
                                        content: '生成的深度链接为: ' + result.data
                                    });
                                }
                                else {
                                    $Message.error(result.msg);
                                }
                            }, $data, 'searchLoading');
                        }
                    });
                }
            },
            handleUploadSuccess: function (response, file, fileList) {
                with (this) {
                    if (response.success) {
                        formModal.img = response.data;

                        var splits = response.data.split(',');

                        upload.img1 = store.imgUrl + splits[0];
                        upload.img2 = store.imgUrl + splits[1];
                        upload.img3 = store.imgUrl + splits[2];
                    }
                    else {
                        $Message.error(response.msg);
                    }
                }
            },
            handleUploadFormatError: function (file) {
                this.$Message.error('图片格式不正确');
            },
            handleUploadSkuImgsSuccess: function (response, file, fileList) {
                with (this) {
                    formModal.skuImgs.forEach(function (t) {
                        upload.skuImgs.push({
                            value: t,
                            label: '图片' + (upload.skuImgs.length + 1)
                        });
                    });

                    /*upload.skuImgs.push({
                        value: response.data.url,
                        label: '图片' + (upload.skuImgs.length + 1)
                    });*/
                }
            },
            productDicChange: function (item) {
                with (this) {

                    var list = [];
                    item.forEach(function (t) {

                        var obj = null;
                        productDicInitList.forEach(function (t2) {
                            if (t2.id == t) {
                                obj = t2;
                                return;
                            }
                        });

                        if (obj) {
                            list.push(obj);
                        }
                        else {
                            var dic = store.state.productDicMap[t];

                            if (dic) {
                                list.push({
                                    label: dic.label,
                                    id: dic.id,
                                    parentId: dic.parentId,
                                    value: null
                                });
                            }
                        }
                    });

                    productDicInitList = list;
                }
            },
            skuAttrChange: function (value) {
                with (this) {

                    if (utils.isEmpty(value)) {
                        return
                    }

                    var isExist = false;
                    var hasCustomization = false;
                    skuAttrInitList.forEach(function (t) {
                        if (t.label == value) {
                            isExist = true;
                        }
                        if(t.label == '定制'){
                            hasCustomization = true;
                        }
                    });

                    if (isExist) {
                        return;
                    }

                    skuTableColumns = [];
                    skuTableData = [];

                    var element = {
                        label: value,
                        list: [{
                            checked: false,
                            value: null
                        }, {
                            checked: false,
                            value: null
                        }, {
                            checked: false,
                            value: null
                        }, {
                            checked: false,
                            value: null
                        }, {
                            checked: false,
                            value: null
                        }, {
                            checked: false,
                            value: null
                        }, {
                            checked: false,
                            value: null
                        }, {
                            checked: false,
                            value: null
                        }, {
                            checked: false,
                            value: null
                        }, {
                            checked: false,
                            value: null
                        }, {
                            checked: false,
                            value: null
                        }, {
                            checked: false,
                            value: null
                        }]
                    };

                    if (hasCustomization){
                        // 拼接函数(索引位置, 要删除元素的数量, 元素)
                        skuAttrInitList.splice(skuAttrInitList.length - 1, 0, element);
                    }else{
                        skuAttrInitList.push(element);
                    }
                }
            },
            handleSkuAttrRemove: function (item) {
                this.skuAttrInitList.splice(this.skuAttrInitList.indexOf(item), 1);
            },
            createSkuTable: function (data) {
                with (this) {

                    var columns = [];

                    if (data) {
                        if (utils.isEmpty(data[0].attrs)) {
                            return;
                        }

                        var attrs = JSON.parse(data[0].attrs);

                        var initId = true;

                        var attrMap = {};
                        attrs.forEach(function (t, i) {

                            if (t.id != null) {
                                initId = false;
                                return;
                            }

                            attrMap[t.attrName] = i + 1;

                            t.id = i + 1;
                            t.label = t.attrName;
                        });

                        if (initId) {
                            data.forEach(function (t) {
                                var attrs = JSON.parse(t.attrs);

                                attrs.forEach(function (t1) {
                                    t1.id = attrMap[t1.attrName];

                                    t1.label = t1.attrName;
                                });

                                t.attrs = JSON.stringify(attrs);
                            });

                        }

                        data.forEach(function (t) {
                            var attrs = JSON.parse(t.attrs);

                            attrs.forEach(function (t1) {
                                t[t1.id] = t1.value;
                            });
                        });

                        attrs.forEach(function (t) {

                            columns.push({
                                title: t.label,
                                key: t.id,
                                plugin: {
                                    type: 'Input'
                                }
                            });

                        });

                    }
                    else {
                        if (skuAttrInitList.length == 0) {
                            return;
                        }

                        skuAttrInitList.forEach(function (t, number) {
                            if (!t.id) {
                                t.id = number;
                            }
                        });

                        var items = [];
                        var attrs = [];
                        skuAttrInitList.forEach(function (t) {

                            var list = t.list;

                            var attrValue = [];

                            if (list.length != 0) {
                                var go = false;

                                list.forEach(function (t2) {
                                    if (t2.checked && utils.isNotEmpty(t2.value)) {
                                        go = true;

                                        attrValue.push({
                                            name: t.id,
                                            value: t2.value
                                        });

                                    }
                                });

                                if (go) {
                                    columns.push({
                                        title: t.label,
                                        key: t.id
                                    });

                                    attrs.push({
                                        id: t.id,
                                        label: t.label,
                                        value: null
                                    });
                                }
                            }

                            items.push(attrValue);

                        });

                        if (columns.length == 0) {
                            return;
                        }

                        data = setTabData(items);

                        data.forEach(function (t) {
                            t.price = 0;
                            t.refPrice = 0;
                            t.costPrice = 0;
                            t.stock = 0;
                            t.img = null;
                            t.attrs = JSON.stringify(attrs);
                        });

                    }

                    columns.push({
                        title: '售价',
                        key: 'price',
                        width: 100,
                        plugin: {
                            type: 'InputNumber'
                        },
                        renderHeader: function (h, params) {
                            return initSkuTableHeader(h, params)
                        }
                    }, {
                        title: '市场参考价',
                        key: 'refPrice',
                        width: 130,
                        plugin: {
                            type: 'InputNumber'
                        },
                        renderHeader: function (h, params) {
                            return initSkuTableHeader(h, params)
                        }
                    }, {
                        title: '成本价',
                        key: 'costPrice',
                        width: 100,
                        plugin: {
                            type: 'InputNumber'
                        },
                        renderHeader: function (h, params) {
                            return initSkuTableHeader(h, params)
                        }
                    }, {
                        title: '库存',
                        key: 'stock',
                        width: 100,
                        plugin: {
                            type: 'InputNumber'
                        },
                        renderHeader: function (h, params) {
                            return initSkuTableHeader(h, params, true)
                        }
                    }, {
                        title: '图片',
                        key: 'img',
                        width: 120,
                        plugin: {
                            type: 'Select',
                            data: upload.skuImgs
                        },
                        renderHeader: function (h, params) {

                            var opts = [];

                            upload.skuImgs.forEach(function (t) {
                                opts.push(h('Option', {
                                    props: {
                                        value: t.value
                                    }
                                }, t.label));
                            });

                            return h('Poptip', {
                                props: {
                                    title: '批量设置' + params.column.title,
                                    transfer: true
                                }
                            }, [
                                params.column.title,
                                h('Button', {
                                    props: {
                                        type: 'text',
                                        size: 'small',
                                        icon: 'ios-brush'
                                    }
                                }),
                                h('div', {
                                    slot: 'content',
                                    style: {
                                        height: '42px'
                                    }
                                }, [h('Select', {
                                    props: {
                                        clearable: true
                                    },
                                    on: {
                                        'on-change': function (value) {
                                            if (value) {
                                                skuTableData.forEach(function (t) {
                                                    t[params.column.key] = value;
                                                });
                                            }
                                        }
                                    }
                                }, opts)])
                            ]);
                        }
                    }, {
                        title: '操作',
                        width: 100,
                        render: function (h, params) {
                            if (params.row.id == null && formModal.appId == 115) {
                                return h('Poptip', {
                                    props: {
                                        confirm: true,
                                        title: '确认移除该行',
                                        placement: 'left'
                                    },
                                    on: {
                                        'on-ok': function () {
                                            skuTableData.splice(params.index, 1);
                                        }
                                    }
                                }, [h('Button', {
                                    props: {
                                        type: 'text',
                                        size: 'small',
                                        icon: 'md-remove-circle'
                                    }
                                })]);
                            }

                            return;
                        },
                        renderHeader: function (h, params) {
                            if (modifyStatus == 2 && formModal.appId == 115) {
                                return h('div', [
                                    params.column.title,
                                    h('Button', {
                                        props: {
                                            type: 'text',
                                            size: 'small',
                                            icon: 'md-add-circle'
                                        },
                                        style: {
                                            position: 'absolute',
                                            right: '5px',
                                            top: '0',
                                            height: '39px',
                                            fontSize: '18px'
                                        },
                                        on: {
                                            click: function () {
                                                var sku = {};

                                                utils.copyBean(skuTableData[0], sku);

                                                sku.price = 0;
                                                sku.refPrice = 0;
                                                sku.costPrice = 0;
                                                sku.stock = 0;
                                                sku.img = null;
                                                sku.id = null;

                                                var attrs = JSON.parse(sku.attrs);

                                                attrs.forEach(function (t) {
                                                    sku[t.id] = null;
                                                    t.value = null;
                                                });

                                                sku.attrs = JSON.stringify(attrs);

                                                skuTableData.push(sku);
                                            }
                                        }
                                    })
                                ]);
                            }

                            return h('div', params.column.title);
                        }
                    });

                    skuTableColumns = columns;

                    skuTableData = data;
                }
            },
            initSkuTableHeader: function (h, params, isInt) {

                with (this) {
                    return h('Poptip', {
                        props: {
                            title: '批量设置' + params.column.title,
                            transfer: true
                        }
                    }, [
                        params.column.title,
                        h('Button', {
                            props: {
                                type: 'text',
                                size: 'small',
                                icon: 'ios-brush'
                            }
                        }),
                        h('div', {
                            slot: 'content',
                            style: {
                                height: '42px'
                            }
                        }, [h('Input', {
                            props: {
                                search: true,
                                'enter-button': '确定'
                            },
                            on: {
                                'on-search': function (value) {
                                    if ($.isNumeric(value)) {
                                        var data = Number(value);

                                        if (data <= 0) {
                                            $Message.error('请输入大于0的数字');
                                            return;
                                        }

                                        if (isInt) {
                                            if (!Number.isInteger(data)) {
                                                $Message.error('请输入整数');
                                                return;
                                            }
                                        }

                                        skuTableData.forEach(function (t) {
                                            t[params.column.key] = data;
                                        })
                                    }
                                    else {
                                        $Message.error('请输入数字');
                                    }
                                }
                            }
                        })])
                    ]);
                }
            },
            modifyProduct: function (params, appId)
            {
                with (this)
                {
                    formModal = {
                        appId: null,
                        title: null,
                        subtitle: null,
                        img: null,
                        sales: null,
                        labels: null,
                        cycle: null,
                        images: [],
                        tag: null,
                        categoryIds: [],
                        buyerId: null,
                        expressIds: [],
                        releaseTime: null,
                        closeTime: null,
                        shelfTime: null,
                        limited: null,
                        supplierId: null,
                        operatorType: 0,
                        discount: 20,
                        instruction: '<p class="p1">订单修改或取消</p>\n' +
                        '<p class="p1"><span class="s1">1</span>）当天<span class="s1">16</span>点前下单的商品，当天<span class="s1">16</span>点前可修改或取消订单，超出该时间不能修改或取消订单。</p>\n' +
                        '<p class="p1"><span class="s1">2</span>）当天<span class="s1">16</span>点后下单的商品，第二天<span class="s1">16</span>点前可修改或取消订单，超出该时间不能修改或取消订单。</p>\n' +
                        '<p class="p2">&nbsp;</p>\n' +
                        '<p class="p3"><span class="s2">退换货</span> <span class="Apple-converted-space">&nbsp; &nbsp; &nbsp; &nbsp;</span></p>\n' +
                        '<p class="p1"><span class="s1">不影响2次销售前提下，30</span>天内无理由退换货（少数特殊商品例外），质量问题我司承担邮费，非质量问题会员承担邮费。</p>\n' +
                        '<p class="p1">注：少数特殊商品指</p>\n' +
                        '<p class="p1"><span class="s1">1</span>）个人订制类商品（可换不可退），<span class="s1">2</span>）无质量问题的生鲜产品，<span class="s1">3</span>）内衣、泳装、贴身裤袜等涉及个人卫生的产品。</p>',
                        describeText: '',
                        videos: null,
                        detailImgMode: null,
                        bigImg: null,
                        details: [],
                        skuImgs: [],
                        addressInfo: null,
                        userInfo: '环球黑卡',
                        phoneInfo: null,
                        keyId: null,
                        status: null,
                        privilegeId: null,
                        scid: [],
                        platformFlag: null,
                        platformFlagList: []
                    };
                    if(platformFlagElement){
                        var array = [];
                        platformFlagElement.forEach(function (t, number) {
                            if (t.selected){
                                array.push(t.id);
                            }
                        });
                        formModal.platformFlagList = array;
                    }
                    upload.img1 = null;
                    upload.img2 = null;
                    upload.img3 = null;
                    upload.checks = [];
                    upload.selects = [];
                    upload.skuImgs = [];

                    skuTableColumns = [];
                    skuTableData = [];
                    productDicInitList = [];
                    skuAttrInitList = [];
                    apiDataId = null;

                    if (appId) {
                        modalTitle = '从第三方同步商品';

                        modifyStatus = 3;

                        cacheAble = false;

                        matterFlag = false;

                        var data = JSON.parse(params.row.data);
                        utils.copyModel(data, formModal);

                        apiDataId = params.row.id;
                        formModal.appId = appId;

                        formModal.details = data.productDetails;

                        if (utils.isNotEmpty(formModal.img)) {
                            upload.img1 = store.imgUrl + formModal.img;
                            upload.img2 = store.imgUrl + formModal.img;
                            upload.img3 = store.imgUrl + formModal.img;

                            formModal.img = formModal.img + ',' + formModal.img + ',' + formModal.img;
                        }

                        utils.get('${contextPath}/thirdPlatform/getProductSkuByIds', {
                            appId: appId,
                            ids: params.row.keyId
                        }, function (result) {
                            if (result.success) {
                                var skuList = result.data;

                                if (skuList.length != 0) {

                                    skuList.forEach(function (t) {
                                        if (t.img != null) {
                                            formModal.skuImgs.push(t.img);

                                            upload.skuImgs.push({
                                                value: t.img,
                                                label: '图片' + (upload.skuImgs.length + 1)
                                            })
                                        }
                                    });

                                    createSkuTable(skuList);
                                }

                            }
                        });

                    }
                    else if (params == -1) {
                        modalTitle = '新增商品';
                        formModal.appId = 115;
                        upload.checks = [125, 126, 127, 128, 129, 138];

                        modifyStatus = 1;

                        cacheAble = true;

                        matterFlag = false;

                        if(platformFlagElement){
                            var array = [];
                            platformFlagElement.forEach(function (t, number) {
                                if (t.selected){
                                    array.push(t.id);
                                }
                            });
                            formModal.platformFlagList = array;
                        }
                    }
                    else if (params == 1) {
                        formModal.title = matterModalForm.title;
                        formModal.subtitle = matterModalForm.subtitle;

                        formModal.img = matterModalForm.img;
                        formModal.details = matterModalForm.details;
                        formModal.skuImgs = matterModalForm.skuImgs;
                        formModal.images = matterModalForm.images;

                        //从素材导入
                        modalTitle = '从素材包导入商品';
                        formModal.appId = 115;
                        upload.checks = [125, 126, 127, 128, 129, 138];

                        modifyStatus = 1;
                        cacheAble = true;

                        matterFlag = true;

                        formModal.skuImgs.forEach(function (t, number) {
                            upload.skuImgs.push({
                                value: t,
                                label: '图片' + (upload.skuImgs.length + 1)
                            })
                        });

                        if (utils.isNotEmpty(formModal.img)) {
                            var splits = formModal.img.split(',');

                            upload.img1 = store.imgUrl + splits[0];
                            upload.img2 = store.imgUrl + splits[1];
                            upload.img3 = store.imgUrl + splits[2];
                        }
                    }
                    else {
                        modalTitle = '修改商品';

                        modifyStatus = 2;

                        cacheAble = false;

                        matterFlag = false;

                        utils.copyModel(params.row, formModal);
                        formModal.id = params.row.id;

                        if(utils.isNotEmpty(formModal.platformFlagList)){
                            formModal.platformFlagList = formModal.platformFlagList.split(",");
                        }else{
                            formModal.platformFlagList = [];
                        }

                        var cid = params.row.cid;
                        if (cid) {
                            formModal.categoryIds = [];

                            var obj = store.state.categoryMap[cid];

                            if (obj) {
                                formModal.categoryIds.push(obj.pid);
                                formModal.categoryIds.push(cid);
                            }
                        }

                        if (formModal.closeTime) {
                            formModal.closeTime = new Date(formModal.closeTime);
                        }
                        formModal.releaseTime = new Date(formModal.releaseTime);
                        formModal.shelfTime = new Date(formModal.shelfTime);

                        if (utils.isNotEmpty(formModal.expressIds)) {
                            var splits = formModal.expressIds.split(',');
                            formModal.expressIds = [];
                            splits.forEach(function (t) {
                                formModal.expressIds.push(parseInt(t));
                            });
                        }
                        else {
                            formModal.expressIds = [];
                        }

                        if (utils.isNotEmpty(params.row.refundAddress)) {
                            var splits = params.row.refundAddress.split(',');
                            formModal.addressInfo = splits[0];
                            formModal.userInfo = splits[1];
                            formModal.phoneInfo = splits[2];
                        }

                        if (utils.isNotEmpty(formModal.details)) {
                            formModal.details = JSON.parse(formModal.details);
                        }

                        if (utils.isNotEmpty(formModal.skuImgs)) {
                            formModal.skuImgs = formModal.skuImgs.split(',');

                            formModal.skuImgs.forEach(function (t, number) {
                                upload.skuImgs.push({
                                    value: t,
                                    label: '图片' + (upload.skuImgs.length + 1)
                                })
                            })
                        }
                        if (utils.isNotEmpty(formModal.images)) {
                            formModal.images = formModal.images.split(',');
                        }

                        if (utils.isNotEmpty(formModal.img)) {
                            var splits = formModal.img.split(',');

                            upload.img1 = store.imgUrl + splits[0];
                            upload.img2 = store.imgUrl + splits[1];
                            upload.img3 = store.imgUrl + splits[2];
                        }

                        if (utils.isNotEmpty(formModal.scid)) {
                            formModal.scid = JSON.parse(formModal.scid);
                        }

                        if (utils.isNotEmpty(params.row.attrTemplate)) {

                            utils.get('${contextPath}/productDic/selectRelates', {
                                pid: formModal.id
                            }, function (result) {
                                if (result.success) {

                                    var checks = [];
                                    var selects = [];
                                    result.data.forEach(function (t) {
                                        if (t.type == 0) {
                                            checks.push(parseInt(t.dicId));
                                        }
                                        else {
                                            selects.push(parseInt(t.dicId));

                                            var dic = store.state.productDicMap[t.dicId];

                                            if (dic) {
                                                productDicInitList.push({
                                                    label: dic.label,
                                                    id: dic.id,
                                                    parentId: dic.parentId,
                                                    value: t.value
                                                })
                                            }

                                        }
                                    });

                                    upload.checks = checks;
                                    upload.selects = selects;
                                }
                            });

                        }

                        utils.get('${contextPath}/productSku/listByModel', {
                            pid: formModal.id
                        }, function (result) {
                            if (result.success) {
                                var data = result.data;

                                if (data.length != 0) {
                                    createSkuTable(data);
                                }
                            }
                        });
                    }

                    modal = true;
                }
            },
            asyncOK: function (name) {
                with (this) {
                    $refs[name].validate(function (valid) {
                        if (valid) {

                            if (skuTableData.length == 0) {
                                $Message.error('请添加sku信息');
                                return;
                            }

                            var product = {};

                            utils.copyBean(formModal, product);

                            if (product.categoryIds.length == 1) {
                                $Message.error('请选择二级分类');
                                return;
                            }

                            product.cid = product.categoryIds[1];
                            product.attrTemplate = upload.checks.concat(upload.selects).join(',');
                            product.releaseTime = Date.parse(product.releaseTime);
                            if (product.closeTime) {
                                product.closeTime = Date.parse(product.closeTime);
                            }
                            product.shelfTime = Date.parse(product.shelfTime);
                            product.expressIds = product.expressIds.join(',');
                            product.skuImgs = product.skuImgs.join(',');
                            if(utils.isEmpty(product.images)){
                                $Message.error('请选择轮播图');
                                return;
                            }
                            if(utils.isNotEmpty(product.labels)){
                                var labelsStr = product.labels;
                                if(labelsStr.indexOf(",") != -1){
                                    if(labelsStr.length>12){
                                        $Message.error('标签请务超过11个字符');
                                        return;
                                    }
                                }else{
                                    if(labelsStr.length>11){
                                        $Message.error('标签请务超过11个字符');
                                        return;
                                    }
                                }
                                /*var labelsStr = product.labels.split(",");
                                for(var i=0; i<labelsStr.length; i++){
                                    if(labelsStr[i].length>11){
                                        $Message.error('单个标签请务超过11个字符');
                                        return;
                                    }
                                }*/
                            }
                            product.images = product.images.join(',');
                            product.platformFlagList = product.platformFlagList.join(',');

                            if (utils.isNotEmpty(product.addressInfo) && utils.isNotEmpty(product.userInfo) && utils.isNotEmpty(product.phoneInfo)) {
                                product.refundAddress = product.addressInfo + ',' + product.userInfo + ',' + product.phoneInfo;
                            }

                            var valid = true;
                            var msg = '';
                            skuTableData.forEach(function (sku) {

                                if (sku.price == null || sku.price == 0) {
                                    valid = false;
                                    msg = 'sku售价不正常';
                                    return;
                                }

                                if (sku.refPrice == null || sku.refPrice == 0) {
                                    valid = false;
                                    msg = 'sku市场参考价不正常';
                                    return;
                                }

                                if (sku.costPrice == null || sku.costPrice == 0) {
                                    valid = false;
                                    msg = 'sku成本价不正常';
                                    return;
                                }

                                if (sku.stock == null) {
                                    valid = false;
                                    msg = 'sku库存不能为空';
                                    return;
                                }

                                if (utils.isEmpty(sku.img)) {
                                    valid = false;
                                    msg = '请选择sku图片';
                                    return;
                                }

                                var attrs = [];

                                if (sku.attrs) {
                                    var array = JSON.parse(sku.attrs);

                                    array.forEach(function (t) {
                                        attrs.push({
                                            id: t.id,
                                            label: t.label,
                                            value: sku[t.id]
                                        });
                                    });
                                }

                                sku.attrs = JSON.stringify(attrs);
                            });

                            if (!valid) {
                                $Message.error(msg);
                                return;
                            }

                            var data = {
                                product: product,
                                productSkus: skuTableData,
                                productDicChecks: upload.checks,
                                productDicSelects: productDicInitList,
                                apiDataId: apiDataId
                            };

                            utils.postJson('${contextPath}/product/modify', data, function (result) {
                                if (result.success) {

                                    cacheAble = false;
                                    cache = null;

                                    modal = false;
                                    $Message.success('操作成功');
                                    listByPage();
                                }
                                else {
                                    $Message.error(result.msg);
                                }

                                if (apiDataId) {
                                    thirdModal = true;
                                    listThirdByPage(1);
                                }
                            }, $data, 'modalLoading')

                        }
                    })
                }
            },
            setTabData: function (arr) {
                var beasArr = [];
                var newData = [];
                (function sortingArr(n, arrData) {
                    if (arr[n]) {
                        for (var i = 0; i < arr[n].length; i++) {
                            var newArr = [].concat(arr[n][i], arrData)
                            if (arr[n + 1] && arr[n + 1].length) {
                                sortingArr(n + 1, newArr)
                            } else {
                                beasArr.push(newArr);
                            }
                        }
                    }
                })(0, [])
                for (var i = 0; i < beasArr.length; i++) {
                    var obj = {};
                    for (var j = 0; j < beasArr[i].length; j++) {
                        obj[beasArr[i][j].name] = beasArr[i][j].value;
                    }
                    newData.push(obj);
                }
                return newData;
            },
            listThirdByPage: function (pageNum) {
                with (this) {
                    $refs.thirdFormModal.validate(function (valid) {
                        if (valid) {
                            thirdFormModal.pageNum = pageNum;

                            utils.get('${contextPath}/thirdPlatform/getProductListByPage', thirdFormModal, function (result) {
                                if (result.success) {
                                    thirdTableData = result.data.list;
                                    thirdTableDataCount = result.data.total;
                                }
                                else {
                                    $Message.error(result.msg);
                                }
                            }, $data, 'modalLoading');
                        }
                    });
                }
            },
            listThirdIdByPage: function (pageNum) {
                with (this) {
                    $refs.thirdFormModal.validate(function (valid) {
                        if (valid) {

                            if (thirdFormModal.appId == 3 || thirdFormModal.appId == 4) {
                                utils.get('${contextPath}/thirdPlatform/getProductIds', {
                                    appId: thirdFormModal.appId,
                                    pageNum: pageNum
                                }, function (result) {
                                    if (result.success) {
                                        thirdIdTableData = [];

                                        result.data.list.forEach(function (t) {
                                            thirdIdTableData.push({
                                                keyId: t
                                            });
                                        });

                                        thirdIdTableDataCount = result.data.total;

                                    }
                                    else {
                                        $Message.error(result.msg);
                                    }
                                }, $data, 'modalLoading');
                            }

                        }
                    });
                }
            },
            showThirdModal: function () {
                with (this) {
                    utils.get('${contextPath}/appInfo/listAll', {
                        type: 1,
                        isEnable: true
                    }, function (result) {
                        if (result.success) {
                            appList = result.data;

                            if (appList.length != 0) {
                                thirdFormModal.appId = appList[0].id;
                                listThirdByPage(1);
                            }
                        }
                        else {
                            $Message.error(result.msg);
                        }
                    });
                    thirdModal = true;
                }
            },
            cancelModal: function () {
                with (this) {
                    if (apiDataId) {
                        thirdModal = true;
                    }

                    if (matterFlag) {
                        matterModal = true;
                    }

                    if (cacheAble && utils.isNotEmpty(formModal.title)) {
                        cache = {};

                        cache.formModal = formModal;

                        cache.img1 = upload.img1;
                        cache.img2 = upload.img2;
                        cache.img3 = upload.img3;

                        cache.selects = upload.selects;
                        cache.checks = upload.checks;
                        cache.skuImgs = upload.skuImgs;

                        cache.productDicInitList = productDicInitList;
                        cache.skuAttrInitList = skuAttrInitList;
                        cache.skuTableColumns = skuTableColumns;
                        cache.skuTableData = skuTableData;

                        cacheTitle = '载入[' + formModal.title + ']的缓存';
                    }
                }
            },
            thirdFormModalSelectChange: function (index) {
                with (this) {
                    if (index == 3 || index == 4) {
                        listThirdIdByPage(1);
                    }
                    else {
                        thirdIdTableData = [];
                        thirdIdTableDataCount = 0;
                    }
                    listThirdByPage(1);
                }
            },
            modifyThirdProduct: function (params) {
                with (this) {
                    thirdModal = false;

                    modifyProduct(params, params.row.appId);
                }
            },
            exportOrder: function (params) {
                with (this) {
                    $Modal.confirm({
                        title: '提示',
                        content: '<div>确认导出 [ ' + params.row.title + ' ] 的订单数据？</div>',
                        onOk: function () {
                            var data = {
                                method: 'post',
                                action: '${contextPath}/order/export?pid=' + params.row.id
                            };
                            utils.download(data, $data, 'searchLoading');
                        }
                    });
                }
            },
            clearCache: function (params) {
                with (this) {
                    $Modal.confirm({
                        title: '提示',
                        content: '<div>确认为 [ ' + params.row.title + ' ] 清除缓存？</div>',
                        onOk: function () {

                            utils.post('${contextPath}/product/clearCache', {
                                id: params.row.id
                            }, function (result) {
                                if (result.success) {
                                    $Message.success('清除成功');
                                }
                                else {
                                    $Message.error(result.msg);
                                }
                            }, $data, 'searchLoading');
                        }
                    });
                }
            },
            popperShow: function () {
                with (this) {
                    conditionImport.productIds = null;
                }
            },
            syncThirdProduct: function () {
                with (this) {
                    $refs.thirdFormModal.validate(function (valid) {
                        if (valid) {
                            if (utils.isNotEmpty(conditionImport.productIds)) {

                                if (thirdFormModal.appId != 1 && conditionImport.productIds.indexOf(',') != -1) {
                                    $Message.error('抱歉，仅严选支持多个商品同步');
                                    return;
                                }

                                utils.post('${contextPath}/thirdPlatform/syncProductList', {
                                    appId: thirdFormModal.appId,
                                    ids: conditionImport.productIds
                                }, function (result) {
                                    if (result.success) {
                                        $Message.success('同步成功');
                                        listThirdByPage(1);
                                    }
                                    else {
                                        $Message.error(result.msg);
                                    }
                                }, $data, 'modalLoading')
                            }
                        }
                    });
                }
            },
            loadCache: function () {
                with (this) {
                    formModal = cache.formModal;
                    upload.img1 = cache.img1;
                    upload.img2 = cache.img2;
                    upload.img3 = cache.img3;

                    upload.selects = cache.selects;
                    upload.checks = cache.checks;
                    upload.skuImgs = cache.skuImgs;
                    productDicInitList = cache.productDicInitList;
                    skuAttrInitList = cache.skuAttrInitList;
                    skuTableColumns = cache.skuTableColumns;
                    skuTableData = cache.skuTableData;
                }
            },
            cidChange: function (value, selectedData) {

                if (value.length == 0) {
                    return;
                }

                value.forEach(function (t, index) {
                    value[index] = parseInt(t);
                });

                this.formModal.categoryIds = value;
            },
            scidChange: function (value, selectedData) {

                if (value.length == 0) {
                    return;
                }

                value.forEach(function (t, index) {
                    value[index] = parseInt(t);
                });

                this.formModal.scid = value;
            },
            dateChange: function (value) {
                with (this) {
                    if (modifyStatus != 2) {
                        var time = formModal.releaseTime.getTime() + 12 * 60 * 60 * 1000;

                        formModal.releaseTime = new Date(time);

                        formModal.shelfTime = formModal.releaseTime;
                    }
                }
            },

            getImageUrl: function (item) {

                if (item.url) {
                    return store.imgUrl + item.url;
                }

                return store.imgUrl + item;
            },
            carouselChange: function (index) {
                with (this) {
                    matterModalForm.carouselValue = matterModalForm.carouselValue + index;

                    matterModalForm.afterButton = false;
                    uploadByController();
                }
            },
            selectDirectory: function () {
                this.$refs.fileDirectory.click();
            },
            directoryChange: function (e) {
                var files = e.target.files;

                if (files.length == 0) {
                    $Message.error('选择的目录没有素材');
                    return;
                }

                var path = files[0].webkitRelativePath.split('/')[0];

                this.matterModalForm.directory = path;

                this.matterModalForm.afterButton = true;
            },
            handleUpload: function (file) {
                return false;
            },
            handleUploadSuccess1: function (response, file, fileList) {
                with (this) {
                    if (response.success) {
                        matterModalForm.img = response.data;

                        var splits = response.data.split(',');

                        matterModalForm.img1 = store.imgUrl + splits[0];
                        matterModalForm.img2 = store.imgUrl + splits[1];
                        matterModalForm.img3 = store.imgUrl + splits[2];
                    }
                    else {
                        $Message.error(response.msg);
                    }
                }
            },
            handleUploadSuccess2: function (response, file, fileList) {
                with (this) {
                    if (response.success) {
                        matterModalForm.detailObjs.push(response.data);

                        if (matterModalForm.detailObjs.length == matterModalForm.detailsLength) {
                            matterModalForm.detailObjs.sort(function (a, b) {
                                return a.index - b.index;
                            });

                            matterModalForm.details = matterModalForm.detailObjs;

                            matterModalForm.syncButton = true;
                        }

                    }
                    else {
                        $Message.error(response.msg);
                    }
                }
            },
            handleUploadSuccess3: function (response, file, fileList) {
                with (this) {
                    if (response.success) {
                        matterModalForm.skuImgObjs.push(response.data);

                        if (matterModalForm.skuImgObjs.length == matterModalForm.skuImgsLength) {
                            matterModalForm.skuImgObjs.sort(function (a, b) {
                                return a.index - b.index;
                            });

                            matterModalForm.skuImgs = [];
                            matterModalForm.skuImgObjs.forEach(function (t) {
                                matterModalForm.skuImgs.push(t.url);
                            });

                            matterModalForm.syncButton = true;
                        }
                    }
                    else {
                        $Message.error(response.msg);
                    }
                }
            },
            handleUploadSuccess4: function (response, file, fileList) {
                with (this) {
                    if (response.success) {
                        matterModalForm.imageObjs.push(response.data);

                        if (matterModalForm.imageObjs.length == matterModalForm.imageLength) {
                            matterModalForm.imageObjs.sort(function (a, b) {
                                return a.index - b.index;
                            });

                            matterModalForm.images = [];
                            matterModalForm.imageObjs.forEach(function (t) {
                                matterModalForm.images.push(t.url);
                            });

                            matterModalForm.syncButton = true;
                        }
                    }
                    else {
                        $Message.error(response.msg);
                    }
                }
            },
            uploadByController: function () {
                var files = this.$refs.fileDirectory.files;

                var img = null;
                var images = [];
                var details = [];
                var skuImgs = [];
                var info = null;

                for (var i = 0; i < files.length; i++) {
                    var t = files[i];

                    if (utils.isNotEmpty(t.type)) {
                        if (t.name.indexOf('.txt') != -1) {
                            info = t;
                        }
                        else if (t.webkitRelativePath.indexOf('主图') != -1) {
                            img = t;
                        }
                        else if (t.webkitRelativePath.indexOf('轮播图') != -1) {
                            images.push(t);
                        }
                        else if (t.webkitRelativePath.indexOf('sku') != -1) {
                            skuImgs.push(t);
                        }
                        else if (t.webkitRelativePath.indexOf('切片') != -1 || t.webkitRelativePath.indexOf('详情') != -1) {
                            details.push(t);
                        }

                    }

                }

                if (img == null && details.length == 0 && skuImgs.length == 0 && info == null) {
                    this.$Message.error('素材为空');
                    return;
                }

                images.sort(function (a, b) {
                    var c = a.name.replace(/[^0-9]/ig, "");
                    var d = b.name.replace(/[^0-9]/ig, "");
                    return parseInt(c) - parseInt(d);
                });

                details.sort(function (a, b) {
                    var c = a.name.replace(/[^0-9]/ig, "");
                    var d = b.name.replace(/[^0-9]/ig, "");
                    return parseInt(c) - parseInt(d);
                });

                with (this) {
                    matterModalForm.detailsLength = details.length;
                    matterModalForm.skuImgsLength = skuImgs.length;
                    matterModalForm.imageLength = images.length;

                    if (img != null) {
                        $refs.img.post(img);
                    }

                    for (var i = 0; i < images.length; i++) {
                        $refs.images.data = {
                            index: i
                        };

                        $refs.images.post(images[i]);
                    }

                    for (var i = 0; i < details.length; i++) {
                        $refs.details.data = {
                            index: i
                        };

                        $refs.details.post(details[i]);
                    }

                    for (var i = 0; i < skuImgs.length; i++) {
                        $refs.skuImgs.data = {
                            index: i
                        };

                        $refs.skuImgs.post(skuImgs[i]);
                    }

                    if (info != null) {
                        var reader = new FileReader();
                        reader.readAsText(info, 'gb2312');

                        reader.onload = function (evt) {
                            var data = evt.target.result;

                            var splits = data.split(/[\n\u0085\u2028\u2029]|\r\n?/g);

                            var title = null;
                            var subtitle = null;
                            var sku = null;
                            var attr = null;

                            var titleIndex = null;
                            var subtitleIndex = null;
                            var skuIndex = null;
                            splits.forEach(function (t2, index) {
                                if (t2.indexOf('主标题') != -1) {
                                    titleIndex = index;
                                }

                                if (t2.indexOf('副标题') != -1) {
                                    subtitleIndex = index;
                                }

                                if (t2.indexOf('sku') != -1) {
                                    skuIndex = index;
                                }

                            });

                            if (titleIndex != null && subtitleIndex != null) {
                                title = '';
                                for (var i = titleIndex + 1; i < subtitleIndex; i++) {
                                    if (utils.isNotEmpty(splits[i])) {
                                        if (utils.isNotEmpty(title)) {
                                            title += ' ';
                                            title += splits[i];
                                        }
                                        else {
                                            title += splits[i];
                                        }

                                    }
                                }
                            }

                            if (utils.isNotEmpty(title)) {
                                matterModalForm.title = title;
                            }

                            if (subtitleIndex != null) {
                                subtitle = '';
                                for (var i = subtitleIndex + 1; i < splits.length; i++) {
                                    if (utils.isNotEmpty(splits[i])) {
                                        if (utils.isNotEmpty(subtitle)) {
                                            subtitle += ' ';
                                            subtitle += splits[i];
                                        }
                                        else {
                                            subtitle += splits[i];
                                        }

                                    }
                                }
                            }

                            if (utils.isNotEmpty(subtitle)) {
                                matterModalForm.subtitle = subtitle;
                            }

//                            if (skuIndex != null) {
//                                sku = [];
//                                for (var i = skuIndex + 1; i < splits.length; i++) {
//                                    if (utils.isNotEmpty(splits[i])) {
//                                        if (i == skuIndex + 1) {
//                                            attr = splits[i];
//                                        }
//                                        else {
//                                            sku.push(splits[i]);
//                                        }
//
//                                    }
//                                }
//
//                                if (attr != null) {
//                                    matterModalForm.attr = attr;
//                                }
//
//                                sku.forEach(function (t2) {
//                                    matterModalForm.sku.push(t2);
//                                })
//                            }
                        }
                    }
                }
            },
            showMatterModal: function () {
                this.matterModal = true;
            },
            syncMatterProduct: function () {
                with (this) {
                    modifyProduct(1);
                    matterModal = false;
                }
            },
            cancelMatterModal: function () {
                with (this) {
                    matterModalForm = {
                        carouselValue: 0,
                        directory: null,
                        afterButton: false,
                        syncButton: false,

                        title: null,
                        subtitle: null,
                        img: null,
                        details: [],
                        skuImgs: [],
                        img1: null,
                        img2: null,
                        img3: null,
                        detailObjs: [],
                        skuImgObjs: [],
                        detailsLength: 0,
                        skuImgsLength: 0,
                        attr: null,
                        sku: [],
                        images: [],
                        imageObjs: [],
                        imageLength: 0
                    };
                }
            },
            exportProduct: function () {
                with (this) {
                    exportFormModal = {
                        supplierId: null,
                        status: null
                    };
                    exportModal = true;
                }
            },
            syncExport: function (name) {
                with (this) {

                    var supplierId = exportFormModal.supplierId == null ? '' : exportFormModal.supplierId;

                    var status = exportFormModal.status == null ? '' : exportFormModal.status;

                    var data = {
                        method: 'post',
                        action: '${contextPath}/product/export?supplierId=' + supplierId + '&status=' + status
                    };

                    utils.download(data, $data, 'modalLoading');
                }
            },
            supplierChange: function (value) {
                with (this) {
                    var supplier = store.state.supplierMap[value];

                    if (supplier && supplier.operatorType != null) {
                        formModal.operatorType = supplier.operatorType;
                    }

                }
            },
            getWetCode: function (params) {
                with (this) {
                    var pid = params.row.id;
                    utils.get('${contextPath}/product/getWetCode', {
                        pid: pid,
                    }, function (result) {
                        if (result.success) {
                            var code = result.data;
                            wetCodeModel = true;
                            wetCodeImg = code;
                        }else {
                            wetCodeImg = null;
                            $Message.error(result.msg);
                        }
                    });
                }
            },
            wetCodeModelOk: function () {
                with (this) {
                    wetCodeModel = false;
                }
            }
        }
    });

</script>