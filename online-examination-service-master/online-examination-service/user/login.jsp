<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE>
<html>
<head>
<script type="text/javascript" src=".././resources/js/jquery-2.1.1.js"></script>
<script type="text/javascript" src=".././resources/js/lyk.js"></script>
<link href=".././resources/css/lyk.css" rel="stylesheet">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta charset="utf-8">
<title>LYK</title>
</head>
<body>
	<div id="wrapper">
		<%@include file=".././commonNav.jsp"%>
		<script type="text/javascript">
			$("#nav").css("padding-top", "0");
		</script>

		<div id="container">
			<div id="login_div" style="text-align: center;">
				<p>아이디와 비밀번호를 입력해주세요.</p>
				<form id="login_frm" name="frm" action=".././login/login.jsp"
					method="post">
					<input id="username" name="j_username" required="required"
						type="text" name="user_id" placeholder="아이디를 입력해 주세요."> <input
						id="password" name="j_password" required="required"
						type="password" name="user_pw" placeholder="비밀번호를 입력해 주세요.">

				</form>
				<button id="login_btn" type="button">로그인</button>

				<button type="button" id="back_btn"
					onclick="location.href=document.referrer"
					class="btn btn-primary block full-width m-b">돌아가기</button>
				<a id="a_css" class="btn btn-sm btn-white btn-block"
					href="./signup.jsp">회원가입</a>
			</div>
		</div>
	</div>

	<script type="text/javascript">
		$("#home").css("background-color", "#293846").css("border-left",
				"5px solid #6F141F").css("color", "white");
		$("#home").addClass("activate");
	</script>
</body>
</html>