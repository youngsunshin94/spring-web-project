<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/resources/css/login.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <title>Yong`s Board</title>
</head>
<body>
    
    <div class="wrapper">

        <div class="logo">
            <a href="/board/list">Yong`s Board</a>
        </div>

        <form action="/member/join" method="post" id="memberForm">
        	<input type='hidden' name='${_csrf.parameterName }' value="${_csrf.token }">
            <div>
                <input type="text" name="userid" placeholder="아이디" id="input_text">
                <p id="idInfo"></p>
            </div>
            <div>
                <input type="password" name="userpw" placeholder="비밀번호" id="input_text">
                <p id="pwInfo"></p>
            </div>
            <div>
                <input type="password" name="userpwConfirm" placeholder="비밀번호 확인" id="input_text">
            </div>
            <div>
                <input type="text" name="userName" placeholder="이름" id="input_text">
                <p id="nameInfo"></p>
            </div>
            <button id="signUpBtn">회원가입</button>
        </form>

    </div>
    
<script type="text/javascript">
$(document).ready(function(){
	
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";
	
	$(document).ajaxSend(function(e, xhr, options){
		xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	});
	
	var userIdCheck = RegExp(/^[A-Za-z0-9_\-]{5,20}$/);
	var passwdCheck = RegExp(/^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^*()\-_=+\\\|\[\]{};:\'",.<>\/?]).{8,16}$/);
	var nameCheck = RegExp(/^[가-힣]{2,6}$/);
	
	var userPass = false;
	var pwPass = false;
	var pwConfirmPass = false;
	var namePass = false;
	
	$("input[name='userid']").focusout(function(){
		
		var userid = $(this).val();
		
		if(userIdCheck.test(userid)) {
			$.ajax({
				url:"checkId",
				type:'post',
				data:{userid:userid},
				dataType:"json",
				success:function(result){
			
					if(result == 1) {			
						$("#idInfo").css("color", "red");
						$("#idInfo").html("이미 사용 중인 아이디입니다.");
						userPass = false;
					} else {
						$("#idInfo").css("color", "#4279ff");
						$("#idInfo").html("사용 가능한 아이디입니다.");
						userPass = true;						
					}
				}
				
			});
		} else {
			$("#idInfo").css("color", "red")
			$("#idInfo").html("5~20자의 영문 소문자, 숫자와 특수기호(_),(-)만 사용 가능합니다.");
			userPass = false;
		}
		
	});
	
	$("input[name='userpw']").focusout(function(){
		
		if(passwdCheck.test($("input[name='userpw']").val())){
			$("#pwInfo").css("color", "#4279ff")
			$("#pwInfo").html("사용 가능한 비밀번호입니다.");
			pwPass = true;
		} else {
			$("#pwInfo").css("color", "red")
			$("#pwInfo").html("8~16자 영문 대 소문자, 숫자, 특수문자를 사용하세요.");
			pwPass = false;
		}
	});
	
	$("input[name='userpwConfirm']").focusout(function(){
		
		if(passwdCheck.test($("input[name='userpwConfirm']").val())){
			
			if($("input[name='userpwConfirm']").val() == $("input[name='userpw']").val()) {
				$("#pwInfo").css("color", "#4279ff")
				$("#pwInfo").html("사용 가능한 비밀번호입니다.");
				pwConfirmPass = true;
				
			} else {
				$("#pwInfo").css("color", "red")
				$("#pwInfo").html("비밀번호가 일치하지 않습니다.");
				pwConfirmPass = false;
			}	
		} else {
			$("#pwInfo").css("color", "red")
			$("#pwInfo").html("8~16자 영문 대 소문자, 숫자, 특수문자를 사용하세요.");
			pwConfirmPass = false;
		}
				
	});
	
	$("input[name='userName']").focusout(function(){
		
		if(nameCheck.test($("input[name='userName']").val())){
			$("#nameInfo").html("");
			namePass = true;
		} else {
			$("#nameInfo").css("color", "red")
			$("#nameInfo").html("이름을 입력해주세요.");
			namePass = false;
		}
		
	});
	
	$("#signUpBtn").on("click", function(){
		
		if(userPass && pwPass && pwConfirmPass && namePass) {
			$("#memberForm").submit();
		} else {
			return false;
		}
		
	});
	
	
	
});
</script>

</body>
</html>