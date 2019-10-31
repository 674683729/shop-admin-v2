<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>修改用户密码页面</title>
    <jsp:include page="/common/head.jsp"></jsp:include>
</head>
<body>
<jsp:include page="/common/nav-static.jsp"></jsp:include>
<div class="container" >
    <div class="row">
        <div class="panel panel-warning" id="search_form">
            <div class="panel-heading">修改用户密码</div>
            <div class="panel-body">
                <form class="form-horizontal" >
                    <div class="form-group">
                        <label class="col-sm-2 control-label">旧密码</label>
                        <div class="col-sm-4">
                            <input type="password" class="form-control" id="oldPassword" placeholder="请输入旧密码...">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">新密码</label>
                        <div class="col-sm-4">
                            <input type="password" class="form-control" id="newPassword" placeholder="请输入新密码..">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">确认密码</label>
                        <div class="col-sm-4">
                            <input type="password" class="form-control" id="confirmPassword" placeholder="请输入确认密码..."/>
                        </div>
                    </div>

                    <div style="text-align: center">
                        <button class="btn btn-primary" type="button" onclick="updatePassword()"><i class="glyphicon glyphicon-ok"></i>修改</button>
                        <button class="btn btn-default" type="reset"><i class="glyphicon glyphicon-refresh"></i>重置</button>
                    </div>
                </form>

            </div>
        </div>
    </div>
</div>

<jsp:include page="/common/script.jsp"></jsp:include>
<script>

    //修改密码
    function updatePassword () {
      var oldPassword = $("#oldPassword").val();
      var newPassword = $("#newPassword").val();
      var confirmPassword = $("#confirmPassword").val();

      if (oldPassword == ''){
          bootbox.alert({
              message:'<span class="glyphicon glyphicon-exclamation-sign">请输入旧密码!</span>',
              size:"small",
          })
          return;
      }
      if (newPassword == '' || confirmPassword == '') {
          bootbox.alert({
              message:'<span class="glyphicon glyphicon-exclamation-sign">请输入两次新密码!</span>',
              size:"small",
          })
          return;
      }
      if (newPassword != confirmPassword){
          bootbox.alert({
              message:'<span class="glyphicon glyphicon-exclamation-sign">两次新密码不一致!</span>',
              size:"small",
          })
          return;
      }

      var id=${user.id};
      $.ajax({
          url:"/user/updatePassword.gyh",
          data:{"id":id,"oldPassword":oldPassword,"newPassword":newPassword,"confirmPassword":confirmPassword},
          type:"post",
          success:function (res) {
              if (res.code == 200){
                  $("#oldPassword").val("");
                  $("#newPassword").val("");
                  $("#confirmPassword").val("");
                  bootbox.alert({
                      message:"修改成功",
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
