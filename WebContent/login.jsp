<%@ page  contentType="text/html;charset=euc-kr" import="java.sql.DriverManager, java.sql.*" %>
<%@ page import="jspdb.DB"%>
<%
   response.setContentType("text/html;charset=EUC-KR;");
   request.setCharacterEncoding("EUC-KR");     //charset, Encoding ����
   
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
         out.println("<p align=\"center\">���̵� ��й�ȣ �� ��ġ���� �ʽ��ϴ�.</p>");
         out.println("<p align=\"center\"><a href=\"main.jsp\">�ٽ� �α����ϱ�</a></p>");
         
      }else{
         out.println("<p align=\"center\">�α��ο� �����ϼ̽��ϴ�.</p>");
         out.println("<p align=\"center\"><a href=\"membership.jsp\">ȸ����������</a></p>");
         /* ���ǿ� �α��� ���̵�� ����� ����Ű�� ���� �����μ� ��� */
         session.setAttribute("logid" ,logid);
         session.setAttribute("logpw" ,logpw);
      }
   %>
</body>
</html>