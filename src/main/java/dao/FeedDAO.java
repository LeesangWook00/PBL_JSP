package dao;

import java.sql.*;
import java.util.ArrayList;

import javax.naming.NamingException;
import util.*;

public class FeedDAO {
	public boolean insert(String uid, String title, String ucon, String uimages) throws NamingException, SQLException {
	    Connection conn = ConnectionPool.get();
	    PreparedStatement stmt = null;
	    try {
	        String sql = "INSERT INTO feed(id, title, content, images) VALUES(?, ?, ?, ?)";
	        stmt = conn.prepareStatement(sql);
	        stmt.setString(1, uid);
	        stmt.setString(2, title);
	        stmt.setString(3, ucon);
	        stmt.setString(4, uimages);

	        int count = stmt.executeUpdate();
	        return (count == 1) ? true : false;

	    } finally {
	        if (stmt != null) stmt.close(); 
	        if (conn != null) conn.close();
	    }
	}

	public ArrayList<FeedObj> getList2() throws NamingException, SQLException {
	    return getPage("", 1, 1000);
	}

    public ArrayList<FeedObj> search(String keyword) throws NamingException, SQLException {
        return getPage(keyword, 1, 1000);
    }

    public ArrayList<FeedObj> getPage(String keyword, int page, int pageSize) throws NamingException, SQLException {
        Connection conn = ConnectionPool.get();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT f.*, u.name AS author_name, u.profile_image AS author_profile_image,";
            sql += " COUNT(DISTINCT r.no) AS reply_count, COUNT(DISTINCT l.id) AS like_count FROM feed f";
            sql += " LEFT JOIN user u ON f.id = u.id";
            sql += " LEFT JOIN reply r ON f.no = r.feed_no";
            sql += " LEFT JOIN feed_like l ON f.no = l.feed_no";
            boolean hasKeyword = keyword != null && !keyword.trim().equals("");
            if (hasKeyword) {
                sql += " WHERE f.title LIKE ? OR f.content LIKE ? OR f.id LIKE ? OR u.name LIKE ?";
            }
            sql += " GROUP BY f.no, f.id, f.title, f.content, f.ts, f.images, u.name, u.profile_image";
            sql += " ORDER BY f.no DESC LIMIT ? OFFSET ?";
            stmt = conn.prepareStatement(sql);
            int idx = 1;
            if (hasKeyword) {
                String q = "%" + keyword.trim() + "%";
                stmt.setString(idx++, q);
                stmt.setString(idx++, q);
                stmt.setString(idx++, q);
                stmt.setString(idx++, q);
            }
            stmt.setInt(idx++, pageSize);
            stmt.setInt(idx, (page - 1) * pageSize);
            rs = stmt.executeQuery();

            ArrayList<FeedObj> feeds = new ArrayList<FeedObj>();
            while(rs.next()) {
                String id = rs.getString("id");
                String profileImage = ProfileUtil.resolveImage(id, rs.getString("author_profile_image"));
                feeds.add(new FeedObj(rs.getInt("no"), id, rs.getString("title"), rs.getString("content"), rs.getString("ts"), rs.getString("images"), rs.getString("author_name"), rs.getInt("reply_count"), rs.getInt("like_count"), profileImage));
            }
            return feeds;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public int getCount(String keyword) throws NamingException, SQLException {
        Connection conn = ConnectionPool.get();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT COUNT(*) FROM feed f LEFT JOIN user u ON f.id = u.id";
            boolean hasKeyword = keyword != null && !keyword.trim().equals("");
            if (hasKeyword) {
                sql += " WHERE f.title LIKE ? OR f.content LIKE ? OR f.id LIKE ? OR u.name LIKE ?";
            }
            stmt = conn.prepareStatement(sql);
            if (hasKeyword) {
                String q = "%" + keyword.trim() + "%";
                stmt.setString(1, q);
                stmt.setString(2, q);
                stmt.setString(3, q);
                stmt.setString(4, q);
            }
            rs = stmt.executeQuery();
            if (!rs.next()) return 0;
            return rs.getInt(1);
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public FeedObj getFeed(int no) throws NamingException, SQLException {
        Connection conn = ConnectionPool.get();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT f.*, u.name AS author_name, u.profile_image AS author_profile_image,";
            sql += " COUNT(DISTINCT r.no) AS reply_count, COUNT(DISTINCT l.id) AS like_count FROM feed f";
            sql += " LEFT JOIN user u ON f.id = u.id";
            sql += " LEFT JOIN reply r ON f.no = r.feed_no";
            sql += " LEFT JOIN feed_like l ON f.no = l.feed_no";
            sql += " WHERE f.no = ?";
            sql += " GROUP BY f.no, f.id, f.title, f.content, f.ts, f.images, u.name, u.profile_image";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, no);
            rs = stmt.executeQuery();

            if (!rs.next()) return null;
            String id = rs.getString("id");
            String profileImage = ProfileUtil.resolveImage(id, rs.getString("author_profile_image"));
            return new FeedObj(rs.getInt("no"), id, rs.getString("title"), rs.getString("content"), rs.getString("ts"), rs.getString("images"), rs.getString("author_name"), rs.getInt("reply_count"), rs.getInt("like_count"), profileImage);
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public boolean update(int no, String uid, String title, String content) throws NamingException, SQLException {
        Connection conn = ConnectionPool.get();
        PreparedStatement stmt = null;
        try {
            String sql = "UPDATE feed SET title = ?, content = ? WHERE no = ? AND id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, title);
            stmt.setString(2, content);
            stmt.setInt(3, no);
            stmt.setString(4, uid);

            int count = stmt.executeUpdate();
            return count == 1;
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public boolean delete(int no, String uid) throws NamingException, SQLException {
        Connection conn = ConnectionPool.get();
        PreparedStatement stmt = null;
        try {
            String sql = "DELETE FROM feed WHERE no = ? AND id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, no);
            stmt.setString(2, uid);

            int count = stmt.executeUpdate();
            return count == 1;
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
	
	public ResultSet getList_old() throws NamingException, SQLException {
	    Connection conn = null;
	    PreparedStatement stmt = null;
	    try {
	        String sql = "SELECT * FROM feed ORDER BY ts DESC";
	        conn = ConnectionPool.get();
	        stmt = conn.prepareStatement(sql);
	        return stmt.executeQuery();

	    } finally {
	        if (stmt != null) stmt.close(); 
	        if (conn != null) conn.close();
	    }
	}
}
