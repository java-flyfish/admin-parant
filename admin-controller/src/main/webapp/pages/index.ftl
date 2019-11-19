<#include "header.ftl">

<div id="app">
    <template>
        <Spin size="large" fix v-if="loading" style="z-index: 1000"></Spin>
        <Layout v-if="!loading" class="layout">
            <i-Header class="layout-header no-padding">
                <i-Menu mode="horizontal" theme="primary" @on-select="topMenuSelect">
                    <Menu-Item style="font-size: 22px">
                        <Icon type="md-appstore" size="24"></Icon>
                        白板狗鱼管理后台
                    </Menu-Item>

                    <Submenu name="3" class="float-right">
                        <template slot="title">
                        <span class="ivu-avatar ivu-avatar-circle ivu-avatar-default ivu-avatar-icon">
                            <i class="ivu-icon ivu-icon-md-person" style="margin-right: 0;"></i>
                        </span>
                            <span>${userName}</span>
                        </template>

                        <Menu-Item name="3-1">
                            <Icon type="md-power"></Icon>
                            退出系统
                        </Menu-Item>

                    </Submenu>

                    <Submenu name="2" class="float-right">
                        <template slot="title">
                            <Icon type="md-settings" size="22"></Icon>
                            设置
                        </template>
                        <Menu-Group title="友情链接">
                            <Menu-Item name="2-1">小亚通</Menu-Item>
                            <Menu-Item name="2-2">商户平台</Menu-Item>
                            <Menu-Item name="2-3">严选招财系统</Menu-Item>
                            <Menu-Item name="2-4">博库分销系统</Menu-Item>
                        </Menu-Group>
                        <Menu-Group title="其他">
                            <Menu-Item name="2-5">反馈及建议</Menu-Item>
                            <Menu-Item name="2-6">帮助</Menu-Item>
                        </Menu-Group>
                    </Submenu>

                    <Menu-Item name="1" class="float-right">
                        <Badge style="margin-right: 5px;height: 26px;line-height: 100%" dot>
                            <Icon type="md-notifications-outline" size="26"></Icon>
                        </Badge>
                        通知
                    </Menu-Item>

                    <fullscreen class="float-right"></fullscreen>
                </i-Menu>
            </i-Header>
            <Layout class="layout-body">
                <Sider hide-trigger class="auto-height color-white auto-overflow">
                    <i-Menu ref="siderMenu" width="auto" class="auto-height" accordion @on-select="slideMenuSelect"
                            :active-name="activeName" :open-names="openNames">
                        <Submenu v-for="menu in slideMenu" :name="menu.name">
                            <template slot="title">
                                <Icon :type="menu.icon"></Icon>
                                {{menu.title}}
                            </template>

                            <Menu-Item v-for="item in menu.children" :name="item.name">{{item.title}}
                            </Menu-Item>
                        </Submenu>
                    </i-Menu>
                </Sider>
                <i-Content class="layout-content">
                    <div class="custom-tabs-style">
                        <Tabs type="card" @on-click="handleTabClick" @on-tab-remove="handleTabRemove"
                              :value="activeName">
                            <Tab-Pane label="主页" icon="ios-home" name="home">
                            </Tab-Pane>

                            <Tab-Pane closable v-for="tab in tabs" :name="tab.name" :label="tab.label" v-if="tab.show">
                            </Tab-Pane>

                            <i-Button @click="handleTabsClear" size="small" slot="extra">清空标签页</i-Button>
                        </Tabs>
                    </div>

                    <div class="router-view">
                        <keep-alive :include="cacheList">
                            <router-view></router-view>
                        </keep-alive>
                    </div>
                </i-Content>
            </Layout>
        </Layout>
    </template>
</div>

