var router = new VueRouter({
    mode: 'history',
    routes: [{
        path: '/',
        name: 'home',
        component: home
    }/*, {
        path: '/product',
        name: 'product',
        component: product
    }, {
        path: '/productDic',
        name: 'productDic',
        component: productDic
    }, {
        path: '/category',
        name: 'category',
        component: category
    }, {
        path: '/supplier',
        name: 'supplier',
        component: supplier
    }, {
        path: '/buyer',
        name: 'buyer',
        component: buyer
    }, {
        path: '/marketActivity',
        name: 'marketActivity',
        component: marketActivity
    }, {
        path: '/topic',
        name: 'topic',
        component: topic
    }, {
        path: '/memberShip',
        name: 'memberShip',
        component: memberShip
    }*/, {
        path: '/order',
        name: 'order',
        component: order
    }, {
        path: '/refund',
        name: 'refund',
        component: refund
    }, {
        path: '/pvStatistic',
        name: 'pvStatistic',
        component: pvStatistic
    }, {
        path: '/user',
        name: 'user',
        component: user
    }, {
        path: '/role',
        name: 'role',
        component: role
    }, {
        path: '/resource',
        name: 'resource',
        component: resource
    }/*, {
        path: '/taskRule',
        name: 'taskRule',
        component: taskRule
    }, {
        path: '/appModule',
        name: 'appModule',
        component: appModule
    }, {
        path: '/systemCategory',
        name: 'systemCategory',
        component: systemCategory
    }, {
        path: '/comment',
        name: 'comment',
        component: comment
    }, {
        path: '/rightslist',
        name: 'rightslist',
        component: rightslist
    }, {
        path: '/recommend',
        name: 'recommend',
        component: recommend
    }*/]
});