<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%!
public class Member {
	private ConnectionMaker connectionMaker;
	private Member() { }
	public Member(ConnectionMaker connectionMaker) {
		this.connectionMaker = connectionMaker;
	}
	public boolean insert(MemberVO vo)  {
		Connection conn = connectionMaker.makeConnection();
		PreparedStatement pstmt = null;
		boolean result = true;
		MessageDigest md = null;
		try {
			md = MessageDigest.getInstance("MD5");
		} catch (NoSuchAlgorithmException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		String mem_id = vo.getUser_id();
		String mem_pw = vo.getUser_pw();

	    byte[] bytData = mem_pw.getBytes();
	    md.update(bytData);
	    byte[] digest = md.digest();
	    String strENCData = "";
	    for(int i =0;i<digest.length;i++) {
	        strENCData = strENCData + Integer.toHexString(digest[i] & 0xFF).toUpperCase();
	    }

		strENCData = strENCData.substring(0, 15);

		String mem_name = vo.getUser_name();
		String mem_intro = vo.getUser_intro();

		String mem_nickname = vo.getUser_nickname();
		String mem_email = vo.getUser_email();

		try {
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException ee) {
		}
		try {
			String Query = "INSERT INTO meta_user "
					+ "(MEM_ID, MEM_PW, MEM_NAME, MEM_NICKNAME,"
					+ "MEM_EMAIL, MEM_INTRO)"
					+ "VALUES(?, ?, ?, ?,  ?, ? )";

			pstmt = conn.prepareStatement(Query);

			pstmt.setString(1, mem_id);
			pstmt.setString(2, strENCData);
			pstmt.setString(3, mem_name);
			pstmt.setString(4, mem_nickname);
			pstmt.setString(5, mem_email);
			pstmt.setString(6, mem_intro);
			pstmt.executeUpdate();
		} catch (SQLException ee1) {
			ee1.printStackTrace();
			result = false;
		} finally {
			try {
				if (conn != null)
					conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return result;
	}

	public boolean modify(MemberVO vo)  {
		Connection conn = connectionMaker.makeConnection();
		PreparedStatement pstmt = null;
		boolean result = true;
		MessageDigest md = null;
		try {
			md = MessageDigest.getInstance("MD5");
		} catch (NoSuchAlgorithmException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		String mem_id = vo.getUser_id();
		String mem_pw = vo.getUser_pw();

		String strENCData = "";
		if(mem_pw.length()!=0) {
			byte[] bytData = mem_pw.getBytes();
			md.update(bytData);
			byte[] digest = md.digest();
			for(int i =0;i<digest.length;i++) {
				strENCData = strENCData + Integer.toHexString(digest[i] & 0xFF).toUpperCase();
			}
		}
		String mem_intro = vo.getUser_intro();
		String mem_email = vo.getUser_email();
		String mem_phone = vo.getUser_phone();
		int change_article_num = 0;
		try {
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException ee) {
		}
		try {
			String Query = "update meta_user set mem_email = '" + mem_email + "' , "
					+"mem_phone = '" + mem_phone + "' , "
					+"mem_intro = '" + mem_intro + "' ";
			if(mem_pw.length()!=0) {
				Query += ", mem_pw = '" + strENCData  + "' ";
			}
			Query += "where mem_id = '" + mem_id + "'";

			pstmt = conn.prepareStatement(Query);
			change_article_num = pstmt.executeUpdate();
		} catch (SQLException ee1) {
			ee1.printStackTrace();
			result = false;
		} finally {
			try {
				if (conn != null)
					conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return result;
	}

	
	public MemberVO Login(String mem_id)  {
		Connection conn = connectionMaker.makeConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		MemberVO vo = new MemberVO();
		
		try {
			String Query = "select mem_id, mem_pw, mem_nickname, mem_level "
					+ "from meta_user where mem_id = '" + mem_id + "'";

			pstmt = conn.prepareStatement(Query);
			rs = pstmt.executeQuery(Query);
			rs.last(); 
			int count = rs.getRow();
			rs.beforeFirst();
			
			if(count==0) return null;
			while (rs.next()) {
				vo.setUser_id(rs.getString("mem_id"));
				vo.setUser_pw(rs.getString("mem_pw") );
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
		return vo;
	}
	
	public MemberVO get_user_info(String mem_id)  {
		Connection conn = connectionMaker.makeConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		MemberVO vo = new MemberVO();
		
		try {
			String Query = "select * "
					+ "from meta_user where mem_id = '" + mem_id + "'";

			pstmt = conn.prepareStatement(Query);
			rs = pstmt.executeQuery(Query);
			rs.last(); 
			int count = rs.getRow();
			rs.beforeFirst();
			
			if(count==0) return null;
			while (rs.next()) {
				vo.setUser_id(rs.getString("mem_id"));
				vo.setUser_pw(rs.getString("mem_pw") );
				vo.setUser_name(rs.getString("mem_name"));
				vo.setUser_nickname(rs.getString("mem_nickname"));
				vo.setUser_level(rs.getInt("mem_level"));
				vo.setUser_email(rs.getString("mem_email"));
				vo.setUser_phone(rs.getString("mem_phone"));
				vo.setUser_intro(rs.getString("mem_intro"));
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
		return vo;
	}
	
	public int id_check(String id_ck)  {
		Connection conn = connectionMaker.makeConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int number = 0;
		
		try {
			String Query = "select count(*) "
					+ "from meta_user where mem_id = '" + id_ck + "'";

			pstmt = conn.prepareStatement(Query);
			rs = pstmt.executeQuery(Query);
			rs.next();
			number = rs.getInt(1);
			rs.close();
		} catch (SQLException ee1) {

		} finally {
			try {
				if (conn != null)
					conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return number;
	}
	
	public int nickname_check (String nickname_ck)  {
		Connection conn = connectionMaker.makeConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int number = 0;
		
		try {
			String Query = "select count(*) "
					+ "from meta_user where mem_nickname = '" + nickname_ck + "'";

			pstmt = conn.prepareStatement(Query);
			rs = pstmt.executeQuery(Query);
			rs.next();
			number = rs.getInt(1);
			rs.close();
		} catch (SQLException ee1) {

		} finally {
			try {
				if (conn != null)
					conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return number;
	}
	
	public int save_ip (String user_id, String user_ip)   {
		Connection conn = connectionMaker.makeConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int number = 0;

		try {
			String Query = "INSERT INTO meta_login "
					+ "(USER_ID, USER_IP, LOGIN_DATE, LOGIN_TIME)"
					+ "VALUES(?, ?, DATE_FORMAT(NOW(),'%Y-%m-%d'), DATE_FORMAT(NOW(),'%H:%i:%s'))";

			
			pstmt = conn.prepareStatement(Query);

			pstmt.setString(1, user_id);
			pstmt.setString(2, user_ip);
			pstmt.executeUpdate();
		} catch (SQLException ee1) {

		} finally {
			try {
				if (conn != null)
					conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return number;
	}
	
	
	public static void main(String[] args) {

	}
}
%>
