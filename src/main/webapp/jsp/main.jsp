<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.*" %>
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
    String loginId = (String) session.getAttribute("id");
    request.setCharacterEncoding("utf-8");
    String keyword = request.getParameter("keyword");
    if (keyword == null) keyword = "";
    int pageNo = 1;
    int pageSize = 10;
    try {
        pageNo = Integer.parseInt(request.getParameter("page"));
        if (pageNo < 1) pageNo = 1;
    } catch (Exception e) {
        pageNo = 1;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=0">
<meta charset="utf-8" />
<link rel="stylesheet" href="../css/core.css">
<title>MySNS - 메인</title>
</head>
<body>
    <div class="page-hdr">MySNS</div>
    <div class="page-body">
        <div class="menu-bar">
            <a href="../index.jsp">홈</a>
            <a href="main.jsp">피드</a>
<% if (loginId == null) { %>
            <a href="../html/login.html">로그인</a>
            <a href="../html/signup.html">회원가입</a>
<% } else { %>
            <a href="../html/feedAdd.html">글쓰기</a>
            <a href="edit.jsp">정보수정</a>
            <a href="followingList.jsp">팔로우 목록</a>
            <a href="logout.jsp">로그아웃</a>
<% } %>
        </div>
        <div class="section">
            <div class="section-head">
                <div>
                    <h2>게시판</h2>
                    <p>제목, 내용, 작성자로 검색할 수 있습니다.</p>
                </div>
<% if (loginId != null) { %>
                <a class="button button-inline" href="../html/feedAdd.html">글쓰기</a>
<% } %>
            </div>
            <form class="board-search" action="main.jsp" method="get">
                <input name="keyword" type="text" value="<%= h(keyword) %>" placeholder="검색어 입력">
                <input type="submit" value="검색">
                <% if (!keyword.trim().equals("")) { %>
                <a class="text-button" href="main.jsp">전체</a>
                <% } %>
            </form>
<%
    FeedDAO feedDao = new FeedDAO();
    int totalCount = feedDao.getCount(keyword);
    int totalPage = (int) Math.ceil(totalCount / (double) pageSize);
    if (totalPage < 1) totalPage = 1;
    if (pageNo > totalPage) pageNo = totalPage;
    ArrayList<FeedObj> feeds = feedDao.getPage(keyword, pageNo, pageSize);
%>
            <div class="board-list">
                <div class="board-row board-head">
                    <div class="board-no">No</div>
                    <div class="board-title">제목</div>
                    <div class="board-author">글쓴이</div>
                    <div class="board-date">작성시간</div>
                    <div class="board-reply">댓글</div>
                    <div class="board-like">좋아요</div>
                </div>
<%
    if (feeds == null || feeds.isEmpty()) {
        out.print("<div class='board-empty'>등록된 글이 없습니다.</div>");
    } else {
        for (FeedObj feed : feeds) {
            String detailUrl = "feedView.jsp?no=" + feed.getNo();
            if (!keyword.trim().equals("")) {
                detailUrl += "&keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8") + "&page=" + pageNo;
            } else {
                detailUrl += "&page=" + pageNo;
            }
            String authorName = feed.getAuthorName() == null ? feed.getId() : feed.getAuthorName();
%>
                <div class="board-item">
                    <div class="board-row">
                        <div class="board-no"><%= feed.getNo() %></div>
                        <div class="board-title">
                            <a class="board-title-link" href="<%= detailUrl %>"><%= h(feed.getTitle()) %></a>
                        </div>
                        <div class="board-author"><span><%= h(authorName) %></span></div>
                        <div class="board-date"><%= h(feed.getTs()) %></div>
                        <div class="board-reply"><%= feed.getReplyCount() %></div>
                        <div class="board-like"><%= feed.getLikeCount() %></div>
                    </div>
                </div>
<%
        }
    }
%>
            </div>
            <div class="pagination">
<%
    String encodedKeyword = java.net.URLEncoder.encode(keyword, "UTF-8");
    for (int i = 1; i <= totalPage; i++) {
        String cls = (i == pageNo) ? "page-link active" : "page-link";
        out.print("<a class='" + cls + "' href='main.jsp?page=" + i + "&keyword=" + encodedKeyword + "'>" + i + "</a>");
    }
%>
            </div>
        </div>
    </div>
    <div class="page-footer">Copyright: mysns.com, 202x</div>

</body>
</html>
