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
		public String r_date;
		public int score;
		public int overall_score;
		public int exam_s;
		public int exam_t;
	}
	Vector<Exam> vec_e = new Vector<Exam>();
	String url 	= "jdbc:mysql://passion.chonbuk.ac.kr:3306/a201110584?characterEncoding=utf8";
	String id 	= "a201110584";
	String pass = "1234";
	Connection conn = null;
	ResultSet rs;
	PreparedStatement pstmt = null;
	String Query;
	
	int user_id = (int)session.getAttribute("no");
	String mem_id = (String)session.getAttribute("id");
	
	
	try {
		Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection(url, id, pass);
	} catch(ClassNotFoundException e) {
		e.printStackTrace();
	} catch(SQLException e) {
		e.printStackTrace();
	}
	try {
		Query = "select * from meta_examination_pass where user_id = '" + mem_id + "' order by r_date asc";
		pstmt = conn.prepareStatement(Query);
		rs = pstmt.executeQuery(Query);
	
		while (rs.next()) {
			Exam tmp = new Exam();
			tmp.no =  rs.getInt("examination_no");
			tmp.score =  rs.getInt("examination_score");
			tmp.r_date =  rs.getString("r_date").substring(5, 16); 
			vec_e.add(tmp);
		}
		rs.close();
		
		for(int i=0; i<vec_e.size(); i++) {
			int rowcount = 0;
			Query = "select * from meta_examination where no = " + vec_e.elementAt(i).no;
			pstmt = conn.prepareStatement(Query);
			rs = pstmt.executeQuery(Query);
		
			while (rs.next()) {
				vec_e.elementAt(i).create_user = rs.getString("create_user");
				vec_e.elementAt(i).title = rs.getString("title");
				vec_e.elementAt(i).explain = rs.getString("explain2");
				vec_e.elementAt(i).overall_score = rs.getInt("score");
			}
			rs.close();
			
			Query ="SELECT COUNT(*) FROM meta_examination_pass where examination_no = " + vec_e.elementAt(i).no;
			pstmt = conn.prepareStatement(Query);
			rs = pstmt.executeQuery(Query);
     	
			if(rs.next()) vec_e.elementAt(i).exam_s  = rs.getInt(1);
			rs.close();
			
			Query ="SELECT COUNT(*) FROM meta_examination_pass where examination_no = " + vec_e.elementAt(i).no + " and examination_score >= " + vec_e.elementAt(i).score;
			pstmt = conn.prepareStatement(Query);
			rs = pstmt.executeQuery(Query);
     	
			if(rs.next()) vec_e.elementAt(i).exam_t  = rs.getInt(1);
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
<script type="text/javascript" src=".././resources/js/Chart.min.js"></script>
<script type="text/javascript">
		$(document).ready(function() {
			Cols = Math.round($("#SearchResults").width() / 300); 
			CollectionCheck = {"강신표":"0", "정진국":"0"};
			$("#SearchResults").BlocksIt({numOfCol: Cols, offsetX: 8, offsetY: 8});

			$(window).resize(function() {
				Cols = Math.round($("#SearchResults").width() / 300);      
				$("#SearchResults").BlocksIt({numOfCol: Cols, offsetX: 8, offsetY: 8});
			});
		});
		
		function MakeDIV(Val) {
			var StrTmp = "<div class='grid' Value = " + Val.ID + " DType='" + Val.Type + "'>";
			if (Val.Description.length > 100){
				Description_ListView = Val.Description.substr(0, 100) + "...";
			}
			else {
				Description_ListView = Val.Description;
			}
			Description_ListView = Description_ListView.replace("\\", "");
			if(Val.ImgSrc != "") StrTmp += "<div class='imgholder'><img src='" + Val.ImgSrc + "'/></div>";
			StrTmp += "<strong>" +  Val.Title  + "</strong><p>" + Description_ListView + "</p><div class='meta'>" + Val.Writer + "</div></div>";
			return StrTmp;
		}

	</script>
<% if(vec_e.size() > 0 ) { %>
<script type="text/javascript">
	$(function () {

	    var barData = {
				<% int _max = vec_e.size(); if(_max>=5) _max = 5; %>
	    		labels : [ "<%=vec_e.elementAt(0).title%>"
          		<%  for(int i=1; i<_max; i++) { %>
          				, "<%=vec_e.elementAt(i).title%>"
          		<%	} %>
          		],
	        datasets: [
	            {
	                label: "받은 점수",
	                fillColor: "rgba(220,220,220,0.5)",
	                strokeColor: "rgba(220,220,220,0.8)",
	                highlightFill: "rgba(220,220,220,0.75)",
	                highlightStroke: "rgba(220,220,220,1)",
	                data: [ <%=vec_e.elementAt(0).score%>	
	          		<%  for(int i=1; i<_max; i++) { %>
	          				, <%=vec_e.elementAt(i).score%>
	          		<%	} %>
	          		]
	            },
	            {
	                label: "총점",
	                fillColor: "rgba(26,179,148,0.5)",
	                strokeColor: "rgba(26,179,148,0.8)",
	                highlightFill: "rgba(26,179,148,0.75)",
	                highlightStroke: "rgba(26,179,148,1)",
	                data: [ <%=vec_e.elementAt(0).score%>	
	          		<%  for(int i=1; i<_max; i++) { %>
	          				, <%=vec_e.elementAt(i).overall_score%>
	          		<%	} %>
	          		]
	            }
	        ]
	    };

	    var barData2 = {
	    		labels : [ "<%=vec_e.elementAt(0).title%>"
          		<%  for(int i=1; i<_max; i++) { %>
          				, "<%=vec_e.elementAt(i).title%>"
          		<%	} %>
          		],
	        datasets: [
	            {
	                label: "받은 점수",
	                fillColor: "rgba(220,220,220,0.5)",
	                strokeColor: "rgba(220,220,220,0.8)",
	                highlightFill: "rgba(220,220,220,0.75)",
	                highlightStroke: "rgba(220,220,220,1)",
	                data: [ <%=vec_e.elementAt(0).exam_t%>	
	          		<%  for(int i=1; i<_max; i++) { %>
	          				, <%=vec_e.elementAt(i).exam_t%>
	          		<%	} %>
	          		]
	            },
	            {
	                label: "총점",
	                fillColor: "rgba(26,179,148,0.5)",
	                strokeColor: "rgba(26,179,148,0.8)",
	                highlightFill: "rgba(26,179,148,0.75)",
	                highlightStroke: "rgba(26,179,148,1)",
	                data: [ <%=vec_e.elementAt(0).exam_s%>	
	          		<%  for(int i=1; i<_max; i++) { %>
	          				, <%=vec_e.elementAt(i).exam_s%>
	          		<%	} %>
	          		]
	            }
	        ]
	    };
	    var barOptions = {
	        scaleBeginAtZero: true,
	        scaleShowGridLines: true,
	        scaleGridLineColor: "rgba(0,0,0,.05)",
	        scaleGridLineWidth: 1,
	        barShowStroke: true,
	        barStrokeWidth: 2,
	        barValueSpacing: 5,
	        barDatasetSpacing: 1,
	        responsive: true,
	    }

	    var ctx = document.getElementById("barChart").getContext("2d");
	    var myNewChart = new Chart(ctx).Bar(barData, barOptions);
	  

	    var ctx2 = document.getElementById("barChart2").getContext("2d");
	    var myNewChart2 = new Chart(ctx2).Bar(barData2, barOptions);
	});
	    
	</script>
<% } %>
<link rel="stylesheet" type="text/css"
	href=".././resources/css/blocksitstyle.css">
<script type="text/javascript" src=".././resources/js/blocksit.min.js"></script>
<link href=".././resources/css/lyk.css" rel="stylesheet">
<link href=".././resources/css/style.css" rel="stylesheet">
<link href=".././resources/css/animate.css" rel="stylesheet">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta charset="utf-8">
<title>마이 페이지</title>
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
			 %>
			<table border="1"
				style="width: 100%; text-align: center; margin-top: 10px; margin-bottom: 25px;">
				<colgroup>
					<col class="column1" style="width: 14%">
					<col class="column2" style="width: 50%">
					<col class="column3" style="width: 12%">
					<col class="column4" style="width: 12%">
					<col class="column5" style="width: 12%">
				</colgroup>
				<tr>
					<th>시험 번호</th>
					<th>시험 명</th>
					<th>제출자</th>
					<th>점수</th>
					<th>등수</th>
				</tr>
				<%for(int i=0; i<vec_e.size(); i++) { %>
				<tr
					style="cursor: pointer; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"
					onclick="location.href = './mExam_infor.jsp?no=<%=vec_e.elementAt(i).no%>'">
					<td style="padding: 5px 0;"><%=vec_e.elementAt(i).no%></td>
					<td style="padding: 5px 0;"><%=vec_e.elementAt(i).title%></td>
					<td style="padding: 5px 0;"><%=vec_e.elementAt(i).create_user%></td>
					<td style="padding: 5px 0;"><%=vec_e.elementAt(i).score%> / <%=vec_e.elementAt(i).overall_score%></td>
					<td style="padding: 5px 0;"><%=vec_e.elementAt(i).exam_t%> / <%=vec_e.elementAt(i).exam_s%></td>
				</tr>
				<%}%>

			</table>
			<!-- 
			<div id="SearchResults">
			 		<%for(int i=0; i<vec_e.size(); i++) { %>
				<div class = "grid" style="text-align: center;">
					<div class='imgholder' onclick="">
						<b><font size="3em"><%=vec_e.elementAt(i).title%></font></b>
						<font size="2em"><%=vec_e.elementAt(i).create_user%></font>
						<font size="2em"><%=vec_e.elementAt(i).explain%></font>
						<font size="2em">받은 점수 : <%=vec_e.elementAt(i).score%></font>
						<font size="2em">시험 총 점수 : <%=vec_e.elementAt(i).overall_score%></font>
					</div>
				</div>
				<%}%>
			</div>
			 -->


			<% if(vec_e.size() > 0 ) { %>
			<div style="width: 50%; text-align: center; float: left;">
				<b><font size="3em">&lt; 최근 5개 시험 비교 그래프 &gt;</font> </b>
				<canvas id="barChart" style="width: 500px;"></canvas>
			</div>
			<div style="width: 50%; text-align: center; float: left;">
				<b><font size="3em">&lt; 최근 5개 시험 등수 그래프 &gt;</font> </b>
				<canvas id="barChart2" style="width: 500px;"></canvas>
			</div>
			<% } else { 
					out.println("시험 내역이 없습니다.");
			   } %>
			<% }
					   } else {
				out.println("권한이 없습니다.");
			} %>
		</div>

	</div>
	<!--
	
-->
	<script type="text/javascript">
		$("#mypage").css("background-color","#293846").css("border-left","5px solid #6F141F").css("color","white");
		$("#mypage").addClass("activate");
	</script>
</body>
</html>