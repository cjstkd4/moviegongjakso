<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
	<meta charset="UTF-8">
</head>
<body>
<%
 session.invalidate();
%>
<p align="center">로그아웃 되었습니다.</p>
<p align="center"><a href="main.jsp">안녕히 가세요 ^^</a></p>
</body>
</html>