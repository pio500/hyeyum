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
	
	PreparedStatement pstmt = null;
	Vector<BoardVO> vec = new Vector<BoardVO>();
	ResultSet rs;
	int first_article = ((page_num - 1) * 3);
		String Query = null;
		Query = "select " + "article_id , " + "article_title , "
				+ "article_writer , " + "article_date ," + "article_time ,"
				+ "article_recommend ," + "article_hit , "
				+ "article_delete , " + "article_re_step, "
				+ "is_lock, "
				+ "article_content, " + "article_reple, " + "article_ref "
				+ "from meta_board where article_type = '" + "freeboard"
				+ "' and article_delete = 'N'"
				+ " order by article_ref desc, article_re_lev limit "
				+ first_article + ", 3";

		pstmt = conn.prepareStatement(Query);
		rs = pstmt.executeQuery(Query);

		while (rs.next()) {
			BoardVO vo = new BoardVO();
			vo.setAt_id(rs.getInt("article_id"));
			vo.setAt_title(rs.getString("article_title"));
			vo.setAt_writer(rs.getString("article_writer"));
			vo.setAt_date(rs.getString("article_date"));
			vo.setAt_re_step(rs.getInt("article_re_step"));
			vo.setAt_reple(rs.getInt("article_reple"));
			vo.setAt_ref(rs.getInt("article_ref"));
			vo.setAt_time(rs.getString("article_time"));
			vo.setAt_recommend_num(rs.getInt("article_recommend"));
			vo.setAt_hit(rs.getInt("article_hit"));
			vo.setIs_lock(rs.getString("is_lock"));
			vo.setAt_deleted(rs.getString("article_delete"));
			vo.setAt_content(rs.getString("article_content"));
			vec.add(vo);
		}
		rs.close();
		
		int num = 0;

		Query = "select count(*) from meta_board where article_type = '"
				+ "freeboard" + "' and article_delete = 'N'";
		pstmt = conn.prepareStatement(Query);
		rs = pstmt.executeQuery(Query);
		rs.next();
		num = rs.getInt(1);

		rs.close();
	if (conn != null)
		conn.close();
%>