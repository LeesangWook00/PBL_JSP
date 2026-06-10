<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="dao.UserDAO" %>
<%
    request.setCharacterEncoding("utf-8");
    String uid = request.getParameter("id");
    String upass = request.getParameter("ps");

    if (uid == null || uid.trim().equals("") || upass == null || upass.trim().equals("")) {
        out.print("<script>alert('아이디와 패스워드를 입력해주세요.'); history.back();</script>");
        return;
    }

    UserDAO dao = new UserDAO();
    int code = dao.login(uid, upass);
    if (code == 1) {
        out.print("<script>alert('아이디가 존재하지 않습니다.'); history.back();</script>");
    }
    else if (code == 2) {
        out.print("<script>alert('패스워드가 일치하지 않습니다.'); history.back();</script>");
    }
    else {
        session.setAttribute("id", uid);
        response.sendRedirect("main.jsp");
    }
%>
