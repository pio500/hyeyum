<%@page import="java.util.Vector"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" session="true"%>
<%

	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html;charset=utf-8");
	
	int insertId = 0;
	String title = request.getParameter("title");
	String text = request.getParameter("text");
	String answer = request.getParameter("answer");
	String answer_explanation = request.getParameter("answer_explanation");
	String category = request.getParameter("category");
	String etc = request.getParameter("etc");
	String user = (String)session.getAttribute("id");
	String t = request.getParameter("t");
	
	String url = "jdbc:mysql://passion.chonbuk.ac.kr:3306/a201110584?characterEncoding=utf8";
	String id = "a201110584";
	String pass = "1234";
	PreparedStatement pstmt = null;
	Connection conn = null;
	try {
		Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection(url, id, pass);
	} catch (ClassNotFoundException e) {
		e.printStackTrace();
	} catch (SQLException e) {
		e.printStackTrace();
	}
	try {
		String Query = "INSERT INTO meta_question "
				+ "(TITLE, TEXT, ANSWER, ANSWER_EXPLANATION, CATEGORY, CREATE_USER)"
				+ "VALUES(?, ?, ?, ?, ?, ? )";
		pstmt = conn.prepareStatement(Query);

		pstmt.setString(1, title);
		pstmt.setString(2, etc);
		pstmt.setString(3, answer);
		pstmt.setString(4, answer_explanation);
		pstmt.setString(5, category);
		pstmt.setString(6, user);
	
		pstmt.executeUpdate();
		pstmt = conn.prepareStatement("SELECT LAST_INSERT_ID()");
		
		ResultSet rs = pstmt.executeQuery();
		if (rs.next())
		{
		 insertId = rs.getInt("last_insert_id()");            
		}
		Query = "INSERT INTO meta_question_question "
				+ "(QUESTION_NO, QUESTION)"
				+ "VALUES(?, ?)";
		pstmt = conn.prepareStatement(Query);

		pstmt.setInt(1,  insertId);
		pstmt.setString(2, text);
	
		pstmt.executeUpdate();
		
	} catch (SQLException ee1) {
		ee1.printStackTrace();
	} finally {

		if(conn!=null) conn.close();
	}
	
	String tmp = 
			"<div class=\"ibox\"  id=\""+ insertId  + "\" data-eid=\""+ insertId  + "\">" + 
			"<div class=\"ibox-title\">" + t + "<b>번 문제 명 (문제 번호 :" +insertId + ") : </b>" + 
						title + 
  				 "<b style=\"color:red;\"> [ 시험 점수 입력 ] </b><input type=\"number\" required=\"required\"></div>" + 
  				 "<div class=\"ibox-content\"><b>문제 내용 : </b>" + 
					text + "<br><b>문제 참조 : </b>" + 
					etc + "<br><b>문제 답 : </b>" + answer + 
  				  "</div>" + 
  				"<div class=\"ibox-infor\">" + 
  						 "<b>문제 참조 : </b>" + answer_explanation +
  				 "</div></div>";
  				 
  				 out.println(tmp);
%>