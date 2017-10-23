
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE>
<html>
<head>
<script type="text/javascript" src=".././resources/js/jquery-2.1.1.js"></script>
<script type="text/javascript" src=".././resources/js/lyk.js"></script>
<link rel="stylesheet" type="text/css"
	href=".././resources/css/blocksitstyle.css">
<script type="text/javascript" src=".././resources/js/blocksit.min.js"></script>
<link href=".././resources/css/lyk.css" rel="stylesheet">

<script type="text/javascript">
	$(document).ready(function() {
		Cols = Math.round($("#SearchResults").width() / 300);
		CollectionCheck = {
			"강신표" : "0",
			"정진국" : "0"
		};
		$("#SearchResults").BlocksIt({
			numOfCol : Cols,
			offsetX : 8,
			offsetY : 8
		});

		$(window).resize(function() {
			Cols = Math.round($("#SearchResults").width() / 300);
			$("#SearchResults").BlocksIt({
				numOfCol : Cols,
				offsetX : 8,
				offsetY : 8
			});
		});
	});

	function MakeDIV(Val) {
		var StrTmp = "<div class='grid' Value = " + Val.ID + " DType='" + Val.Type + "'>";

		if (Val.Description.length > 100) {
			Description_ListView = Val.Description.substr(0, 100) + "...";
		} else {
			Description_ListView = Val.Description;
		}
		Description_ListView = Description_ListView.replace("\\", "");

		if (Val.ImgSrc != "")
			StrTmp += "<div class='imgholder'><img src='" + Val.ImgSrc + "'/></div>";

		StrTmp += "<strong>" + Val.Title + "</strong><p>"
				+ Description_ListView + "</p><div class='meta'>" + Val.Writer
				+ "</div></div>";

		return StrTmp;
	}
</script>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta charset="utf-8">
<title>시험 응시</title>
</head>
<body>
	<div id="wrapper">
		<%@include file=".././commonNav.jsp"%>
		<%@include file=".././commonSign.jsp"%>

		<div id="container">
			<% if (session.getAttribute("no")!=null) { 
				if((int)(session.getAttribute("level")) < 6) {
					out.println("권한이 없습니다.");
				}
			 	else {
			%><%@include file="./nExamGetProcess.jsp"%>
			<div id="SearchResults">
				<% for(int i=0; i<vec.size(); i++) { 
					if(vec.elementAt(i).state=="true") {
				%>
				<div class="grid" style="text-align: center;">
					<div class='imgholder'
						onclick="location.href='./exam_information.jsp?no=<%=vec.elementAt(i).no%>'">
						<b><font size="3em"><%=vec.elementAt(i).title%></font></b> <font
							size="2em"><%=vec.elementAt(i).explain%></font> <font size="2em"><%=vec.elementAt(i).create_user%></font>
						<font size="2em"><%=vec.elementAt(i).start %> ~<br> <%=vec.elementAt(i).end %></font>
					</div>
				</div>
				<%  } else { %>
				<div class="grid"
					style="text-align: center; background-color: #D5D5D5; cursor: default;">
					<div class='imgholder'>
						<b><font size="3em"><%=vec.elementAt(i).title%></font></b> <font
							size="2em"><%=vec.elementAt(i).explain%></font> <font size="2em"><%=vec.elementAt(i).create_user%></font>
						<font size="2em">받은 점수 : <%=vec.elementAt(i).score%></font> <font
							size="2em">시험 총 점수 : <%=vec.elementAt(i).overall_score%></font>
					</div>
				</div>
				<% }
				} %>
			</div>
			<%} } else {
				out.println("권한이 없습니다.");
			}%>
		</div>
	</div>
	<!--
	
-->
	<script type="text/javascript">
		$("#examination").css("background-color", "#293846").css("border-left",
				"5px solid #6F141F").css("color", "white");
		$("#examination").addClass("activate");
	</script>
</body>
</html>