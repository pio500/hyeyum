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
	if (request.getParameter("m").equals("w")) {

		ResultSet rs = null;

		article_re_lev = 0;
		article_re_step = 0;
		article_id = 0;
		try {
			String strQuery = "SELECT MAX(article_id) FROM meta_board";
			try {
				pstmt = conn.prepareStatement(strQuery);
				rs = pstmt.executeQuery(strQuery);
				if (rs.next()) {
					article_id = rs.getInt(1);
				}
				rs.close();
			} catch (SQLException e2) {

			}
			String Query = "INSERT INTO meta_board "
					+ "(ARTICLE_ID,  ARTICLE_TITLE, ARTICLE_WRITER, ARTICLE_DATE, ARTICLE_TIME, ARTICLE_TYPE, "
					+ "ARTICLE_CONTENT, ARTICLE_REF, ARTICLE_RE_STEP, ARTICLE_RE_LEV, IS_LOCK, ARTICLE_PASSWORD)"
					+ "VALUES(?, ?, ?, DATE_FORMAT(NOW(),'%Y-%m-%d'), "
					+ "DATE_FORMAT(NOW(),'%H:%i:%s'), ?, ?, ?, ?, ?, ?, ? )";
			pstmt = conn.prepareStatement(Query);

			pstmt.setInt(1, article_id + 1);
			pstmt.setString(2, article_title);
			pstmt.setString(3, article_write);
			pstmt.setString(4, article_type);
			pstmt.setString(5, article_content);
			pstmt.setInt(6, article_id + 1);
			pstmt.setInt(7, article_re_step);
			pstmt.setInt(8, article_re_lev);
			pstmt.setString(9, "N");
			pstmt.setString(10, "");
			pstmt.executeUpdate();

		} catch (SQLException ee1) {
			System.out.println("insert()");
			ee1.printStackTrace();
		} finally {
			if(conn!=null) conn.close();
		}
		article_id += 1;
	} else if (request.getParameter("m").equals("r")) {
		//article_id = b_dao.reply_article(vo);
	} else if (request.getParameter("m").equals("m")) {
		//article_id = b_dao.modify(vo);
	}
	
	response.sendRedirect(".././bbs/read.jsp?p=1&n="+article_id);
%>