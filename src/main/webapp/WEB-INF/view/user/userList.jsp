<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>用户展示</title>
    <jsp:include page="/common/head.jsp"></jsp:include>
</head>
<body>
<jsp:include page="/common/nav-static.jsp"></jsp:include>
<div class="container" >
    <div class="row">
        <div class="panel panel-warning" id="search_form">
            <div class="panel-heading">用户查询</div>
            <div class="panel-body">
                <form class="form-horizontal" >
                    <div class="form-group">
                        <label for="userName" class="col-sm-2 control-label">用户名</label>
                        <div class="col-sm-4">
                            <input type="text" class="form-control" name="userName" id="userName" placeholder="请输入用户名...">
                        </div>
                        <label for="realName" class="col-sm-2 control-label">真实姓名</label>
                        <div class="col-sm-4">
                            <input type="text" class="form-control" name="realName" id="realName" placeholder="请输入真实姓名...">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">年龄范围</label>
                        <div class="col-sm-4">
                            <div class="input-group">
                                <input type="text" class="form-control" name="minAge" id="minAge" placeholder="开始年龄...">
                                <span class="input-group-addon"><i class="glyphicon glyphicon-transfer"></i></span>
                                <input type="text" class="form-control" name="maxAge" id="maxAge" placeholder="结束年龄...">
                            </div>
                        </div>
                        <label class="col-sm-2 control-label">薪资范围</label>
                        <div class="col-sm-4">
                            <div class="input-group">
                                <input type="text" class="form-control" name="minPay" id="minPay" placeholder="最低薪资...">
                                <span class="input-group-addon"><i class="glyphicon glyphicon-usd"></i></span>
                                <input type="text" class="form-control" name="maxPay" id="maxPay" placeholder="最高薪资...">
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">入职时间</label>
                        <div class="col-sm-4">
                            <div class="input-group">
                                <input type="text" class="form-control" name="minEntryTime" id="minEntryTime" placeholder="开始时间...">
                                <span class="input-group-addon"><i class="glyphicon glyphicon-calendar"></i></span>
                                <input type="text" class="form-control" name="maxEntryTime" id="maxEntryTime" placeholder="结束时间...">
                            </div>
                        </div>
                        <label class="col-sm-2 control-label">角色</label>
                        <div class="col-sm-4">
                            <div class="input-group" id="search_roleDiv">

                            </div>
                        </div>
                    </div>

                    <div style="text-align: center">
                        <button class="btn btn-primary" type="button" onclick="search()"><i class="glyphicon glyphicon-search"></i>查询</button>
                        <button class="btn btn-default" type="reset"><i class="glyphicon glyphicon-refresh"></i>重置</button>
                    </div>
                </form>

            </div>
        </div>
    </div>

    <div class="row" style="background-color:#e4b9b9; width: 102.7%">
        <button class="btn btn-info" onclick="addUser()"><i class="glyphicon glyphicon-plus"></i>新增用户</button>
        <button class="btn btn-danger" onclick="batchDelete()"><i class="glyphicon glyphicon-trash"></i>批量删除</button>
        <button class="btn btn-primary" onclick="excelExpord()"><i class="glyphicon glyphicon-download-alt"></i>Excel导出</button>
        <button class="btn btn-primary" onclick="wordExpord()"><i class="glyphicon glyphicon-download-alt"></i>work导出</button>
        <button class="btn btn-primary" onclick="pdfExpord()"><i class="glyphicon glyphicon-download-alt"></i>pdf导出</button>
    </div>

    <div class="row">
        <div class="panel panel-primary">
            <div class="panel-heading">用户展示</div>
            <table id="userTable" class="table table-striped table-bordered" style="width:100%">
                <thead>
                <tr>
                    <th style="text-align:center">选择</th>
                    <th style="text-align:center">用户名</th>
                    <th style="text-align:center">真实姓名</th>
                    <th style="text-align:center">性别</th>
                    <th style="text-align:center">年龄</th>
                    <th style="text-align:center">状态</th>
                    <th style="text-align:center">电话</th>
                    <th style="text-align:center">Email</th>
                    <th style="text-align:center">薪资</th>
                    <th style="text-align:center">头像</th>
                    <th style="text-align:center">入职时间</th>
                    <th style="text-align:center">角色</th>
                    <th style="text-align:center">操作</th>
                </tr>
                </thead>
                <tbody style="text-align: center;"></tbody>
                <tfoot>
                <tr>
                    <th style="text-align:center">选择</th>
                    <th style="text-align:center">用户名</th>
                    <th style="text-align:center">真实姓名</th>
                    <th style="text-align:center">性别</th>
                    <th style="text-align:center">年龄</th>
                    <th style="text-align:center">状态</th>
                    <th style="text-align:center">电话</th>
                    <th style="text-align:center">Email</th>
                    <th style="text-align:center">薪资</th>
                    <th style="text-align:center">头像</th>
                    <th style="text-align:center">入职时间</th>
                    <th style="text-align:center">角色</th>
                    <th style="text-align:center">操作</th>
                </tr>
                </tfoot>
            </table>

        </div>
    </div>
