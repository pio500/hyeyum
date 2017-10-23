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
	pageEncoding="utf-8" session="true"%>
<%

	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html;charset=utf-8");
	int  insertId = 0;
	String exam_name 			=	request.getParameter("exam_name");
	String exam_explanation 	=	request.getParameter("exam_explanation");
	String datestart 			=	request.getParameter("datestart");
	String dateend				=	request.getParameter("dateend");
	String timestart			=	request.getParameter("timestart");
	String timeend				=	request.getParameter("timeend");
	String question_list		=	request.getParameter("question_list");
	String score_list			=	request.getParameter("score_list");
	String exam_password		=	request.getParameter("exam_password");
	String user = (String)session.getAttribute("id");
	String[] question_array = question_list.split("###");
	String[] score_array = score_list.split("@@@");
	int res = 0;
	for(int i=0; i<score_array.length; i++) {
		res += Integer.parseInt(score_array[i]);
	}
	
	out.println(exam_name);
	out.println(exam_explanation);
	out.println(datestart);
	out.println(dateend);
	out.println(timestart);
	out.println(timeend);
	out.println(question_list);
	out.println(score_list);

    Timestamp timestamp = null;
    Timestamp timestamp2 = null;
	try{
	    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm");
	    Date parsedDate = dateFormat.parse(datestart + " " + timestart);
	    timestamp = new java.sql.Timestamp(parsedDate.getTime());
	    
	    out.println(timestamp);
	}catch(Exception e){//this generic but you can control another types of exception
		out.println("test");
	}
	try{
	    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm");
	    Date parsedDate = dateFormat.parse(dateend + " " + timeend);
	    timestamp2 = new java.sql.Timestamp(parsedDate.getTime());
	    out.println(timestamp2);
	}catch(Exception e){//this generic but you can control another types of exception
		out.println("tes2t");
	}
	
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

		out.println("111");
		String Query = "INSERT INTO meta_examination "
				+ "(CREATE_USER, TITLE, EXPLAIN2, START_TIME, END_TIME, PASSWORD, SCORE)"
				+ " VALUES(?, ?, ?,'" + timestamp.toString() + "' , '" + timestamp2.toString() + "', ?, ?)";
		pstmt = conn.prepareStatement(Query);
		out.println(timestamp.toString());
		out.println(Query);
		pstmt.setString(1, user);
		pstmt.setString(2, exam_name);
		pstmt.setString(3, exam_explanation);
		pstmt.setString(4, exam_password);
		pstmt.setInt(5, res);

		out.println("111");
		pstmt.executeUpdate();

		out.println("111");
		pstmt = conn.prepareStatement("SELECT LAST_INSERT_ID()");
		
		ResultSet rs = pstmt.executeQuery();
		if (rs.next())
		{
		    insertId = rs.getInt("last_insert_id()");            
		}
		
		Query = "INSERT INTO meta_examination_questionset "
				+ "(META_EXAMINATION, META_QUESTION_NO, META_QUESTION_SCORE)"
				+ " VALUES(?, ?, ?)";
		pstmt = conn.prepareStatement(Query);
		
		out.println(Query);
		for(int i=0; i<score_array.length; i++) {
			pstmt.setInt(1,  insertId);
			pstmt.setString(2,  question_array[i]);
			pstmt.setString(3, score_array[i]);
		
			pstmt.executeUpdate();
		}
		
		
	} catch (SQLException ee1) {
		out.print( ee1.getMessage() );
	} finally {
		if(conn!=null) conn.close();
	}
%>