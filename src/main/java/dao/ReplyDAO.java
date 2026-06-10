package dao;

import java.sql.*;
import java.util.ArrayList;
import javax.naming.NamingException;
import util.*;

public class ReplyDAO {
    public boolean insert(int feedNo, String uid, String content) throws NamingException, SQLException {
        Connection conn = ConnectionPool.get();
        PreparedStatement stmt = null;
        try {
            String sql = "INSERT INTO reply(feed_no, id, content) VALUES(?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, feedNo);
            stmt.setString(2, uid);
            stmt.setString(3, content);

            int count = stmt.executeUpdate();
            return count == 1;
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public ArrayList<ReplyObj> getList(int feedNo) throws NamingException, SQLException {
        Connection conn = ConnectionPool.get();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT * FROM reply WHERE feed_no = ? ORDER BY ts ASC";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, feedNo);
            rs = stmt.executeQuery();

            ArrayList<ReplyObj> replies = new ArrayList<ReplyObj>();
            while (rs.next()) {
                replies.add(new ReplyObj(rs.getInt("no"), rs.getInt("feed_no"), rs.getString("id"), rs.getString("content"), rs.getString("ts")));
            }
            return replies;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public boolean delete(int no, String uid) throws NamingException, SQLException {
        Connection conn = ConnectionPool.get();
        PreparedStatement stmt = null;
        try {
            String sql = "DELETE FROM reply WHERE no = ? AND id = ?";
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
}
