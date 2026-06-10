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
            <a href="../index.html">홈</a>
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
            <div class="section-head">
                <div>
                    <h2>게시판</h2>
                    <p>글 작성, 이미지 첨부, 수정, 삭제가 가능한 피드 게시판입니다.</p>
                </div>
                <a class="button button-inline" href="../html/feedAdd.html">글쓰기</a>
            </div>
            <div class="feed-grid">
<%
    ArrayList<FeedObj> feeds = (new FeedDAO()).getList2();
    if (feeds == null || feeds.isEmpty()) {
        out.print("<div class='feed-card'><div class='feed-content'>등록된 글이 없습니다.</div></div>");
    } else {
        ReplyDAO replyDao = new ReplyDAO();
        for (FeedObj feed : feeds) {
            String img = feed.getImages();
            String imgstr = "";
            if (img != null && !img.trim().isEmpty()) {
                imgstr = "<div class='feed-img'><img src='../images/" + h(img) + "' alt='Image'></div>";
            }
            out.print("<div class='feed-card'>");
            out.print("  <div class='feed-header'>");
            out.print("    <strong class='feed-title'>" + h(feed.getTitle()) + "</strong>");
            out.print("    <span class='feed-author'>" + h(feed.getId()) + "</span>");
            out.print("    <span class='feed-time'>" + h(feed.getTs()) + "</span>");
            out.print("  </div>");
            out.print(imgstr);
            out.print("  <div class='feed-content'>" + h(feed.getContent()).replace("\n", "<br>") + "</div>");
            if (loginId != null && loginId.equals(feed.getId())) {
                out.print("  <div class='feed-actions'>");
                out.print("    <a class='text-button' href='feedEdit.jsp?no=" + feed.getNo() + "'>수정</a>");
                out.print("    <a class='text-button danger' href='feedDelete.jsp?no=" + feed.getNo() + "' onclick=\"return confirm('삭제하시겠습니까?');\">삭제</a>");
                out.print("  </div>");
            }
            out.print("  <div class='reply-box'>");
            ArrayList<ReplyObj> replies = replyDao.getList(feed.getNo());
            if (replies.isEmpty()) {
                out.print("    <div class='reply-empty'>댓글이 없습니다.</div>");
            } else {
                for (ReplyObj reply : replies) {
                    out.print("    <div class='reply-item'>");
                    out.print("      <div><strong>" + h(reply.getId()) + "</strong><span>" + h(reply.getTs()) + "</span></div>");
                    out.print("      <p>" + h(reply.getContent()).replace("\n", "<br>") + "</p>");
                    if (loginId != null && loginId.equals(reply.getId())) {
                        out.print("      <a class='reply-delete' href='replyDelete.jsp?no=" + reply.getNo() + "' onclick=\"return confirm('댓글을 삭제하시겠습니까?');\">삭제</a>");
                    }
                    out.print("    </div>");
                }
            }
            if (loginId != null) {
                out.print("    <form class='reply-form' action='replyAdd.jsp' method='post'>");
                out.print("      <input type='hidden' name='feedNo' value='" + feed.getNo() + "'>");
                out.print("      <input name='content' type='text' placeholder='댓글 작성' required>");
                out.print("      <input type='submit' value='등록'>");
                out.print("    </form>");
            }
            out.print("  </div>");
            out.print("</div>");
        }
    }
%>
            </div>
        </div>
    </div>
    <div class="page-footer">Copyright: mysns.com, 202x</div>
</body>
</html>
