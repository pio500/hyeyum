
<%@page import="java.util.Vector"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%!
public class BoardVO {
	private int at_id;
	private int at_reple;
	private int at_recommend_num;
	private int at_hit;
	private int at_ref;
	private int at_re_step;
	private int at_re_lev;
	private int attach_file_num;
	
	private String at_title;
	private String at_writer;
	private String at_date;
	private String at_time;
	private String user_id;
	private String at_deleted;
	private String is_lock;
	private String at_type;
	private String at_cmt_num;
	private String at_content;
	private String at_pw;
	public int getAt_id() {
		return at_id;
	}
	public void setAt_id(int at_id) {
		this.at_id = at_id;
	}
	public int getAt_reple() {
		return at_reple;
	}
	public void setAt_reple(int at_reple) {
		this.at_reple = at_reple;
	}
	public int getAt_recommend_num() {
		return at_recommend_num;
	}
	public void setAt_recommend_num(int at_recommend_num) {
		this.at_recommend_num = at_recommend_num;
	}
	public int getAt_hit() {
		return at_hit;
	}
	public void setAt_hit(int at_hit) {
		this.at_hit = at_hit;
	}
	public int getAt_ref() {
		return at_ref;
	}
	public void setAt_ref(int at_ref) {
		this.at_ref = at_ref;
	}
	public int getAt_re_step() {
		return at_re_step;
	}
	public void setAt_re_step(int at_re_step) {
		this.at_re_step = at_re_step;
	}
	public int getAt_re_lev() {
		return at_re_lev;
	}
	public void setAt_re_lev(int at_re_lev) {
		this.at_re_lev = at_re_lev;
	}
	public int getAttach_file_num() {
		return attach_file_num;
	}
	public void setAttach_file_num(int attach_file_num) {
		this.attach_file_num = attach_file_num;
	}
	public String getAt_title() {
		return at_title;
	}
	public void setAt_title(String at_title) {
		this.at_title = at_title;
	}
	public String getAt_writer() {
		return at_writer;
	}
	public void setAt_writer(String at_writer) {
		this.at_writer = at_writer;
	}
	public String getAt_date() {
		return at_date;
	}
	public void setAt_date(String at_date) {
		this.at_date = at_date;
	}
	public String getAt_time() {
		return at_time;
	}
	public void setAt_time(String at_time) {
		this.at_time = at_time;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getAt_deleted() {
		return at_deleted;
	}
	public void setAt_deleted(String at_deleted) {
		this.at_deleted = at_deleted;
	}
	public String getIs_lock() {
		return is_lock;
	}
	public void setIs_lock(String is_lock) {
		this.is_lock = is_lock;
	}
	public String getAt_type() {
		return at_type;
	}
	public void setAt_type(String at_type) {
		this.at_type = at_type;
	}
	public String getAt_cmt_num() {
		return at_cmt_num;
	}
	public void setAt_cmt_num(String at_cmt_num) {
		this.at_cmt_num = at_cmt_num;
	}
	public String getAt_content() {
		return at_content;
	}
	public void setAt_content(String at_content) {
		this.at_content = at_content;
	}
	public String getAt_pw() {
		return at_pw;
	}
	public void setAt_pw(String at_pw) {
		this.at_pw = at_pw;
	}
}

public class Board {
	Connection conn = null;
	private void connect() {
		String url 	= "jdbc:mysql://passion.chonbuk.ac.kr:3306/a201110584?characterEncoding=utf8";
		String id 	= "a201110584";
		String pass = "1234";
		Connection conn = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(url, id, pass);
		} catch(ClassNotFoundException e) {
			e.printStackTrace();
		} catch(SQLException e) {
			e.printStackTrace();
		}
	}
	private void disconnect() throws SQLException {
		if (conn != null) 
			conn.close();
		conn = null;
	}

