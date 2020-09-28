<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/boardProject/resources/css/login.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <title>Yong`s Board</title>
</head>
<body>
    
    <div class="wrapper">

        <div class="logo">
            <a href="/boardProject/board/list">Yong`s Board</a>
        </div>

        <form action="/boardProject/login" method="post" id="loginForm">
            <div>
                <input type="text" name="username" placeholder="아이디" id="input_text">
            </div>
            <div>
                <input type="password" name="password" placeholder="비밀번호" id="input_text">
            </div>
            <div>
                <input type="checkbox" name="remember-me" id="checkbox"> 로그인 상태 유지
            </div>
            <input type='hidden' name="${_csrf.parameterName }" value="${_csrf.token }"/>
            <button id="loginBtn">로그인</button><br>
            
        </form>
        <button id="signUpBtn">회원가입</button>
    </div>
<script type="text/javascript">
	$("#loginBtn").on('click', function(e){
		e.preventDefault();
		
		$("#loginForm").submit();
	});
	
	$("#signUpBtn").on("click", function(){
		self.location = "/boardProject/signUp";
	});
</script>
</body>
</html>