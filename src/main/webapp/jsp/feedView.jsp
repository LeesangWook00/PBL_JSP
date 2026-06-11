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
    request.setCharacterEncoding("utf-8");
    String loginId = (String) session.getAttribute("id");
    String keyword = request.getParameter("keyword");
    String pageNo = request.getParameter("page");
    if (keyword == null) keyword = "";
    if (pageNo == null || pageNo.trim().equals("")) pageNo = "1";

    int no = 0;
    try {
        no = Integer.parseInt(request.getParameter("no"));
    } catch (Exception e) {
        out.print("<script>alert('잘못된 게시글입니다.'); location.href='main.jsp';</script>");
        return;
    }

    FeedObj feed = (new FeedDAO()).getFeed(no);
    if (feed == null) {
        out.print("<script>alert('게시글이 없습니다.'); location.href='main.jsp';</script>");
        return;
    }

    String listUrl = "main.jsp?page=" + pageNo + "&keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8");
    ArrayList<ReplyObj> replies = (new ReplyDAO()).getList(no);
    LikeDAO likeDao = new LikeDAO();
    boolean liked = likeDao.isLiked(feed.getNo(), loginId);
    String currentUrl = "feedView.jsp?no=" + feed.getNo() + "&page=" + pageNo + "&keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8");
    String likeUrl = "likeToggle.jsp?no=" + feed.getNo() + "&redirect=" + java.net.URLEncoder.encode(currentUrl, "UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=0">
<meta charset="utf-8" />
<link rel="stylesheet" href="../css/core.css">
<title>MySNS - 상세보기</title>
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
            <a href="userList.jsp">회원목록</a>
            <a href="logout.jsp">로그아웃</a>
<% } %>
        </div>
        <div class="section">
            <div class="view-head">
                <h2><%= h(feed.getTitle()) %></h2>
                <div class="view-meta">
                    <span class="author-chip">
                    <% if (feed.getAuthorProfileImage() != null && !feed.getAuthorProfileImage().trim().equals("")) { %>
                        <img class="avatar avatar-small" src="../images/<%= h(feed.getAuthorProfileImage()) %>" alt="프로필 이미지">
                    <% } else { %>
                        <span class="avatar avatar-small avatar-empty"><%= h(feed.getId().substring(0, 1)) %></span>
                    <% } %>
                    작성자 <b><%= h(feed.getAuthorName() == null ? feed.getId() : feed.getAuthorName()) %></b>
                    </span>
                    <span>작성일 <%= h(feed.getTs()) %></span>
                    <span>👍 <%= feed.getLikeCount() %></span>
                </div>
            </div>
            <% if (feed.getImages() != null && !feed.getImages().trim().equals("")) { %>
            <div class="view-image">
                <img src="../images/<%= h(feed.getImages()) %>" alt="첨부 이미지">
            </div>
            <% } %>
            <div class="view-content"><%= h(feed.getContent()).replace("\n", "<br>") %></div>
            <div class="view-actions">
                <a class="text-button" href="<%= listUrl %>">목록</a>
                <% if (loginId != null) { %>
                <a class="icon-action <%= liked ? "active" : "" %>" href="<%= likeUrl %>" title="<%= liked ? "좋아요 취소" : "좋아요" %>">👍 <span><%= feed.getLikeCount() %></span></a>
                <% } %>
                <% if (loginId != null && loginId.equals(feed.getId())) { %>
                <a class="text-button" href="feedEdit.jsp?no=<%= feed.getNo() %>">수정</a>
                <a class="text-button danger" href="feedDelete.jsp?no=<%= feed.getNo() %>" onclick="return confirm('삭제하시겠습니까?');">삭제</a>
                <% } %>
            </div>
        </div>
        <div class="section mtop-20">
            <h2>댓글 <%= replies.size() %></h2>
            <div class="reply-box detail-replies">
                <% if (replies.isEmpty()) { %>
                <div class="reply-empty">댓글이 없습니다.</div>
                <% } else {
                    for (ReplyObj reply : replies) {
                %>
                <div class="reply-item">
                    <div><strong><%= h(reply.getId()) %></strong><span><%= h(reply.getTs()) %></span></div>
                    <p><%= h(reply.getContent()).replace("\n", "<br>") %></p>
                    <% if (loginId != null && loginId.equals(reply.getId())) { %>
                    <a class="reply-delete" href="replyDelete.jsp?no=<%= reply.getNo() %>&feedNo=<%= feed.getNo() %>" onclick="return confirm('댓글을 삭제하시겠습니까?');">삭제</a>
                    <% } %>
                </div>
                <% }} %>
                <% if (loginId != null) { %>
                <form class="reply-form" action="replyAdd.jsp" method="post">
                    <input type="hidden" name="feedNo" value="<%= feed.getNo() %>">
                    <input name="content" type="text" placeholder="댓글 작성" required>
                    <input type="submit" value="등록">
                </form>
                <% } %>
            </div>
        </div>
    </div>
    <div class="page-footer">Copyright: mysns.com, 202x</div>
</body>
</html>
