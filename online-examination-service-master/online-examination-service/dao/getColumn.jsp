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
	String _article_id = (String) request.getParameter("n");
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
	ResultSet rs;
	BoardVO vo = new BoardVO();
	int change_column_num = 0;

	try {
		String Query = "select * "
				+ "from meta_board where article_id = " + _article_id;

		pstmt = conn.prepareStatement(Query);
		rs = pstmt.executeQuery(Query);
		while (rs.next()) {
			vo.setAt_id(rs.getInt("article_id"));
			vo.setAt_title(rs.getString("article_title"));
			vo.setAt_writer(rs.getString("article_writer"));
			vo.setAt_date(rs.getString("article_date"));
			vo.setAt_time(rs.getString("article_time"));
			vo.setAt_content(rs.getString("article_content"));
			vo.setAt_type(rs.getString("article_type"));
			vo.setAt_hit(rs.getInt("article_hit"));
			vo.setAt_deleted(rs.getString("article_delete"));
			vo.setAt_re_lev(rs.getInt("article_re_lev"));
			vo.setAt_ref(rs.getInt("article_ref"));
			vo.setAt_re_step(rs.getInt("article_re_step"));
			vo.setAt_recommend_num(rs.getInt("article_recommend"));
			vo.setAt_reple(rs.getInt("article_reple"));
			vo.setIs_lock(rs.getString("is_lock"));
			vo.setAt_pw(rs.getString("article_password"));
		}
		rs.close();

	} catch (SQLException ee1) {
		System.out.println("get_column()");
	} finally {
		try {
			if (conn != null)
				conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
%>