<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>登陆</title>
</head>
<body>
<h1>登陆</h1>
<form method="post" action="/sysUser/login">
    <div>
        用户名：<input type="text" name="name">
    </div>
    <div>
        密码：<input type="password" name="password">
    </div>
    <#--<div>
        <input type="text" class="form-control" name="verifyCode" required="required" placeholder="验证码">
        <img src="getVerifyCode" title="看不清，请点我" onclick="refresh(this)" onmouseover="mouseover(this)" />
    </div>-->
    <div>
        <#--<label><input type="checkbox" name="remember-me"/>自动登录</label>-->
        <button type="submit">立即登陆</button>
    </div>
</form>
<br>
<#--<form method="post" action="/sms/login">
    <div>
        手机号：<input type="text" id="phone" name="phone" value="jitwxs">
    </div>
    <div>
        验证码：<input type="text" name="smsCode">
        <a href="javascript:;" onclick="sendSms()">获取验证码</a>
    </div>
    <div>
        <button type="submit">立即登陆</button>
    </div>
</form>-->
<script>
    function refresh(obj) { obj.src = "getVerifyCode?" + Math.random(); }

    function mouseover(obj) { obj.style.cursor = "pointer"; }

    function sendSms() {
        window.location.href = '/sms/code?phone=' + document.getElementById("phone").value;
    }
</script>

</body>
</html>