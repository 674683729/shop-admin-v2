<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2019/8/24
  Time: 16:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>商品管理页面</title>
    <jsp:include page="/common/head.jsp"></jsp:include>
</head>
<body>
<jsp:include page="/common/nav-static.jsp"></jsp:include>
<div class="container" >
    <div class="row">
        <div class="panel panel-warning">
            <div class="panel-heading">商品查询</div>
            <div class="panel-body">
                <form class="form-horizontal" id="productForm">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">商品名称</label>
                        <div class="col-sm-4">
                            <input type="text" class="form-control" name="productName" id="productName" placeholder="请输入商品名...">
                        </div>
                        <label class="col-sm-2 control-label">价格范围</label>
                        <div class="col-sm-4">
                            <div class="input-group">
                                <input type="text" class="form-control" name="minPrice" id="minPrice" placeholder="开始价格...">
                                <span class="input-group-addon"><i class="glyphicon glyphicon-transfer"></i></span>
                                <input type="text" class="form-control" name="maxPrice" id="maxPrice" placeholder="结束价格...">
                            </div>
                        </div>
                    </div>



                    <div class="form-group">
                        <label class="col-sm-2 control-label">创建时间</label>
                        <div class="col-sm-4">
                            <div class="input-group">
                                <input type="text" class="form-control" name="minCreateTime" id="minCreateTime" placeholder="开始时间...">
                                <span class="input-group-addon"><i class="glyphicon glyphicon-calendar"></i></span>
                                <input type="text" class="form-control" name="maxCreateTime" id="maxCreateTime" placeholder="结束时间...">
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
        <button class="btn btn-info" onclick="addProduct()"><i class="glyphicon glyphicon-plus"></i>新增商品</button>
        <button class="btn btn-danger" onclick="batchDelete()"><i class="glyphicon glyphicon-trash"></i>批量删除</button>
        <button class="btn btn-primary" onclick="expordExcel()"><i class="glyphicon glyphicon-download-alt"></i>Excel导出</button>
        <button class="btn btn-primary" onclick="expordWord()"><i class="glyphicon glyphicon-download-alt"></i>work导出</button>
        <button class="btn btn-primary" onclick="exportPdf()"><i class="glyphicon glyphicon-download-alt"></i>pdf导出</button>
    </div>

    <div class="row">
        <div class="panel panel-primary">
            <div class="panel-heading">商品展示</div>
            <table id="productTable" class="table table-striped table-bordered" style="width:100%">
                <thead>
                <tr>
                    <th style="text-align:center">选择</th>
                    <th style="text-align:center">商品名称</th>
                    <th style="text-align:center">价格</th>
                    <th style="text-align:center">库存</th>
                    <th style="text-align:center">是否热销</th>
                    <th style="text-align:center">状态</th>
                    <th style="text-align:center">品牌</th>
                    <th style="text-align:center">图片</th>
                    <th style="text-align:center">生产日期</th>
                    <th style="text-align:center">操作</th>
                </tr>
                </thead>
                <tbody style="text-align: center;"></tbody>
                <tfoot>
                <tr>
                    <th style="text-align:center">选择</th>
                    <th style="text-align:center">商品名称</th>
                    <th style="text-align:center">价格</th>
                    <th style="text-align:center">库存</th>
                    <th style="text-align:center">是否热销</th>
                    <th style="text-align:center">状态</th>
                    <th style="text-align:center">品牌</th>
                    <th style="text-align:center">图片</th>
                    <th style="text-align:center">生产日期</th>
                    <th style="text-align:center">操作</th>
                </tr>
                </tfoot>
            </table>

        </div>
    </div>
</div>

<!-- 新增form表单 -->
<div id="addProductDiv" style="display: none" method="post">
    <form id="add_form" class="form-horizontal" role="form">
        <div class="form-group">
            <label class="col-sm-2 control-label">商品名称</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="add_productName" placeholder="请输入商品名...">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">价格</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="add_price" placeholder="请输入价格...">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">库存</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="add_stock" placeholder="请输入库存...">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">是否热销</label>
            <div class="col-sm-4">
                <input type="radio" name="add_isSellWell" value="1">是
                <input type="radio" name="add_isSellWell" value="2">否
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">状态</label>
            <div class="col-sm-4">
                <input type="radio" name="add_isValid" value="1">上架
                <input type="radio" name="add_isValid" value="2">未上架
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">品牌</label>
            <div class="col-sm-4">
                <select id="add_brand">
                </select>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">图片</label>
            <div class="col-sm-4">
                <input type="file" name="myfile" data-ref="add_mainImage"
                       class="col-sm-4 myfile" value=""/>
                <input type="hidden" name="add_mainImage" value="">
            </div>
            <span style="display: none;" id="add_mainImage"></span>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">生产时间</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="add_createTime" placeholder="请输生产时间...">
            </div>
        </div>

    </form>
