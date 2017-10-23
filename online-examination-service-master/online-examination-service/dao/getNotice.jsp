<%@page import="java.util.Vector"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" session="true"%>

<%@include file="./BoardVO.jsp"%>
<%
	int page_num = 1;
	if(request.getParameter("p")!=null) {
		page_num = Integer.parseInt(request.getParameter("p"));
	}
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
	
	Vector<BoardVO> vec = new Vector<BoardVO>();
	PreparedStatement pstmt = null;
	ResultSet rs;
	BoardVO vo = new BoardVO();
	String Query = "select * from meta_board where article_type = 'notice' and article_delete = 'N' and is_lock = 'N' order by article_id desc limit 0, 1";

	pstmt = conn.prepareStatement(Query);
	rs = pstmt.executeQuery(Query);
	while (rs.next()) {
		vo.setAt_id(rs.getInt("article_id"));
		vo.setAt_title(rs.getString("article_title"));
		vo.setAt_writer(rs.getString("article_writer"));
		vo.setAt_date(rs.getString("article_date"));
		vo.setAt_time(rs.getString("article_time"));
		vo.setAt_hit(rs.getInt("article_hit"));
		vo.setAt_content(rs.getString("article_content"));
		vo.setAt_recommend_num(rs.getInt("article_recommend"));
		vo.setIs_lock(rs.getString("is_lock"));
	}
	
	int result = 0;

	Query = "select count(*) from meta_board";
	pstmt = conn.prepareStatement(Query);
	rs = pstmt.executeQuery(Query);
	rs.next();
	result = rs.getInt(1);
	
	rs.close();
	if (conn != null)
		conn.close();
%>