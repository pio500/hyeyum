<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.Date"%>
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
	class sQuestion {
		public int exam_no;
		public int question_no;
		public String solved_answer;
	}
	
	class rScore {
		public int question_no;
		public int score;
	}
	class rQuestion extends rScore {
		public String answer;
	}
	Vector<sQuestion> vec_s = new Vector<sQuestion>();
	Vector<rQuestion> vec_r = new Vector<rQuestion>();
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html;charset=utf-8");
	int question_no = Integer.parseInt(request.getParameter("no"));

	String text = request.getParameter("text");
	String[] question_set = text.split("###");
	int user_id = (int)session.getAttribute("no");
	String mem_id = (String)session.getAttribute("id");
	
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
		Query = "INSERT INTO meta_examination_pass "
				+ "(USER_ID,EXAMINATION_NO)"
				+ "VALUES(?, ?)";
		pstmt = conn.prepareStatement(Query);

		pstmt.setString(1, mem_id);
		pstmt.setInt(2, question_no);
		pstmt.executeUpdate();
		
		for(int i=0; i<question_set.length; i++) {
			String set1[] = question_set[i].split("@@@");
			if(set1[1].equals("&&&")) set1[1] = "";
			Query = "INSERT INTO meta_question_solved "
					+ "(QUESTION_NO, EXAM_NO, USER_NO, ANSWER)"
					+ "VALUES(?, ?, ?, ?)";
			pstmt = conn.prepareStatement(Query);

			pstmt.setInt(2, question_no);
			pstmt.setInt(3, user_id);
			pstmt.setInt(1, Integer.parseInt(set1[0]));
			pstmt.setString(4, set1[1]);
			pstmt.executeUpdate();
		}
		/**/
			//여기서 다시 가져와야지;
			String request_solved_examiniation = "select * from meta_question_solved where exam_no = " + question_no + " and user_no = " + user_id + " order by question_no asc";
			pstmt = conn.prepareStatement(request_solved_examiniation);
			rs = pstmt.executeQuery(request_solved_examiniation);
			
			while (rs.next()) {
				sQuestion tmp = new sQuestion();
				tmp.question_no = rs.getInt("question_no");
				tmp.exam_no = rs.getInt("exam_no");
				tmp.solved_answer = rs.getString("answer");
				vec_s.add(tmp);
			}
			rs.close();
			
			String request_score = "select * from meta_examination_questionset where meta_examination = " + question_no + " order by meta_question_no asc";
			pstmt = conn.prepareStatement(request_score);
			rs = pstmt.executeQuery(request_score);
			
			while (rs.next()) {
				rQuestion tmp = new rQuestion();
				tmp.score = rs.getInt("meta_question_score");
				tmp.question_no = rs.getInt("meta_question_no");
				vec_r.add(tmp);
			}
			rs.close();
			
			for(int i=0; i<vec_r.size(); i++) {
				String request_answer = "select answer from meta_question where no = " +  vec_r.elementAt(i).question_no;
				pstmt = conn.prepareStatement(request_answer);
				rs = pstmt.executeQuery(request_answer);
				
				while (rs.next()) {
					vec_r.elementAt(i).answer = rs.getString("answer");
				}
				rs.close();
				
			}
			int res = 0;
			for(int i=0; i<vec_r.size(); i++) {
				if(vec_r.elementAt(i).answer.equals (vec_s.elementAt(i).solved_answer) ) {
					res += vec_r.elementAt(i).score;
					String sql = "update meta_question_solved set state = 1 where question_no = " + vec_s.elementAt(i).question_no + " and exam_no = " + vec_s.elementAt(i).exam_no + " and user_no = " + user_id; 
					pstmt = conn.prepareStatement(sql);
					pstmt.executeUpdate(sql); 
				} else {
					
				}
			}
			String sql = "update meta_examination_pass set examination_score = " + res + " where examination_no = " + question_no + " and user_id = '" + mem_id + "'";
			pstmt = conn.prepareStatement(sql);
			pstmt.executeUpdate(sql); 
	}  catch (SQLException ee1) {
		out.println(ee1.getMessage());
		if(conn!=null) conn.close();
	}  finally {
		
	}
%>