</div>

    <!-- 新增form表单 -->
    <div id="addUserDiv"  style="display: none" method="post">
        <form id="add_form" class="form-horizontal" role="form">
            <div class="form-group">
                <label class="col-sm-2 control-label">用户名称</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control" name="add_userName" id="add_userName" placeholder="请输入用户名...">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">密码</label>
                <div class="col-sm-4">
                    <input type="password" class="form-control" name="add_password" id="add_password" placeholder="请输入密码...">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">确认密码</label>
                <div class="col-sm-4">
                    <input type="password" class="form-control" name="add_affirmPassword" id="add_confirmPassword" placeholder="请输入确认密码...">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">真实姓名</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control" name="add_realName" id="add_realName" placeholder="请输入真实姓名...">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">性别</label>
                <div class="col-sm-4">
                    <input type="radio" name="add_sex" value="1"> 男
                    <input type="radio" name="add_sex" value="0"> 女
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">年龄</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control" name="add_age" id="add_age" placeholder="请输入年龄...">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">手机号</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control" name="add_phone" id="add_phone" placeholder="请输入电话...">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">邮箱</label>
                <div class="col-sm-4">
                    <input type="email" class="form-control" name="add_email" id="add_email" placeholder="请输入Email...">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">薪资</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control" name="add_pay" id="add_pay" placeholder="请输入薪资...">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">入职时间</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control" name="add_entryTime" id="add_entryTime" placeholder="请输入入职时间...">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">角色</label>
                <div class="col-sm-4">
                    <div class="input-group" id="add_roleDiv">
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">头像</label>
                <div class="col-sm-4">
                    <input type="file" name="myfile" data-ref="add_photo"
                           class="col-sm-4 myfile" value=""/>
                    <input type="hidden" name="add_photo" value="">
                </div>
                <span style="display: none;" id="add_photo"></span>
            </div>
        </form>
    </div>

    <!-- 修改form表单 -->
    <div id="updateUserDiv" style="display: none">
        <form id="update_form" class="form-horizontal">
            <div class="form-group">
                <label class="col-sm-2 control-label">用户名称</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control" name="update_userName" id="update_userName" placeholder="请输入用户名...">
                </div>
            </div>

            <div class="form-group">
                <label class="col-sm-2 control-label">真实姓名</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control" name="update_realName" id="update_realName" placeholder="请输入真实姓名...">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">性别</label>
                <div class="col-sm-4">
                    <input type="radio" name="update_sex" value="1">男
                    <input type="radio" name="update_sex" value="0">女
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">年龄</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control" name="update_age" id="update_age" placeholder="请输入年龄...">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">手机号</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control" name="update_phone" id="update_phone" placeholder="请输入电话...">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">邮箱</label>
                <div class="col-sm-4">
                    <input type="email" class="form-control" name="update_email" id="update_email" placeholder="请输入Email...">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">薪资</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control" name="update_pay" id="update_pay" placeholder="请输入薪资...">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">入职时间</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control" name="update_entryTime" id="update_entryTime" placeholder="请输入入职时间...">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">角色</label>
                <div class="col-sm-4">
                    <div class="input-group" id="update_roleDiv">
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">头像</label>
                <div class="col-sm-4">
                    <input type="file" name="myfile" data-ref="update_photo"
                           class="col-sm-4 myfile" value=""/>
                    <input type="hidden" name="update_photo" value="">
                </div>
                <span style="display: none;" id="update_photo"></span>
            </div>
        </form>
    </div>

