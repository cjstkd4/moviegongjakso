<%@ page contentType="text/html;charset=UTF-8" import="java.sql.*"%>
<%@ page import="jspdb.DB"%>
<%
request.setCharacterEncoding("UTF-8");
String memberid = request.getParameter("memberid");
String memberpw = request.getParameter("memberpw");
String memberName = request.getParameter("memberName");
String nickname = request.getParameter("nickname");

DB db = new DB();
try {
	db.putMember(memberid, memberpw, memberName, nickname);
	db.commit();
} catch (Exception e) {
		out.println("아이디나 별명이 중복이 됩니다.");
	try {
		Thread.sleep(2000);
	} catch(InterruptedException i) {
		out.println(i.getMessage());
	}
	response.sendRedirect("join.html");
}

if (memberid != null && memberpw != null && memberName != null && nickname != null) {
	response.sendRedirect("main.jsp");
} else if (memberid == null) {
	response.sendRedirect("join.html");
}
%>