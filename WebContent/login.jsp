<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<meta charset="UTF-8">
<link rel="stylesheet" href="http://www.w3schools.com/lib/w3.css">
<link href="http://fonts.googleapis.com/css?family=Raleway"
	rel="stylesheet" type="text/css">
<style>
<!--table 형식 -->
table {
	border-collapse: collapse;	
	background-color : #B6D2C4;
}
a.login {
	font-size: 15px;
	padding: 30px;
	background-color: #1ab2ff;
	text-color: #ffffff;
	text-size:20px;
	font-weight: bold;
	weight: 300px;
}
</style>
<script>
function validateForm() {
	//id에 관한 유효성 검사
    var id = document.forms["join"]["memberid"].value;
    if (id == null || id == "") {
        alert("아이디를 입력하지 않있습니다.");
        return false;
    }else if(!(id>='0' && id<='9') && !(id>='a' && id<='z')){
        alert("아이디는 소문자, 숫자만 입력해주세요");
        return false;
   }else if(!(id.length>6)){
	   alert("아이디는 6글자 이상으로 입력해주세요.");
	   return false;
   }
  //pw에 관한 유효성 검사    
    var pw = document.forms["join"]["memberpw"].value;
    if (pw == null || pw == "") {
        alert("비밀번호를 입력하지 않았습니다.");
        return false;
    }else if(!(pw.length>6) || !(pw.length<16)){
	   alert("비밀번호 6글자 ~ 16글자 사이로 입력해주세요.");
	   return false;
   }
  //rpw에 관한 유효성 검사 
    var rpw = document.forms["join"]["rpwd"].value;
    if (rpw == null || rpw == "") {
        alert("비밀번호 확인을 입력하지 않았습니다.");
        return false;
    }else if(pw!=rpw){
    	alert("비밀번호와 비밀번호확인이 같지 않습니다.");
    	return false;
    }
  //이름에 관한 유효성 검사 
    var name = document.forms["join"]["memberName"].value;
    if (name == null || name == "") {
        alert("이름을 입력하지 않았습니다.");
        return false;
    }
    //nickname에 관한 유효성 검사 
    var nick = document.forms["join"]["nickname"].value;
    if (nick == null || nick == "") {
        alert("별명을 입력하지 않았습니다.");
        return false;
    }    
}
</script>
</head>
<body align="center">
	<form name="join" action="memberin.jsp" onsubmit="return validateForm()" method="post"> 
		<div class="w3-content" style="max-width:1500px">
			<header class="w3-container w3-xlarge w3-padding-24" aling="center">
		    	<a href="main.jsp" class="w3-left w3-btn w3-Orange login"  onclick=".style.display='block'">영화 공작소</a>
		  </header>
		<table align="center">	
			<tr>
				<th style="width: 120px; "> 아이디  </th>
				<th><input type="text" placeholder="아이디를 적어주세요" name="memberid" id="id"></th>
			</tr>
			<tr>
				<th style="width: 120px; "> 비밀번호 </th>
				<th><input type="password" placeholder="비밀번호를 적어주세요" name="memberpw" id="pwd"></th>
			</tr>
			<tr>
				<th style="width: 120px; "> 비밀번호 확인  </th>
				<th><input type="password" placeholder="비밀번호 확인을 적어주세요" name="rpwd" id="rpwd"></th>
			</tr>
			<tr>
				<th style="width: 120px; "> 이름  </th>
				<th><input type="text" placeholder="이름을 적어주세요" name="memberName" id="name"></th>
			</tr>
			<tr>
				<th style="width: 120px; "> 별명  </th>
				<th><input type="text" placeholder="별명을 적어주세요" name="nickname" id="nickname"></th>
			</tr>
		</table>
			<input type="submit" value="회원가입">
		</div>
	</form>
</body>
</html>
