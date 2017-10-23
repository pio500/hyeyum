<%@page import="java.util.Vector"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE>
<html>
<head>
<script type="text/javascript" src=".././resources/js/jquery-2.1.1.js"></script>
<script type="text/javascript" src=".././resources/js/lyk.js"></script>
<script type="text/javascript"
	src=".././resources/ck/ckeditor/ckeditor.js"></script>
<link href=".././resources/css/lyk.css" rel="stylesheet">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta charset="utf-8">
<title>자유게시판</title>
</head>
<body>
	<div id="wrapper">
		<%@include file=".././commonNav.jsp"%>
		<%@include file=".././commonSign.jsp"%>
		<div id="container">
			<div class="row">
				<div class="col-lg-12">
					<%
					String b = request.getParameter("b");
					String p = request.getParameter("p");
					if(b.equals("freeboard")) {
				%>
					<h1>글 수정 - 자유게시판</h1>
					<script type="text/javascript">
						$("#board").css("background-color", "#293846").css(
								"border-left", "5px solid #6F141F").css(
								"color", "white");
						$("#board").addClass("activate");
					</script>
					<%
					} else {
 				%>
					<h1>글수정 - 공지사항</h1>
					<script type="text/javascript">
						$("#notice").css("background-color", "#293846").css(
								"border-left", "5px solid #6F141F").css(
								"color", "white");
						$("#notice").addClass("activate");
					</script>
					<% 
					}
 				%>

					<%@include file=".././dao/getColumn.jsp"%>
					<form method="post" action=".././dao/bModifyProcess.jsp"
						id="bWriteProcess">
						<div class="form-group">
							<input type="text" name="title" placeholder="제목을 입력해 주세요."
								required="required" id="title" maxlength="40"
								class="form-control"
								style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 3px; margin-bottom: 10px;"
								value="<%=vo.getAt_title() %>">
						</div>
						<input type="hidden" name="at_type" value="<%=b%>"> <input
							type="hidden" name="at_writer" class="writer"
							value="<%=(String)session.getAttribute("nickname")%>"> <input
							type="hidden" name="at_ref" value="0"> <input
							type="hidden" name="at_re_lev" value="0"> <input
							type="hidden" name="at_re_step" value="0"> <input
							type="hidden" name="m" value="m"> <input type="hidden"
							name="at_id" value="<%=vo.getAt_id()%>">
						<textarea id="contents" name="contents" required="required"
							style="width: 100%; min-height: 200px;"
							placeholder=" 내용을 입력해 주세요" class="bor_r_7 bor_d"><%=vo.getAt_content() %></textarea>

						<script type="text/javascript">
							var ckfinder = '.././/resources/ck/ckfinder';
							var commonCommand = ckfinder
									+ '/core/connector/java/connector.java?command=QuickUpload';
							CKEDITOR.replace('contents', {
								toolbar : [
										{
											name : 'document',
											items : [ 'Source', '-',
													'DocProps', 'Preview',
													'Print' ]
										},

										{
											name : 'basicstyles',
											items : [ 'Bold', 'Italic',
													'Underline', 'Strike',
													'Subscript', 'Superscript',
													'-', 'RemoveFormat' ]
										},
										{
											name : 'paragraph',
											items : [ 'NumberedList',
													'BulletedList', '-',
													'Outdent', 'Indent', '-',
													'JustifyLeft',
													'JustifyCenter',
													'JustifyRight',
													'JustifyBlock' ]
										},

										{
											name : 'insert',
											items : [ 'Image', 'Smiley',
													'Link', 'SpecialChar' ]
										},

										{
											name : 'styles',
											items : [ 'Styles', 'Format',
													'Font', 'FontSize' ]
										}, {
											name : 'colors',
											items : [ 'TextColor', 'BGColor' ]
										}

								],
								filebrowserBrowseUrl : '',
								filebrowserImageBrowseUrl : '',
								filebrowserUploadUrl : '',
								filebrowserImageUploadUrl : '',
								FilesystemEncoding : 'CP949',
								enterMode : 'CKEDITOR.ENTER_BR',
								height : '350px'
							});
						</script>
						<%
							if(b.equals("freeboard")) {
						%>
						<a href="./board.jsp?p=<%=p%>">
							<button type="button"
								class="btn btn-default btn-xs btn-left btn-margin-top">목록
							</button>
						</a>
						<%	
							} else {
						%>
						<a href="./notice.jsp?p=<%=p%>">
							<button type="button"
								class="btn btn-default btn-xs btn-left btn-margin-top">목록
							</button>
						</a>
						<%  } 
						%>
						<a href="javascript:void(0);">
							<button type="submit" id="board_submit"
								class="btn btn-default btn-xs btn-left btn-margin-top">제출
							</button>
						</a>
					</form>
				</div>
			</div>
		</div>
	</div>

</body>
</html>