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
	int result = 0;
	int no = Integer.parseInt(request.getParameter("no"));
	String password = request.getParameter("password");
	
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
		String _password = "";
		
		while (rs.next()) {
			_password = rs.getString("password");
		}
		rs.close();
		if(_password.equals(password)) out.println("Y");
		else out.println("N");
	}  catch (SQLException ee1) {
		if(conn!=null) conn.close();
	}  finally {
		
	}
%>