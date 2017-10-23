
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE>
<html>
<head>
<script type="text/javascript" src="./resources/js/jquery-2.1.1.js"></script>
<script type="text/javascript" src="./resources/js/lyk.js"></script>
<link href="./resources/css/lyk.css" rel="stylesheet">


<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black" />
<meta name="viewport" content="width=device-width,
                               initial-scale=1.0,
                               maximum-scale=1.0,
                               user-scalable=no">
<meta charset="utf-8">


<title>혜윰</title>
</head>
<body onload="document.getElementById('nav').height = document.height;">
	<div id="wrapper">
		<%@include file="./commonNav.jsp"%>
		<%@include file="./commonSign.jsp"%>
		<%@include file="./dao/getNotice.jsp"%>
		<div id="container">
			<div class="row">
				<div class="ibox">
					<div class="ibox-title">
						<h5>
							#<%=vo.getAt_id() %>
							<%=vo.getAt_title() %>

						</h5>
					</div>
					<div class="ibox-content"  style="display: table;">
						<%=vo.getAt_content() %>
					</div>
					<div class="ibox-infor">
						<img src="./resources/btn-image/user.png" class="btn-image-lyk"
							style="margin-left: 0px;"><font><%=vo.getAt_writer()%></font>
						<img src="./resources/btn-image/view.png" class="btn-image-lyk"><font><%=vo.getAt_hit()%></font>
						<img src="./resources/btn-image/recommend.png"
							class="btn-image-lyk"><font id="at_recommend"><%=vo.getAt_recommend_num()%></font>
						<img src="./resources/btn-image/time.png" class="btn-image-lyk">

						<font><%=vo.getAt_date()%></font>
					</div>
				</div>
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