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
<title>시험지 생성</title>
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
		}
		class View {
			String text;
		}
		class Question {
			public String title;
			public String text;
			
			public int q_no;
			public int score;
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
				
				vec.add(e12);
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
			for(int i=0; i<vec_q.size(); i++) {
				Query = "select * from meta_question where no = " + vec_q.elementAt(i).q_no;
				pstmt = conn.prepareStatement(Query);
				rs = pstmt.executeQuery(Query);
				
				while (rs.next()) {
					vec_q.elementAt(i).title = rs.getString("title");
					vec_q.elementAt(i).text = rs.getString("text");
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
						<b><font style="margin: 0 auto; float: none;">시험 정보</font></b>
					</div>
					<div class="ibox-content" style="padding-top: 16px;">
						<font style="margin: 0 auto; float: none;">시험 제목 : <%=e12.title %></font>
						<font style="margin: 0 auto; float: none;">시험 설명 : <%=e12.explain %></font>
						<font style="margin: 0 auto; float: none;">제출자 : <%=e12.create_user %></font>
						<font style="margin: 0 auto; float: none;">총점 : <%=e12.score %></font>
						<font style="margin: 0 auto; float: none;">시작 시간 : <%=e12.start %></font>
						<font style="margin: 0 auto; float: none;">종료 시간 : <%=e12.end %></font><br>
					</div>
				</div>
			</div>
			<div class="examination row">
				<% 
				for(int i=0; i<vec_q.size(); i++) { %>
				<div class="ibox question_s" style="margin-bottom: 10px;">
					<div class="ibox-title">
						<font size="4em" style="margin: 0 auto; float: none;"><b><%=i+1%>번
								- <%=vec_q.elementAt(i).title %></b> [<%=vec_q.elementAt(i).score %>점]</font>
					</div>
					<div class="ibox-content" style="padding-top: 17px;">
						<font>문제 내용 : <%=vec_q.elementAt(i).vec.elementAt(0).text %></font><br>
						<font>문제 참조 : <%=vec_q.elementAt(i).text %></font>
					</div>
					<% if(vec_q.elementAt(i).vec.size() >=2 ) { %>
					<div class="ibox-content">
						<br>
						<% for(int j=0; j<vec_q.elementAt(i).vec.size()-1; j++) { %>
						<%=j+1%>
						번:
						<%=vec_q.elementAt(i).vec.elementAt(j+1).text %><br>
						<% } %>
						<br>
					</div>
					<% } %>
					<div class="ibox-infor">
						답 -
						<% if(vec_q.elementAt(i).vec.size() >=2 ) { %>
						<% for(int j=0; j<vec_q.elementAt(i).vec.size()-1; j++) { %>
						<%=j+1%>
						번 <input class="ans_radio" type="radio"
							data-qid="<%=vec_q.elementAt(i).q_no%>" data-index="<%=j+1%>">
						<% } %>
						<% } else { %>
						<input style="padding: 3px 20px; width: 300px;" class="question_s"
							type="text" data-qid="<%=vec_q.elementAt(i).q_no%>">
						<% } %>
					</div>
					<script type="text/javascript"> 
						$(".ans_radio").click(function() {
							var tmp = $(this).data("index");
							$(this).parent().children().each(function(index) {
								if($(this).data("index")!=tmp) {
									$(this).removeClass("question_s");
									$(this).attr("checked", false);
								} else {
									$(this).addClass("question_s");
								}
							});
						});
					</script>
				</div>
				<% } %>
			</div>
			<button
				style="display: block; margin: 0 auto; background: white; border: 1px solid #ddd; border-radius: 3px; padding: 5px 20px;"
				id="submit_exam">시험지 제출</button>
			<script type="text/javascript"> 
				$("#submit_exam").click(function() {
					if(confirm("이대로 제출하시겠습니까?")==true) {
						var result = "";
						var testing = 0;
						
						$(".question_s").each(function(index) {
							if(index%2==1) {
								var t = $(this).val();
								if(t=="") t = "&&&";
								else if(t=="on") {
									t = $(this).data("index");
									
								}
								testing++;
								var _text = $(this).data("qid") + "@@@" + t;
								result += _text + "###";
							}
						});
						if(<%= vec_q.size() %>!= testing) {
							alert("문제를 다 푼 후에 제출해 주시기 바랍니다.");
							return false;
						}
						$.ajax({
							type : "post",
							url : "./vExamSubmitProcess.jsp",
							dataType : "text",
							data : {
								no : "<%=e12.no %>",
														text : result
													},
													success : function(data) {
														//alert(data.trim());
														//	alert(data.trim());
														location.href = "./examination.jsp";
													},
													error : function(e, xhr) {
														alert(e.status + ">"
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
	<script type="text/javascript">
		$("#examination").css("background-color", "#293846").css("border-left",
				"5px solid #6F141F").css("color", "white");
		$("#examination").addClass("activate");
	</script>
</body>
</html>