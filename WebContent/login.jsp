<%@ page  contentType="text/html;charset=euc-kr" import="java.sql.DriverManager, java.sql.*" %>
<%@ page import="jspdb.DB"%>
<%
   response.setContentType("text/html;charset=EUC-KR;");
   request.setCharacterEncoding("EUC-KR");     //charset, Encoding 설정
   
   String logid = request.getParameter("logid");
   String logpw = request.getParameter("logpw");
   
   DB db = new DB();
   String dbid = "";
   String dbpw = "";

   try {
       String[] info = db.login(logid, logpw);
       dbid = info[0];
       dbpw = info[1];
   }
   catch (Exception e) {
         out.println("err:" + e.toString());
   } 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
</head>
<body>
   <%
      if(! logid.equals(dbid) || ! logpw.equals(dbpw)){
         out.println("<p align=\"center\">아이디나 비밀번호 중 일치하지 않습니다.</p>");
         out.println("<p align=\"center\"><a href=\"main.jsp\">다시 로그인하기</a></p>");
         
      }else{
         out.println("<p align=\"center\">로그인에 성공하셨습니다.</p>");
         out.println("<p align=\"center\"><a href=\"membership.jsp\">회원페이지로</a></p>");
         /* 세션에 로그인 아이디와 비번을 기억시키고 세션 정보로서 사용 */
         session.setAttribute("logid" ,logid);
         session.setAttribute("logpw" ,logpw);
      }
   %>
</body>
</html>