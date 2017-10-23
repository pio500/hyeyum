<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!-- 
				로그인 하는 곳.
			 -->
<%
	if (session.getAttribute("user") != null) {
%>
	<p>로그인 되었습니다.</p>
	<button id="logout_btn">로그아웃</button>
	<%
		} else {
	%>

<form id="login_frm" name="frm" action="./login/login.jsp" method="post">
	<input id="username" name="j_username" required="required" type="text"
		name="user_id" placeholder="아이디를 입력해 주세요."> <input
		id="password" name="j_password" required="required" type="password"
		name="user_pw" placeholder="비밀번호를 입력해 주세요.">

</form>
<button id="login_btn" type="button">로그인</button>
<a href="#" onclick="alert('버튼 클릭');"><font>Or sign up with:</font></a>
<%
	}
%>