<jsp:include page="/common/script.jsp"></jsp:include>
<script>


    var v_addUserDiv;
    var v_updateUserDiv;
    //页面加载函数
    $(function(){
        initUserTable();//分页查询
        copyForm();//备份新增修改form表单
        initDatetimepicker();//日期插件
        entrtyTime();//条件查询日期插件
        roleSelect("add");//拼接新增角色下拉框
        //roleSelect("update");//拼接修改角色下拉框
        roleSelect("search");//角色下拉框条件查询
        initBindEvent();//加入事件
        initFileInput();//删除图片
        initValidateAddForm();//新增表单验证
        initValidateUpdateForm();//修改表单验证
        initValidateSearchForm();//条件查询表单验证

    });


    //角色下拉框
    function roleSelect(str){
        $.ajax({
            url:"/role/roleList.gyh",
            data:"",
            dataType:"json",
            type:"post",
            success:function(res){
                var dataList=res.data;
                var html = '<select id=\''+str+'_roleSelect\' name=\''+str+'_roleSelect\' titile="请选择角色..." multiple>';
                for (var i = 0; i < dataList.length; i++) {
                    html += '<option value="'+dataList[i].id+'">'+dataList[i].roleName+'</option>';
                }
                html += '</select>';
                $('#'+str + '_roleDiv').html(html);
                $( '#'+str+'_roleSelect').selectpicker();
            }
        })
    }

    //备份form表单
    function copyForm() {
        //备份新增的form表单
        v_addUserDiv=$("#addUserDiv").html();
        //备份修改的form表单
        v_updateUserDiv=$("#updateUserDiv").html();
    }

    //分页查询
    var userTable;
    function initUserTable(){
        userTable=$('#userTable').DataTable({
            "language": {
                "url": "/js/commons/Chinese.json"
            },
            // 是否允许检索
            "searching": false,
            // 件数选择下拉框内容
            "lengthMenu": [5, 10, 15, 20, 2],
            "processing": true,
            "serverSide": true,
            "ajax": {
                "url": "/user/findUserList.gyh",
                "type": "POST",

            },
            "columns": [
                { "data": "id" ,
                    "render": function (data, type, row, meta) {
                        return "<input type=\"checkbox\" value=\""+data+"\">"+data+"";
                    }},
                { "data": "userName" },
                { "data": "realName" },
                { "data": "sex",
                    "render":function (data,type,row,meta) {
                        return data==1?"男":"女";
                    }},
                { "data": "age" },
                { "data": "lock" ,
                    "render":function (data) {
                        return data?"锁定":"正常";
                    }},
                { "data": "phone" },
                { "data": "email" },
                { "data": "pay" },
                { "data": "photo",
                    "render":function (data,type,row,meta) {
                        return "<img width='80px' src='http://192.168.124.53/"+data+"'/>";
                    }
                },
                { "data": "entryTime"},
                { "data": "roleNames"},
                { "data": "id",
                    "render": function (data, type, row, meta) {
                        return "<div class=\"btn-group\" role=\"group\" aria-label=\"...\">\n" +
                                    "<button type=\"button\" class=\"btn btn-primary\" onclick=\"updateUser("+data+")\"><i class=\"glyphicon glyphicon-pencil\"></i>修改用户</button>\n" +
                                    "<button class=\"btn btn-danger\" onclick=\"deleteUser("+data+")\"><i class=\"glyphicon glyphicon-trash\"></i>删除用户</button>\n" +
                                    "<button class=\""+(row.lock?'btn btn-success':'btn btn-warning')+"\" onclick=\"updateLock("+data+","+row.lock+")\"><i class=\"glyphicon glyphicon-cog\"></i>"+(row.lock?"解锁用户":"锁定用户")+"</button>\n" +
                                    "<button class=\"btn btn-info\" onclick=\"updateResultPassword("+data+")\"><i class=\"glyphicon glyphicon-refresh\"></i>重置密码</button>\n" +
                                "</div>";

                    }
                }
            ],
            // 每一行创建完调用的函数
            "createdRow": function (row, data, dataIndex) {
                //row <tr></tr>  data json 格式 dataIndex 这行在本页面的坐标

            },
            // 每次DataTable描画后都要调用，调用这个函数时，table可能没有描画完成，
            // 所以不要在里面操作table的dom，要操作dom应放在initComplete
            "drawCallback": function( settings ) {
                $("table tbody tr").each(function () {
                    //获取本行的复选框
                    var checkbox=$(this).find("input[type='checkbox']");
                    //存在加选中 样式
                    for (var i=0;i<v_ids.length;i++){
                        if (v_ids[i]==checkbox.val()){
                            checkbox.prop("checked",true);
                            $(this).css("background-color","pink");
                        }
                    }
                });


            },
        });
    }

    //删除
    function deleteUser(id){
        //阻止时间冒泡
        event.stopPropagation();
        bootbox.confirm({
            message: "确定删除该用户吗?",
            size:"small",
            buttons: {
                confirm: {
                    label: '确定',
                    className: 'btn-success'
                },
                cancel: {
                    label: '取消',
                    className: 'btn-danger'
                }
            },
            callback: function (result) {
                if (result) {
                    $.ajax({
                        url:"/user/deleteUserById.gyh",
                        data:{"id":id},
                        dataType:"json",
                        type:"post",
                        success:function(result){
                            if(result.code==200){
                                bootbox.alert({
                                    message: "删除成功",
                                    size:"small",
                                    callback: function (result) {
                                        search();
                                    }
                                });
                            }
                        },
                        error:function(result){
                            bootbox.alert({
                                message: "请求失败",
                                size:"small"
                            });
                        }
                    })
                }
            }
        });

    }

    //新增
    var add_dialog;
    function addUser() {
        add_dialog = bootbox.dialog({
            title:"新增用户",
            message:$("#addUserDiv form"),
            size:"large",
            buttons:{
                cancel:{
                    label:"<i class='glyphicon glyphicon-remove'>取消</i>",
                    className:"btn-info"
                },
                add:{
                    label:"<i class='glyphicon glyphicon-plus'>新增</i>",
                    className:"btn-danger",
                    callback:function (result) {
                        var userQuery= $("#add_form",add_dialog).data('bootstrapValidator');
                        userQuery.validate();
                        //如果表单验证通过 提交新增
                        if(userQuery.isValid()){
                            var params = {};
                            params.userName = $("#add_userName",add_dialog).val();
                            params.password = $("#add_password",add_dialog).val();
                            params.realName = $("#add_realName",add_dialog).val();
                            params.realName = $("#add_realName",add_dialog).val();
                            params.sex = $("[name='add_sex']:checked",add_dialog).val();
                            params.age = $("#add_age",add_dialog).val();
                            params.phone = $("#add_phone",add_dialog).val();
                            params.email = $("#add_email",add_dialog).val();
                            params.pay = $("#add_pay",add_dialog).val();
                            params.entryTime = $("#add_entryTime",add_dialog).val();
                            params.photo = $("input[name='add_photo']",add_dialog).val();
                            var roleStr="";
                            $("#add_roleSelect option:selected",add_dialog).each(function(){
                                roleStr+=","+this.value;
                            });
                            if (roleStr.length>1){
                                params.ids=roleStr.substring(1);
                            }
                            /*alert(JSON.stringify(params));*/

                            $.post({
                                url:"/user/addUser.gyh",
                                data:params,
                                success:function (result) {
                                    if(result.code == 200){
                                        bootbox.alert({
                                            message:"新增成功",
                                            size:"small",
                                            callback: function (result) {
                                                search();//刷新
                                            }
                                        });
                                    }
                                }
                            });
                        }else{
                            return false;
                        }

                    }
                },
            }
        });
        $("#addUserDiv").html(v_addUserDiv);
        initDatetimepicker();
        roleSelect("add");//角色下拉框
        initFileInput();//上传图片
        initValidateAddForm();//新增表单验证
    }

    //重置密码
    function updateResultPassword(id) {
        //阻止事件冒泡
        event.stopPropagation();
        bootbox.confirm({
            message: "确定重置该用户密码吗?",
            size:"small",
            buttons: {
                confirm: {
                    label: '确定',
                    className: 'btn-success'
                },
                cancel: {
                    label: '取消',
                    className: 'btn-danger'
                }
            },
            callback: function (result) {
                if (result) {
                    $.ajax({
                        url:"/user/updateResultPassword.gyh",
                        data:{"id":id,},
                        dataType:"json",
                        type:"post",
                        success:function(result){
                            if(result.code==200){
                                bootbox.alert({
                                    message: "密码重置成功!",
                                    size:"small",
                                    callback: function (result) {
                                        search();
                                    }
                                });
                            }
                        },
                        error:function(result){
                            bootbox.alert({
                                message: "请求失败",
                                size:"small"
                            });
                        }
                    })
                }
            }
        });
    }

    //修改用户
    var update_dialog;
    function updateUser(id){
        //阻止时间冒泡
        event.stopPropagation();
        //还原修改的角色下拉框
        roleSelect("update");
        //通过id查询用户
        $.ajax({
            url:"/user/findUser.gyh",
            data:{"id":id},
            dataType:"json",
            type:"post",
            success:function (result) {
                if(result.code==200){
                    var userName=result.data.userName;
                    var realName=result.data.realName;
                    var sex=result.data.sex;
                    var age=result.data.age;
                    var phone=result.data.phone;
                    var email=result.data.email;
                    var pay=result.data.pay;
                    var entryTime=result.data.entryTime;
                    var roleIdList=result.data.roleIdList;
                    var photo=result.data.photo;
                    //回显角色复下拉框
                    for (var i=0;i<roleIdList.length;i++){
                        $("#update_roleSelect option").each(function () {
                            if (this.value==roleIdList[i]){
                                this.selected=true;
                            }
                        })
                    }
                    $("#update_roleSelect").selectpicker('refresh');
                    $("#update_userName").val(userName);
                    $("#update_realName").val(realName);
                    $("#update_age").val(age);
                    $("#update_phone").val(phone);
                    $("#update_email").val(email);
                    $("#update_pay").val(pay);
                    $("#update_entryTime").val(entryTime);
                    $("input[name='update_photo']").val(photo);
                    $("[name='update_sex']").each(function(){
                        if(this.value==sex){
                            this.checked=true;
                        }
                    })

                        update_dialog = bootbox.dialog({
                        title: '修改用户',
                        message:$("#updateUserDiv form"),
                        size: 'large',
                        buttons: {
                            cancel: {
                                label: '<i class="glyphicon glyphicon-off">取消</i>',
                                className: 'btn btn-info',
                                callback: function(){
                                    //取消回调函数
                                }
                            },
                            ok: {
                                label: '<i class="glyphicon glyphicon-pencil">修改</i>',
                                className: 'btn btn-danger',
                                callback: function() {
                                    var userQuery = $("#update_form", update_dialog).data('bootstrapValidator');
                                    userQuery.validate();
                                    //如果表单验证通过 提交新增
                                    if (userQuery.isValid()) {
                                        var param = {};
                                        param.id = id;
                                        param.userName = $("#update_userName", update_dialog).val();
                                        param.realName = $("#update_realName", update_dialog).val();
                                        param.sex = $("[name='update_sex']:checked", update_dialog).val();
                                        param.age = $("#update_age", update_dialog).val();
                                        param.phone = $("#update_phone", update_dialog).val();
                                        param.email = $("#update_email", update_dialog).val();
                                        param.pay = $("#update_pay", update_dialog).val();
                                        param.entryTime = $("#update_entryTime", update_dialog).val();
                                        param.photo = $("input[name='update_photo']", update_dialog).val();
                                        var roleIds = "";
                                        $("#update_roleSelect option:selected").each(function () {
                                            roleIds += "," + this.value;

                                        });
                                        param.ids = roleIds.substring(1);
                                        /*alert(JSON.stringify(param))*/
                                        $.ajax({
                                            url: "/user/updateUser.gyh",
                                            data: param,
                                            dataType: "json",
                                            type: "post",
                                            success: function (result) {
                                                if (result.code == 200) {
                                                    bootbox.alert({
                                                        message: "修改成功",
                                                        size: "small",
                                                        callback: function (result) {
                                                            search();//刷新
                                                        }
                                                    });
                                                }

                                            }
                                        })
                                    }else{
                                        return false;
                                    }
                                }
                            }
                        }
                    });
                }
            },
            error:function (result) {
                bootbox.alert({
                    message: "请求失败",
                    size:"small"
                });
            }
        })
        $("#updateUserDiv").html(v_updateUserDiv);
        initDatetimepicker();
        initFileInput();
        initValidateUpdateForm();//修改表单验证
    }

    //新增,修改form日期组件
    function initDatetimepicker(){
        //新增,修改的入职时间
        $("#add_entryTime,#update_entryTime").datetimepicker({
            format: 'YYYY-MM-DD',
            locale: 'zh-CN',
            showClear: true
        });
    }

    //条件查询时间组件
    function entrtyTime(){
        $("#minEntryTime").datetimepicker({
            format: 'YYYY-MM-DD',
            locale: 'zh-CN',
            showClear: true
        });
        $("#maxEntryTime").datetimepicker({
            format: 'YYYY-MM-DD',
            locale: 'zh-CN',
            showClear: true
        });
    }

    //条件查询
    function search(){
        var userQuery= $("#search_form").data('bootstrapValidator');
        userQuery.validate();
        //如果表单验证通过 提交新增
        if(userQuery.isValid()){
            //查询本质是刷新datatable的数据
            //获取参数信息
            var v_userName=$("#userName").val();
            var v_realName=$("#realName").val();
            var v_minAge=$("#minAge").val();
            var v_maxAge=$("#maxAge").val();
            var v_minPay=$("#minPay").val();
            var v_maxPay=$("#maxPay").val();
            var v_minEntryTime=$("#minEntryTime").val();
            var v_maxEntryTime=$("#maxEntryTime").val();
            var roleIdArr = $("#search_roleSelect").val();
            var roleIds=roleIdArr.join(",");
            //组装参数
            var v_param={};
            v_param.userName=v_userName;
            v_param.realName=v_realName;
            v_param.minAge=v_minAge;
            v_param.maxAge=v_maxAge;
            v_param.minPay=v_minPay;
            v_param.maxPay=v_maxPay;
            v_param.minEntryTime=v_minEntryTime;
            v_param.maxEntryTime=v_maxEntryTime;
            v_param.roleIds=roleIds;
            /*alert(JSON.stringify(v_param));*/
            //调用datable中的方法发送请求,传递参数,这样就能达到刷新datable的效果
            userTable.settings()[0].ajax.data=v_param;
            userTable.ajax.reload();
        }else{
            return false;
        }

    }

    //加入事件
    var v_ids=[];
    function initBindEvent() {
        //给所有行加一个单击事件
        $("table tbody").on("click","tr",function(){
            var v_checkbox=$(this).find("input[type=checkbox]");
            //获取当前行的选中状态
            var v_checked=v_checkbox.prop("checked");
            if(v_checked){
                v_checkbox.prop("checked",false);
                $(this).css("background-color","");
                var id=v_checkbox.val();
                for (var i=0;i<v_ids.length;i++){
                    if (v_ids[i]==id){
                        //splice(起始下标,个数[元素1,元素2])
                        //在数组中添加或删除任意个元素
                        v_ids.splice(i,1);
                        break;
                    }
                }
            }else{
                v_checkbox.prop("checked",true)
                $(this).css("background-color","pink");
                v_ids.push(v_checkbox.val())
            }
        })
    }

    //批量删除
    function batchDelete(){
        if(v_ids.length==0){
            bootbox.alert({
                message:"请选择要删除的用户!",
                size:"small",
            })
        }else{
            bootbox.confirm({
                message: "确定删除选中的用户吗?",
                size:"small",
                buttons: {
                    confirm: {
                        label: '<i class="glyphicon glyphicon-trash"></i>确定',
                        className: 'btn-danger'

                    },
                    cancel: {
                        label: '<i class="glyphicon glyphicon-refresh"></i>取消',
                        className: 'btn-success'
                    }
                },
                callback: function (result) {
                    if (result) {
                        $.ajax({
                            url:"/user/batchDelete.gyh",
                            type:"post",
                            dataType:"json",
                            data:{"ids":v_ids},
                            success:function(res){
                                if(res.code==200){
                                    bootbox.alert({
                                        message: "删除成功",
                                        size:"small",
                                        callback: function (result) {
                                            v_ids=[];
                                            search();//刷新
                                        }
                                    });
                                }

                            },
                        })
                    }

                }

            });
        }
    }

    //Excel导出
    function excelExpord(){
        var userName=$("#userName").val();
        var realName=$("#realName").val();
        var minAge=$("#minAge").val();
        var maxAge=$("#maxAge").val();
        var minPay=$("#minPay").val();
        var maxPay=$("#maxPay").val();
        var minEntryTime=$("#minEntryTime").val();
        var maxEntryTime=$("#maxEntryTime").val();
        var roleIdArr = $("#search_roleSelect").val();
        var roleIds=roleIdArr.join(",");
        bootbox.confirm({
            message:"确定按此条件导出Excel?",
            size:"small",
            buttons: {
                confirm: {
                    label: '确定',
                    className: 'btn-success'
                },
                cancel: {
                    label: '取消',
                    className: 'btn-danger'
                }
            },
            callback: function(result){
                if (result) {
                    location.href = "/user/excelExpord.gyh?userName=" + userName + "&realName=" + realName + "&minAge=" + minAge + "&maxAge=" + maxAge + "+" +
                        "&minPay=" + minPay + "&maxPay=" + maxPay + "&minEntryTime=" + minEntryTime + "&maxEntryTime=" + maxEntryTime + "&roleIds=" + roleIds + "";
                }
            }
        })
    }

    //pdf导出
    function pdfExpord(){
        var userName=$("#userName").val();
        var realName=$("#realName").val();
        var minAge=$("#minAge").val();
        var maxAge=$("#maxAge").val();
        var minPay=$("#minPay").val();
        var maxPay=$("#maxPay").val();
        var minEntryTime=$("#minEntryTime").val();
        var maxEntryTime=$("#maxEntryTime").val();
        var roleIdArr = $("#search_roleSelect").val();
        var roleIds=roleIdArr.join(",");
        bootbox.confirm({
            message:"确定按此条件导出Word?",
            size:"small",
            buttons: {
                confirm: {
                    label: '确定',
                    className: 'btn-success'
                },
                cancel: {
                    label: '取消',
                    className: 'btn-danger'
                }
            },
            callback: function(res){
                if (res){
                location.href="/user/pdfExpord.gyh?userName="+userName+"&realName="+realName+"&minAge="+minAge+"&maxAge="+maxAge+"+" +
                    "&minPay="+minPay+"&maxPay="+maxPay+"&minEntryTime="+minEntryTime+"&maxEntryTime="+maxEntryTime+"&roleIds="+roleIds+"";
                }
            }
        })
    }

    //word导出
    function wordExpord(){
        var userName=$("#userName").val();
        var realName=$("#realName").val();
        var minAge=$("#minAge").val();
        var maxAge=$("#maxAge").val();
        var minPay=$("#minPay").val();
        var maxPay=$("#maxPay").val();
        var minEntryTime=$("#minEntryTime").val();
        var maxEntryTime=$("#maxEntryTime").val();
        var roleIdArr = $("#search_roleSelect").val();
        var roleIds=roleIdArr.join(",");
        bootbox.confirm({
            message:"确定按此条件导出Word?",
            size:"small",
            buttons: {
                confirm: {
                    label: '确定',
                    className: 'btn-success'
                },
                cancel: {
                    label: '取消',
                    className: 'btn-danger'
                }
            },
            callback: function(res){
                if (res){
                location.href="/user/wordExpord.gyh?userName="+userName+"&realName="+realName+"&minAge="+minAge+"&maxAge="+maxAge+"+" +
                    "&minPay="+minPay+"&maxPay="+maxPay+"&minEntryTime="+minEntryTime+"&maxEntryTime="+maxEntryTime+"&roleIds="+roleIds+"";
                }
            }
        })
    }

    //图片上传
    function initFileInput(){
        $(".myfile").fileinput({
            //上传的地址
            uploadUrl:"/user/uploadPhoto.gyh",
            uploadAsync : true, //默认异步上传
            showUpload : false, //是否显示上传按钮,跟随文本框的那个
            showRemove : false, //显示移除按钮,跟随文本框的那个
            showCaption : true,//是否显示标题,就是那个文本框
            showPreview : true, //是否显示预览,不写默认为true
            dropZoneEnabled : false,//是否显示拖拽区域，默认不写为true，但是会占用很大区域
            //minImageWidth: 50, //图片的最小宽度
            //minImageHeight: 50,//图片的最小高度
            //maxImageWidth: 1000,//图片的最大宽度
            //maxImageHeight: 1000,//图片的最大高度
            //maxFileSize: 0,//单位为kb，如果为0表示不限制文件大小
            //minFileCount: 0,
            maxFileCount : 1, //表示允许同时上传的最大文件个数
            enctype : 'multipart/form-data',
            validateInitialCount : true,
            previewFileIcon : "<i class='glyphicon glyphicon-king'></i>",
            msgFilesTooMany : "选择上传的文件数量({n}) 超过允许的最大数值{m}！",
            allowedFileTypes : [ 'image' ],//配置允许文件上传的类型
            allowedPreviewTypes : [ 'image' ],//配置所有的被预览文件类型
            allowedPreviewMimeTypes : [ 'jpg', 'png', 'gif' ],//控制被预览的所有mime类型
            language : 'zh'
        })
        //异步上传返回结果处理
        $('.myfile').on('fileerror', function(event, data, msg) {
            console.log("fileerror");
            console.log(data);
        });
        //异步上传返回结果处理
        $(".myfile").on("fileuploaded", function(event, data, previewId, index) {
            if (data.response.code==200){
                var ref = $(this).attr("data-ref");
                $("input[name='" + ref + "']").val(data.response.data);
            }

        });

        //同步上传错误处理
        $('.myfile').on('filebatchuploaderror', function(event, data, msg) {
            console.log("filebatchuploaderror");
            console.log(data);
        });

        //同步上传返回结果处理
        $(".myfile").on("filebatchuploadsuccess",
            function(event, data, previewId, index) {
                console.log("filebatchuploadsuccess");
                console.log(data);
            });

        //上传前
        $('.myfile').on('filepreupload', function(event, data, previewId, index) {
            console.log("filepreupload");
            //删除之前图片

        });
    }

    //新增表单验证
    function initValidateAddForm() {
        $("#add_form").bootstrapValidator({
            message: 'This value is not valid',
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                add_userName: {
                    validators: {
                        notEmpty: {
                            message: '账号不能为空'
                        },
                        stringLength: {
                            min: 6,
                            max: 12,
                            message: '用户名长度必须在6到18位之间'
                        },
                        regexp: {
                            regexp: /^[a-zA-Z0-9_]+$/,
                            message: '只能是数字和字母以及下划线'
                        },
                        threshold: 5,//长度超过5位开始验证
                        remote: {//ajax验证。server result:{"valid",true or false}
                            url: "/user/findUserName.gyh",
                            message: '用户名已存在,请重新输入',
                            delay: 1000,//ajax刷新的时间是1秒一次
                            type: 'POST',
                            data:function () {
                                return {userName:$("#add_userName",add_dialog).val()};
                            }
                            //自定义提交数据，默认值提交当前input value

                        }
                    }

                },
                add_realName: {
                    validators: {
                        notEmpty: {
                            message: '真实姓名不能为空'
                        },
                        stringLength: {
                            min: 2,
                            max: 5,
                            message: '真实姓名长度必须在2到5位之间'
                        },
                        regexp: {
                            regexp: /^[\u4e00-\u9fa5]+$/,
                            message: '真实姓名只能是汉字'
                        },
                    }
                },
                add_password: {
                    validators: {
                        notEmpty: {
                            message: '密码不能为空'
                        },
                        stringLength: {
                            min: 6,
                            max: 8,
                            message: '密码长度必须在6到8位之间'
                        },
                        regexp: {
                            regexp: /^[a-zA-Z0-9_]+$/,
                            message: '只能是数字和字母以及下划线'
                        },
                    }
                },
                add_affirmPassword: {
                    validators: {
                        notEmpty: {
                            message: '确认密码不能为空'
                        },
                        callback: {
                            /*自定义，可以在这里与其他输入项联动校验*/
                            message: '两次密码不一致',
                            callback: function (value, validator, $field) {
                                var password = validator.getFieldElements('add_password').val();

                                if (password == value) {
                                    return true;
                                }
                                return false;
                            }
                        }
                    }
                },
                add_age: {
                    validators: {
                        notEmpty: {
                            message: '年龄不能为空'
                        },
                        stringLength: {
                            min: 1,
                            max: 3,
                            message: '年龄长度必须在1到3位之间'
                        },
                        regexp: {
                            regexp: /^\d+$/,
                            message: '年龄必须是正整数'
                        },
                    }
                },
                add_sex: {
                    validators: {
                        notEmpty: {
                            message: '性别必选'
                        },
                    }
                },
                add_phone: {
                    validators: {
                        notEmpty: {
                            message: '手机号不能为空'
                        },
                        regexp: {
                            regexp: /^1[3456789]\d{9}$/,
                            message: '手机号格式错误'
                        },
                    }
                },
                add_email: {
                    validators: {
                        notEmpty: {
                            message: '邮箱不能为空'
                        },
                        regexp: {
                            regexp: /^\w+((.\w+)|(-\w+))@[A-Za-z0-9]+((.|-)[A-Za-z0-9]+).[A-Za-z0-9]+$/,
                            message: '邮箱格式错误'
                        },
                        threshold: 5,//长度超过5位开始验证
                        remote: {//ajax验证。server result:{"valid",true or false}
                            url: "/user/findEmail.gyh",
                            message: '该邮箱已存在',
                            delay: 1000,//ajax刷新的时间是1秒一次
                            type: 'POST',
                            data:function () {
                                return {email:$("#add_email",add_dialog).val()};
                            }
                            //自定义提交数据，默认值提交当前input value

                        }
                    }
                },
                add_pay: {
                    validators: {
                        notEmpty: {
                            message: '薪资不能为空'
                        },
                    }
                },


            }
        })

    }

    //修改表单验证
    function initValidateUpdateForm() {
        $("#update_form").bootstrapValidator({
            message: 'This value is not valid',
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                update_userName: {
                    validators: {
                        notEmpty: {
                            message: '账号不能为空'
                        },
                        stringLength: {
                            min: 6,
                            max: 12,
                            message: '用户名长度必须在6到18位之间'
                        },
                        regexp: {
                            regexp: /^[a-zA-Z0-9_]+$/,
                            message: '只能是数字和字母以及下划线'
                        },
                    }

                },
                update_realName: {
                    validators: {
                        notEmpty: {
                            message: '真实姓名不能为空'
                        },
                        stringLength: {
                            min: 2,
                            max: 5,
                            message: '真实姓名长度必须在2到5位之间'
                        },
                        regexp: {
                            regexp: /^[\u4e00-\u9fa5]+$/,
                            message: '真实姓名只能是汉字'
                        },
                    }
                },
                update_password: {
                    validators: {
                        notEmpty: {
                            message: '密码不能为空'
                        },
                        stringLength: {
                            min: 6,
                            max: 8,
                            message: '密码长度必须在6到8位之间'
                        },
                        regexp: {
                            regexp: /^[a-zA-Z0-9_]+$/,
                            message: '只能是数字和字母以及下划线'
                        },
                    }
                },
                update_affirmPassword: {
                    validators: {
                        notEmpty: {
                            message: '确认密码不能为空'
                        },
                        callback: {
                            /*自定义，可以在这里与其他输入项联动校验*/
                            message: '两次密码不一致',
                            callback: function (value, validator, $field) {
                                var password = validator.getFieldElements('add_password').val();

                                if (password == value) {
                                    return true;
                                }
                                return false;
                            }
                        }
                    }
                },
                update_age: {
                    validators: {
                        notEmpty: {
                            message: '年龄不能为空'
                        },
                        stringLength: {
                            min: 1,
                            max: 3,
                            message: '年龄长度必须在1到3位之间'
                        },
                        regexp: {
                            regexp: /^\d+$/,
                            message: '年龄必须是正整数'
                        },
                    }
                },
                update_sex: {
                    validators: {
                        notEmpty: {
                            message: '性别必选'
                        },
                    }
                },
                update_phone: {
                    validators: {
                        notEmpty: {
                            message: '手机号不能为空'
                        },
                        regexp: {
                            regexp: /^1[3456789]\d{9}$/,
                            message: '手机号格式错误'
                        },
                    }
                },
                update_email: {
                    validators: {
                        notEmpty: {
                            message: '邮箱不能为空'
                        },
                        regexp: {
                            regexp: /^\w+((.\w+)|(-\w+))@[A-Za-z0-9]+((.|-)[A-Za-z0-9]+).[A-Za-z0-9]+$/,
                            message: '邮箱格式错误'
                        },
                        /*threshold: 5,//长度超过5位开始验证
                        remote: {//ajax验证。server result:{"valid",true or false}
                            url: "/user/findEmail.gyh",
                            message: '该邮箱已存在',
                            delay: 1000,//ajax刷新的时间是1秒一次
                            type: 'POST',
                            data:function () {
                                return {email:$("#update_email",update_dialog).val()};
                            }
                            //自定义提交数据，默认值提交当前input value

                        }*/
                    }
                },
                update_pay: {
                    validators: {
                        notEmpty: {
                            message: '薪资不能为空'
                        },
                    }
                },


            }
        })

    }

    //条件查询表单验证
    function initValidateSearchForm() {
        $("#search_form").bootstrapValidator({
            message: 'This value is not valid',
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                userName: {
                    trigger: 'change', //失去焦点就会触发,
                    validators: {
                        regexp: {
                            regexp: /^[a-zA-Z0-9_]+$/,
                            message: '只能是数字和字母以及下划线'
                        },
                    }
                },
                realName: {
                    validators: {
                        regexp: {
                            regexp: /^[\u4e00-\u9fa5]+$/,
                            message: '真实姓名只能是汉字'
                        },
                    }
                },
                minAge: {
                    validators: {
                        stringLength: {
                            min: 1,
                            max: 2,
                            message: '年龄范围为1-99'
                        },
                        regexp: {
                            regexp: /^\d+$/,
                            message: '年龄必须是正整数'
                        },
                    }
                },
                maxAge: {
                    validators: {
                        stringLength: {
                            min: 1,
                            max: 2,
                            message: '年龄范围为1-99'
                        },
                        regexp: {
                            regexp: /^\d+$/,
                            message: '年龄必须是正整数'
                        },
                    }
                },
                minPay:{
                    validators: {
                        stringLength: {
                            min: 1,
                            max: 20,
                            message: '薪资长度必须在1到20位之间'
                        },
                        regexp: {
                            regexp: /^\d+$/,
                            message: '薪资必须是正整数'
                        },
                        callback: {/*自定义，可以在这里与其他输入项联动校验*/
                            message: '只能是小于或等于最大薪资',
                            callback:function(value, validator,$field){
                                var maxPay = validator.getFieldElements('maxPay').val();
                                if(value<=maxPay || maxPay==''){
                                    return true;
                                }else {
                                    return false;
                                }
                            }
                        }
                    }
                },
                maxPay:{
                    validators: {
                        stringLength: {
                            min: 1,
                            max: 20,
                            message: '薪资长度必须在1到20位之间'
                        },
                        regexp: {
                            regexp: /^\d+$/,
                            message: '薪资必须是正整数'
                        },
                        callback: {/*自定义，可以在这里与其他输入项联动校验*/
                            message: '只能是大于或等于最小薪资',
                            callback:function(value, validator,$field){
                                var minPay = validator.getFieldElements('minPay').val();
                                if(value>=minPay || minPay==''){
                                    return true;
                                }else {
                                    return false;
                                }
                            }
                        }
                    }
                },
                minEntryTime:{
                    validators: {
                        callback: {/*自定义，可以在这里与其他输入项联动校验*/
                            message: '开始时间必须小于结束时间',
                            callback:function(value, validator,$field){

                                var maxEntryTime = validator.getFieldElements('maxEntryTime').val();
                                if(value==''){
                                    return true;
                                }
                                var max = new Date(maxEntryTime.replace("-", "/").replace("-", "/"));
                                var min = new Date(value.replace("-", "/").replace("-", "/"));
                                if (min <= max) {
                                    return true;
                                }
                                return false;
                            }
                        }
                    }
                },
                maxEntryTime:{
                    validators: {
                        callback: {/*自定义，可以在这里与其他输入项联动校验*/
                            message: '结束时间必须大于开始时间',
                            callback:function(value, validator,$field){

                                var minEntryTime = validator.getFieldElements('minEntryTime').val();
                                if(value==''){
                                    return true;
                                }
                                var min = new Date(minEntryTime.replace("-", "/").replace("-", "/"));
                                var max = new Date(value.replace("-", "/").replace("-", "/"));
                                if (min <= max) {
                                    return true;
                                }
                                return false;
                            }
                        }
                    }
                },

            }
        })
    }

    //解锁 或解锁 用户
    function updateLock(id,lock) {
        //阻止时间冒泡
        event.stopPropagation();
        bootbox.confirm({
            message: lock?"确定解锁该用户吗?":"确定锁定该用户吗?",
            size:"small",
            buttons: {
                confirm: {
                    label: '确定',
                    className: 'btn-success'
                },
                cancel: {
                    label: '取消',
                    className: 'btn-danger'
                }
            },
            callback: function (result) {
                if (result) {
                    $.ajax({
                        url:"/user/updateLock.gyh",
                        data:{"id":id,"lock":lock},
                        dataType:"json",
                        type:"post",
                        success:function(result){
                            if(result.code==200){
                                bootbox.alert({
                                    message: lock?"解锁成功!":"锁定成功!",
                                    size:"small",
                                    callback: function (result) {
                                        search();
                                    }
                                });
                            }
                        },
                        error:function(result){
                            bootbox.alert({
                                message: "请求失败",
                                size:"small"
                            });
                        }
                    })
                }
            }
        });
    }
</script>

</body>
</html>
