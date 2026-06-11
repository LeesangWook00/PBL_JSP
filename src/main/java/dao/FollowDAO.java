package dao;

import java.sql.*;
import java.util.ArrayList;
import javax.naming.NamingException;
import util.*;

public class FollowDAO {
    public boolean isFollowing(String followerId, String targetId) throws NamingException, SQLException {
        if (followerId == null || targetId == null) return false;
        Connection conn = ConnectionPool.get();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT follower_id FROM follow WHERE follower_id = ? AND target_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, followerId);
            stmt.setString(2, targetId);
            rs = stmt.executeQuery();
            return rs.next();
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public int getFollowerCount(String targetId) throws NamingException, SQLException {
        Connection conn = ConnectionPool.get();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT COUNT(*) FROM follow WHERE target_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, targetId);
            rs = stmt.executeQuery();
            if (!rs.next()) return 0;
            return rs.getInt(1);
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public void toggle(String followerId, String targetId) throws NamingException, SQLException {
        if (followerId == null || targetId == null || followerId.equals(targetId)) return;
        Connection conn = ConnectionPool.get();
        PreparedStatement stmt = null;
        try {
            if (isFollowing(followerId, targetId)) {
                String sql = "DELETE FROM follow WHERE follower_id = ? AND target_id = ?";
                stmt = conn.prepareStatement(sql);
            } else {
                String sql = "INSERT INTO follow(follower_id, target_id) VALUES(?, ?)";
                stmt = conn.prepareStatement(sql);
            }
            stmt.setString(1, followerId);
            stmt.setString(2, targetId);
            stmt.executeUpdate();
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public ArrayList<UserObj> getFollowingList(String followerId) throws NamingException, SQLException {
        ArrayList<UserObj> users = new ArrayList<UserObj>();
        if (followerId == null) return users;
        Connection conn = ConnectionPool.get();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT u.* FROM follow f JOIN user u ON f.target_id = u.id WHERE f.follower_id = ? ORDER BY f.ts DESC";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, followerId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                String id = rs.getString("id");
                String profileImage = ProfileUtil.resolveImage(id, rs.getString("profile_image"));
                users.add(new UserObj(id, rs.getString("name"), rs.getString("bio"), rs.getString("ts"), profileImage));
            }
            return users;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
}
