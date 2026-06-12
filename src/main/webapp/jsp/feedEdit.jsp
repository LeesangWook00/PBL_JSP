<%@ page contentType="text/html" pageEncoding="utf-8" %>
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

    int no = 0;
    try {
        no = Integer.parseInt(request.getParameter("no"));
    } catch (Exception e) {
        out.print("<script>alert('잘못된 게시글입니다.'); location.href='main.jsp';</script>");
        return;
    }

    FeedObj feed = (new FeedDAO()).getFeed(no);
    if (feed == null || !uid.equals(feed.getId())) {
        out.print("<script>alert('수정 권한이 없습니다.'); location.href='main.jsp';</script>");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=0">
<meta charset="utf-8" />
<link rel="stylesheet" href="../css/core.css">
<title>MySNS - 글 수정</title>
</head>
<body>
<form action="feedUpdate.jsp" method="post">
    <div class="page-hdr">MySNS</div>
    <div class="page-body">
        <div class="menu-bar">
            <a href="../index.jsp">홈</a>
            <a href="main.jsp">피드</a>
            <a href="../html/feedAdd.html">글쓰기</a>
            <a href="edit.jsp">정보수정</a>
            <% if ("root@abc.com".equals(uid)) { %>
            <a href="userList.jsp">회원목록</a>
            <% } %>
            <a href="followingList.jsp">팔로우 목록</a>
            <a href="logout.jsp">로그아웃</a>
        </div>
        <div class="section">
            <h2>글 수정</h2>
            <input type="hidden" name="no" value="<%= feed.getNo() %>">
            <input name="title" type="text" value="<%= h(feed.getTitle()) %>" placeholder="제목" required>
            <textarea name="content" class="mtop-10" required><%= h(feed.getContent()) %></textarea>
            <input type="submit" class="mtop-30" value="수정하기">
        </div>
    </div>
    <div class="page-footer">Copyright: mysns.com, 202x</div>
</form>
</body>
</html>
