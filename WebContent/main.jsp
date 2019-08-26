<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar"%>
<%
	String y = request.getParameter("year");
	String m = request.getParameter("month");

	String m = request.getParameter("month");
	String m = request.getParameter("month");
	String m = request.getParameter("month");
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
		temp = "0" + month;
	else
		temp = String.valueOf(month);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1">
	<link href="http://fonts.googleapis.com/css?family=Raleway" rel="stylesheet">
	<link rel="stylesheet" href="http://www.w3schools.com/lib/w3.css">
	<link rel='stylesheet' type='text/css' href='login.css' />
	<link rel='stylesheet' type='text/css' href='list.css' />
	<script>
		var modal = document.getElementById('id01');
		window.onclick = function(event) {
			if (event.target == modal) {
				modal.style.display = "none";
			}
		}
	</script>
</head>
<body>
	<div class="bg">
		<div class="w3-content" style="max-width: 80%">
			<!-- 상단 버튼 -->
			<header class="w3-container w3-xlarge w3-padding-24"> 
				<a class="w3-left w3-btn login" onclick="style.display='block'">영화 공작소</a> 
				<%
			 	if (session.getAttribute("logid") == null) {
			 	%> 
				<a class="w3-right w3-btn login" onclick="document.getElementById('id01').style.display='block'">로그인</a>
				<%
				}
				if (session.getAttribute("logid") != null) {
				%> 
				<a class="w3-right w3-btn login" href="logout.jsp">로그아웃</a> 
				<%
			 	}
				%>
			</header>
			<div id="id01" class="modal" type="login/css">
				<form class="modal-content animate" action="login.jsp" accept-charset="UTF-8">
					<div class="container">
						<label><b>아이디</b></label>
						<input type="text" placeholder="아이디를 입력하세요." name="logid" required>
						<label><b>비밀번호</b></label>
						<input type="password" placeholder="비밀번호를 입력하세요." name="logpw" required>
						<button type="submit" style="">로그인</button>
					</div>
					<div class="container" style="background-color: #f1f1f1">
						<button type="button" onclick="document.getElementById('id01').style.display='none'" class="cancelbtn">취소</button>
						<span class="psw"><a href="find.html" class="link">회원 찾기</a></span>
						<span class="psw"><a href="join.html" class="link">회원가입</a></span>
					</div>
				</form>
			</div>

			<!-- 달력 기능 -->
			<center>
				<jsp:include page="calendar.jsp" flush="false">
					<jsp:param name="year" value="<%=year%>" />
					<jsp:param name="month" value="<%=month%>" />
				</jsp:include>
			</center>

			<!-- 영화 리스트, 즐겨찾기 리스트 -->
			<div class="w3-row w3-section">
				<jsp:include page="movieList.jsp" />
				<jsp:include page="favoriteList.jsp" />
			</div>
		</div>
	</div>
</body>
</html>
