<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="dao.*" %>
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
        out.print("<script>alert('잘못된 댓글입니다.'); location.href='main.jsp';</script>");
        return;
    }

    if ((new ReplyDAO()).delete(no, uid)) {
        response.sendRedirect("main.jsp");
    } else {
        out.print("<script>alert('삭제 권한이 없거나 댓글이 없습니다.'); location.href='main.jsp';</script>");
    }
%>
