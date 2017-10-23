<%@page import="java.util.Vector"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%
	class Exam {
		public int no;
		public String create_user;
		public String title;
		public String explain;
		public String start;
		public String end;
		public String password;
		public String create;
		public int score;
	}

	Exam e12 = new Exam();
	int result = 0;
	Vector<Exam> vec = new Vector<Exam>();
	int no = Integer.parseInt(request.getParameter("no"));
	String url 	= "jdbc:mysql://passion.chonbuk.ac.kr:3306/a201110584?characterEncoding=utf8";
	String id 	= "a201110584";
	String pass = "1234";
	Connection conn = null;
	ResultSet rs;
	PreparedStatement pstmt = null;
	String Query;
	try {
		Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection(url, id, pass);
	} catch(ClassNotFoundException e) {
		e.printStackTrace();
	} catch(SQLException e) {
		e.printStackTrace();
	}
	try {
		Query = "select * from meta_examination where no = " + no;
		pstmt = conn.prepareStatement(Query);
		rs = pstmt.executeQuery(Query);

		
		while (rs.next()) {
			e12.no = rs.getInt("no");
			e12.create_user = rs.getString("create_user");
			e12.title = rs.getString("title");
			e12.explain = rs.getString("explain2");
			e12.start = rs.getString("start_time");
			e12.end = rs.getString("end_time");
			e12.password = rs.getString("password");
			e12.create = rs.getString("r_date");
			e12.score = rs.getInt("score");
			
		}
		rs.close();
		Query = "select count(*) from meta_examination_questionset where meta_examination = " + no;
		pstmt = conn.prepareStatement(Query);
		rs = pstmt.executeQuery(Query);
		rs.next();
		result = rs.getInt(1);

		rs.close();
	}  catch (SQLException ee1) {
		if(conn!=null) conn.close();
	}  finally {
		
	}
%>
<!DOCTYPE>
<html>
<head>
<script type="text/javascript" src=".././resources/js/jquery-2.1.1.js"></script>
<script type="text/javascript" src=".././resources/js/lyk.js"></script>
<link rel="stylesheet" type="text/css"
	href=".././resources/css/blocksitstyle.css">
<script type="text/javascript" src=".././resources/js/blocksit.min.js"></script>
<link href=".././resources/css/lyk.css" rel="stylesheet">

<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta charset="utf-8">
<title>시험 정보</title>
</head>
<body>
	<div id="wrapper">
		<%@include file=".././commonNav.jsp"%>
		<%@include file=".././commonSign.jsp"%>
		<div id="container">
			<div class="row">
				<div class="ibox">
					<div class="ibox-title">
						<b><font size="3em">시험 명 : <%=e12.title%></font></b><br>
					</div>
					<div class="ibox-content">
						<font size="3em">시험 설명 : <%=e12.explain%></font><br>
						<br> <font size="3em">시험 제출자 : <%=e12.create_user%></font><br>
						<br> <font size="3em">시험 시작 시간 : <%=e12.start%></font><br>
						<br> <font size="3em">시험 종료 시간 : <%=e12.end%></font><br>
						<br> <font size="3em">시험 개설 날짜 : <%=e12.create%></font><br>
						<br> <font size="3em">시험 총 문제 수 : <%=result%></font><br>
						<br> <font size="3em">시험 총 점수 : <%=e12.score%>점
						</font><br>
						<br>
					</div>
					<div class="ibox-infor">
						<% if(!e12.password.equals("")) { %>
						<b style="color: red">시험 비밀번호 입력 : </b><input type="password"
							id="pass" required="required"
							style="padding: 5px 10px; margin-right: 5px;">
						<% } %>
						<button
							style="margin-left: 5px; background: white; border: 1px solid #ddd; border-radius: 3px; padding: 5px 20px;">시험
							시작</button>
						<script type="text/javascript">
							$("button").click(function() {
								if ( $("#pass").val() == null ) {
									//여기는 시험 비밀번호가 없는 부분;
									location.href="./vExam.jsp?no=<%=e12.no%>";
								} 
								else {
									var tmp = $("#pass").val();
									$.ajax({
										type : "post",
										url : "./nExamPasswordCheck.jsp",
										dataType : "text",
										data : {
											no : '<%=e12.no%>',
											password : tmp
										},
										success : function(data) {
											if(data.trim()=="Y") {
												//여기서 시험에 등록을 해야함, 만약 등록을안한 사람이 접근을 하면 거부해야 하니까.
												location.href="./vExam.jsp?no=<%=e12.no%>";
																	} else
																		alert("시험 비밀번호가 일치하지 않습니다.");
																},
																error : function(
																		e, xhr) {
																	alert(e.status
																			+ ">"
																			+ xhr)
																},
																cache : false,
																async : false,
																contentType : "application/x-www-form-urlencoded;charset=utf-8"
															});
												}
											});
						</script>
					</div>
				</div>
			</div>
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