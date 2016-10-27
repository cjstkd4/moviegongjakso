<%@ page  contentType="text/html;charset=UTF-8" import="java.sql.DriverManager, java.sql.*" %>
<%@ page import="jspdb.DB"%>
<%
	response.setContentType("text/html;charset=UTF-8;");
	request.setCharacterEncoding("UTF-8");     //charset, Encoding 설정
	  
	String fmemberName = request.getParameter("fmemberName");
	String fnickname = request.getParameter("fnickname");
	
	DB db = new DB();
	String dbid = "";
	String dbname = "";
	String dbnick = "";
	
	try {
	    String[] info = db.findMemberID(fmemberName, fnickname);
	    dbid = info[0];
	    dbname = info[1];
	    dbnick = info[2];
	}
	catch (Exception e) {
	      out.println("err:" + e.toString());
	} 
%>
<div class="w3-half w3-contaner w3-large w3-white" style="height: 900px">
	<form style="height: 300px;">
		<fieldset style="height: 208px; border-color: #00cc00; width: 499px">
		<legend> 아이디 결과 </legend>
			<form></form>
			<form action="main.jsp" method="post">
				<%
	    		if(! fmemberName.equals(dbname) || ! fnickname.equals(dbnick)){
				%>
					<h3> 이름이나 별명중 하나가 틀렸습니다. </h3> <br>
				<%
				} else if((fmemberName.equals(dbname)) && (fnickname.equals(dbnick))){
				%>
					<h3> ◀ <%= fmemberName%> ▶ 님의 아이디는  ◀ <%= dbid %> ▶ 입니다. </h3> <br>
				<%
				}
				%>
				<button type="submit">확인</button>
			</form>
		</fieldset>
	</form>
</div>