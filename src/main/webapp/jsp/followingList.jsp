<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="dao.*" %>
<%!
    private String h(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>
<%
    String uid = (String) session.getAttribute("id");
    if (uid == null) {
        out.print("<script>alert('로그인이 필요합니다.'); location.href='../html/login.html';</script>");
        return;
    }
    FollowDAO followDao = new FollowDAO();
    ArrayList<UserObj> users = followDao.getFollowingList(uid);
%>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=0">
<meta charset="utf-8" />
<link rel="stylesheet" href="../css/core.css">
<title>MySNS - 팔로우 목록</title>
</head>
<body>
    <div class="page-hdr">MySNS</div>
    <div class="page-body">
        <div class="menu-bar">
            <a href="../index.jsp">홈</a>
            <a href="main.jsp">피드</a>
            <a href="../html/feedAdd.html">글쓰기</a>
            <a href="edit.jsp">정보수정</a>
            <a href="userList.jsp">회원목록</a>
            <a href="followingList.jsp">팔로우 목록</a>
            <a href="logout.jsp">로그아웃</a>
        </div>
        <div class="section">
            <h2>팔로우 목록</h2>
            <% if (users.isEmpty()) { %>
            <div class="board-empty">팔로우한 회원이 없습니다.</div>
            <% } else { %>
            <table class="data-table member-table">
                <tr>
                    <th>프로필</th>
                    <th>아이디</th>
                    <th>이름</th>
                    <th>소개</th>
                    <th>관리</th>
                </tr>
<% for (UserObj user : users) { %>
                <tr>
                    <td data-label="프로필">
                        <% if (user.getProfileImage() != null && !user.getProfileImage().trim().equals("")) { %>
                        <img class="avatar" src="../images/<%= h(user.getProfileImage()) %>" alt="프로필 이미지">
                        <% } else { %>
                        <span class="avatar avatar-empty"><%= h(user.getName() == null || user.getName().equals("") ? user.getId().substring(0, 1) : user.getName().substring(0, 1)) %></span>
                        <% } %>
                    </td>
                    <td data-label="아이디"><%= h(user.getId()) %></td>
                    <td data-label="이름"><%= h(user.getName()) %></td>
                    <td data-label="소개"><%= h(user.getBio()) %></td>
                    <td data-label="관리">
                        <a class="text-button follow-icon following" title="팔로우 취소" href="followToggle.jsp?targetId=<%= java.net.URLEncoder.encode(user.getId(), "UTF-8") %>&redirect=followingList.jsp">×</a>
                    </td>
                </tr>
<% } %>
            </table>
            <% } %>
        </div>
    </div>
    <div class="page-footer">Copyright: mysns.com, 202x</div>
</body>
</html>
