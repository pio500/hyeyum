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

	if (session.getAttribute("nickname") == null
			|| session.getAttribute("id") == null
				|| session.getAttribute("level") == null) {
		response.sendRedirect(".././user/login.jsp");
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
	String article_title = request.getParameter("title");
	String article_write = request.getParameter("at_writer");

	int article_hit = 0;
	int article_re_lev = 0;
	int article_ref = 0;
	int article_re_step = 0;
	int article_id = 0;

	if (request.getParameter("at_id") != null
			&& request.getParameter("at_id").trim().length() != 0) {
		article_id = Integer.parseInt(request.getParameter("at_id"));
	}
	if (request.getParameter("at_re_lev") != null
			&& request.getParameter("at_re_lev").trim().length() != 0) {
		article_re_lev = Integer.parseInt(request
				.getParameter("at_re_lev"));
	}
	if (request.getParameter("at_ref") != null
			&& request.getParameter("at_ref").trim().length() != 0) {
		article_ref = Integer.parseInt(request.getParameter("at_ref"));
	}
	if (request.getParameter("at_re_step") != null
			&& request.getParameter("at_re_step").trim().length() != 0) {
		article_re_step = Integer.parseInt(request
				.getParameter("at_re_step"));
	}
	String article_type = request.getParameter("at_type");
	String article_content = request.getParameter("contents");

	article_content = article_content.replaceAll("<script",	"&lt;script");
	article_content = article_content.replaceAll("</script","&lt;/script");
	article_content = article_content.replaceAll("<iframe","&lt;iframe");
	article_content = article_content.replaceAll("<embed", "&lt;embed"); // embed 태그를 사용하지 않을 경우만
	article_content = article_content.replaceAll("<object", "&lt;object"); // object 태그를 사용하지 않을 경우만
	article_content = article_content.replaceAll("<frame", "&lt;frame");

	

	// enctype="multipart/form-data" 넘기는 파라미터는 기존의 request로 받을 수 없다.
	if (request.getParameter("m").equals("m")) {

		ResultSet rs = null;

		try {
			int change_article_num = 0;

			String Query = "";
			
				Query = "update meta_board set article_title = '" + article_title
						+ "' , " + "article_content = '" + article_content
						+ "' where article_id = " + article_id;
			

			pstmt = conn.prepareStatement(Query);
			change_article_num = pstmt.executeUpdate();
		} catch (SQLException ee1) {
			ee1.printStackTrace();
		} finally {
			if (conn != null)
				conn.close();
		}
	} 
	
	response.sendRedirect(".././bbs/read.jsp?p=1&n="+article_id);
%>