<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2019/9/8
  Time: 23:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>日志信息页面</title>
    <jsp:include page="/common/head.jsp"></jsp:include>
</head>
<body>
<jsp:include page="/common/nav-static.jsp"></jsp:include>
<div class="container" >
    <div class="row">
        <div class="panel panel-warning">
            <div class="panel-heading">日志查询</div>
            <div class="panel-body">
                <form class="form-horizontal" id="productForm">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">用户名称</label>
                        <div class="col-sm-4">
                            <input type="text" class="form-control" id="userName" placeholder="请输入用户名...">
                        </div>
                        <label class="col-sm-2 control-label">真实姓名</label>
                        <div class="col-sm-4">
                            <input type="text" class="form-control" id="realName" placeholder="请输入真实姓名...">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">操作时间</label>
                        <div class="col-sm-4">
                            <div class="input-group">
                                <input type="text" class="form-control"  id="minCurrTime" placeholder="开始时间...">
                                <span class="input-group-addon"><i class="glyphicon glyphicon-calendar"></i></span>
                                <input type="text" class="form-control"  id="maxCurrTime" placeholder="结束时间...">
                            </div>
                        </div>
                        <label class="col-sm-2 control-label">操作信息</label>
                        <div class="col-sm-4">
                            <input type="text" class="form-control" id="context" placeholder="请输入操作信息...">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">操作状态</label>
                        <div class="col-sm-4">
                            <select id="status" class="form-control">
                                <option value="-1">操作状态查询</option>
                                <option value="1">成功</option>
                                <option value="0">失败</option>
                            </select>
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

    <div class="row">
        <div class="panel panel-primary">
            <div class="panel-heading">日志展示</div>
            <table id="logTable" class="table table-striped table-bordered" style="width:100%">
                <thead>
                <tr>
                    <th style="text-align:center">用户名</th>
                    <th style="text-align:center">真实姓名</th>
                    <th style="text-align:center">操作时间</th>
                    <th style="text-align:center">操作</th>
                    <th style="text-align:center">是否操作成功</th>
                    <th style="text-align:center">操作成功信息</th>
                    <th style="text-align:center">操作失败信息</th>
                    <th style="text-align:center">参数详情</th>
                </tr>
                </thead>
                <tbody style="text-align: center;"></tbody>
                <tfoot>
                <tr>
                    <th style="text-align:center">用户名</th>
                    <th style="text-align:center">真实姓名</th>
                    <th style="text-align:center">操作时间</th>
                    <th style="text-align:center">操作</th>
                    <th style="text-align:center">是否操作成功</th>
                    <th style="text-align:center">操作成功信息</th>
                    <th style="text-align:center">操作失败信息</th>
                    <th style="text-align:center">参数详情</th>
                </tr>
                </tfoot>
            </table>

        </div>
    </div>
</div>



<jsp:include page="/common/script.jsp"></jsp:include>
<script>
    //页面加载函数
    $(function(){
        initLogTable();//分页查询
        currTime();//条件查询日期插件
    })

    //分页查询
    var logTable;
    function initLogTable(){
        logTable=$('#logTable').DataTable({
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
                "url": "/log/findLogList.gyh",
                "type": "POST",

            },
            "columns": [
                { "data": "userName"},
                { "data": "realName" },
                { "data": "currTime" },
                { "data": "context" },
                { "data": "status",
                    "render":function (data,type,row,meta) {
                        return data==1?"成功":"失败";
                    }
                },
                { "data": "info" },
                { "data": "errorMsg" },
                { "data": "detail"},
            ],

        });
    }

    //条件查询
    function search(){
        //查询本质是刷新datatable的数据
        //获取参数信息
        var v_userName=$("#userName").val();
        var v_realName=$("#realName").val();
        var v_minCurrTime=$("#minCurrTime").val();
        var v_maxCurrTime=$("#maxCurrTime").val();
        var v_context=$("#context").val();
        var v_status=$("#status").find("option:selected").val();
        //组装参数
        var v_param={};
        v_param.userName=v_userName;
        v_param.realName=v_realName;
        v_param.minCurrTime=v_minCurrTime;
        v_param.maxCurrTime=v_maxCurrTime;
        v_param.context=v_context;
        v_param.status=v_status;
        /*alert(JSON.stringify(v_param));*/
        //调用datable中的方法发送请求,传递参数,这样就能达到刷新datable的效果
        logTable.settings()[0].ajax.data=v_param;
        logTable.ajax.reload();
    }

    //条件查询时间组件
    function currTime(){
        $("#minCurrTime").datetimepicker({
            format: 'YYYY-MM-DD HH:mm',
            locale: 'zh-CN',
            showClear: true
        });
        $("#maxCurrTime").datetimepicker({
            format: 'YYYY-MM-DD HH:mm',
            locale: 'zh-CN',
            showClear: true
        });
    }
</script>
</body>
</html>
