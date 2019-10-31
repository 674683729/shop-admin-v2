<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>飞狐电商后台管理登录</title>

    <link rel="stylesheet" type="text/css" href="/js/login/css/normalize.css" />
    <link rel="stylesheet" type="text/css" href="/js/login/css/default.css">
    <link rel="stylesheet" type="text/css" href="/js/login/css/styles.css">
    <link href="/js/login/layui/css/modules/layer/default/layer.css" rel="stylesheet">
</head>
<body>
<div id="logo">
    <h1 class="hogo"><i>飞狐电商后台管理登录</i></h1>
</div>
<section class="stark-login">
    <form action="">
        <div id="fade-box">
            <input type="text" id="userName" placeholder="用户名" required>
            <input type="password" id="password" placeholder="密码" required>
            <button onclick="login()" type="button">登录</button><br/>
            <a href="/user/toFindPassword.gyh" style="float: right;">忘记密码?点击找回</a>
        </div>

    </form>
</section>
<div id="circle1">
    <div id="inner-cirlce1">
        <h2> </h2>
    </div>
</div>
<ul>
    <li></li>
    <li></li>
    <li></li>
    <li></li>
    <li></li>
</ul>


<script type="text/javascript" src="/js/commons/jquery-3.3.1.js"></script>
<script src='/js/login/js/prefixfree.min.js'></script>
<script type="text/javascript" src="/js/login/layui/layui.all.js"></script>
<script>
    $(function () {

    })

    //登陆
    function login(){
        //获取用户名 密码
        var userName=$("#userName").val();
        var password=$("#password").val();
        if (userName == '' || password == '') {
            layer.msg("用户名和密码不能为空!");
            return;
        }else {
            $.ajax({
                url:"/user/login.gyh",
                data:{"userName":userName,"password":password},
                type:"post",
                success:function (res) {
                    if (res.code==200) {
                        layer.msg("登录成功!");
                        location.href="/admin/toIndex.gyh";
                    }else{
                        layer.msg(res.msg);
                    }
                },
                error:function () {
                    layer.msg("登录请求失败!");
                }
            })
        }
    }

</script>
</body>
</html>