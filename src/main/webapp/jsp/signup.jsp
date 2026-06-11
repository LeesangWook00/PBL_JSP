<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="dao.UserDAO" %>
<%
	request.setCharacterEncoding("utf-8");

    String uid = request.getParameter("id");
    String upass = request.getParameter("ps");
    String upass2 = request.getParameter("ps2");
    String uname = request.getParameter("name");
    String ubio = request.getParameter("bio");

    if (uid == null || uid.trim().equals("") || upass == null || upass.trim().equals("")) {
        out.print("<script>alert('아이디와 패스워드를 입력해주세요.'); history.back();</script>");
        return;
    }

    if (upass2 == null || upass2.trim().equals("") || !upass.equals(upass2)) {
        out.print("<script>alert('패스워드가 일치하지 않습니다.'); history.back();</script>");
        return;
    }
    
    UserDAO dao = new UserDAO();
    if (dao.exists(uid)) {
        out.print("<script>alert('이미 가입한 회원입니다.'); history.back();</script>");
        return;
    }
    
    if (dao.insert(uid, upass, uname, ubio)) {
        out.print("<script>alert('회원 가입이 완료되었습니다. 로그인해주세요.'); location.href='../html/login.html';</script>");
    }
    else {
        out.print("<script>alert('회원 가입 중 오류가 발생했습니다.'); history.back();</script>");
    }
%>
