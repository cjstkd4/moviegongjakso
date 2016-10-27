<%@ page  contentType="text/html;charset=UTF-8" import="java.sql.DriverManager, java.sql.*" %>
<%@ page import="jspdb.DB"%>
<%
response.setContentType("text/html;charset=UTF-8;");
request.setCharacterEncoding("UTF-8");
String logid;
String logpw;
if(session.getAttribute("logid") == null && session.getAttribute("logpw") == null){
	out.println("seesion값이 null입니다.");
} else {
	logid=(String)session.getAttribute("logid");
	logpw=(String)session.getAttribute("logpw");
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Trans	itional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<%
response.sendRedirect("main.jsp");
%>
</body>
</html>