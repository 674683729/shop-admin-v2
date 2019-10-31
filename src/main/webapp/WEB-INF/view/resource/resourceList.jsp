<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2019/8/25
  Time: 18:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>资源管理</title>
    <jsp:include page="/common/head.jsp"></jsp:include>
</head>
<body>
<jsp:include page="/common/nav-static.jsp"></jsp:include>
<div class="container" >

    <div class="row">
        <div class="panel panel-info">
            <div class="panel-heading">菜单展示
                <button class="btn btn-primary" type="button" onclick="addResource()"><i class="glyphicon glyphicon-plus"></i>新增</button>
                <button class="btn btn-success" type="button" onclick="updateResource()"><i class="glyphicon glyphicon-pencil"></i>修改</button>
                <button class="btn btn-danger" type="button" onclick="deleteResource()"><i class="glyphicon glyphicon-trash"></i>删除</button>
            </div>
            <div class="panel-body">
                <div class="row">
                    <div class="col-sm-12">

                        <ul id="tree" class="ztree" style="width:230px; overflow:auto;"></ul>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <!-- 新增form表单 -->
    <div id="addResourceDiv" style="display: none" method="post">
        <form id="add_form" class="form-horizontal" role="form">
            <div class="form-group">
                <label class="col-sm-2 control-label">菜单名称</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control" id="add_menuName" placeholder="请输入菜单名...">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">菜单类型</label>
                <div class="col-sm-4">
                    <input type="radio" name="add_menuType" value="1" > 菜单
                    <input type="radio" name="add_menuType" value="2" > 按钮
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">路径</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control" id="add_url" placeholder="请输入菜单名...">
                </div>
            </div>
        </form>
    </div>

    <!-- 修改form表单 -->
    <div id="updateResourceDiv" style="display: none" method="post">
        <form id="update_form" class="form-horizontal" role="form">
            <div class="form-group">
                <label class="col-sm-2 control-label">菜单名称</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control" id="update_menuName" placeholder="请输入菜单名...">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">菜单类型</label>
                <div class="col-sm-4">
                    <input type="radio" name="update_menuType" value="1" > 菜单
                    <input type="radio" name="update_menuType" value="2" > 按钮
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">路径</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control" id="update_url" placeholder="请填写URL...">
                </div>
            </div>
        </form>
    </div>
</div>

