<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="java.security.NoSuchAlgorithmException"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>

<%@include file=".././dao/MemberVO.jsp"%>

<%
	if (session.getAttribute("nickname") != null
			|| session.getAttribute("id") != null
			|| session.getAttribute("level") != null) {
		session.invalidate();
	}


	String strENCData = "";
	String user_id = request.getParameter("j_username");
	String user_pw = request.getParameter("j_password");
	int __id = 0;
	String url = "jdbc:mysql://passion.chonbuk.ac.kr:3306/a201110584?characterEncoding=utf8";
	String id = "a201110584";
	String pass = "1234";
	Connection conn = null;
	try {
		Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection(url, id, pass);
	} catch (ClassNotFoundException e) {
		e.printStackTrace();
	} catch (SQLException e) {
		e.printStackTrace();
	}

	PreparedStatement pstmt = null;
	ResultSet rs = null;

	MemberVO vo = new MemberVO();

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
	    for(int i =0;i<digest.length;i++) {
	        strENCData = strENCData + Integer.toHexString(digest[i] & 0xFF).toUpperCase();
	    }

		strENCData = strENCData.substring(0, 15);
		
		String Query = "select id, mem_id, mem_pw, mem_nickname, mem_level "
				+ "from meta_user where mem_id = '" + user_id + "'";

		pstmt = conn.prepareStatement(Query);
		rs = pstmt.executeQuery(Query);
		rs.last();
		int count = rs.getRow();
		rs.beforeFirst();

		if (count == 0)
			;
		while (rs.next()) {
			__id = rs.getInt("id");
			vo.setUser_id(rs.getString("mem_id"));
			vo.setUser_pw(rs.getString("mem_pw"));
			vo.setUser_nickname(rs.getString("mem_nickname"));
			vo.setUser_level(rs.getInt("mem_level"));
		}
		rs.close();
	} catch (SQLException ee1) {
		ee1.printStackTrace();
	} finally {
		try {
			if (conn != null)
				conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	if(vo.getUser_id()==null) {
		out.println("N");
	}
	if (vo.getUser_id().equals(user_id)
			&& vo.getUser_pw().equals(strENCData)) {
		session.setAttribute("no", __id);
		session.setAttribute("id", vo.getUser_id());
		session.setAttribute("nickname", vo.getUser_nickname());
		session.setAttribute("level", vo.getUser_level());
		session.setMaxInactiveInterval(60 * 60 * 60);

		out.println("Y");
	} else {
		out.println("N");
	}
%>