<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2019/8/22
  Time: 21:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>角色管理</title>
    <jsp:include page="/common/head.jsp"></jsp:include>
</head>
<body>
<jsp:include page="/common/nav-static.jsp"></jsp:include>
<div class="container" >
    <div class="row" style="background-color:#e4b9b9; width: 102.7%">
        <button class="btn btn-info" onclick="addRole()"><i class="glyphicon glyphicon-plus"></i>新增角色</button>
        <button class="btn btn-danger" ><i class="glyphicon glyphicon-trash"></i>批量删除</button>
    </div>

    <div class="row">
        <div class="panel panel-primary">
            <div class="panel-heading">角色展示</div>
            <table id="roleTable" class="table table-striped table-bordered" style="width:100%">
                <thead>
                <tr>
                    <th style="text-align:center">id</th>
                    <th style="text-align:center">角色名</th>
                    <th style="text-align:center">操作</th>
                </tr>
                </thead>
                <tbody style="text-align: center;"></tbody>
                <tfoot>
                <tr>
                    <th style="text-align:center">id</th>
                    <th style="text-align:center">角色名</th>
                    <th style="text-align:center">操作</th>
                </tr>
                </tfoot>
            </table>

        </div>
    </div>
</div>
<!-- 新增form表单 -->
<div id="addRoleDiv" style="display: none" method="post">
    <form id="add_form" class="form-horizontal" role="form">
        <div class="form-group">
            <label class="col-sm-2 control-label">角色名称</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="add_roleName" placeholder="请输入角色名...">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">资源</label>
            <div class="col-sm-4">
                <ul id="add_menuTree" class="ztree" style="width:230px; overflow:auto;"></ul>
            </div>
        </div>
    </form>
</div>

<!-- 修改form表单 -->
<div id="updateRoleDiv" style="display: none">
    <form id="update_form" class="form-horizontal">
        <div class="form-group">
            <label class="col-sm-2 control-label">角色名称</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="update_roleName" placeholder="请输入角色名...">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">资源</label>
            <div class="col-sm-4">
                <ul id="update_menuTree" class="ztree" style="width:230px; overflow:auto;"></ul>
            </div>
        </div>
    </form>
</div>

