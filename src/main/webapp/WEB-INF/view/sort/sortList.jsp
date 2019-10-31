<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2019/9/21
  Time: 13:17
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>分类管理</title>
    <jsp:include page="/common/head.jsp"></jsp:include>
</head>
<body>
<jsp:include page="/common/nav-static.jsp"></jsp:include>

<div class="container" >

    <div class="row">
        <div class="panel panel-info">
            <div class="panel-heading">分类展示
                <button class="btn btn-primary" type="button" onclick="addSort()"><i class="glyphicon glyphicon-plus"></i>新增</button>
                <button class="btn btn-success" type="button" onclick="updateSort()"><i class="glyphicon glyphicon-pencil"></i>修改</button>
                <button class="btn btn-danger" type="button" onclick="deleteSort()"><i class="glyphicon glyphicon-trash"></i>删除</button>
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
    <div id="addSortDiv" style="display: none" method="post">
        <form id="add_form" class="form-horizontal" role="form">
            <div class="form-group">
                <label class="col-sm-2 control-label">名称</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control" id="add_sortName" placeholder="请输入节点名...">
                </div>
            </div>
        </form>
    </div>

    <!-- 修改form表单 -->
    <div id="updateSortDiv" style="display: none" method="post">
        <form id="update_form" class="form-horizontal" role="form">
            <div class="form-group">
                <label class="col-sm-2 control-label">名称</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control" id="update_sortName" placeholder="请输入节点名...">
                </div>
            </div>
        </form>
    </div>
</div>

<jsp:include page="/common/script.jsp"></jsp:include>
<script>
    var v_addSortDiv;
    var v_updateSortDiv;
    $(function () {
        initSortTree();//查询分类树
        copyForm();//备份新增修改form表单
    })

    //查询分类树
    function initSortTree(){
        $.post({
            url:"/sort/findSortList.gyh",
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
                var expandNode = $.fn.zTree.init($("#tree"), setting, res.data);
                //默认打开节点
                expandNode.expandAll(true);
            },
            error:function(res){
                alert("请求失败");
            }
        })
    }

    //新增节点
    var add_dialog;
    function  addSort() {
        //获取当前被选中的节点数据集合
        var treeObj = $.fn.zTree.getZTreeObj("tree");
        var nodes = treeObj.getSelectedNodes();
        if(nodes.length == 1){
            add_dialog = bootbox.dialog({
                title:"新增分类节点",
                message:$("#addSortDiv form"),
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
                            var sortName = $("#add_sortName",add_dialog).val();
                            params.fatherId=id;
                            params.sortName = sortName;
                            /*alert(JSON.stringify(params));*/
                            $.post({
                                url:"/sort/addSort.gyh",
                                data:params,
                                success:function (result) {
                                    if(result.code == 200){
                                        bootbox.alert({
                                            message:"新增成功",
                                            size:"small",
                                            callback: function (res) {
                                                //刷新
                                                var sortNode = {"id":result.data,"name":sortName,"pId":id};
                                                newNode = treeObj.addNodes(nodes[0], sortNode);
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
        $("#addSortDiv").html(v_addSortDiv);
    }
    
    //修改节点
    var update_dialog;
    function updateSort() {
        //获取当前被选中的节点数据集合
        var treeObj = $.fn.zTree.getZTreeObj("tree");
        var nodes = treeObj.getSelectedNodes();
        if(nodes.length == 1){
            var id=nodes[0].id;
            var sortName=nodes[0].name;
            //回显
            $("#update_sortName").val(sortName);
            update_dialog = bootbox.dialog({
                title: '修改节点',
                message:$("#updateSortDiv form"),
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
                            var sortName=$("#update_sortName",update_dialog).val();
                            param.id=id;
                            param.sortName=sortName;
                            /*alert(JSON.stringify(param))*/
                            $.ajax({
                                url:"/sort/updateSort.gyh",
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
                                                nodes[0].name = sortName;
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
                message:"只能选择一个节点",
                size:"small",
            })
        }else{
            bootbox.alert({
                message:"请选择你要修改的节点",
                size:"small",
            })

        }
        $("#updateSortDiv").html(v_updateSortDiv);
    }

    //删除节点
    function deleteSort(){
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
                                url:"/sort/deleteSort.gyh",
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
        v_addSortDiv=$("#addSortDiv").html();
        //备份修改的form表单
        v_updateSortDiv=$("#updateSortDiv").html();
    }
</script>

</body>
</html>
