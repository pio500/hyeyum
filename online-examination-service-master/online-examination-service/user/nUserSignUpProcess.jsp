<%@page import="java.util.Vector"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="java.security.NoSuchAlgorithmException"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>

<%

int insertId = 0;
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html; charset=utf-8");
	
	String user_id = request.getParameter("user_id");
	String user_pw = request.getParameter("user_pw");
	String user_name = request.getParameter("user_name");
	String user_nickname = request.getParameter("user_nickname");

	out.println(user_id);
	out.println(user_pw);
	out.println(user_name);
	out.println(user_nickname);
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
	String sdff ="";
	try {

		MessageDigest md = null;
		try {
			md = MessageDigest.getInstance("MD5");
		} catch (NoSuchAlgorithmException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
	    byte[] bytData = user_pw.getBytes();
	    md.update(bytData);
	    byte[] digest = md.digest();
	    String strENCData = "";
	    for(int i =0;i<digest.length;i++) {
	        strENCData = strENCData + Integer.toHexString(digest[i] & 0xFF).toUpperCase();
	    }

		strENCData = strENCData.substring(0, 15);
		
		String Query = "INSERT INTO meta_user "
				+ "(mem_id, mem_pw, mem_name, mem_nickname)"
				+ " VALUES(?, ?, ?, ?)";
		pstmt = conn.prepareStatement(Query);
		pstmt.setString(1, user_id);
		pstmt.setString(2, strENCData);
		pstmt.setString(3, user_name);
		pstmt.setString(4, user_nickname);

		pstmt.executeUpdate();

		pstmt = conn.prepareStatement("SELECT LAST_INSERT_ID()");
		
		ResultSet rs = pstmt.executeQuery();
		if (rs.next())
		{
		    insertId = rs.getInt("last_insert_id()");            
		}
		rs.close();
	} catch (SQLException ee1) {
		out.print( ee1.getMessage() );
	} finally {
		if(conn!=null) conn.close();
	}
	if (session.getAttribute("nickname") != null
			|| session.getAttribute("id") != null
			|| session.getAttribute("level") != null) {
		session.invalidate();
	} 
	session.setAttribute("no", insertId);
	session.setAttribute("id", user_id);
	session.setAttribute("nickname", user_nickname);
	session.setAttribute("level", 9);
	session.setMaxInactiveInterval(60 * 60 * 60);

	response.sendRedirect("/201110584/lyk/index.jsp");
%>