<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<div id="sign">

	<% if (session.getAttribute("nickname") != null
						|| session.getAttribute("id") != null
							|| session.getAttribute("level") != null) { %>
	<ul>
		<li><a href="javascript:void(0);" onclick="return logout();">
				<b><font size="3em" color="#1E2F3C">로그아웃</font></b>
		</a></li>
	</ul>
	<% } else { %>
	<ul>
		<li><a href="javascript:void(0);" onclick="return login();">
				<b><font size="3em" color="#1E2F3C">로그인</font></b>
		</a></li>
	</ul>
	<% } %>

	<script type="text/javascript">
		var tmp = window.location.href;
		var tmp2 = window.location.pathname;
		var flag = tmp.indexOf("lyk");
		tmp = tmp.substring(0, flag);
		function login() {
			location.href = tmp + "lyk/user/login.jsp"
			return false;
		}
		function logout() {
			location.href = tmp + "lyk/login/logout.jsp"
			return false;
		}
	</script>

</div>