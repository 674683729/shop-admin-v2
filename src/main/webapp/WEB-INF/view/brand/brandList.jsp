<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2019/8/24
  Time: 18:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>品牌管理页面</title>
    <jsp:include page="/common/head.jsp"></jsp:include>
</head>
<body>
<jsp:include page="/common/nav-static.jsp"></jsp:include>

<div class="container" >
    <div class="row">
        <div class="panel panel-warning">
            <div class="panel-heading">品牌查询</div>
            <div class="panel-body">
                <form class="form-horizontal" id="productForm">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">品牌名：</label>
                        <div class="col-sm-4">
                            <input type="text" class="form-control" id="brandName" placeholder="请输入品牌名...">
                        </div>
                    </div>

                    <div style="text-align: center">
                        <button class="btn btn-primary" type="button" onclick="search()"><i class="glyphicon glyphicon-search"></i>排序</button>
                        <button class="btn btn-default" type="reset"><i class="glyphicon glyphicon-refresh"></i>重置</button>
                    </div>
                </form>

            </div>
        </div>
    </div>

    <div class="row" style="background-color:#e4b9b9; width: 102.7%">
        <button class="btn btn-info" onclick="addBrand()"><i class="glyphicon glyphicon-plus"></i>新增品牌</button>
        <button class="btn btn-danger"><i class="glyphicon glyphicon-trash"></i>批量删除</button>
    </div>

    <div class="row">
        <div class="panel panel-primary">
            <div class="panel-heading">品牌展示</div>
            <table id="brandTable" class="table table-striped table-bordered" style="width:100%">
                <thead>
                <tr>
                    <th style="text-align:center">id</th>
                    <th style="text-align:center">品牌名称</th>
                    <th style="text-align:center">图片</th>
                    <th style="text-align:center">是否热销</th>
                    <th style="text-align:center">排序</th>
                    <th style="text-align:center">操作</th>
                </tr>
                </thead>
                <tbody style="text-align: center;"></tbody>
                <tfoot>
                <tr>
                    <th style="text-align:center">id</th>
                    <th style="text-align:center">品牌名称</th>
                    <th style="text-align:center">图片</th>
                    <th style="text-align:center">是否热销</th>
                    <th style="text-align:center">排序</th>
                    <th style="text-align:center">操作</th>
                </tr>
                </tfoot>
            </table>

        </div>
    </div>
</div>

