<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2019/8/24
  Time: 21:00
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>地区树</title>
    <jsp:include page="/common/head.jsp"></jsp:include>
</head>
<body>
<jsp:include page="/common/nav-static.jsp"></jsp:include>
<div class="container" >

    <div class="row">
        <div class="panel panel-primary">
            <div class="panel-heading">地区树展示
                <button class="btn btn-info" type="button" onclick="addArea()"><i class="glyphicon glyphicon-plus"></i>新增</button>
                <button class="btn btn-success" type="button" onclick="updateArea()"><i class="glyphicon glyphicon-pencil"></i>修改</button>
                <button class="btn btn-danger" type="button" onclick="deleteArea()"><i class="glyphicon glyphicon-trash"></i>删除</button>
            </div>
            <div class="panel-body">
                <div class="row">
                    <div class="col-sm-12">
                        <!-- zTree 是一个依靠 jQuery 实现的多功能 “树插件”。优异的性能、灵活的配置、多种功能的组合是 zTree 最大优点。
                        zTree 是开源免费的软件（MIT 许可证） -->
                        <ul id="tree" class="ztree" style="width:230px; overflow:auto;"></ul>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<!-- 新增form表单 -->
<div id="addAreaDiv" style="display: none" method="post">
    <form id="add_form" class="form-horizontal" role="form">
        <div class="form-group">
            <label class="col-sm-2 control-label">地区名</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="add_cityName" placeholder="请输入地区名...">
            </div>
        </div>
    </form>
</div>

<!-- 修改form表单 -->
<div id="updateAreaDiv" style="display: none" method="post">
    <form id="update_form" class="form-horizontal" role="form">
        <div class="form-group">
            <label class="col-sm-2 control-label">地区名</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="update_cityName" placeholder="请输入地区名...">
            </div>
        </div>
    </form>
</div>

<jsp:include page="/common/script.jsp"></jsp:include>
<script>
    var v_addAreaDiv;
    var v_updateAreaDiv;
    $(function() {
        findCityZtree();
        copyForm();//备份新增修改form表单
    })

    //查询
    function findCityZtree(){
        $.post({
            url:"/area/findAreaList.gyh",
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
                    //需要显示 checkbox
                    check: {
                        enable: true,
                        //checkbox 勾选操作，只影响父级节点；取消勾选操作，只影响子级节点
                        //chkStyle: "checkbox",
                        //chkboxType: { "Y": "p", "N": "s" }
                        chkboxType: { "Y": "s", "N": "s" }
                    },
                    edit:{
                        enable:true,//设置树为编辑模式
                        showRemoveBtn: false,//设置是否显示删除按钮
                        showRenameBtn: true//设置是否显示编辑名称按钮
                    },
                };

                var nodes = res.data;

                var zTreeObj = $.fn.zTree.init($("#tree"), setting, nodes);

                //展开全部节点
                //var treeObj = $.fn.zTree.getZTreeObj("tree");
                //zTreeObj.expandAll(true);
                var treeObj = $.fn.zTree.getZTreeObj("tree");
                var nodes = zTreeObj.getNodes();
                if (nodes.length>0) {
                    for(var i=0;i<nodes.length;i++){
                        zTreeObj.expandNode(nodes[i], true, false, false);
                    }
                }
            },
            error:function(res){
                alert("请求失败");
            }
        })
    };

    ///新增节点
    var add_dialog;
    function  addArea() {
        //获取当前被选中的节点数据集合
        var treeObj = $.fn.zTree.getZTreeObj("tree");
        var nodes = treeObj.getSelectedNodes();
        if(nodes.length == 1){
            if(nodes[0].type == 3){
                bootbox.alert({
                    message:'县级/区不能添加子节点',
                    size:"small",
                })
            }else{
                add_dialog = bootbox.dialog({
                    title:"新增地区",
                    message:$("#addAreaDiv form"),
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
                                var cityName = $("#add_cityName",add_dialog).val();
                                var type = nodes[0].type+1;
                                params.pid=id;
                                params.cityName = cityName;
                                params.type = type;
                                /*alert(JSON.stringify(params));*/
                                $.post({
                                    url:"/area/addCity.gyh",
                                    data:params,
                                    success:function (result) {
                                        if(result.code == 200){
                                            bootbox.alert({
                                                message:"新增成功",
                                                size:"small",
                                                callback: function (res) {
                                                    //刷新
                                                    var cityNode = {"id":result.data,"name":cityName,"pId":id};
                                                    newNode = treeObj.addNodes(nodes[0], cityNode);
                                                }
                                            });
                                        }
                                    }
                                });
                            }
                        },
                    }
                });
            }

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
        $("#addAreaDiv").html(v_addAreaDiv);
    }

    //修改节点
    var update_dialog;
    function updateArea() {
        //获取当前被选中的节点数据集合
        var treeObj = $.fn.zTree.getZTreeObj("tree");
        var nodes = treeObj.getSelectedNodes();
        if(nodes.length == 1){
            var id=nodes[0].id;
            var cityName=nodes[0].name;
            //回显
            $("#update_cityName").val(cityName);
            update_dialog = bootbox.dialog({
                title: '修改地区名',
                message:$("#updateAreaDiv form"),
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
                            var cityName=$("#update_cityName",update_dialog).val();
                            param.id=id;
                            param.cityName=cityName;
                            /*alert(JSON.stringify(param))*/
                            $.ajax({
                                url:"/area/updateArea.gyh",
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
                                                nodes[0].name = cityName;
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
        $("#updateAreaDiv").html(v_updateAreaDiv);
    }

    //删除节点
    function deleteArea(){
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
                                url:"/area/deleteArea.gyh",
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
        v_addAreaDiv=$("#addAreaDiv").html();
        //备份修改的form表单
        v_updateAreaDiv=$("#updateAreaDiv").html();
    }
</script>
</body>
</html>
