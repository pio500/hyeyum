<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" session="true"%>
<%
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html;charset=utf-8");

	if (session.getAttribute("nickname") == null
			|| session.getAttribute("id") == null
				|| session.getAttribute("level") == null) {
		response.sendRedirect(".././user/login.jsp");
	}

	String article_id = request.getParameter("article_id");
	String url 	= "jdbc:mysql://passion.chonbuk.ac.kr:3306/a201110584?characterEncoding=utf8";
	String id 	= "a201110584";
	String pass = "1234";
	Connection conn = null;
	try {
		Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection(url, id, pass);
	} catch(ClassNotFoundException e) {
		e.printStackTrace();
	} catch(SQLException e) {
		e.printStackTrace();
	}
	
	PreparedStatement pstmt = null;

	try {
		String Query = "UPDATE meta_board SET article_delete = 'Y' WHERE article_id = "
				+ article_id;

		pstmt = conn.prepareStatement(Query);
		pstmt.executeUpdate(Query);

	} catch (SQLException ee1) {
		System.out.println("delete()");
	} finally {
		try {
			if(conn!=null) conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
%>