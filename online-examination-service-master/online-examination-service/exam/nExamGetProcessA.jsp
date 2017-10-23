<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.util.Vector"%>


<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" session="true"%>
<%
	class Exam {
		public int no;
		public String create_user;
		public String title;
		public String explain;
		public String start;
		public String end;
		public String password;
		public String state;
	}
	Vector<Exam> vec = new Vector<Exam>();
	String user_id = (String)session.getAttribute("id");
	int level = (int)session.getAttribute("level");
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
		
		DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		Date date = new Date();
		String date1 = dateFormat.format(date); //2014/08/06 15:59:48
		if(level < 9) {
			Query = "select * from meta_examination WHERE end_time > DATE_FORMAT('" + date1 + "','%Y-%m-%d 00:00:00') and create_user = '" + user_id + "'";
		} else {
			Query = "select * from meta_examination where create_user = '" + user_id + "'";
		}
		pstmt = conn.prepareStatement(Query);
		rs = pstmt.executeQuery(Query);

		while (rs.next()) {
			Exam e = new Exam();
			e.no = rs.getInt("no");
			e.create_user = rs.getString("create_user");
			e.title = rs.getString("title");
			e.explain = rs.getString("explain2");
			e.start = rs.getString("start_time");
			e.end = rs.getString("end_time");
			e.password = rs.getString("password");
			
			vec.add(e);
		}
		rs.close();
		int rowcount = 0;
		for(int i=0; i<vec.size(); i++) {
			Query ="SELECT COUNT(*) FROM meta_examination_pass where user_id = '" + user_id +"' and examination_no = " + vec.elementAt(i).no;
			pstmt = conn.prepareStatement(Query);
			rs = pstmt.executeQuery(Query);
     	
			if(rs.next()) rowcount = rs.getInt(1);
			rs.close();
			
			if(rowcount==0) vec.elementAt(i).state = "true";
			else vec.elementAt(i).state = "false";
		}
	}  catch (SQLException ee1) {
		if(conn!=null) conn.close();
	}  finally {
		
	}
%>