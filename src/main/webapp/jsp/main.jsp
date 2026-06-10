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
                    <p>글 작성, 이미지 첨부, 댓글, 수정, 삭제가 가능한 게시판입니다.</p>
                </div>
<% if (loginId != null) { %>
                <a class="button button-inline" href="../html/feedAdd.html">글쓰기</a>
<% } %>
            </div>
            <div class="board-list">
                <div class="board-row board-head">
                    <div class="board-no">번호</div>
                    <div class="board-title">제목</div>
                    <div class="board-author">작성자</div>
                    <div class="board-date">작성일</div>
                    <div class="board-manage">관리</div>
                </div>
<%
    ArrayList<FeedObj> feeds = (new FeedDAO()).getList2();
    if (feeds == null || feeds.isEmpty()) {
        out.print("<div class='board-empty'>등록된 글이 없습니다.</div>");
    } else {
        ReplyDAO replyDao = new ReplyDAO();
        for (FeedObj feed : feeds) {
            String img = feed.getImages();
            String imgstr = "";
            if (img != null && !img.trim().isEmpty()) {
                imgstr = "<div class='board-image'><img src='../images/" + h(img) + "' alt='Image'></div>";
            }
            out.print("<div class='board-item'>");
            out.print("  <div class='board-row'>");
            out.print("    <div class='board-no'>" + feed.getNo() + "</div>");
            out.print("    <div class='board-title'><strong>" + h(feed.getTitle()) + "</strong><p>" + h(feed.getContent()).replace("\n", "<br>") + "</p>" + imgstr + "</div>");
            out.print("    <div class='board-author'>" + h(feed.getId()) + "</div>");
            out.print("    <div class='board-date'>" + h(feed.getTs()) + "</div>");
            out.print("    <div class='board-manage'>");
            if (loginId != null && loginId.equals(feed.getId())) {
                out.print("      <a class='text-button' href='feedEdit.jsp?no=" + feed.getNo() + "'>수정</a>");
                out.print("      <a class='text-button danger' href='feedDelete.jsp?no=" + feed.getNo() + "' onclick=\"return confirm('삭제하시겠습니까?');\">삭제</a>");
            }
            out.print("    </div>");
            out.print("  </div>");
            out.print("  <div class='reply-box board-replies'>");
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
