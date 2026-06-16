<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="util.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.nio.file.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%
String uid = (String) session.getAttribute("id");
if (uid == null) {
    out.print("<script>alert('로그인이 필요합니다.'); location.href='../html/login.html';</script>");
    return;
}

String title = null, ucon = null, ufname = null;
byte[] ufile = null;
String file = null;
request.setCharacterEncoding("utf-8");

ServletFileUpload sfu = new ServletFileUpload(new DiskFileItemFactory());
List items = sfu.parseRequest(request);
Iterator iter = items.iterator();
while(iter.hasNext()) {
    FileItem item = (FileItem) iter.next();
    String name = item.getFieldName();
    if(item.isFormField()) {
        String value = item.getString("utf-8");
        if (name.equals("title")) title = value;
        else if (name.equals("content")) ucon = value;
    }
    else {
        if (name.equals("image")) {
            ufname = item.getName();
            if (ufname != null && !ufname.trim().equals("")) {
                Path p = Paths.get(ufname);
                file = FileUtil.safeFileName(uid, p.getFileName().toString());
                ufile = item.get();
                String root = application.getRealPath(java.io.File.separator);
                FileUtil.saveImage(root, file, ufile);
            }
        }
    }
}

FeedDAO dao = new FeedDAO();
if (title != null && !title.trim().equals("") && ucon != null && !ucon.trim().equals("") && dao.insert(uid, title, ucon, file)) {
    response.sendRedirect("main.jsp");
}
else {
    out.print("<script>alert('작성 글을 업로드하는 중 오류가 발생했습니다.'); history.back();</script>");
}
%>
