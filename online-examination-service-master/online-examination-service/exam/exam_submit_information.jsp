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
	class Person {
		String user_id;
		int user_no;
		int score;
	}
	
	Exam e12 = new Exam();
	Vector<Exam> vec = new Vector<Exam>();
	Vector<Person> person = new Vector<Person>();
	int result = 0;
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
		
		rs.close();
		Query = "select count(*) from meta_examination_questionset where meta_examination = " + no;
		pstmt = conn.prepareStatement(Query);
		rs = pstmt.executeQuery(Query);
		rs.next();
		result = rs.getInt(1);

		rs.close();
		
		Query = "select * from meta_examination_pass where examination_no = " + no + " order by examination_score desc";
		pstmt = conn.prepareStatement(Query);
		rs = pstmt.executeQuery(Query);
		while (rs.next()) {
			Person tmp = new Person();
			tmp.user_id = rs.getString("user_id");
			tmp.score = rs.getInt("examination_score");
			person.add(tmp);
		}
		rs.close();
		
		for(int i=0; i<person.size(); i++) {
			Query = "select * from meta_user where mem_id = '" + person.elementAt(i).user_id  + "'" ;
			pstmt = conn.prepareStatement(Query);
			rs = pstmt.executeQuery(Query);
			while (rs.next()) {
				person.elementAt(i).user_no = rs.getInt("id");
			}
			rs.close();
		}
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
						<font size="3em">시험 설명 : <%=e12.explain%></font><br> <br>
						<font size="3em">시험 제출자 : <%=e12.create_user%></font><br> <br>
						<font size="3em">시험 시작 시간 : <%=e12.start%></font><br> <br>
						<font size="3em">시험 종료 시간 : <%=e12.end%></font><br> <br>
						<font size="3em">시험 개설 날짜 : <%=e12.create%></font><br> <br>
						<font size="3em">시험 총 문제 수 : <%=result%></font><br> <br>
						<font color="red" size="3em"><b>답안 제출자 수 : <%=person.size()%></b></font><br>
						<br>
					</div>
					<% if(person.size() > 0) { %>
					<div class="ibox-infor">
						<table border="1"
							style="width: 100%; text-align: center; margin-top: 10px; margin-bottom: 25px;">
							<colgroup>
								<col class="column1" style="width: 20%">
								<col class="column2" style="width: 30%">
								<col class="column3" style="width: 20%">
							</colgroup>
							<tr>
								<th>등수</th>
								<th>답안 제출자 아이디</th>
								<th>점수</th>
							</tr>
							<% int all_score = 0; %>
							<% for(int i=0; i<person.size(); i++) { all_score += person.elementAt(i).score; %> 
							<tr
								style="cursor: pointer; text-align:center; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
								<td style="padding: 5px 0;"><%=i+1%>등</td>
								<td style="padding: 5px 0; cursor: pointer; text-align:center;"><a style="cursor: pointer; text-align:center;"
									href=".././user/submitter_infor.jsp?no=<%=e12.no%>&user_no=<%=person.elementAt(i).user_no%>&user_id=<%=person.elementAt(i).user_id%>"><font style="float: inherit;"
										size="2em"><%=person.elementAt(i).user_id %> - <b>답안지 확인</b></font></a></td>
								<td style="padding: 5px 0;"><%=person.elementAt(i).score %> / <%=e12.score %></td>
							</tr>
							<%}%>
							<tr>
								<td style="padding: 5px 0;"></td>
								<td style="padding: 5px 0;">평균 점수</td>
								<td style="padding: 5px 0;"><b style="color: red"><%=all_score/person.size()%></b></td>
							</tr>
						</table>
						<br>

					</div>
					<% } %>
				</div>
			</div>
		</div>
	</div>
	<!--
	
-->
	<script type="text/javascript">
		$("#submit").css("background-color", "#293846").css("border-left",
				"5px solid #6F141F").css("color", "white");
		$("#submit").addClass("activate");
	</script>
</body>
</html>
