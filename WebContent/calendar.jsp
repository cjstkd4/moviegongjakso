<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="java.util.StringTokenizer"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.LinkedHashMap"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="jspdb.DB"%>

<%
	request.setCharacterEncoding("UTF-8");

	String y = request.getParameter("year");
	String m = request.getParameter("month");
	
	Calendar cal = Calendar.getInstance();
	int year = cal.get(Calendar.YEAR);
	int month = cal.get(Calendar.MONTH) + 1;
	String temp = "";

	if (y != null)
		year = Integer.parseInt(y);
	if (m != null)
		month = Integer.parseInt(m);
	if (month < 10)
		temp = "0"+month;
	else temp = String.valueOf(month);

	cal.set(year, month - 1, 1);
	year = cal.get(Calendar.YEAR);
	month = cal.get(Calendar.MONTH) + 1;

	// 1일은 무슨 요일.
	int w = cal.get(Calendar.DAY_OF_WEEK);

	// 달의 마지막 날짜.
	int endDays = cal.getActualMaximum(Calendar.DATE);

	DB db = new DB();
	int[] count = new int[33];
	ArrayList<LinkedHashMap<String, String>> oper = db.getMovie("name", "open", "open LIKE '"+year+"."+temp+"%'");
	for(LinkedHashMap<String, String> lhm : oper){
		Set<String> set = lhm.keySet();
		Iterator<String> it = set.iterator();
		while(it.hasNext()){
			String key = it.next();
			String value = lhm.get(key);
			StringTokenizer st = new StringTokenizer(value, ".");
			int num = st.countTokens();
			if(num == 3) {
				for(int i = 0; i < num - 1; i++)
					st.nextToken();
				String str = st.nextToken();
				count[Integer.valueOf(str)]++;
			}
		}
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<style>
	table{
	   box-shadow: 0 4px 8px 0 rgba(0,0,0,0.3),0 6px 20px 0 rgba(0,0,0,0.19);
	}
</style>
</head>
<body>
	<table width="600" cellpadding="0" cellspacing="1" bgcolor="#cccccc">
		<caption style="height: 25px">
			<a href="main.jsp?year=<%=year%>&month=<%=month-1%>" style="text-decoration:none"> ◀ </a>
			<%=year %>년 <%=month %>월
			<a href="main.jsp?year=<%=year%>&month=<%=month+1%>" style="text-decoration:none"> ▶ </a>
			<a href="main.jsp"style="text-decoration:none"> Today </a>
		</caption>
		<tr height="40" bgcolor="#e4e4e4">
			<td width="40" align="center">일</td>
			<td width="40" align="center">월</td>
			<td width="40" align="center">화</td>
			<td width="40" align="center">수</td>
			<td width="40" align="center">목</td>
			<td width="40" align="center">금</td>
			<td width="40" align="center">토</td>
		</tr>
		<%
			int line = 0;
			//앞의 공백처리
			out.print("<tr bgcolor='#ffffff' height='40'>");
			for (int i = 1; i < w; i++) {
				out.print("<td> </td>");
				line += 1;
			}
	
			//날짜출력
			String fc;					
			for (int i = 1; i <= endDays; i++) {
				fc = line == 0 ? "red" : (line == 6 ? "blue" : "black");
				out.print("<td align='right' valign='top' style='color:" + fc + ";'>");
				out.print(i + "<br>");
				out.print("<br>");
				out.print("<b style='color:black'>"+count[i]+"개</b>");
				out.print("</td>");
				line += 1;
				if (line == 7 && i != endDays) {
					out.print("</tr><tr height='40' bgcolor='#ffffff'>");
					line = 0;
				}
			}
			
			//뒷부분 공백 처리
			while (line > 0 && line < 7) {
				out.print("<td> </td>");
				line++;
			}
			out.print("</tr>");
		%>
	</table>
</body>
</html>