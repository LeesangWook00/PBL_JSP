<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="dao.*" %>
<%
    request.setCharacterEncoding("utf-8");

    String uid = (String) session.getAttribute("id");
    if (uid == null) {
        out.print("<script>alert('로그인이 필요합니다.'); location.href='../html/login.html';</script>");
        return;
    }

    int feedNo = 0;
    try {
        feedNo = Integer.parseInt(request.getParameter("feedNo"));
    } catch (Exception e) {
        out.print("<script>alert('잘못된 게시글입니다.'); location.href='main.jsp';</script>");
        return;
    }

    String content = request.getParameter("content");
    if (content == null || content.trim().equals("")) {
        out.print("<script>alert('댓글 내용을 입력해주세요.'); history.back();</script>");
        return;
    }

    if ((new ReplyDAO()).insert(feedNo, uid, content)) {
        response.sendRedirect("main.jsp");
    } else {
        out.print("<script>alert('댓글 등록 중 오류가 발생했습니다.'); history.back();</script>");
    }
%>
