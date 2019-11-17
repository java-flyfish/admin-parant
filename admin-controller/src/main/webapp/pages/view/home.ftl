<template id="home">
    <div class="auto-height auto-overflow">

        <#--<virtual-list :size="40" :remain="8" wtag="ul">-->
            <#--<li class="item" v-for="(udf, index) of items" :key="index">Item: # {{ index }}</li>-->
        <#--</virtual-list>-->

        <#--<Timeline style="margin: 10px">
            <Timeline-Item>
                <p class="time">2019-6-25</p>

                <p class="content">2.4版本 更新内容</p>

                <p class="content">
                    <Icon type="md-radio-button-off"></Icon>
                    新增:对接拼团
                </p>

                <p class="content">
                    <Icon type="md-radio-button-off"></Icon>
                    新增:商品销售渠道选择
                    <br>
                    需要新增渠道找开发
                </p>

            </Timeline-Item>

            <Timeline-Item>
                <img style="animation: FromTopToBottom 3s linear infinite;" slot="dot" width="28px" src="http://img2.ultimavip.cn/70df6e0282514cedaaab5bbec989c0ed"/>

                <p class="time">2019-1-27 <span style="color:#ff3573">新年快乐 happy new year !</span></p>

                <p class="content">2.3版本 更新内容</p>

                <p class="content">
                    <Icon type="md-radio-button-off"></Icon>
                    新增:后台分类批量关联商品
                </p>

                <p class="content">
                    <Icon type="md-radio-button-off"></Icon>
                    修复:选择框错位问题
                </p>

            </Timeline-Item>

            <Timeline-Item>

                <Icon class="ivu-load-loop" type="ios-snow" slot="dot"
                      style="font-size: 24px;color: rgb(220, 50, 51);animation-duration:3s"></Icon>

                <p class="time">2018-12-28 <span style="color:#39f">Merry Christmas</span></p>

                <p class="content">2.2版本 更新内容</p>

                <p class="content">
                    <Icon type="md-radio-button-off"></Icon>
                    新增:从素材包导入
                    <br>
                    从[商品]--[工具箱]--[从素材包导入] 可以选择从本地上架素材包导入商品
                    <br>
                    程序会自动解析 商品主图、商品详情图、商品sku图、商品主标题、商品副标题
                    <br>
                    ps:素材包有一定的格式规范，预设的格式已经能满足大部分导入需求
                </p>

                <p class="content">
                    <Icon type="md-radio-button-off"></Icon>
                    优化:新增或修改商品时，商品详情图过多导致的保存速度慢的问题
                </p>

                <p class="content">
                    <Icon type="md-radio-button-off"></Icon>
                    新增:商品信息导出 (仅自营)
                    <br>
                    从[商品]--[工具箱]--[导出商品] 可以根据条件导出商品信息(精确到sku维度)
                </p>

            </Timeline-Item>
            <Timeline-Item>
                <p class="time">2018-12-18</p>

                <p class="content">2.1版本 更新内容</p>

                <p class="content">
                    <Icon type="md-radio-button-off"></Icon>
                    新增:商品缓存
                    <br>
                    新增商品时，未保存情况下关闭窗口(例如需要临时增加供应商、分类等信息)，将缓存本次输入内容，方便下次恢复内容
                    <br>
                    注:缓存会在刷新浏览器、保存商品成功后失效
                </p>

                <p class="content">
                    <Icon type="md-radio-button-off"></Icon>
                    新增:新增商品时，填开售时间，默认12点，并且自动同步时间到上架时间(避免重复填2次)
                </p>

                <p class="content">
                    <Icon type="md-radio-button-off"></Icon>
                    修复:新增或修改商品时，前台分类和后台分类搜索无效问题
                </p>

            </Timeline-Item>
            <Timeline-Item>
                <p class="time">2018-11-24</p>

                <p class="content">2.0版本 更新内容</p>

                <p class="content">
                    <Icon type="md-radio-button-off"></Icon>
                    新增:商品sku 动态增加库存记录
                </p>

                <p class="content">
                    <Icon type="md-radio-button-off"></Icon>
                    新增:商品sku 批量设置库存属性
                </p>

                <p class="content">
                    <Icon type="md-radio-button-off"></Icon>
                    新增:商品详情图拖拽排序
                </p>

                <p class="content">
                    <Icon type="md-radio-button-off"></Icon>
                    新增:商品 sku 可直接输入框添加sku属性
                </p>

                <p class="content">
                    <Icon type="md-radio-button-off"></Icon>
                    新增:添加商品属性、分类时，商品页面无需刷新即可使用刚添加的属性
                </p>

                <p class="content">
                    <Icon type="md-radio-button-off"></Icon>
                    修复:平台商品修改sku属性无效
                </p>

                <br>

                <p class="content">
                    <Icon type="md-radio-button-off"></Icon>
                    重构:订单模块 按供应商维度显示订单，更强大的订单修改功能(可更改物流、交易信息)，退款按钮移至订单详情
                </p>

                <p class="content">
                    <Icon type="md-radio-button-off"></Icon>
                    重构:退款模块 按供应商维度显示订单，退款按钮移至退款详情
                </p>

                <p class="content">
                    <Icon type="md-radio-button-off"></Icon>
                    重构:第三方数据中心，不同的第三方平台，动态关联对应的推送类型
                </p>

                <br>

                <p class="content">
                    <Icon type="md-radio-button-off"></Icon>
                    全屏功能，更优雅的办公
                </p>

                <p class="content">
                    <Icon type="md-radio-button-off"></Icon>
                    上传图片控件升级
                </p>

                <p class="content">
                    <Icon type="md-radio-button-off"></Icon>
                    标签页控件升级
                </p>

                <p class="content">
                    <Icon type="md-radio-button-off"></Icon>
                    表格控件升级，适配不同分辨率
                </p>

                <p class="content">
                    <Icon type="md-radio-button-off"></Icon>
                    其他细节优化、性能优化
                </p>

            </Timeline-Item>-->
            <Timeline-Item color="green">
                <Icon type="ios-trophy" slot="dot"></Icon>
                <p class="time">2019-11-17</p>
                <p class="content">白板狗鱼1.0版本 开始开发。。。</p>
            </Timeline-Item>
        </Timeline>
    </div>
</template>

<script>
    var home = Vue.component('home', {
        template: '#home',
        data: function () {
            return {
                columns6: [{
                    title: '标题',
                    key: 'a'
                }, {
                    title: '标题',
                    key: 'a',
                    plugin: {
                        type: 'Input'
                    }
                }, {
                    title: '自定义',
                    key: 'b'
                }],
                data6: [{
                    a: '123',
                    b: '444'
                }, {
                    a: '144431',
                    b: '44444'
                }],

                items: new Array(100000),

                newYearData: ["恭喜发财","财源广进","龙马精神","意气风发","万马奔腾","全家福气","神采奕奕","鹏程万里","幸福安康","万事如意","升官发财","年年有余","大吉大利","财源广进","百事可乐","一帆风顺","好运连连","日新月异","蒸蒸日上","事业有成","笑口常开"]
            }
        },
        created: function () {
        },
        methods: {}
    });
</script>