package dao;

import java.sql.*;
import java.util.ArrayList;
import javax.naming.NamingException;
import util.*;

public class UserDAO {
    public boolean insert(String uid, String upass, String uname, String ubio) throws NamingException, SQLException {
        Connection conn = ConnectionPool.get();
        PreparedStatement stmt = null;
        try {
            String sql = "INSERT INTO user(id, password, name, bio) VALUES(?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, uid);
            stmt.setString(2, upass);
            stmt.setString(3, uname);
            stmt.setString(4, ubio);

            int count = stmt.executeUpdate();
            return (count == 1) ? true : false;

        } finally {
            if (stmt != null)
                stmt.close();
            if (conn != null)
                conn.close();
        }
    }

    public boolean update(String uid, String upass, String uname, String ubio) throws NamingException, SQLException {
        return update(uid, upass, uname, ubio, null);
    }

    public boolean update(String uid, String upass, String uname, String ubio, String profileImage) throws NamingException, SQLException {
        Connection conn = ConnectionPool.get();
        PreparedStatement stmt = null;
        try {
            String sql = "UPDATE user SET password = ?, name = ?, bio = ?";
            if (profileImage != null && !profileImage.trim().equals("")) {
                sql += ", profile_image = ?";
            }
            sql += " WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, upass);
            stmt.setString(2, uname);
            stmt.setString(3, ubio);
            if (profileImage != null && !profileImage.trim().equals("")) {
                stmt.setString(4, profileImage);
                stmt.setString(5, uid);
            } else {
                stmt.setString(4, uid);
            }

            int count = stmt.executeUpdate();
            return (count == 1) ? true : false;

        } finally {
            if (stmt != null)
                stmt.close();
            if (conn != null)
                conn.close();
        }
    }

    public boolean updateProfile(String uid, String uname, String ubio, String profileImage) throws NamingException, SQLException {
        Connection conn = ConnectionPool.get();
        PreparedStatement stmt = null;
        try {
            String sql = "UPDATE user SET name = ?, bio = ?";
            if (profileImage != null && !profileImage.trim().equals("")) {
                sql += ", profile_image = ?";
            }
            sql += " WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, uname);
            stmt.setString(2, ubio);
            if (profileImage != null && !profileImage.trim().equals("")) {
                stmt.setString(3, profileImage);
                stmt.setString(4, uid);
            } else {
                stmt.setString(3, uid);
            }

            int count = stmt.executeUpdate();
            return (count == 1) ? true : false;

        } finally {
            if (stmt != null)
                stmt.close();
            if (conn != null)
                conn.close();
        }
    }

    public boolean exists(String uid) throws NamingException, SQLException {
        Connection conn = ConnectionPool.get();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT id FROM user WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, uid);

            rs = stmt.executeQuery();
            return rs.next();

        } finally {
            if (rs != null)
                rs.close();
            if (stmt != null)
                stmt.close();
            if (conn != null)
                conn.close();
        }
    }

    public boolean delete(String uid) throws NamingException, SQLException {
        Connection conn = ConnectionPool.get();
        PreparedStatement stmt = null;
        try {
            String sql = "DELETE FROM user WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, uid);

            int count = stmt.executeUpdate();
            return (count > 0) ? true : false;

        } finally {
            if (stmt != null)
                stmt.close();
            if (conn != null)
                conn.close();
        }
    }

    public int login(String uid, String upass) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT id, password FROM user WHERE id = ?";

            conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, uid);

            rs = stmt.executeQuery();
            if (!rs.next())
                return 1;
            if (!upass.equals(rs.getString("password")))
                return 2;
            return 0;
        } finally {
            if (rs != null)
                rs.close();
            if (stmt != null)
                stmt.close();
            if (conn != null)
                conn.close();
        }
    }

    public ArrayList<UserObj> getList() throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT * FROM user ORDER BY ts DESC";
            conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            ArrayList<UserObj> users = new ArrayList<UserObj>();
            while (rs.next()) {
                String id = rs.getString("id");
                String profileImage = ProfileUtil.resolveImage(id, rs.getString("profile_image"));
                users.add(new UserObj(id, rs.getString("name"), rs.getString("bio"), rs.getString("ts"), profileImage));
            }
            return users;
        } finally {
            if (rs != null)
                rs.close();
            if (stmt != null)
                stmt.close();
            if (conn != null)
                conn.close();
        }

    }

    public UserObj getUser(String uid) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT * FROM user WHERE id = ?";
            conn = ConnectionPool.get();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, uid);
            rs = stmt.executeQuery();
            if (!rs.next()) return null;
            String id = rs.getString("id");
            String profileImage = ProfileUtil.resolveImage(id, rs.getString("profile_image"));
            return new UserObj(id, rs.getString("name"), rs.getString("bio"), rs.getString("ts"), profileImage);
        } finally {
            if (rs != null)
                rs.close();
            if (stmt != null)
                stmt.close();
            if (conn != null)
                conn.close();
        }
    }

}
