
<%@page import="java.util.Vector"%>
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
<title>공지사항</title>
</head>
<body>
	<div id="wrapper">
		<%@include file=".././commonNav.jsp"%>
		<%@include file=".././commonSign.jsp"%>
		<%@include file=".././dao/selectNotice.jsp"%>
		<div id="container">
			<div id="board">
				<%
					int p = 1;
					if(request.getParameter("p")==null) {
						;
					} else {
						p = Integer.parseInt(request.getParameter("p"));
					}
							
						
					// 현재 게시판 종류의 총 게시물의 갯수를 가져옴.
					page_num = num % 3;
					// 현재 게시물의 갯수를 15로 나눈 나머지가 0이 아닐경우, 페이지가 한개 더 추가됨.
					if (page_num == 0)
						page_num = num /3;
					else
						page_num = (num / 3) + 1;
					// 총 페이지의 갯수를 지정함.
					int curr_page_num = p;
					// 현재 페이지 넘버를 가지는 정수형 변수.
					int curr_page = (int) ((curr_page_num - 1) / 10);
					int pt = (int) page_num / 10;
					int n = 0;
					
					String board = "notice";
				%>
				<div id="board_header"></div>
				<div id="board_container">
					<% for(BoardVO article : vec) { %>
					<div class="row">
						<div class="col-lg-12"
							onclick="n_hit_up('<%=article.getAt_id() %>', 'notice', '<%=curr_page_num %>')"
							style="cursor: pointer;">


							<div class="ibox" style="margin-bottom: 10px;">
								<div class="ibox-title">
									<% if(article.getAt_deleted().equals("N")) { %>
									<h5>
										#<%=article.getAt_id() %>
										<%=article.getAt_title() %>

									</h5>
									<% } %>
								</div>
								<div class="ibox-content" style="display: table;">
									<%=article.getAt_content() %>
								</div>
								<div class="ibox-infor">
									<img src=".././resources/btn-image/user.png"
										class="btn-image-lyk" style="margin-left: 0px;"><font><%=article.getAt_writer() %></font>
									<img src=".././resources/btn-image/view.png"
										class="btn-image-lyk"><font><%=article.getAt_hit() %></font>
									<img src=".././resources/btn-image/recommend.png"
										class="btn-image-lyk"><font><%=article.getAt_recommend_num() %></font>
									<img src=".././resources/btn-image/time.png"
										class="btn-image-lyk"> <font><%=article.getAt_date() %></font>
								</div>
							</div>
						</div>
					</div>
					<% } %>
				</div>

				<div class="col-lg-12" style="text-align: center;">
					<div class="btn-group">
						<% if (p==1) { %>
							<% if(p!=page_num) { %>
								<button class="btn btn-white btn-height-34 btn-navigate-board" style="width: 120px;"
									onclick="location.href ='./notice.jsp?p=<%=p+1%>'">다음 페이지</button>
							<% } %>
						<% } %>
						<% if(p==page_num) { %>
							   <% if(page_num!=1) { %>
							   		<button class="btn btn-white btn-height-34 btn-navigate-board" style="width: 120px;"
							   		onclick="location.href ='./notice.jsp?p=<%=p-1%>'">이전 페이지</button>
							   <% } %>
						<% } %>
						<%  if(session.getAttribute("id")!=null) {
						 	if((Integer)session.getAttribute("level") >= 9) { %>
						<a href="./write.jsp?b=<%=board%>&p=<%=p%>"><button
								type="button" class=" btn-white btn btn-height-34"
								style="width: 80px;">글쓰기</button></a>
						<%		}
						} %>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!--
	
-->
	<script type="text/javascript">
		$("#notice").css("background-color", "#293846").css("border-left",
				"5px solid #6F141F").css("color", "white");
		$("#notice").addClass("activate");
	</script>
</body>
</html>