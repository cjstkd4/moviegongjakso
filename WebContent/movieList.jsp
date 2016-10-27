<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.StringTokenizer"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.LinkedHashMap"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="jspdb.DB"%>
<html>
<head>
<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.6.3/css/font-awesome.min.css">
</head>
<body>
	<div class="w3-half	 w3-white w3-large" style="height: auto">
		<form style="height: 500px;">
			<legend>이 달의 개봉예정 영화</legend>
			<fieldset
				style="height: 292px; overflow: auto; border-color: #00cc00;">
				<div class="w3-content" type="list/css">
					<%
						request.setCharacterEncoding("UTF-8");
						String y = request.getParameter("year");
						String m = request.getParameter("month");
						String logid = (String) session.getAttribute("logid");

						Calendar cal = Calendar.getInstance();
						int year = cal.get(Calendar.YEAR);
						int month = cal.get(Calendar.MONTH) + 1;
						String temp = "";

						if (y != null)
							year = Integer.parseInt(y);
						if (m != null)
							month = Integer.parseInt(m);

						cal.set(year, month - 1, 1);
						year = cal.get(Calendar.YEAR);
						month = cal.get(Calendar.MONTH) + 1;
						if (month < 10)
							temp = "0" + month;
						else
							temp = String.valueOf(month);

						int w = cal.get(Calendar.DAY_OF_WEEK);
						int endDays = cal.getActualMaximum(Calendar.DATE);

						DB db = new DB();

						ArrayList<String> nameList = new ArrayList<String>();
						ArrayList<String[]> fvl = db.getFvList(logid);
						for (int j = 0; j < fvl.size(); j++) {
							String[] b = fvl.get(j);
							nameList.add(b[0]);
						}
						
						ArrayList<String[]> list = db.getAllMovieByCondition("open like '" + year + "." + temp + "%'");
						int i = 1;
						for (String[] infos : list) {
							String id = infos[0];
							String name = infos[1];
							String genre = infos[2];
							String time = infos[3];
							String open = infos[4];
							String director = infos[5];
							String actors = infos[6];
							String thumbAddrs = infos[7];
					%>
					<label onclick="document.getElementById('<%=id%>').style.display='block'" style="width: auto;"><%=i%>. <%=name%> - <%=open%></label><br>

					<!-- 영화 정보창 -->
					<div id="<%=id%>" class="list">
						<div class="list-content animate">
							<div class="imgcontainer">
								<form name="isfv" method="get">
								<% if(logid != null){
							           if (!nameList.contains(name)) { %>
									   <button type="submit" class="fv" style="background-color:#1ab2ff" name="dofv" value="true&<%=id%>"><i class="fa fa-star-o" style="color:green"></i></button>
								<%     } else { %>
									   <button type="submit" class="fv" style="background-color:#1ab2ff" name="dofv" value="false&<%=id%>"><i class="material-icons" style="color:green">star</i></button>
								<%     }
								   } %>
								</form>
								<img src="<%=thumbAddrs%>"> 
								<span onclick="document.getElementById(<%=id%>).style.display='none'" class="close"> &times; </span>
							</div>
							<div class="container">
								<label><b>제목 : </b><%=name%></label><br>
								<label><b>장르 : </b><%=genre%></label><br>
								<label><b>시간 : </b><%=time%>분</label><br>
								<label><b>개봉 : </b><%=open%></label><br>
								<label><b>감독 : </b><%=director%></label><br>
								<label><b>배우 : </b><%=actors%></label>
							</div>
						</div>
					</div>
					<%
						i++;
					}
					%>
				</div>
			</fieldset>
		</form>
	</div>
</body>
</html>