<!-- 新增form表单 -->
<div id="addBrandDiv" style="display: none" method="post">
    <form id="add_form" class="form-horizontal" role="form">
        <div class="form-group">
            <label class="col-sm-2 control-label">品牌名称</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="add_brandName" placeholder="请输入品牌名...">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">图片</label>
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
<div id="updateBrandDiv" style="display: none">
    <form id="update_form" class="form-horizontal">
        <div class="form-group">
            <label class="col-sm-2 control-label">品牌名称</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="update_brandName" placeholder="请输入品牌名...">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">图片</label>
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
    var v_addBrandDiv;
    var v_updateBrandDiv;

    //页面加载函数
    $(function(){
        initBrandTable();//分页查询
        copyForm();//备份新增修改form表单
        initFileInput();

    })

    //备份form表单
    function copyForm() {
        //备份新增的form表单
        v_addBrandDiv=$("#addBrandDiv").html();
        //备份修改的form表单
        v_updateBrandDiv=$("#updateBrandDiv").html();
    }

    //分页查询
    var brandTable;
    function initBrandTable(){
        brandTable=$('#brandTable').DataTable({
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
                "url": "/brand/findBrandList.gyh",
                "type": "POST",

            },
            "columns": [
                { "data": "id" ,
                    "render": function (data, type, row, meta) {
                        return "<input type=\"checkbox\" name=\"check\" value=\""+data+"\">"+data+"";
                    }},
                { "data": "brandName" },
                { "data": "photo" ,
                    "render":function(data){
                        return"<img width='80px' src='http://192.168.124.53/"+data+"'/>";
                    }
                },
                { "data": "isSellWell" ,
                    "render":function(data){
                        return data==1?"热销":"非热销";
                    }
                },
                { "data": "sort" ,
                    "render":function(data, type, row, meta){
                        return '<input class="form-control" type="text" value="'+data+'" id="sort_'+row.id+'"/>' +
                            '<button class="btn btn-primary" onclick="updateBrandSort('+row.id+')"><i class="glyphicon glyphicon-refresh">刷新</i></button>';
                    }
                },
                { "data": "id",
                    "render": function (data, type, row, meta) {
                        return "<div class=\"btn-group\" role=\"group\" aria-label=\"...\">\n" +
                            "<button type=\"button\" class=\"btn btn-primary\" onclick=\"updateBrand("+data+")\"><i class=\"glyphicon glyphicon-pencil\"></i>修改</button>\n" +
                            "<button class=\"btn btn-danger\" onclick=\"deleteBrand("+data+")\"><i class=\"glyphicon glyphicon-trash\"></i>删除</button>\n" +
                            "<button class=\""+(row.isSellWell==1?"btn btn-warning":"btn btn-success")+"\" onclick=\"updateSellWell("+data+","+row.isSellWell+")\"><i class=\"glyphicon glyphicon-resize-vertical\">"+(row.isSellWell==1?"取消热销":"设为热销")+"</i></button>\n" +
                            "</div>";
                    }
                }
            ],

        });
    }

    //删除
    function deleteBrand(id){
        bootbox.confirm({
            message: "确定删除该品牌吗?",
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
                        url:"/brand/deleteBrandById.gyh",
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
    function addBrand() {

        var dialog = bootbox.dialog({
            title:"新增品牌",
            message:$("#addBrandDiv form"),
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
                        params.brandName = $("#add_brandName",dialog).val();
                        params.photo = $("input[name='add_photo']",dialog).val();
                        /*alert(JSON.stringify(params));*/
                        $.post({
                            url:"/brand/addBrand.gyh",
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
        $("#addBrandDiv").html(v_addBrandDiv);
        initFileInput();
    }

    //修改品牌
    function updateBrand(id){
        //通过id查询品牌
        $.ajax({
            url:"/brand/findBrand.gyh",
            data:{"id":id},
            dataType:"json",
            type:"post",
            success:function (result) {
                if(result.code==200){
                    var brandName=result.data.brandName;
                    var photo=result.data.photo;
                    $("#update_brandName").val(brandName);
                    $("input[name='update_photo']").val(photo);

                    var dialog = bootbox.dialog({
                        title: '修改品牌',
                        message:$("#updateBrandDiv form"),
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
                                    param.id=id;
                                    param.brandName=$("#update_brandName",dialog).val();
                                    param.photo = $("input[name='update_photo']",dialog).val();
                                    /*alert(JSON.stringify(param))*/
                                    $.ajax({
                                        url:"/brand/updateBrand.gyh",
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
                                            if (result.code==-1){
                                                bootbox.alert({
                                                    message: "修改失败",
                                                    size:"small"
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
        $("#updateBrandDiv").html(v_updateBrandDiv);
        initFileInput();
    }

    //修改排序
    function updateBrandSort(brandId) {
        event.stopPropagation();
        bootbox.confirm({
            message: "确定修该品牌排序？",
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
                    var v_sort = $("#sort_"+brandId).val();
                    $.ajax({
                        url:"/brand/updateBrandSort.gyh",
                        data:{"id":brandId,"sort":v_sort},
                        type:"post",
                        success:function (result) {
                            if (result.code == 200) {
                                search();
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

    //设置热销
    function updateSellWell(id,isSellwell) {
        //取消事件冒泡
        event.stopPropagation();
        bootbox.confirm({
            message: isSellWell==1?"确定取消该热销品牌吗?":"确定设为热销品牌吗?",
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
                        url:"/brand/updateSellWell.gyh",
                        data:{"id":id,"isSellWell":isSellWell},
                        dataType:"json",
                        type:"post",
                        success:function(result){
                            if(result.code==200){
                                bootbox.alert({
                                    message: "设置成功!",
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
    //新增,修改form日期组件
    function initDatetimepicker(){
        //新增,修改的入职时间
        $("#add_createTime,#update_createTime").datetimepicker({
            format: 'YYYY-MM-DD HH:mm:ss',
            locale: 'zh-CN',
            showClear: true
        });
    }

    //条件查询
    function search(){
        //组装参数
        var v_param={};
        /*alert(JSON.stringify(v_param));*/
        //调用datable中的方法发送请求,传递参数,这样就能达到刷新datable的效果
        brandTable.settings()[0].ajax.data=v_param;
        brandTable.ajax.reload();
    }

    function initFileInput() {
        $(".myfile").fileinput({
            //上传的地址
            uploadUrl:"/brand/uploadPhoto.gyh",
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
</script>
</body>
</html>