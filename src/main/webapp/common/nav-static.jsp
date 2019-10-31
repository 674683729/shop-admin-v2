<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<style>
    .dropdown-submenu {
        position: relative;
    }

    .dropdown-submenu > .dropdown-menu {
        top: 0;
        left: 100%;
        margin-top: -6px;
        margin-left: -1px;
        -webkit-border-radius: 0 6px 6px 6px;
        -moz-border-radius: 0 6px 6px;
        border-radius: 0 6px 6px 6px;
    }

    .dropdown-submenu:hover > .dropdown-menu {
        display: block;
    }

    .dropdown-submenu > a:after {
        display: block;
        content: " ";
        float: right;
        width: 0;
        height: 0;
        border-color: transparent;
        border-style: solid;
        border-width: 5px 0 5px 5px;
        border-left-color: #ccc;
        margin-top: 5px;
        margin-right: -10px;
    }

    .dropdown-submenu:hover > a:after {
        border-left-color: #fff;
    }

    .dropdown-submenu.pull-left {
        float: none;
    }

    .dropdown-submenu.pull-left > .dropdown-menu {
        left: -100%;
        margin-left: 10px;
        -webkit-border-radius: 6px 0 6px 6px;
        -moz-border-radius: 6px 0 6px 6px;
        border-radius: 6px 0 6px 6px;
    }
</style>
<nav class="navbar navbar-inverse">
    <div class="container-fluid">
        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="#">飞狐电商后台管理</a>
        </div>

        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">


            <ul class="nav navbar-nav navbar-right">
                <li><a href="#">欢迎${user.realName}登录</a></li>
                <li><a href="#">今天是第${user.loginCount}次登录</a></li>
                <c:if test="${!empty user.loginTime}">
                    <li><a href="#">上次登录的时间<fmt:formatDate value="${user.loginTime}" pattern="yyyy-MM-dd HH:mm:ss"></fmt:formatDate> </a></li>
                </c:if>
                <li><a href="/user/toUpdatePassword.gyh">修改密码</a></li>
                <li><a href="/user/logout.gyh">退出</a></li>
                <%--<li class="dropdown">--%>
                <%--<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Dropdown <span class="caret"></span></a>--%>
                <%--<ul class="dropdown-menu">--%>
                <%--<li><a href="#">Action</a></li>--%>
                <%--<li><a href="#">Another action</a></li>--%>
                <%--<li><a href="#">Something else here</a></li>--%>
                <%--<li role="separator" class="divider"></li>--%>
                <%--<li><a href="#">Separated link</a></li>--%>
                <%--</ul>--%>
                <%--</li>--%>
            </ul>
        </div>
    </div>
</nav>
<script type="text/javascript" src="/js/commons/jquery-3.3.1.js"></script>
<script>
    $(function () {
        //根据登陆的用户 查询菜单
        initMenu();
        //全局的ajax请求后执行语句
        allAjax();
    })

    //全局ajax的请求后执行语句
    function allAjax(){
        $.ajaxSetup({
            complete:function (result) {
                var data = result.responseJSON;
                if (data.code != 200 && data.code != undefined){
                    bootbox.alert({
                        message:'<span class="glyphicon glyphicon-exclamation-sign">'+data.msg+'</span>',
                        size:"small",
                    })
                }

            }
        })
    }

    //根据登陆的用户 查询菜单
    var menuArr;
    function initMenu(){
        $.ajax({
            url:"/resource/findResourceByUserId.gyh",
            type:"post",
            success:function(res){
                if (res.code == 200){
                    menuArr = res.data;
                    //获取菜单
                    buildMenu(1,1);
                    $("#bs-example-navbar-collapse-1").append(v_html);
                }
            }
        })
    }

    //拼接顶级菜单
    var v_html = "";
    function buildMenu(id, level){
        //获取指定id的孩子
        var childs = getChilds(id);
        //判断是否有子id
        if (childs.length > 0){
            //父亲
            if (level == 1){
                v_html += '<ul class="nav navbar-nav">';
            }else{
                v_html += '<ul class="dropdown-menu">';
            }

            for (var i=0; i<childs.length; i++){
                var node = childs[i];
                //是否有子节点
                var hasChilds = getHasChild(node.id);
                if(level==1){
                    if (hasChilds) {
                        v_html += '<li><a href="#" data-toggle="dropdown">'+node.menuName+'<span class="caret"></span></a>';
                    }else{
                        v_html += '<li><a href="'+node.url+'">'+node.menuName+'</a>';
                    }
                }else{
                    if (hasChilds) {
                        v_html += '<li class="dropdown-submenu"><a href="'+node.url+'">'+node.menuName+'</a>';
                    }else{
                        v_html += '<li><a href="'+node.url+'">'+node.menuName+'</a>';
                    }
                }
                buildMenu(node.id,level+1);
                v_html += '</li>'
            }
            v_html += '</ul>';
        }

    }

    //获取指定id的孩子
    function getChilds(id){
        var childs = [];
        for (var i=0; i<menuArr.length; i++){
            if (menuArr[i].fatherId == id){
                childs.push(menuArr[i]);
            }
        }
        return childs;
    }

    //是否拥有子节点
    function getHasChild(id){
        for (var i=0; i<menuArr.length; i++){
            if (menuArr[i].fatherId == id){
                return true;
            }
        }
        return false;
    }

</script>





