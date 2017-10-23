
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.util.Vector"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" session="true"%>
<%
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html;charset=utf-8");
	String article_id = (String)request.getParameter("article_id");
	String mem_id = (String)request.getParameter("mem_id");
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
	ResultSet rs = null;
	int result = 0;
	int flag = 0;
	int change_column_num = 0;
	boolean bool = false;

	try {
		String re_ck = "select count(*) from meta_recommend where article_id = "
				+ article_id + " and mem_id = '" + mem_id + "'";
		String Query = "UPDATE meta_board SET article_recommend = (article_recommend + 1) WHERE article_id = "
				+ article_id;
		pstmt = conn.prepareStatement(re_ck);
		rs = pstmt.executeQuery(re_ck);

		rs.next();
		flag = rs.getInt(1);
		rs.close();
		if (flag == 0) { // ï¿½ï¿½Ãµï¿½ï¿½ ï¿½ÈµÈ°ï¿½ï¿½Ï±ï¿½.
			pstmt = conn.prepareStatement(Query);
			change_column_num = pstmt.executeUpdate(Query);

			Query = "INSERT INTO meta_recommend "
					+ "(ARTICLE_ID, MEM_ID)" + "value(?, ?)";
			pstmt = conn.prepareStatement(Query);
			pstmt.setInt(1, Integer.parseInt(article_id));
			pstmt.setString(2, mem_id);
			pstmt.executeUpdate();

			bool = true;
		}
		
		Query = "select article_recommend from meta_board where article_id = "
				+ article_id;

		pstmt = conn.prepareStatement(Query);
		rs = pstmt.executeQuery(Query);

		rs.next();
		result = rs.getInt("article_recommend");
		rs.close();
	} catch (SQLException ee1) {

		ee1.printStackTrace();
		System.out.println("article_r123ecommend");
	} finally {
		try {
			if(conn!=null) conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	String data = "";

	if (flag==0) { // 참인경우 올려줘야지.
		data = "Y" + result;
	} else {
		data = "N" + result;
	}
	out.println(data);
%>