</div>

<!-- 修改form表单 -->
<div id="updateProductDiv" style="display: none">
    <form id="update_form" class="form-horizontal">
        <div class="form-group">
            <label class="col-sm-2 control-label">商品名称</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="update_productName" placeholder="请输入商品名...">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">价格</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="update_price" placeholder="请输入价格...">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">库存</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="update_stock" placeholder="请输入库存...">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">是否热销</label>
            <div class="col-sm-4">
                <input type="radio" name="update_isSellWell" value="1">是
                <input type="radio" name="update_isSellWell" value="2">否
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">状态</label>
            <div class="col-sm-4">
                <input type="radio" name="update_isValid" value="1">上架
                <input type="radio" name="update_isValid" value="2">未上架
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">品牌</label>
            <div class="col-sm-4">
                <select id="update_brand">
                </select>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">图片</label>
            <div class="col-sm-4">
                <input type="file" name="myfile" data-ref="update_mainImage"
                       class="col-sm-4 myfile" value=""/>
                <input type="hidden" name="update_mainImage" value="">
            </div>
            <span style="display: none;" id="update_mainImage"></span>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">入职时间</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="update_createTime" placeholder="请输入生产时间...">
            </div>
        </div>
    </form>
</div>


<jsp:include page="/common/script.jsp"></jsp:include>
<script>
    var v_ids=[];
    var v_addProductDiv;
    var v_updateProductDiv;
    //页面加载函数
    $(function(){
        initProductTable();//分页查询
        copyForm();//备份新增修改form表单
        initDatetimepicker();//日期插件
        createTime();//条件查询日期插件
        initBindEvent();//加入事件
        initFileInput();//上传图片
        initBrandSelect("add");//新增 品牌下拉框
        //initBrandSelect("update");
    })

    //批量删除
    function batchDelete(){
        if(v_ids.length==0){
            bootbox.alert({
                message:"请选择要删除的商品!",
                size:"small",
            })
        }else{
            bootbox.confirm({
                message: "确定删除选中的商品吗?",
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
                            url:"/product/batchDelete.gyh",
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

    //加入事件
    function initBindEvent(){
        $("table tbody").on("click","tr",function () {
            //获取当前行的复选框
            var v_checkbox=$(this).find("input[type='checkbox']");
            //获取当前复选框的选中状态
            var v_checked=v_checkbox.prop("checked");
            if(v_checked){
                v_checkbox.prop("checked",false);
                $(this).css("background-color","");
                var checkboxId=v_checkbox.val();
                for(var i=0;i<v_ids.length;i++){
                    if (v_ids[i]==checkboxId){
                        v_ids.splice(i,1);
                        break;
                    }
                }
            }else{
                v_checkbox.prop("checked",true);
                $(this).css("background-color","#5bc0de");
                v_ids.push(v_checkbox.val());
            }
        })

    }

    //备份form表单
    function copyForm() {
        //备份新增的form表单
        v_addProductDiv=$("#addProductDiv").html();
        //备份修改的form表单
        v_updateProductDiv=$("#updateProductDiv").html();
    }

    //分页查询
    var productTable;
    function initProductTable(){
        productTable=$('#productTable').DataTable({
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
                "url": "/product/findProductList.gyh",
                "type": "POST",

            },
            "columns": [
                { "data": "id" ,
                    "render": function (data, type, row, meta) {
                        return "<input type=\"checkbox\" value=\""+data+"\">"+data+"";
                    }},
                { "data": "productName"},
                { "data": "price" },
                { "data": "stock" },
                { "data": "isSellWell",
                    "render":function (data,type,row,meta) {
                        return data==1?"是":"否";
                    }
                },
                { "data": "isValid",
                    "render":function (data,type,row,meta) {
                        return data==1?"上架":"未上架";
                    }
                },
                { "data": "brandName" },
                { "data": "mainImage",
                    "render":function (data) {
                        return "<img width='80px' src='http://192.168.124.53/"+data+"'/>";
                    }
                },
                { "data": "createTime" },
                { "data": "id",
                    "render": function (data, type, row, meta) {
                        return "<div class=\"btn-group\" role=\"group\" aria-label=\"...\">\n" +
                            "<button type=\"button\" class=\"btn btn-primary\" onclick=\"updateProduct("+data+")\"><i class=\"glyphicon glyphicon-pencil\"></i>修改</button>\n" +
                            "<button class=\"btn btn-danger\" onclick=\"deleteProduct("+data+")\"><i class=\"glyphicon glyphicon-trash\"></i>删除</button>\n" +
                            "<button class=\""+(row.isValid==1?"btn btn-warning":"btn btn-success")+"\" onclick=\"updateValid("+data+","+row.isValid+")\"><i class=\"glyphicon glyphicon-resize-vertical\">"+(row.isValid==1?"下架":"上架")+"</i></button>\n" +
                            "</div>";

                    }
                }
            ],
            // 每次DataTable描画后都要调用，调用这个函数时，table可能没有描画完成，
            // 所以不要在里面操作table的dom，要操作dom应放在initComplete
            "drawCallback": function( settings ) {
                $("table tbody tr").each(function () {
                    var checkboxId=$(this).find("input[type='checkbox']").val();
                    for (var i=0;i,i<v_ids.length;i++){
                        if (v_ids[i]==checkboxId) {
                            $(this).css("background-color","#5bc0de");
                            $(this).find("input[type='checkbox']").prop("checked",true);
                        }
                    }
                })
            },

        });
    }

    //删除
    function deleteProduct(id){
        //阻止时间冒泡
        event.stopPropagation();
        bootbox.confirm({
            message: "确定删除该商品吗?",
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
                        url:"/product/deleteProductById.gyh",
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
    function addProduct() {

            add_dialog = bootbox.dialog({
            title:"新增商品",
            message:$("#addProductDiv form"),
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
                        params.productName = $("#add_productName",add_dialog).val();
                        params.price = $("#add_price",add_dialog).val();
                        params.stock = $("#add_stock",add_dialog).val();
                        params.isSellWell = $("[name='add_isSellWell']:checked",add_dialog).val();
                        params.isValid = $("[name='add_isValid']:checked",add_dialog).val();
                        params.brandId = $("#add_brand",add_dialog).val();
                        params.createTime = $("#add_createTime",add_dialog).val();
                        params.mainImage = $("input[name='add_mainImage']",add_dialog).val();
                        /*alert(JSON.stringify(params));*/
                        $.post({
                            url:"/product/addProduct.gyh",
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
        $("#addProductDiv").html(v_addProductDiv);
        initDatetimepicker();
        initFileInput();
        initBrandSelect("add");//新增品牌下拉框
    }
    
    //修改商品
    var dialog;
    function updateProduct(id){

        //阻止时间冒泡
        event.stopPropagation();
        //通过id查询商品
        $.ajax({
            url:"/product/findProduct.gyh",
            data:{"id":id},
            dataType:"json",
            type:"post",
            success:function (result) {
                if(result.code==200){
                    var productName=result.data.productName;
                    var price=result.data.price;
                    var stock=result.data.stock;
                    var isSellWell=result.data.isSellWell;
                    var isValid=result.data.isValid;
                    var brandId=result.data.brandId;
                    var createTime=result.data.createTime;
                    var mainImage=result.data.mainImage;
                    $("#update_productName").val(productName);
                    $("#update_price").val(price);
                    $("#update_stock").val(stock);
                    $("#update_createTime").val(createTime);
                    $("input[name='update_mainImage']").val(mainImage);
                    $("[name='update_isSellWell']").each(function(){
                        if(this.value==isSellWell){
                            this.checked=true;
                        }
                    })
                    $("[name='update_isValid']").each(function(){
                        if(this.value==isValid){
                            this.checked=true;
                        }
                    })
                    //回显品牌下拉框
                    $("#update_brand option").each(function () {
                        if (this.value==brandId){
                            this.selected=true;
                        }
                    })
                    dialog = bootbox.dialog({
                        title: '修改商品',
                        message:$("#updateProductDiv form"),
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
                                    param.productName=$("#update_productName",dialog).val();
                                    param.price=$("#update_price",dialog).val();
                                    param.stock = $("#update_stock",dialog).val();
                                    param.isSellWell = $("[name='update_isSellWell']:checked",dialog).val();
                                    param.isValid = $("[name='update_isValid']:checked",dialog).val();
                                    param.brandId = $("#update_brand",dialog).val();
                                    param.createTime=$("#update_createTime",dialog).val();
                                    param.mainImage = $("input[name='update_mainImage']",dialog).val();
                                    //alert(JSON.stringify(param))
                                    $.ajax({
                                        url:"/product/updateProduct.gyh",
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
        $("#updateProductDiv").html(v_updateProductDiv);
        initDatetimepicker();
        initFileInput();
        initBrandSelect("update");

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

    //条件查询时间组件
    function createTime(){
        $("#minCreateTime").datetimepicker({
            format: 'YYYY-MM-DD HH:mm:ss',
            locale: 'zh-CN',
            showClear: true
        });
        $("#maxCreateTime").datetimepicker({
            format: 'YYYY-MM-DD HH:mm:ss',
            locale: 'zh-CN',
            showClear: true
        });
    }

    //条件查询
    function search(){
        //查询本质是刷新datatable的数据
        //获取参数信息
        var v_productName=$("#productName").val();
        var v_minPrice=$("#minPrice").val();
        var v_maxPrice=$("#maxPrice").val();
        var v_minCreateTime=$("#minCreateTime").val();
        var v_maxCreateTime=$("#maxCreateTime").val();
        var roleIds="";
        $("input[name='search_roleCheckbox']:checked").each(function () {
            roleIds+=","+this.value;
        })
        //组装参数
        var v_param={};
        v_param.productName=v_productName;
        v_param.minPrice=v_minPrice;
        v_param.maxPrice=v_maxPrice;
        v_param.minCreateTime=v_minCreateTime;
        v_param.maxCreateTime=v_maxCreateTime;
        /*alert(JSON.stringify(v_param));*/
        //调用datable中的方法发送请求,传递参数,这样就能达到刷新datable的效果
        productTable.settings()[0].ajax.data=v_param;
        productTable.ajax.reload();
    }

    //导出Excel
    function expordExcel(){
        var v_productForm = document.getElementById("productForm");
        v_productForm.action="/product/expordExcel.gyh";
        v_productForm.method="post";
        v_productForm.submit();
    }

    //导出word
    function expordWord(){
        var v_productForm = document.getElementById("productForm");
        v_productForm.action="/product/expordWord.gyh";
        v_productForm.method="post";
        v_productForm.submit();
    }

    //导出pdf
    function exportPdf(){
        var v_productForm = document.getElementById("productForm");
        v_productForm.action="/product/exportPdf.gyh";
        v_productForm.method="post";
        v_productForm.submit();
    }

    //上下架
    function updateValid(id,valid){
            //取消事件冒泡
            event.stopPropagation();
            bootbox.confirm({
                message: valid==1?"确定下架该商品吗?":"确定上架该商品吗?",
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
                            url:"/product/updateValid.gyh",
                            data:{"id":id},
                            dataType:"json",
                            type:"post",
                            success:function(result){
                                if(result.code==200){
                                    bootbox.alert({
                                        message: valid==1?"下架成功!":"上架成功!",
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

    //加载品牌下拉框
    function initBrandSelect(str){
        $.ajax({
            url:"/brand/findAllBrand.gyh",
            type:"post",
            async:false,
            success:function(res){
                if (res.code == 200){
                    var brandList = res.data;
                    var html = "<option value='-1'>===请选择===</option>";
                    for(var i = 0 ; i < brandList.length ; i ++){
                        html += "<option value='"+brandList[i].id+"'>"+brandList[i].brandName + "</option>";
                    }
                    $("#"+str+"_brand").html(html);
                }

            },
            error:function(res){
                alert("请求失败");
            }
        })
    }

    //上传图片
    function  initFileInput() {
        $(".myfile").fileinput({
            //上传的地址
            uploadUrl:"/product/uploadMainImage.gyh",
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
