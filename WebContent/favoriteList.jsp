<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.StringTokenizer"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.sql.*"%>
<%@ page import="jspdb.DB"%>
<html>
<body>
	<div class="w3-half w3-large w3-white" style="height: auto">
		<form style="height: 500px;">
			<legend>즐겨찾기</legend>
			<fieldset
				style="height: 292px; overflow: auto; border-color: #00cc00;">
				<div class="w3-content" type="list/css">
					<%
						request.setCharacterEncoding("UTF-8");
						if (session.getAttribute("logid") == null && session.getAttribute("logpw") == null) {
					%>
					<label>로그인이 필요합니다.</label>
					<%
						} else {
							DB db = new DB();
							String logid = (String) session.getAttribute("logid");
							String fv = request.getParameter("dofv");
							String doAdd = null;
							int getMovieId = 0;
							if(fv != null){
								StringTokenizer mv = new StringTokenizer(fv, "&");
								while(mv.hasMoreTokens()){
									doAdd = mv.nextToken().trim();
									getMovieId = Integer.parseInt(mv.nextToken().trim());
								}
								if(doAdd.equals("true")){
									db.putFv(logid, getMovieId);
								}
								else {
									db.rmFv(logid, getMovieId);
								}
								db.commit();
							}							
							
							Calendar cal = Calendar.getInstance();
							int now = cal.get(Calendar.DAY_OF_YEAR);
							long nowMill = cal.getTimeInMillis();
							
							ArrayList<String[]> fvl = null;
							fvl = db.getFvList(logid);
							for (int i = 0; i < fvl.size(); i++) {
								String[] info = fvl.get(i);
								String name = info[0];
								String open = info[1];
								StringTokenizer stz = new StringTokenizer(open, ".");
								int ty = 0, tm = 0, td = 0, goalday = 0, dd = 0;
								if (stz.countTokens() > 2) {
									long d;
									while (stz.hasMoreTokens()) {
										ty = Integer.valueOf(stz.nextToken().trim());
										tm = Integer.valueOf(stz.nextToken().trim());
										td = Integer.valueOf(stz.nextToken().trim());
										cal.set(ty, tm - 1, td);
										long ddayMill = cal.getTimeInMillis();
										long d_n = ddayMill-nowMill;
										dd = (int)(d_n / (1000 * 60 * 60 * 24));
									}
								%>
								<label><%=i + 1%>. <%=name%> <%=tm%>.<%=td%> [D-<%=dd%>]</label> <br>
								<%
								} else {
									while (stz.hasMoreTokens()) {
										ty = Integer.valueOf(stz.nextToken().trim());
										tm = Integer.valueOf(stz.nextToken().trim());
									}
									%>
									<label><%=i + 1%>. <%=name%> <%=ty%>.<%=tm%></label> <br>
									<%
								}
							}
						}
					%>
				</div>
			</fieldset>
		</form>
	</div>
</body>
</html>
