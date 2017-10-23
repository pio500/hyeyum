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
<title>글 읽기</title>
</head>
<body>
	<div id="wrapper">
		<%@include file=".././commonNav.jsp"%>
		<%@include file=".././commonSign.jsp"%>
		<div id="container">
			<div id="board">
				<%
					String p = request.getParameter("p");
					String n = request.getParameter("n");
				%>

				<%@include file=".././dao/getColumn.jsp"%>
				<% 

					String b = vo.getAt_type();
					if (vo.getAt_content().equals("")) {
						vo.setAt_content("<br><br>");
					}
					vo.setAt_pw("NOT ACCESS");
					/* 여기서 글이 지워졌는지 확인 */

					String title = vo.getAt_title();
					String content = vo.getAt_content();
					
					/*
					 * num에 해당하는 게시물의 코멘트를 모조리 불러와 comments에 넣음.
					 */
					content = content.replace("&amp;", "&");

					int article_id = vo.getAt_id();
				%>

				<div class="row">
					<div class="col-lg-12">
						<div class="ibox float-e-margins" style="margin-bottom: 10px;">
							<div class="ibox-title">
								<h5>
									#<%=vo.getAt_id()%>
									<%=vo.getAt_title()%></h5>
							</div>
							<div class="ibox-content" id="image-showing-aius" style="display: table;">
								<%=vo.getAt_content()%></div>

							<div class="ibox-infor">
								<img src=".././resources/btn-image/user.png"
									class="btn-image-lyk" style="margin-left: 0px;"><font><%=vo.getAt_writer()%></font>
								<img src=".././resources/btn-image/view.png"
									class="btn-image-lyk"><font><%=vo.getAt_hit()%></font> <img
									src=".././resources/btn-image/recommend.png"
									class="btn-image-lyk"><font id="at_recommend"><%=vo.getAt_recommend_num()%></font>
								<img src=".././resources/btn-image/time.png"
									class="btn-image-lyk"> <font><%=vo.getAt_date()%></font>
							</div>

						</div>
					</div>
				</div>

				<div class="row" style="height: 40px;">
					<div class="col-lg-12">
						<% if(vo.getAt_type().equals("freeboard")) { %>
						<a href="./board.jsp?p=<%=p%>">
							<button type="button" class="btn btn-default btn-xs btn-left">목록
							</button>
						</a>
						<% } else { %>
						<a href="./notice.jsp?p=<%=p%>">
							<button type="button" class="btn btn-default btn-xs btn-left">목록
							</button>
						</a>
						<% } %>

						<% if(session.getAttribute("id")!=null) { %>
						<a href="javascript:void(0);"><button type="button"
								class="btn btn-default btn-xs btn-left" id="bRecommend"
								data-b="<%=session.getAttribute("id")%>"
								data-a="<%=vo.getAt_id()%>">추천</button></a>
						<script type="text/javascript">
							$("#bRecommend")
									.click(
											function() {
												var _mem_id = $(this).data("b");
												var _article_id = $(this).data(
														"a");
												$
														.ajax({
															type : "post",
															url : ".././dao/bRecommandProcess.jsp",
															dataType : "text",
															data : {
																article_id : _article_id,
																mem_id : _mem_id
															},
															success : function(
																	data) {
																data = data
																		.trim();
																var bool = data
																		.substring(
																				0,
																				1);
																var recommend = data
																		.substring(1);
																if (bool == "Y") {
																	alert("추천하였습니다.");
																	$(
																			'#at_recommend')
																			.html(
																					recommend)
																} else {
																	alert("이미 추천하였습니다.");
																}
															},
															error : function(e,
																	xhr) {
																alert(e.status
																		+ ">"
																		+ xhr)
															},
															cache : false,
															async : false,
															contentType : "application/x-www-form-urlencoded;charset=utf-8"
														})
											});
						</script>
						<!-- <a href="/bReply?b=<%=b%>&p=<%=p%>&n=<%=n%>" id="reply"><button
									type="button" class="btn btn-default btn-xs btn-left"
									id="bReply">답글</button></a>  -->


						<% 
								int _level = 0;
								String _nickname = "";
								if (session.getAttribute("nickname") != null
									&& session.getAttribute("id") != null
										&& session.getAttribute("level") != null) {

									_level = (Integer) session.getAttribute("level");
									_nickname = (String)session.getAttribute("nickname");
								
									if(_level >= 9 || _nickname.equals(vo.getAt_writer())) { %>
						<a href="./modify.jsp?b=<%=b%>&p=<%=p%>&n=<%=n%>"><button
								type="button" class="btn btn-default btn-xs btn-left"
								id="bModify">수정</button></a>
						<% } %>
						<% } %>
						<% 
									if( ((Integer) session.getAttribute("level") >= 9 || _nickname.equals(vo.getAt_writer())) && vo.getAt_deleted().equals("N")) { %>
						<a href="javascript:void(0);"><button type="button"
								class="btn btn-default btn-xs btn-left" id="bDelete"
								data-a="<%=b%>" data-b="<%=vo.getAt_id()%>">삭제</button></a>
						<script type="text/javascript">
							$("#bDelete")
									.click(
											function() {
												var _article_id = $(this).data(
														"b");
												var board = $(this).data("a");
												$
														.ajax({
															type : "post",
															url : ".././dao/bDeleteProcess.jsp",
															dataType : "text",
															data : {
																article_id : _article_id
															},
															success : function(
																	data) {
																if (board == 'freeboard')
																	location.href = '.././bbs/board.jsp?p='
																			+
						<%=p%>
							;
																if (board == 'notice')
																	location.href = '.././bbs/notice.jsp?p='
																			+
						<%=p%>
							;
															},
															error : function(e,
																	xhr) {
																alert(e.status
																		+ ">"
																		+ xhr)
															},
															cache : false,
															async : false,
															contentType : "application/x-www-form-urlencoded;charset=utf-8"
														})
											});
						</script>
						<% } %>
						<% if(_level >= 9 && vo.getAt_deleted().equals("Y")) { %>
						<a href="#"><button type="button"
								class="btn btn-default btn-xs btn-left" id="atRestore"
								data-a="<%=b%>" data-b="<%=vo.getAt_id()%>">복구</button></a>
						<% } %>
						<% } %>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		
	<% 
		String _bb = b;
		if(_bb.equals("freeboard")){ %>
		$("#board").css("background-color", "#293846").css("border-left",
				"5px solid #6F141F").css("color", "white");
		$("#board").addClass("activate");
	<% } 
	 else {  %>
		$("#notice").css("background-color", "#293846").css("border-left",
				"5px solid #6F141F").css("color", "white");
		$("#notice").addClass("activate");
	<% } %>
		
	</script>
</body>
</html>