<jsp:include page="/common/script.jsp"></jsp:include>
<script>
    var v_addRoleDiv;
    var v_updateRoleDiv;
    $(function() {
        initRoleTable();//分页查询
        copyForm();//备份新增修改form表单
        initResourceTree();//加载资源树

    })

    //备份form表单
    function copyForm() {
        //备份新增的form表单
        v_addRoleDiv=$("#addRoleDiv").html();
        //备份修改的form表单
        v_updateRoleDiv=$("#updateRoleDiv").html();
    }
    
    //分页查询
    var roleTable;
    function initRoleTable(){
        roleTable=$('#roleTable').DataTable({
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
                "url": "/role/findRoleList.gyh",
                "type": "POST",

            },
            "columns": [
                { "data": "id" ,
                    "render": function (data, type, row, meta) {
                        return "<input type=\"checkbox\" name=\"check\" value=\""+data+"\">"+data+"";
                    }},
                { "data": "roleName" },
                { "data": "id",
                    "render": function (data, type, row, meta) {
                        return "<div class=\"btn-group\" role=\"group\" aria-label=\"...\">\n" +
                            "<button type=\"button\" class=\"btn btn-primary\" onclick=\"updateRole("+data+")\"><i class=\"glyphicon glyphicon-pencil\"></i>修改</button>\n" +
                            "<button class=\"btn btn-danger\" onclick=\"deleteRole("+data+")\"><i class=\"glyphicon glyphicon-trash\"></i>删除</button>\n" +
                            "</div>";

                    }
                }
            ],

        });
    }

    //新增
    var add_dialog;
    function addRole() {
        add_dialog = bootbox.dialog({
        title:"新增角色",
        message:$("#addRoleDiv form"),
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
                    var treeObj = $.fn.zTree.getZTreeObj("add_menuTree");
                    //获取当前被勾选的节点集合
                    var nodes = treeObj.getCheckedNodes(true);
                    var resourceIdArr=[];
                    for (var i=0;i<nodes.length;i++){
                        resourceIdArr.push(nodes[i].id);
                    }
                    var params = {};
                    params.roleName = $("#add_roleName",add_dialog).val();
                    params.resourceIdArr=resourceIdArr;
                    /*alert(JSON.stringify(params));*/
                    $.post({
                        url:"/role/addRole.gyh",
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
                }
            },
            }
        });
        $("#addRoleDiv").html(v_addRoleDiv);
        initResourceTree();
    }

    //修改角色
    var update_dialog;
    function updateRole(id){
        //通过id查询角色
        $.ajax({
            url:"/role/findRole.gyh",
            data:{"id":id},
            dataType:"json",
            type:"post",
            success:function (result) {
                if(result.code==200){
                    //加载修改的菜单树  同步
                    initResourceTreeUpdate();

                    var roleVo=result.data;
                    $("#update_roleName").val(roleVo.roleName);
                    var resourceIdArr=roleVo.resourceIdList;
                    var treeObj = $.fn.zTree.getZTreeObj("update_menuTree");
                    for (var i=0; i<resourceIdArr.length; i++) {
                        //根据id查询节点
                        var node = treeObj.getNodeByParam("id", resourceIdArr[i], null);
                        //勾选节点
                        treeObj.checkNode(node, true);
                    }
                        update_dialog = bootbox.dialog({
                        title: '修改角色',
                        message:$("#updateRoleDiv form"),
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
                                callback: function(){
                                    var nodes = treeObj.getCheckedNodes();
                                    var resourceIdArr=[];
                                    for(var i=0;i<nodes.length;i++){
                                        resourceIdArr.push(nodes[i].id);
                                    }
                                    var param={};
                                    param.id=id;
                                    param.roleName=$("#update_roleName",update_dialog).val();
                                    param.resourceIdArr=resourceIdArr;
                                    $.ajax({
                                        url:"/role/updateRole.gyh",
                                        data:param,
                                        dataType:"json",
                                        type:"post",
                                        success:function (result) {
                                            if(result.code==200){
                                                bootbox.alert({
                                                    message: "修改成功",
                                                    size:"small",
                                                    callback: function (result) {
                                                        search();//刷新
                                                    }
                                                });
                                            }
                                        }
                                    })
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
        $("#updateRoleDiv").html(v_updateRoleDiv);
    }

    //删除
    function deleteRole(id){
        bootbox.confirm({
            message: "确定删除该角色吗?",
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
                        url:"/role/deleteRoleById.gyh",
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

    //条件查询
    function search(){
        //调用datable中的方法发送请求,传递参数,这样就能达到刷新datable的效果
        roleTable.ajax.reload();
    }

    //资源树
    function initResourceTree(){
        $.post({
            url:"/resource/findResourceList.gyh",
            data:"",
            dataType:"json",
            success:function(res){
                var setting = {
                    check: {
                        enable: true,
                        chkboxType: { "Y" : "ps", "N" : "s" },
                    },
                    data: {
                        simpleData: {
                            enable: true
                        }
                    },
                };
                //新增树
                if(add_dialog){
                    var treeObj = $.fn.zTree.init($("#add_menuTree",add_dialog), setting, res.data);
                }else{
                    var treeObj = $.fn.zTree.init($("#add_menuTree"), setting, res.data);
                }

            },
            error:function(res){
                alert("请求失败");
            }
        })
    }

    //修改资源树
    function initResourceTreeUpdate(){
        $.post({
            url:"/resource/findResourceList.gyh",
            data:"",
            dataType:"json",
            async:false,
            success:function(res){
                var setting = {
                    check: {
                        enable: true,
                        chkboxType: { "Y" : "ps", "N" : "s" },
                    },
                    data: {
                        simpleData: {
                            enable: true
                        }
                    },
                };

                //修改树
                var treeObj = $.fn.zTree.init($("#update_menuTree"), setting, res.data);



            },
            error:function(res){
                alert("请求失败");
            }
        })
    }
</script>
</body>
</html>
