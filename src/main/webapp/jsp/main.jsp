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
            <div class="instagram-container">
                <div class="feed-list-wrap">
<%
    if (feeds == null || feeds.isEmpty()) {
        out.print("<div class='board-empty' style='text-align:center; padding: 50px; color:#8e8e8e;'>등록된 글이 없습니다.</div>");
    } else {
        LikeDAO likeDao = new LikeDAO();
        FollowDAO followDao = new FollowDAO();
        for (FeedObj feed : feeds) {
            String detailUrl = "feedView.jsp?no=" + feed.getNo();
            if (!keyword.trim().equals("")) {
                detailUrl += "&keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8") + "&page=" + pageNo;
            } else {
                detailUrl += "&page=" + pageNo;
            }
            String currentUrl = "main.jsp?page=" + pageNo + "&keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8");
            String likeUrl = "likeToggle.jsp?no=" + feed.getNo() + "&redirect=" + java.net.URLEncoder.encode(currentUrl, "UTF-8");
            
            boolean liked = false;
            boolean isFollowing = false;
            if (loginId != null) {
                liked = likeDao.isLiked(feed.getNo(), loginId);
                isFollowing = followDao.isFollowing(loginId, feed.getId());
            }
            
            String authorName = feed.getAuthorName() == null ? feed.getId() : feed.getAuthorName();
            String profileImg = (feed.getAuthorProfileImage() != null && !feed.getAuthorProfileImage().trim().equals("")) ? "../images/" + h(feed.getAuthorProfileImage()) : "../image/default_profile.png";
%>
                    <article class="insta-feed-card">
                        <div class="insta-card-header">
                            <img src="<%= profileImg %>" class="insta-profile-pic" alt="프로필">
                            <div class="insta-author-info">
                                <span class="insta-author-name"><%= h(authorName) %></span>
                                <span class="insta-feed-time"><%= feed.getTs().substring(0, 16) %></span>
                            </div>
<% if (loginId != null && !loginId.equals(feed.getId())) { %>
                            <button class="btn-follow follow-icon <%= isFollowing ? "following" : "" %>" title="<%= isFollowing ? "팔로우 취소" : "팔로우" %>" onclick="location.href='followToggle.jsp?targetId=<%= feed.getId() %>'">
                                <%= isFollowing ? "×" : "+" %>
                            </button>
<% } %>
                        </div>
<% if (feed.getImages() != null && !feed.getImages().trim().isEmpty()) { %>
                        <img src="../images/<%= h(feed.getImages()) %>" class="insta-feed-image" alt="게시글 이미지">
<% } %>
                        <div class="insta-card-actions">
                            <% if (loginId != null) { %>
                            <a class="icon-action <%= liked ? "active" : "" %>" href="<%= likeUrl %>" title="<%= liked ? "좋아요 취소" : "좋아요" %>">👍 <span><%= feed.getLikeCount() %></span></a>
                            <% } else { %>
                            <span class="icon-action">👍 <span><%= feed.getLikeCount() %></span></span>
                            <% } %>
                            <a class="icon-action" href="<%= detailUrl %>" title="댓글">💬 <span><%= feed.getReplyCount() %></span></a>
                        </div>
                        <div class="insta-card-content">
                            <a href="<%= detailUrl %>" class="insta-feed-title"><%= h(feed.getTitle()) %></a>
                            <p class="insta-feed-text"><%= h(feed.getContent()) %></p>
                        </div>
                    </article>
<%
        }
    }
%>
                </div>
                <div class="insta-sidebar">
<%
    if (loginId != null) {
        String myName = loginId;
        String myProfileImg = "../image/default_profile.png";
        
        java.sql.Connection conn = null;
        java.sql.PreparedStatement stmt = null;
        java.sql.ResultSet rs = null;
        try {
            conn = util.ConnectionPool.get();
            stmt = conn.prepareStatement("SELECT name, profile_image FROM user WHERE id=?");
            stmt.setString(1, loginId);
            rs = stmt.executeQuery();
            if(rs.next()) {
                myName = rs.getString("name");
                if(myName == null || myName.trim().isEmpty()) myName = loginId;
                String pImg = rs.getString("profile_image");
                if(pImg != null && !pImg.trim().isEmpty()) myProfileImg = "../images/" + pImg;
            }
        } catch(Exception e) { } finally {
            if(rs!=null) rs.close(); if(stmt!=null) stmt.close(); if(conn!=null) conn.close();
        }
%>
                    <div class="sidebar-profile">
                        <img src="<%= myProfileImg %>" class="sidebar-pic" alt="내 프로필">
                        <div class="sidebar-info">
                            <span class="sidebar-id"><%= h(loginId) %></span>
                            <span class="sidebar-desc"><%= h(myName) %></span>
                        </div>
                        <a href="logout.jsp" class="sidebar-action">로그아웃</a>
                    </div>
                    <div class="sidebar-suggestions">
                        <div class="sugg-header">
                            <span>회원님을 위한 추천</span>
                            <a href="userList.jsp">모두 보기</a>
                        </div>
                        <div class="sugg-item">
                            새로운 친구들을 팔로우하고<br>새로운 소식을 받아보세요!
                        </div>
                    </div>
<%
    } else {
%>
                    <div class="sidebar-profile">
                        <div class="sidebar-info">
                            <span class="sidebar-id">로그인이 필요합니다</span>
                            <span class="sidebar-desc">MySNS를 100% 즐겨보세요!</span>
                        </div>
                        <a href="../html/login.html" class="sidebar-action">로그인</a>
                    </div>
<%
    }
%>
                    <div class="sidebar-footer">
                        <a href="#">소개</a> · <a href="#">도움말</a> · <a href="#">홍보 센터</a><br>
                        <a href="#">개인정보처리방침</a> · <a href="#">약관</a><br><br>
                        © 202X MySNS from PBL_JSP
                    </div>
                </div>
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
