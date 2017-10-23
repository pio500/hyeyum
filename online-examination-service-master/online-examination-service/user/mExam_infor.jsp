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
<title>시험 제출 정보 확인</title>
</head>
<body>
	<div id="wrapper">
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
			public int overall_score;
			public int exam_s;
			public int exam_t;
		}
		class View {
			String text;
		}
		class Question {
			public String title;
			public String text;
			public String anwser;
			public String my_anwser;
			public int q_no;
			public String explain;
			public int score;
			public int state;
			Vector<View> vec;
			
			Question() { 
				vec = new Vector<View>();
			}
		}
		Exam e12 = new Exam();
		int result = 0;
		Vector<Exam> vec = new Vector<Exam>();
		Vector<Question> vec_q = new Vector<Question>();
		
		int no = Integer.parseInt(request.getParameter("no"));
		int user_no = (int)session.getAttribute("no");
		String user_id = (String)session.getAttribute("id");
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
				e12.overall_score = rs.getInt("score");
				
				vec.add(e12);
			}
			rs.close();
			
			Query = "select * from meta_examination_pass where examination_no = " + e12.no + " and user_id = '" + user_id + "'";
			pstmt = conn.prepareStatement(Query);
			rs = pstmt.executeQuery(Query);
		
			while (rs.next()) {
				e12.score = rs.getInt("examination_score");
			}
			rs.close();
			
			
			Query = "select * from meta_examination_questionset where meta_examination = " + no;
			pstmt = conn.prepareStatement(Query);
			rs = pstmt.executeQuery(Query);
			
			while (rs.next()) {
				Question q12 = new Question();
				q12.q_no = rs.getInt("meta_question_no");
				q12.score = rs.getInt("meta_question_score");
				vec_q.add(q12);
			}
			rs.close();
			for(int i=0; i< vec_q.size(); i++) {
				Query = "select * from meta_question_solved where exam_no = " + e12.no + " and question_no = " + vec_q.elementAt(i).q_no + " and user_no = " + user_no;
				pstmt = conn.prepareStatement(Query);
				rs = pstmt.executeQuery(Query);
				
				while (rs.next()) {
					vec_q.elementAt(i).state = rs.getInt("state");
					vec_q.elementAt(i).my_anwser = rs.getString("answer");
				}
				rs.close();
			}
			
			
			for(int i=0; i<vec_q.size(); i++) {
				Query = "select * from meta_question_question where question_no = " + vec_q.elementAt(i).q_no;
				pstmt = conn.prepareStatement(Query);
				rs = pstmt.executeQuery(Query);
				
				while (rs.next()) {

					View v = new View();
					v.text = rs.getString("question");
					vec_q.elementAt(i).vec.add(v);
				}
				rs.close();
			}
			
			for(int i=0; i<vec_q.size(); i++) {
				Query = "select * from meta_question where no = " + vec_q.elementAt(i).q_no;
				pstmt = conn.prepareStatement(Query);
				rs = pstmt.executeQuery(Query);
				
				while (rs.next()) {
					
					vec_q.elementAt(i).title = rs.getString("title");
					vec_q.elementAt(i).text = rs.getString("text");
					vec_q.elementAt(i).explain = rs.getString("answer_explanation");
					vec_q.elementAt(i).anwser = rs.getString("answer");
				}
				rs.close();
			}
			
			
		}  catch (SQLException ee1) {
			out.println(ee1.getMessage());
			if(conn!=null) conn.close();
		}  finally {
			
		}
		%>
		<%@include file=".././commonNav.jsp"%>
		<%@include file=".././commonSign.jsp"%>
		<div id="container">
			<div class="exam_information row">
				<div class="ibox" style="text-align: center;">
					<div class="ibox-title">
						<b><font style="margin: 0 auto; float: none;">제출한 답안지 정보</font></b>
					</div>
					<div class="ibox-content" style="padding-top: 16px;">
						<font style="margin: 0 auto; float: none;">시험 제목 : <%=e12.title %></font>
						<font style="margin: 0 auto; float: none;">시험 설명 : <%=e12.explain %></font>
						<font style="margin: 0 auto; float: none;">제출자 : <%=e12.create_user %></font>
						<font style="margin: 0 auto; float: none;">점수 : <%=e12.score %>/
							<%=e12.overall_score %></font><br>
					</div>
				</div>
			</div>
			<div class="examination row">
				<% 
				for(int i=0; i<vec_q.size(); i++) { %>
				<% if(vec_q.elementAt(i).state!=0) { %>
				<div class="ibox question_s" style="margin-bottom: 10px;">
					<% } else { %>
					<div class="ibox question_s"
						style="color: red; margin-bottom: 10px;">
						<% } %>
						<div class="ibox-title">
							<% if(vec_q.elementAt(i).state!=0) { %>
							<font size="4em" style="margin: 0 auto; float: none;"><b><%=i+1%>번
									- <%=vec_q.elementAt(i).title %></b> [<%=vec_q.elementAt(i).score %>점]
								- 맞았습니다.</font>
							<% } else { %>
							<font size="4em" style="color: red; margin: 0 auto; float: none;"><b><%=i+1%>번
									- <%=vec_q.elementAt(i).title %></b> [<%=vec_q.elementAt(i).score %>점]
								- 틀렸습니다.</font>
							<% } %>

						</div>
						<div class="ibox-content" style="padding-top: 17px;">
							<% if(vec_q.elementAt(i).state!=0) { %>
							<font>문제 내용 : <%=vec_q.elementAt(i).vec.elementAt(0).text %></font><br>
							<font>문제 참조 : <%=vec_q.elementAt(i).text %></font><br> <font>문제
								해설 : <%=vec_q.elementAt(i).explain %></font><br>
							<br>
							<% } else { %>
							<font color="red">문제 내용 : <%=vec_q.elementAt(i).vec.elementAt(0).text %></font><br>
							<font color="red">문제 참조 : <%=vec_q.elementAt(i).text %></font><br>
							<font color="red">문제 해설 : <%=vec_q.elementAt(i).explain %></font><br>
							<br>
							<% } %>

						</div>
						<% if(vec_q.elementAt(i).vec.size() >=2 ) { %>
						<div class="ibox-content">
							<% for(int j=0; j<vec_q.elementAt(i).vec.size()-1; j++) { %>
							<%=j+1%>
							번:
							<%=vec_q.elementAt(i).vec.elementAt(j+1).text %><br>
							<% } %>
						</div>
						<% } %>
						<div class="ibox-infor">
							<% if(vec_q.elementAt(i).state!=0) { %>
							<font>답 - <%=vec_q.elementAt(i).anwser %> [ 제출한 답 - <%=vec_q.elementAt(i).my_anwser %>
								]
							</font>
							<% } else { %>
							<b><font style="color: red">답 - <%=vec_q.elementAt(i).anwser %>
									[ 제출한 답 - <%=vec_q.elementAt(i).my_anwser %> ]
							</font></b>
							<% } %>
						</div>
					</div>
					<% } %>
				</div>
			</div>
		</div>

		<script type="text/javascript">
			$("#mypage").css("background-color", "#293846").css("border-left",
					"5px solid #6F141F").css("color", "white");
			$("#mypage").addClass("activate");
		</script>
</body>
</html>