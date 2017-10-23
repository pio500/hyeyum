<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<div id="nav">
	<div id="lyk_logo">
		<font size="4em">LYK 홈페이지입니다.</font> <a
			href="/201110584/lyk/index.jsp"><img
			src="/201110584/lyk/resources/image/logo.png"></a>
	</div>
	<!-- <div id="lyk_sign">
	
		<@include file="./login/sign.jsp"  %>
		<img src="./resources/image/login.png">
		<font size="4em">LYK 로그인 버튼입니다.</font>
		</div>
		 -->
	<div id="lyk_menu">
		<!-- 
			메뉴선택란임. 각각의 li태그는 이동할 페이지에 대한 정보를 담고 있거나,
			js에서 처리해 주어야 함.
		-->
		<ul>
			<li id="home" data-index="1"><font size="2.5em">홈으로</font></li>
			<li id="notice" data-index="2"><font size="2.5em">공지 사항</font></li>
			<li id="board" data-index="3"><font size="2.5em">자유 게시판</font></li>
			<% if(session.getAttribute("id")!=null) {  %>
			<li id="submit" data-index="4"><font size="2.5em">시험 출제</font></li>
			<li id="examination" data-index="5"><font size="2.5em">시험
					응시</font></li>
			<li id="mypage" data-index="6"><font size="2.5em">마이 페이지</font></li>
			<% } %>
			<li id="login_li" data-index="8" style="display: none;"><font
				size="2.5em">로그인</font></li>
		</ul>
	</div>
</div>