<script>

    store.contextPath = '${contextPath}';
    store.email = '${email}';
    store.imgUrl = 'http://img2.ultimavip.cn/';
    store.dispatch('init');

    new Vue({
        el: '#app',
        router: router,
        data: {
            loading: false,
            slideMenu: [],
            tabs: [],
            activeName: 'home',
            openNames: [],
            cacheList: []
        },
        watch: {
            activeName: function (name) {
                this.turnToPage(name);
            },
            openNames: function () {
                this.$nextTick(function () {
                    this.$refs.siderMenu.updateOpened();
                })
            },
            '$route': function (to) {
                if (to.name == this.activeName) {
                    return;
                }
                if (to.name == 'home') {
                    this.activeName = 'home';
                }
                else {
                    this.slideMenuSelect(to.name);
                }
            }
        },
        created: function () {
            with (this) {
                utils.get('${contextPath}/resource/listTreeByRole', {
                    isEnable: true
                }, function (result) {
                    if (result.success) {
                        if (result.data.length != 0) {
                            slideMenu = result.data[0].children;
                        }
                    }
                }, $data, 'loading');

                $(document).ajaxError(function (event, jqxhr, settings, exception) {
                    if (jqxhr.status == 401) {
                        $Modal.confirm({
                            title: '提示',
                            content: '<p>登录超时</p>',
                            onOk: function () {
                                window.location = '${contextPath}/sysUser/logout';
                            },
                            onCancel: function () {
                                window.location = '${contextPath}/sysUser/logout';
                            }
                        });
                    }
                });
            }
        },
        methods: {
            topMenuSelect: function (name) {
                switch (name) {
                    case '2-1':
                        window.open('https://i.xiaoyatong.com/#/login');
                        break;
                    case '2-2':
                        window.open('http://172.16.30.43:8876/main/index');
                        break;
                    case '2-3':
                        window.open('http://zhaocai.you.163.com/index.ftl');
                        break;
                    case '2-4':
                        window.open('http://168.bookuu.com/');
                        break;
                    case '2-5':
                        //window.open('http://168.bookuu.com/');
                        break;
                    case '2-6':
                        //window.open('http://168.bookuu.com/');
                        break;
                    case '3-1':
                        window.location = '${contextPath}/sysUser/logout';
                        break;
                    default:
                        break;
                }
            },
            slideMenuSelect: function (name) {
                with (this) {
                    if (activeName == name) {
                        return;
                    }

                    for (var i = 0; i < tabs.length; i++) {
                        if (tabs[i].name == name) {
                            tabs[i].show = true;
                            activeName = name;

                            if ($.inArray(name, cacheList) == -1) {
                                cacheList.push(name);
                            }

                            return;
                        }
                    }

                    var item = utils.getTreeItem(slideMenu, 'name', name);

                    if (item) {
                        tabs.push({
                            name: name,
                            label: item.title,
                            show: true
                        });

                        activeName = name;

                        cacheList.push(name);
                    }
                }
            },
            handleTabClick: function (name) {
                if (this.activeName != name) {
                    this.activeName = name;
                }
            },
            handleTabsClear: function () {
                if (this.activeName != 'home') {
                    this.activeName = 'home';
                }
                this.tabs = [];
                this.cacheList = [];
            },
            handleTabRemove: function (name) {
                with (this) {
                    var pre = 'home';
                    tabs.map(function (item, index) {
                        if (item.name == name) {
                            item.show = false;

                            var array = [];
                            cacheList.forEach(function (t, number) {
                                if (t != name) {
                                    array.push(t);
                                }
                            });

                            cacheList = array;

                            return;
                        }

                        if (item.show) {
                            pre = item.name;
                        }
                    });

                    activeName = pre;
                }
            },
            turnToPage: function (name) {

                with (this) {
                    $router.push({
                        name: name
                    });

                    if (name == 'home') {
                        openNames = [];
                    }
                    else {
                        slideMenu.forEach(function (t) {
                            for (var i = 0; i < t.children.length; i++) {
                                if (t.children[i].name == name) {
                                    var array = [];
                                    array.push(t.name);

                                    openNames = array;
                                    return;
                                }
                            }
                        })
                    }
                }
            }
        }
    });
</script>

<#include "footer.ftl">