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
    // 세션에서 로그인한 사용자 아이디 가져오기
    String uid = (String) session.getAttribute("id");
    if (uid == null) {
        out.print("<script>alert('로그인이 필요합니다.'); location.href='../html/login.html';</script>");
        return;
    }
    UserObj user = (new UserDAO()).getUser(uid);
    String profileImage = user == null ? null : user.getProfileImage();
    String displayName = user == null ? "" : user.getName();
    String bio = user == null ? "" : user.getBio();
%>
<!DOCTYPE html>
<html>
<head>
<meta name=viewport content="width=device-width, initial-scale=1, user-scalable=0">
<meta charset="utf-8" />
<link rel="stylesheet" href="../css/core.css">
<title>MySNS - 정보 수정</title>
</head>
<body>
<form action="update.jsp" method="post" enctype="multipart/form-data">
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
            <h2>프로필 수정</h2>
            <div class="desc">
                프로필 사진, 이름, 소개를 수정할 수 있습니다.
            </div>
            <div class="profile-edit">
                <div class="profile-label">프로필 사진</div>
                <div class="profile-field profile-photo-field">
                    <% if (profileImage != null && !profileImage.trim().equals("")) { %>
                    <img class="profile-preview" src="../images/<%= h(profileImage) %>" alt="프로필 이미지">
                    <% } else { %>
                    <span class="profile-preview avatar-empty"><%= h((displayName == null || displayName.equals("") ? uid : displayName).substring(0, 1)) %></span>
                    <% } %>
                    <label class="text-button file-change-button" for="profileImage">사진변경</label>
                    <input id="profileImage" name="profileImage" class="file-hidden" type="file" accept="image/*">
                </div>

                <div class="profile-label">이메일</div>
                <div class="profile-field">
                    <input name="id" type="text" value="<%= h(uid) %>" readonly>
                </div>

                <div class="profile-label">이름</div>
                <div class="profile-field">
                    <input name="name" type="text" value="<%= h(displayName) %>" placeholder="이름" required>
                </div>

                <div class="profile-label">소개</div>
                <div class="profile-field">
                    <textarea name="bio" placeholder="소개"><%= h(bio) %></textarea>
                </div>

                <div class="profile-label">비밀번호 확인</div>
                <div class="profile-field">
                    <input name="currentPassword" type="password" placeholder="현재 비밀번호" required>
                </div>
            </div>
            <input type="submit" class="mtop-20" value="정보 수정하기"> 
        </div>
        <div class="section mtop-30">
            <h2>회원탈퇴</h2>
            <div class="desc">현재 로그인된 <b><%= uid %></b> 계정을 탈퇴합니다.</div>
            <a class="button danger-button" href="withdraw.jsp" onclick="return confirm('정말 회원탈퇴 하시겠습니까?');">회원탈퇴하기</a>
        </div>
    </div>
    <div class="page-footer">© 202x MySNS from GCA</div>
</form>
</body>
</html>
