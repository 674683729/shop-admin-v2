<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav" id="nav_menu">
                <%--<li><a href="#">商品管理</a></li>
                <li><a href="#">品牌管理</a></li>
                <li class="dropdown" >
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">系统管理<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="/user/toList.gyh">用户管理</a></li>
                        <li role="separator" class="divider"></li>
                        <li><a href="/role/toList.gyh">角色管理</a></li>
                        <li role="separator" class="divider"></li>
                    </ul>
                </li>--%>
            </ul>

            <ul class="nav navbar-nav navbar-right">
                <li><a href="#">欢迎${user.realName}登录</a></li>
                <li><a href="#">这是您今天第${user.loginCount}次登录</a></li>
                <c:if test="${!empty user.loginTime}">
                    <li><a href="#">上次登录时间:<fmt:formatDate value="${user.loginTime}" pattern="yyyy-MM-dd HH:mm:ss"></fmt:formatDate></a></li>
                </c:if>
                <li><a href="/user/logout.gyh">退出</a></li>
                <%--<li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Dropdown <span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="#">Action</a></li>
                        <li><a href="#">Another action</a></li>
                        <li><a href="#">Something else here</a></li>
                        <li role="separator" class="divider"></li>
                        <li><a href="#">Separated link</a></li>
                    </ul>
                </li>--%>
            </ul>
        </div>
    </div>
</nav>
<script type="text/javascript" src="/js/commons/jquery-3.3.1.js"></script>
<script>
    $(function () {
        //根据 登录的用户查询菜单
        buildMenu();

    })

    //根据 登录的用户查询菜单
    var menuArr;
    function buildMenu() {
        $.ajax({
            url:"/resource/findResourceByUserId.gyh",
            type:"post",
            success:function (res) {
                if (res.code == 200){
                    menuArr=res.data;
                    //获取顶级菜单
                    initMenu();
                    console.log(menuArr)
                }
            },
            error:function (res) {
                alert("请求失败");
            }
        })
    }

    function  initMenu() {
        //获取顶级菜单
        var menuTopHtml="";
        for(var i=0; i<menuArr.length; i++){
            if (menuArr[i].fatherId == 1){
                menuTopHtml += '<li><a href="#" data-id="'+menuArr[i].id+'">'+menuArr[i].menuName+'</a></li>';
            }
        }
        //获取顶级菜单id数组
        var topMenuIdArr = [];
        for (var i=0; i<menuArr.length; i++){
            if (menuArr[i].fatherId == 1) {
                topMenuIdArr.push(menuArr[i].id);
            }
        }
        var v_topMenuObj = $(menuTopHtml);
        //拼接顶级菜的的子菜单
        for (var i=0; i<topMenuIdArr.length; i++){
            //获取子节点数组 子节点
            var children = getChildren(topMenuIdArr[i]);

            if (children.length > 0) {
                //有子节点 拼接 加特定属性
                var v_href=v_topMenuObj.find("a[data-id="+topMenuIdArr[i]+"]");
                v_href.attr("data-toggle","dropdown");
                v_href.append('<span class="caret"></span>');
                //拼接子菜单
                var childsHtml = childrenHtml(children);
                console.log(childsHtml)
                v_href.parent().append(childsHtml);
            }
        }
        $("#nav_menu").html(v_topMenuObj);
    }

    //拼接子节点
    function getChildren(id){
        var chileArr=[];
        for (var i=0; i<menuArr.length; i++){
            if (menuArr[i].fatherId == id){
                chileArr.push(menuArr[i]);
            }
        }
        return chileArr;
    }

    //拼接子菜单
    function childrenHtml(childs){
        var result = '<ul class="dropdown-menu">';
        for (var i=0; i<childs.length; i++){
            result += '<li><a href="'+childs[i].url+'">'+childs[i].menuName+'</a></li>';
        }
        result += '</ul>';
        return result;
    }

</script>