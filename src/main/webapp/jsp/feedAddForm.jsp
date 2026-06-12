<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%
    String uid = (String) session.getAttribute("id");
    if (uid == null) {
        out.print("<script>alert('로그인이 필요합니다.'); location.href='../html/login.html';</script>");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta name=viewport content="width=device-width, initial-scale=1, user-scalable=0">
<meta charset="utf-8" />
<link rel="stylesheet" href="../css/core.css">
<title>MySNS - 글쓰기</title>
</head>
<body>
<form action="feedAdd.jsp" method="post" enctype="multipart/form-data">
    <div class="page-hdr">MySNS</div>
    <div class="page-body">
        <div class="menu-bar">
            <a href="../index.jsp">홈</a>
            <a href="main.jsp">피드</a>
            <a href="feedAddForm.jsp">글쓰기</a>
            <a href="edit.jsp">정보수정</a>
            <% if ("root@abc.com".equals(uid)) { %>
            <a href="userList.jsp">회원목록</a>
            <% } %>
            <a href="followingList.jsp">팔로우 목록</a>
            <a href="logout.jsp">로그아웃</a>
        </div>
        <div class="section">
            <h2>새 글 작성</h2>
            <input name="title" type="text" placeholder="제목" required>
            <textarea name="content" class="mtop-10" placeholder="이곳에 글을 작성해 주세요." required></textarea>
            <div class="section pad-4 mtop-30">
                <div class="desc">아래에서 이미지를 선택해주세요.</div>
                <input type="file" name="image">
            </div>
            <input type="submit" class="mtop-30" value="업로드하기">
        </div>
    </div>
    <div class="page-footer">Copyright: mysns.com, 202x</div>
</form>
</body>
</html>
