<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="dao.FollowDAO" %>
<%
    String uid = (String) session.getAttribute("id");
    if (uid == null) {
        out.print("<script>alert('로그인이 필요합니다.'); location.href='../html/login.html';</script>");
        return;
    }

    String targetId = request.getParameter("targetId");
    String redirect = request.getParameter("redirect");
    if (redirect == null || redirect.trim().equals("")) redirect = "userList.jsp";

    if (targetId == null || targetId.trim().equals("") || uid.equals(targetId)) {
        response.sendRedirect(redirect);
        return;
    }

    try {
        (new FollowDAO()).toggle(uid, targetId);
        response.sendRedirect(redirect);
    } catch (Exception e) {
        out.print("<script>alert('팔로우 처리 중 오류가 발생했습니다.'); history.back();</script>");
    }
%>
