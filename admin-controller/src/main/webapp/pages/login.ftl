<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>白板狗鱼</title>
    <link rel="stylesheet" href="../resources/iView/iview.css">
    <link rel="stylesheet" href="../resources/base/base.css">

    <script type="text/javascript" src="../resources/iView/vue.min.js"></script>
    <script type="text/javascript" src="../resources/iView/vue-router.js"></script>
    <script type="text/javascript" src="../resources/iView/vuex.js"></script>
    <script type="text/javascript" src="../resources/iView/iview.min.js"></script>
    <script type="text/javascript" src="../resources/jquery/jquery-3.2.1.min.js"></script>
    <script type="text/javascript" src="../resources/jquery/jquery-resize.js"></script>
    <script type="text/javascript" src="../resources/plugin/Sortable.js"></script>
    <script type="text/javascript" src="../resources/plugin/wangEditor.min.js"></script>
    <script type="text/javascript" src="../resources/plugin/VirtualScrollList.js"></script>
    <script type="text/javascript" src="../resources/base/base.js"></script>
    <script type="text/javascript" src="../resources/base/store.js"></script>
    <style type="text/css">
        body{
            background: #2d8cf0;
        }
        .test{
            display: flex;
            width:500px;
            height: 500px;
            margin:0 auto;
            -webkit-align-items: center;
            align-items: center;
            justify-content: center;
        }
    </style>
</head>
<body>
    <div id="login" class="auto-height test" >
        <i-form v-ref:form-inline :model="form">
            <Form-item  inline>
                <i-input v-model="form.name" placeholder="请输入用户名..." style="width: 300px"></i-input>
            </Form-item>

            <Form-item  inline>
                <i-input type="password" v-model="form.password" placeholder="请输入密码..." style="width: 300px"></i-input>
            </Form-item>
            <Form-item inline>
                <i-button type="success" @click="handleSubmit('form')" :loading="loading" style="width: 300px">登陆</i-button>
            </Form-item>
        </i-form>
    </div>
<script>
    new Vue({
        el: '#login',
        data: function(){
            var vm = this;
            return {
                visible: false,
                form: {
                    name: null,
                    password: null
                },
                loading: false
            }
        },
        methods: {
            handleSubmit: function(name) {
                with (this) {
                    loading = true;
                    if (utils.isEmpty(form.name)){
                        $Message.error('请输入用户名！');
                        loading = false;
                        return;
                    }
                    if (utils.isEmpty(form.password)){
                        $Message.error('请输入密码！');
                        loading = false;
                        return;
                    }
                    utils.post('${contextPath}/sysUser/login', form, function (result) {
                        if (result.success) {
                            // this.$Message.success('操作成功');
                            window.location.href="/";
                        }
                        else {
                            loading = false;
                            $Message.error(result.msg);
                        }
                    }, $data, 'modalLoading')
                }
            }
        }
    })
</script>
</body>
</html>