	public int insert(BoardVO vo) {
		connect();
		PreparedStatement pstmt = null;

		String article_title = vo.getAt_title();
		String article_writer = vo.getAt_writer();
		String article_type = vo.getAt_type();
		String article_content = vo.getAt_content();
		String is_lock = vo.getIs_lock();
		String article_password = vo.getAt_pw();

		ResultSet rs = null;

		int article_re_lev = 0;
		int article_re_step = 0;
		int article_id = 0;
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
			pstmt.setString(3, article_writer);
			pstmt.setString(4, article_type);
			pstmt.setString(5, article_content);
			pstmt.setInt(6, article_id + 1);
			pstmt.setInt(7, article_re_step);
			pstmt.setInt(8, article_re_lev);
			pstmt.setString(9, is_lock);
			pstmt.setString(10, article_password);
			pstmt.executeUpdate();

		} catch (SQLException ee1) {
			System.out.println("insert()");
			ee1.printStackTrace();
		} finally {
			
		}
		return article_id + 1;
	}

	public int modify(BoardVO vo) throws SQLException {
		connect();
		PreparedStatement pstmt = null;
		int change_article_num = 0;
		String article_title = vo.getAt_title();
		String article_content = vo.getAt_content();
		int article_id = vo.getAt_id();

		String Query = "";
		if (vo.getAt_pw().equals("2E11EDB12C37D93")) {
			Query = "update meta_board set article_title = '" + article_title
					+ "' , " + "article_content = '" + article_content
					+ "' where article_id = " + article_id;
		} else {
			Query = "update meta_board set article_title = '" + article_title
					+ "' , " + "article_content = '" + article_content
					+ "', is_lock = '" + vo.getIs_lock()
					+ "', article_password = '" + vo.getAt_pw()
					+ "' where article_id = " + article_id;
		}

		pstmt = conn.prepareStatement(Query);
		change_article_num = pstmt.executeUpdate();
		System.out.println("modify()");

		disconnect();
		return article_id;
	}

	public int reply_article(BoardVO vo) {
		connect();
		PreparedStatement pstmt = null;

		String article_title = vo.getAt_title();
		String article_writer = vo.getAt_writer();
		int article_re_lev = vo.getAt_re_lev() + 1;
		int article_ref = vo.getAt_ref();
		int article_re_step = vo.getAt_re_step() + 1;

		int change_column_num = 0;
		String article_type = vo.getAt_type();
		String article_content = vo.getAt_content();
		ResultSet rs = null;
		int article_id = 0;
		try {
			String strQuery = "SELECT MAX(article_id) FROM meta_board";
			try {
				pstmt = conn.prepareStatement(strQuery);
				rs = pstmt.executeQuery(strQuery);
				if (rs.next()) {
					article_id = rs.getInt(1);
				}
				rs.close();

				strQuery = "UPDATE meta_board SET article_re_lev = article_re_lev + 1 "
						+ "where article_ref="
						+ article_ref
						+ " and article_re_lev >= " + article_re_lev + "";

				change_column_num = pstmt.executeUpdate(strQuery);

			} catch (SQLException e2) {
				System.out.println("MAXï¿½ï¿½ ï¿½ï¿½Ò·ï¿½ï¿½ï¿½.");
			}
			String Query = "INSERT INTO meta_board "
					+ "(ARTICLE_ID,  ARTICLE_TITLE, ARTICLE_WRITER, ARTICLE_DATE, "
					+ "ARTICLE_TIME, ARTICLE_TYPE, "
					+ "ARTICLE_CONTENT, ARTICLE_REF, ARTICLE_RE_STEP, ARTICLE_RE_LEV, IS_LOCK, ARTICLE_PASSWORD)"
					+ "VALUES(?, ?, ?, DATE_FORMAT(NOW(),'%Y-%m-%d'), "
					+ "DATE_FORMAT(NOW(),'%H:%i:%s'), ?, ?, ?, ?, ? ,?, ?)";

			pstmt = conn.prepareStatement(Query);

			pstmt.setInt(1, article_id + 1);
			pstmt.setString(2, article_title);
			pstmt.setString(3, article_writer);
			pstmt.setString(4, article_type);
			pstmt.setString(5, article_content);
			pstmt.setInt(6, article_ref);
			pstmt.setInt(7, article_re_step);
			pstmt.setInt(8, article_re_lev);
			pstmt.setString(9, vo.getIs_lock());
			pstmt.setString(10, vo.getAt_pw());
			pstmt.executeUpdate();

		} catch (SQLException ee1) {
			System.out.println("insert()");
		} finally {
			try {
				disconnect();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return article_id + 1;
	}

	/*
	 * 2015.01.28 ï¿½ï¿½ï¿½ï¿½ï¿½Ï¿ï¿½ ï¿½ï¿½ï¿½ï¿½ï¿½. ï¿½ï¿½Ü½ï¿½ ï¿½Ï´ï¿½ ï¿½ï¿½ï¿½ï¿½.
	 */
	public Vector<BoardVO> select_board(String str, int page_num)
			throws SQLException {
		Vector<BoardVO> vec = new Vector<BoardVO>();
		connect();
		PreparedStatement pstmt = null;
		ResultSet rs;
		int first_article = ((page_num - 1) * 3);
		String Query = null;
		Query = "select " + "article_id , " + "article_title , "
				+ "article_writer , " + "article_date ," + "article_time ,"
				+ "article_recommend ," + "article_hit , "
				+ "article_content, " + "article_delete , " 
				+ "is_lock, "
				+ "article_re_step, " + "article_reple, " + "article_ref "
				+ "from meta_board where article_type = '" + str
				+ "' order by article_ref desc, article_re_lev limit "
				+ first_article + ", 3";
		pstmt = conn.prepareStatement(Query);
		rs = pstmt.executeQuery(Query);

		while (rs.next()) {
			BoardVO vo = new BoardVO();
			vo.setAt_id(rs.getInt("article_id"));
			vo.setAt_title(rs.getString("article_title"));
			vo.setAt_writer(rs.getString("article_writer"));
			vo.setAt_date(rs.getString("article_date"));
			vo.setAt_time(rs.getString("article_time"));
			vo.setAt_re_step(rs.getInt("article_re_step"));
			vo.setAt_reple(rs.getInt("article_reple"));
			vo.setAt_ref(rs.getInt("article_ref"));
			vo.setIs_lock(rs.getString("is_lock"));
			vo.setAt_content(rs.getString("article_content"));
			vo.setAt_recommend_num(rs.getInt("article_recommend"));
			vo.setAt_hit(rs.getInt("article_hit"));
			vo.setAt_deleted(rs.getString("article_delete"));
			vec.add(vo);
		}
		rs.close();
		disconnect();
		return vec;
	}

	public Vector<BoardVO> select_board_not_delete(String str, int page_num) {
		
		connect();
		PreparedStatement pstmt = null;
		Vector<BoardVO> vec = new Vector<BoardVO>();
		ResultSet rs;
		int first_article = ((page_num - 1) * 3);
		try {

			String Query = null;
			Query = "select " + "article_id , " + "article_title , "
					+ "article_writer , " + "article_date ," + "article_time ,"
					+ "article_recommend ," + "article_hit , "
					+ "article_delete , " + "article_re_step, "
					+ "is_lock, "
					+ "article_content, " + "article_reple, " + "article_ref "
					+ "from meta_board where article_type = '" + str
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
		} catch (SQLException ee1) {
			System.out.println("select_board()");
			ee1.printStackTrace();
		} finally {
			try {
				disconnect();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		return vec;

	}

	public Vector<BoardVO> search_article(String board, String index,
			String word, int page_num) {
		Vector<BoardVO> vec = new Vector<BoardVO>();
		connect();
		PreparedStatement pstmt = null;
		ResultSet rs;
		int first_article = ((page_num - 1) * 20);
		try {

			String Query = null;
			Query = "select " + "article_id , " + "article_title , "
					+ "article_writer , " + "article_date ," + "article_time ,"
					+ "article_recommend ," + "article_hit , "
					+ "article_delete , " + "article_re_step, "
					+ "article_reple, " + "article_ref, " + "is_lock, "
					+ "attach_file_num ";

			String addQuery = "";
			if (index.equals("title")) {
				addQuery = "from meta_board where binary(article_title) like '%"
						+ word
						+ "%' and article_delete = 'N' and article_type = '"
						+ board
						+ "' order by article_ref desc, article_re_lev limit "
						+ first_article + ",15";
			} else if (index.equals("writer")) {
				addQuery = "from meta_board where binary(article_writer) like '%"
						+ word
						+ "%' and article_delete = 'N' and article_type = '"
						+ board
						+ "' order by article_ref desc, article_re_lev limit "
						+ first_article + ", 15";
			} else if (index.equals("contents")) {
				addQuery = "from meta_board where binary(article_content) like '%"
						+ word
						+ "%' and article_delete = 'N' and article_type = '"
						+ board
						+ "' order by article_ref desc, article_re_lev limit "
						+ first_article + ", 15";
			} else {
				addQuery = "from meta_board where (binary(article_title) like '%"
						+ word
						+ "%' or binary(article_content) like '%"
						+ word
						+ "%') and article_delete = 'N' and article_type = '"
						+ board
						+ "' order by article_ref desc, article_re_lev limit "
						+ first_article + ", 15";
			}
			Query += addQuery;
			pstmt = conn.prepareStatement(Query);
			rs = pstmt.executeQuery(Query);
			while (rs.next()) {
				BoardVO vo = new BoardVO();
				vo.setAt_id(rs.getInt("article_id"));
				vo.setAt_title(rs.getString("article_title"));
				vo.setAt_writer(rs.getString("article_writer"));
				vo.setAt_date(rs.getString("article_date"));
				vo.setAt_time(rs.getString("article_time"));
				vo.setAt_recommend_num(rs.getInt("article_recommend"));
				vo.setAt_hit(rs.getInt("article_hit"));
				vo.setAt_deleted(rs.getString("article_delete"));
				vo.setAt_re_step(rs.getInt("article_re_step"));
				vo.setAt_reple(rs.getInt("article_reple"));
				vo.setAt_ref(rs.getInt("article_ref"));
				vo.setIs_lock(rs.getString("is_lock"));
				vo.setAttach_file_num(rs.getInt("attach_file_num"));
				vec.add(vo);
			}
			rs.close();
		} catch (SQLException ee1) {
			System.out.println("select_board()");
			ee1.printStackTrace();
		} finally {
			try {
				disconnect();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		return vec;

	}

	public int get_column_number(String str) throws SQLException {
		connect();
		PreparedStatement pstmt = null;
		ResultSet rs;
		int result = 0;

		String Query = "select count(*) from meta_board where article_type = '"
				+ str + "'";
		pstmt = conn.prepareStatement(Query);
		rs = pstmt.executeQuery(Query);
		rs.next();
		result = rs.getInt(1);

		rs.close();
		disconnect();

		return result;

	}

	public int get_column_number_not_delete(String str) {
		connect();
		PreparedStatement pstmt = null;
		ResultSet rs;
		int result = 0;

		try {
			String Query = "select count(*) from meta_board where article_type = '"
					+ str + "' and article_delete = 'N'";
			pstmt = conn.prepareStatement(Query);
			rs = pstmt.executeQuery(Query);
			rs.next();
			result = rs.getInt(1);

			rs.close();
		} catch (SQLException ee1) {
			System.out.println("get_column_number()");
		} finally {
			try {
				disconnect();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		return result;

	}

	public int get_search_number(String str, String index, String word) {
		connect();
		PreparedStatement pstmt = null;
		ResultSet rs;
		int result = 0;

		try {
			String Query = "select count(*) from meta_board where article_type = '"
					+ str + "' and article_delete = 'N' and ";
			String addQuery = "";
			if (index.equals("title"))
				addQuery = "binary(article_title) like '%" + word + "%'";
			else if (index.equals("writer"))
				addQuery = "binary(article_writer) like '%" + word + "%'";
			else if (index.equals("contents"))
				addQuery = "binary(article_content) like '%" + word + "%'";
			else if (index.equals("at"))
				addQuery = "binary(article_title) like '%" + word
						+ "%' or binary(article_content) like '%" + word + "%'";
			pstmt = conn.prepareStatement(Query);
			Query += addQuery;
			rs = pstmt.executeQuery(Query);
			rs.next();
			result = rs.getInt(1);

			rs.close();
		} catch (SQLException ee1) {
			System.out.println("get_column_number()");
		} finally {
			try {
				disconnect();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		return result;

	}

	public boolean article_recommend(String article_id, String mem_id) {
		connect();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int result = 0;
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
			result = rs.getInt(1);
			rs.close();
			if (result == 0) { // ï¿½ï¿½Ãµï¿½ï¿½ ï¿½ÈµÈ°ï¿½ï¿½Ï±ï¿½.
				pstmt = conn.prepareStatement(Query);
				change_column_num = pstmt.executeUpdate(Query);

				Query = "INSERT INTO meta_recommend " + "(ARTICLE_ID, MEM_ID)"
						+ "value(?, ?)";
				pstmt = conn.prepareStatement(Query);
				pstmt.setInt(1, Integer.parseInt(article_id));
				pstmt.setString(2, mem_id);
				pstmt.executeUpdate();

				bool = true;
			}

		} catch (SQLException ee1) {

			ee1.printStackTrace();
			System.out.println("article_r123ecommend");
		} finally {
			try {
				disconnect();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return bool;
	}

	public void article_hit_up(String article_id) {
		connect();
		PreparedStatement pstmt = null;

		int change_column_num = 0;

		try {
			String Query = "UPDATE meta_board SET article_hit = (article_hit + 1) WHERE article_id = "
					+ article_id;
			pstmt = conn.prepareStatement(Query);
			change_column_num = pstmt.executeUpdate(Query);
		} catch (SQLException ee1) {
			System.out.println("article_recommend");
		} finally {
			try {
				disconnect();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return;
	}

	public int inquiry_recommend(String article_id, String mem_id) {
		connect();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int result = 0;
		int change_column_num = 0;

		try {
			String Query = "select article_recommend from meta_board where article_id = "
					+ article_id;

			pstmt = conn.prepareStatement(Query);
			rs = pstmt.executeQuery(Query);

			rs.next();
			result = rs.getInt("article_recommend");
			rs.close();

		} catch (SQLException ee1) {
			System.out.println("article_recommend");
		} finally {
			try {
				disconnect();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return result;
	}

	public BoardVO get_column(String article_id) {
		connect();
		PreparedStatement pstmt = null;
		ResultSet rs;
		BoardVO vo = new BoardVO();
		int change_column_num = 0;

		try {
			String Query = "select * " + "from meta_board where article_id = "
					+ article_id;

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
				disconnect();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return vo;
	}

	public BoardVO get_column_password(String article_id) {
		connect();
		PreparedStatement pstmt = null;
		ResultSet rs;
		BoardVO vo = new BoardVO();
		int change_column_num = 0;

		try {
			String Query = "select article_password, article_type "
					+ "from meta_board where article_id = " + article_id;

			pstmt = conn.prepareStatement(Query);
			rs = pstmt.executeQuery(Query);
			while (rs.next()) {
				vo.setAt_pw(rs.getString("article_password"));
				vo.setAt_type(rs.getString("article_type"));
			}
			rs.close();
		} catch (SQLException ee1) {
			System.out.println("get_column()");
		} finally {
			try {
				disconnect();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return vo;
	}

	public BoardVO up_hits(String article_id) {
		connect();
		PreparedStatement pstmt = null;
		BoardVO vo = new BoardVO();
		int change_column_num = 0;

		try {
			String Query2 = "UPDATE meta_board SET article_hit = (article_hit + 1) WHERE article_id = "
					+ article_id;

			pstmt = conn.prepareStatement(Query2);
			change_column_num = pstmt.executeUpdate(Query2);

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
		return vo;
	}

	public BoardVO get_notice() throws SQLException {
		connect();
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
		disconnect();
		return vo;

	}

	public boolean inquiry_column(String article_id) {
		connect();
		PreparedStatement pstmt = null;
		ResultSet rs;
		boolean bool = false;
		int result = 0;
		try {
			String Query = "select count(*) "
					+ "from meta_board where article_id = " + article_id;

			pstmt = conn.prepareStatement(Query);
			rs = pstmt.executeQuery(Query);

			rs.next();
			result = rs.getInt(1);
			rs.close();

			if (result == 1) {
				bool = true;
			}
		} catch (SQLException ee1) {
			System.out.println("get_column()");
		} finally {
			try {
				disconnect();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		return bool;

	}

	public Vector<BoardVO> lately_article() {
		Vector<BoardVO> vec = new Vector<BoardVO>();
		connect();
		PreparedStatement pstmt = null;
		ResultSet rs;

		try {
			String Query = null;
			Query = "select article_id, article_type, article_title, article_date, article_type, is_lock from meta_board "
					+ "where article_delete = 'N' "
					+ "order by article_id desc limit 0, 15";

			pstmt = conn.prepareStatement(Query);
			rs = pstmt.executeQuery(Query);

			while (rs.next()) {
				BoardVO vo = new BoardVO();
				vo.setAt_id(rs.getInt("article_id"));
				vo.setAt_type(rs.getString("article_type"));
				vo.setAt_title(rs.getString("article_title"));
				vo.setAt_date(rs.getString("article_date"));
				vo.setAt_type(rs.getString("article_type"));
				vo.setIs_lock(rs.getString("is_lock"));
				vec.add(vo);
			}
		} catch (SQLException ee1) {
			System.out.println("lately_article()");
		} finally {
			try {
				disconnect();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		return vec;

	}

	public void article_delete(String article_id) {
		connect();
		PreparedStatement pstmt = null;

		try {
			String Query = "UPDATE meta_board SET article_delete = 'Y' WHERE article_id = "
					+ article_id;

			pstmt = conn.prepareStatement(Query);
			pstmt.executeUpdate(Query);

		} catch (SQLException ee1) {
			System.out.println("delete()");
		} finally {
			try {
				disconnect();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return;
	}

	public void article_restore(String article_id) {
		connect();
		PreparedStatement pstmt = null;
		try {
			String Query = "UPDATE meta_board SET article_delete = 'N' WHERE article_id = "
					+ article_id;

			pstmt = conn.prepareStatement(Query);
			pstmt.executeUpdate(Query);

		} catch (SQLException ee1) {
			System.out.println("restore()");
		} finally {
			try {
				disconnect();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return;
	}

	public void reple_delete(String article_id) {
		connect();
		PreparedStatement pstmt = null;
		try {
			String Query = "delete " + "from meta_board where article_ref = "
					+ article_id;

			pstmt = conn.prepareStatement(Query);
			pstmt.executeUpdate(Query);

		} catch (SQLException ee1) {
			System.out.println("delete()");
		} finally {
			try {
				disconnect();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return;
	}
}
%>