<jsp:include page="/common/script.jsp"></jsp:include>
<script>
    var v_addResourceDiv;
    var v_updateResourceDiv;
    $(function () {
        initResourceDlg();//查询资源表
        copyForm();//备份新增修改form表单


    })

    //资源树查询
    function initResourceDlg(){
        $.post({
            url:"/resource/findResourceList.gyh",
            data:"",
            dataType:"json",
            success:function(res){
                var setting = {
                    //使用简单 Array 格式的数据
                    data: {
                        simpleData: {
                            enable: true
                        }
                    },
                };
                var treeObj = $.fn.zTree.init($("#tree"), setting, res.data);

                //默认打开一级
                var nodes = treeObj.getNodes();
                if (nodes.length>0) {
                    for(var i=0;i<nodes.length;i++){
                        treeObj.expandNode(nodes[i], true, false, false);
                    }
                }
            },
            error:function(res){
                alert("请求失败");
            }
        })
    }

    //新增菜单类型 单击事件
    function menuTypeJs(obj) {
        var menuTypeChecked = obj.value;
        if (menuTypeChecked==1){
            $("#add_url",dialog).val("");
            $("#add_url",dialog).prop("disabled",true);
            $("#add_url",dialog).prop("placeholder","菜单不用填写URL");
        }else{
            $("#add_url",dialog).prop("disabled",false);
            $("#add_url",dialog).prop("placeholder","请填写URL...");
        }
    }

    //修改 菜单类型
    function updateMenuTypeJs(obj){
        var menuTypeChecked = obj.value;
        if (menuTypeChecked==1){
            $("#update_url",update_dialog).val("");
            $("#update_url",update_dialog).prop("disabled",true);
            $("#update_url",update_dialog).prop("placeholder","菜单不用填写URL");
        }else{
            $("#update_url",update_dialog).val(url);
            $("#update_url",update_dialog).prop("disabled",false);
            $("#update_url",update_dialog).prop("placeholder","请填写URL...");
        }


    }

    //新增节点
    var dialog;
    function addResource(){
        //获取当前被选中的节点数据集合
        var treeObj = $.fn.zTree.getZTreeObj("tree");
        var nodes = treeObj.getSelectedNodes();
        if(nodes.length == 1){
            var menuType=nodes[0].menuType;
            if (menuType == 2){
                bootbox.alert({
                    message:"按钮不能添加子节点",
                    size:"small",
                })
                return;
            }
            dialog = bootbox.dialog({
                title:"新增菜单",
                message:$("#addResourceDiv form"),
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
                            var params = {};
                            var id=nodes[0].id;
                            var menuName = $("#add_menuName",dialog).val();
                            var menuType = $("input[name='add_menuType']:checked",dialog).val();
                            var url = $("#add_url",dialog).val();
                            params.fatherId=id;
                            params.menuName = menuName;
                            params.menuType = menuType;
                            params.url = url;
                            /*alert(JSON.stringify(params));*/
                            $.post({
                                url:"/resource/addResource.gyh",
                                data:params,
                                success:function (result) {
                                    if(result.code == 200){
                                        bootbox.alert({
                                            message:"新增成功",
                                            size:"small",
                                            callback: function (res) {
                                                //刷新
                                                var resourceNode = {"id":result.data,"name":menuName,"menuType":menuType,"pId":id,"menuUrl":url};
                                                newNode = treeObj.addNodes(nodes[0], resourceNode);
                                            }
                                        });
                                    }
                                }
                            });
                        }
                    },
                }
            });
        }else if(nodes.length > 1){
            bootbox.alert({
                message:'只能选择一个父节点!',
                size:"small",
            })
        }else {
            bootbox.alert({
                message:'请选择一个父节点!',
                size:"small",
            })
        }
        $("#addResourceDiv").html(v_addResourceDiv);
    }

    //修改节点
    var update_dialog;
    function updateResource(){
        //获取当前被选中的节点数据集合
        var treeObj = $.fn.zTree.getZTreeObj("tree");
        var nodes = treeObj.getSelectedNodes();
        if(nodes.length == 1){
            var id=nodes[0].id;
            var selectedMenuName=nodes[0].name;
            var menuType=nodes[0].menuType;
            var url=nodes[0].menuUrl;
            console.log()
            //回显
            $("input[name='update_menuType']").each(function () {
                if(this.value == menuType){
                    this.checked=true;
                }
            })
            $("#update_menuName").val(selectedMenuName);
            $("#update_url").val(url);
            update_dialog = bootbox.dialog({
                title: '修改用户',
                message:$("#updateResourceDiv form"),
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
                            var param={};
                            var menuName=$("#update_menuName",update_dialog).val();
                            var menuType=$("input[name='update_menuType']:checked",update_dialog).val();
                            var url=$("#update_url",update_dialog).val();
                            param.id=id;
                            param.menuName=menuName;
                            param.menuType=menuType;
                            param.url=url;
                            /*alert(JSON.stringify(param))*/
                            $.ajax({
                                url:"/resource/updateResource.gyh",
                                data:param,
                                dataType:"json",
                                type:"post",
                                success:function (result) {
                                    if(result.code==200){
                                        bootbox.alert({
                                            message: "修改成功",
                                            size:"small",
                                            callback: function (result) {
                                                //刷新
                                                nodes[0].name = menuName;
                                                nodes[0].menuType = menuType;
                                                nodes[0].menuUrl = url;
                                                treeObj.updateNode(nodes[0]);
                                            }
                                        });
                                    }
                                }
                            })
                        }
                    }
                }
            });

        }else if(nodes.length >1){
            bootbox.alert({
                message:"只能选择一个菜单",
                size:"small",
            })
        }else{
            bootbox.alert({
                message:"请选择你要修改的菜单",
                size:"small",
            })

        }
        $("#updateResourceDiv").html(v_updateResourceDiv);
    }

    //删除菜单
    function deleteResource(){
        //获取当前被选中的节点数据集合
        var treeObj = $.fn.zTree.getZTreeObj("tree");
        var nodes = treeObj.getSelectedNodes();
        if(nodes.length > 0){

            if(nodes[0].id==1){
                bootbox.alert({
                    message: "不能删除根节点",
                    size:"small"
                });
            }else{
                bootbox.confirm({
                    message: "确定删除选中的所有节点吗?",
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
                            //获取选中节点的子子孙孙节点数组
                            var  ztreeArr= treeObj.transformToArray(nodes);
                            var nodeIdArr=[];
                            for (var i = 0; i < ztreeArr.length; i++) {
                                nodeIdArr.push(ztreeArr[i].id);
                            }
                            //删除节点 以及子节点
                            $.ajax({
                                url:"/resource/deleteResource.gyh",
                                type:"post",
                                dataType:"json",
                                data:{"nodeIdArr":nodeIdArr},
                                success:function(res){
                                    if(res.code==200){
                                        bootbox.alert({
                                            message: "删除成功",
                                            size:"small",
                                            callback: function (result) {
                                                //刷新
                                                for (var i = ztreeArr.length-1; i >= 0 ; i--) {
                                                    treeObj.removeNode(ztreeArr[i]);
                                                }
                                            }
                                        });
                                    }

                                },
                                error:function(res){
                                    bootbox.alert({
                                        message: "删除节点失败",
                                        size:"small"
                                    });
                                }
                            })
                        }

                    }

                });

            }

        }else{
            bootbox.alert({
                message: "请选择要删除的节点",
                size:"small"
            });
        }
    }

    //备份form表单
    function copyForm() {
        //备份新增的form表单
        v_addResourceDiv=$("#addResourceDiv").html();
        //备份修改的form表单
        v_updateResourceDiv=$("#updateResourceDiv").html();
    }

</script>
</body>
</html>
