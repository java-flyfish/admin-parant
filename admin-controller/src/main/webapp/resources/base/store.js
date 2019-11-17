var store = new Vuex.Store({
    state: {
        appList: [],
        categoryList: [],
        supplierList: [],
        buyerList: [],
        expressList: [],
        productDicList: [],
        skuAttrList: [],
        payChannelList: [],
        postageTempletList: [],

        systemCategoryList: [],

        appMap: {},
        categoryMap: {},
        supplierMap: {},
        buyerMap: {},
        expressMap: {},
        productDicMap: {},
        skuAttrMap: {},
        payChannelMap: {},
        postageTempletMap: {}
    },
    mutations: {
        initAppList: function (state, data) {
            state.appList = data;
        },
        initCategoryList: function (state, data) {
            state.categoryList = data;
        },
        initSupplierList: function (state, data) {
            state.supplierList = data;
        },
        initBuyerList: function (state, data) {
            state.buyerList = data;
        },
        initExpressList: function (state, data) {
            state.expressList = data;
        },
        initProductDicList: function (state, data) {
            state.productDicList = data;
        },
        initSkuAttrList: function (state, data) {
            state.skuAttrList = data;
        },
        initPayChannelList: function (state, data) {
            state.payChannelList = data;
        },
        initPostageTempletList: function (state, data) {
            state.postageTempletList = data;
        },
        initSystemCategoryList: function (state, data) {
            state.systemCategoryList = data;
        },

        initAppMap: function (state, data) {
            state.appMap = data;
        },
        initCategoryMap: function (state, data) {
            state.categoryMap = data;
        },
        initSupplierMap: function (state, data) {
            state.supplierMap = data;
        },
        initBuyerMap: function (state, data) {
            state.buyerMap = data;
        },
        initExpressMap: function (state, data) {
            state.expressMap = data;
        },
        initProductDicMap: function (state, data) {
            state.productDicMap = data;
        },
        initSkuAttrMap: function (state, data) {
            state.skuAttrMap = data;
        },
        initPayChannelMap: function (state, data) {
            state.payChannelMap = data;
        },
        initPostageTempletMap: function (state, data) {
            state.postageTempletMap = data;
        }
    },
    actions: {
        loadAppList: function (context) {
            $.get(store.contextPath + '/appInfo/listAll', {
                type: 1,
                isEnable: true
            }, function (result) {
                if (result.success) {

                    context.commit('initAppList', result.data);

                    var map = {};
                    utils.listToMap(map, result.data, 'id');

                    context.commit('initAppMap', map);
                }
            });
        },
        loadCategoryList: function (context) {
            $.get(store.contextPath + '/category/listTree', {}, function (result) {
                if (result.success) {

                    var map = {};
                    result.data.forEach(function (t) {

                        map[t.value] = {
                            label: t.label
                        };

                        if (t.children) {
                            t.children.forEach(function (t2) {
                                map[t2.value] = {
                                    pid: t2.pid,
                                    label: t2.label
                                };
                            });
                        }

                    });

                    context.commit('initCategoryMap', map);

                    context.commit('initCategoryList', result.data);
                }
            });
        },
        loadSupplierList: function (context) {
            $.get(store.contextPath + '/supplier/listAll', {}, function (result) {
                if (result.success) {

                    context.commit('initSupplierList', result.data);

                    var map = {};
                    utils.listToMap(map, result.data, 'id');

                    context.commit('initSupplierMap', map);
                }
            });
        },
        loadBuyerList: function (context) {
            $.get(store.contextPath + '/buyer/listAll', {}, function (result) {
                if (result.success) {
                    context.commit('initBuyerList', result.data);

                    var map = {};
                    utils.listToMap(map, result.data, 'id');

                    context.commit('initBuyerMap', map);

                }
            });
        },
        loadExpressList: function (context) {
            $.get(store.contextPath + '/express/listAll', {}, function (result) {
                if (result.success) {

                    context.commit('initExpressList', result.data);

                    var map = {};
                    utils.listToMap(map, result.data, 'id');

                    context.commit('initExpressMap', map);
                }
            });
        },
        loadProductDicList: function (context) {
            $.get(store.contextPath + '/productDic/listTree', {}, function (result) {
                if (result.success) {

                    var productDicList = [];
                    var skuAttrList = [];

                    result.data.forEach(function (t) {
                        if (t.name == 'skuAttr') {
                            skuAttrList = t.children;
                        }
                        else {
                            productDicList.push(t);
                        }
                    });

                    context.commit('initProductDicList', productDicList);
                    context.commit('initSkuAttrList', skuAttrList);

                    var productDicMap = {};
                    utils.listToMap(productDicMap, productDicList, 'id');

                    var skuAttrMap = {};
                    utils.listToMap(skuAttrMap, skuAttrList, 'id');

                    context.commit('initProductDicMap', productDicMap);
                    context.commit('initSkuAttrMap', skuAttrMap);

                }
            });
        },
        loadPostageTempletList: function (context) {
            $.get(store.contextPath + '/postageTemplet/listAll', {}, function (result) {
                if (result.success) {

                    context.commit('initPostageTempletList', result.data);

                    var map = {};
                    utils.listToMap(map, result.data, 'id');

                    context.commit('initPostageTempletMap', map);
                }
            });
        },
        loadPayChannelList: function (context) {
            $.get(store.contextPath + '/systemDic/listAll', {
                name: 'payChannel'
            }, function (result) {
                if (result.success) {

                    context.commit('initPayChannelList', result.data);

                    var map = {};
                    utils.listToMap(map, result.data, 'value');

                    context.commit('initPayChannelMap', map);
                }
            });
        },
        loadSystemCategoryList: function (context) {
            $.get(store.contextPath + '/systemCategory/listTreeForWeb', {}, function (result) {
                if (result.success) {
                    context.commit('initSystemCategoryList', result.data);
                }
            });
        },
        init: function (context) {
            store.dispatch('loadAppList');
            store.dispatch('loadCategoryList');
            store.dispatch('loadSupplierList');
            store.dispatch('loadBuyerList');
            store.dispatch('loadExpressList');
            store.dispatch('loadProductDicList');
            store.dispatch('loadPostageTempletList');
            store.dispatch('loadPayChannelList');
            store.dispatch('loadSystemCategoryList');
        }
    }
});