<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>找回密码页面</title>
    <jsp:include page="/common/head.jsp"></jsp:include>
</head>
<body>
<div class="container" >
    <div class="row">
        <div class="panel panel-warning" id="search_form">
            <div class="panel-heading">找回用户密码</div>
            <div class="panel-body">
                <form class="form-horizontal" >

                    <div class="form-group">
                        <label class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-4">
                            <input type="text" class="form-control" id="email" placeholder="请输入邮箱找回密码..."/>
                        </div>
                    </div>

                    <%--<div class="form-group">
                        <label class="col-sm-2 control-label">验证码</label>
                        <div class="col-sm-4">
                            <input type="password" class="form-control" id="code" placeholder="请输入验证..."/>
                        </div>
                        <button>点击获取验证码</button>
                    </div>--%>

                    <div style="text-align: center">
                        <button class="btn btn-primary" type="button" onclick="findPassword()"><i class="glyphicon glyphicon-search"></i>找回密码</button>
                        <button class="btn btn-default" type="reset"><i class="glyphicon glyphicon-refresh"></i>重置</button>
                    </div>
                </form>

            </div>
        </div>
    </div>
</div>

<jsp:include page="/common/script.jsp"></jsp:include>
<script>

    //找回密码
    function findPassword() {
        var email = $("#email").val();

        if (email == ''){
            bootbox.alert({
                message:'<span class="glyphicon glyphicon-exclamation-sign">请输入邮箱!</span>',
                size:"small",
            })
            return;
        }

        $.ajax({
            url:"/user/findPassword.gyh",
            data:{"email":email},
            type:"post",
            success:function (res) {
                if (res.code == 200){
                    bootbox.alert({
                        message:'<span class="glyphicon glyphicon-ok"></span>密码找回成功,已发送至您的邮箱!点击确定前往登陆.',
                        size:"small",
                        callback:function (res) {
                            location.href="/";
                        }
                    })
                }else{
                    bootbox.alert({
                        message:'<span class="glyphicon glyphicon-remove"></span>'+res.msg,
                        size:"small",
                    })
                }
            },
            error:function (res) {
                alert("请求失败")
            }
        })

    }



</script>
</body>
</html>
