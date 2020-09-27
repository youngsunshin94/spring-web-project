<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Yong`s Board</title>
<link rel="stylesheet" href="/resources/css/common.css">
<link rel="stylesheet" href="/resources/css/get1.css">
<link rel="stylesheet" href="/resources/css/modal.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.1/css/all.min.css">
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script src="/resources/js/logout.js"></script>
</head>
<body>
	<div class="wrapper">
		<div class="header_wrapper">
			<div class="header">
				<div class="logo">
					<a href="/board/list">Yong`s board</a>
				</div>
				<sec:authorize access="isAnonymous()">
					<div class="hd_link">
                    	<a href="/customLogin"><i class="fas fa-sign-in-alt"></i> 로그인</a>
                	</div>                
                </sec:authorize>

				<sec:authorize access="isAuthenticated()">
					<div class="hd_link">
						<form action="/customLogout" method="post" id="logoutForm">
							<input type='hidden' name="${_csrf.parameterName }" value="${_csrf.token }">
						</form>
                    	<a id="logoutTag"><i class="fas fa-sign-out-alt"></i> 로그아웃</a>
                	</div>
				</sec:authorize>	
			</div>
		</div>
		<div class="contents">
			<div class="ct_head">
				<h2>게시물</h2>
			</div>
			<div class="ct_body">
				<div class="form-group">
					<input type="text" name="title" value="${board.title }" placeholder="Title" class="input_title"
						style="font-family: Georgia, 'Times New Roman', Times, serif;" readonly="readonly">
				</div>
				<div class="form-group">
					<div contenteditable="false" placeholder="contents..."
						class="form_contents" spellcheck="false">${board.content }</div>
				</div>
				<div class="form-group">
					<input type="text" name="writer" value="${board.writer }" readonly="readonly">
				</div>

				<div class="uploadDiv">
					<label>첨부파일</label><br>
					<div class="uploadResult">
						<ul>
						</ul>
					</div>
				</div>
				<button class="btn" data-oper="list">List</button>
				
				<sec:authentication property="principal" var="pinfo"/>
				<sec:authorize access="isAuthenticated()">
					<c:if test="${pinfo.username eq board.writer }">
						<button class="btn" data-oper="modify">수정</button>
					</c:if>
				</sec:authorize>
			</div>
			<form action="/board/modify" method="get" id="formObj">
				<input type="hidden" name="bno" value="${board.bno }" id="bno">
				<input type="hidden" name="pageNum" value="${cri.pageNum }">
				<input type="hidden" name="amount" value="${cri.amount }">
				<input type="hidden" name="type" value="${cri.type }">
				<input type="hidden" name="keyword" value="${cri.keyword }">
			</form>
			
			<div class="reply">
				<div class="reply_header">
					<p>
						<i class="fas fa-comment-dots"></i> 댓글
						<sec:authorize access="isAuthenticated()">
							<button id="addReplyBtn">댓글 쓰기</button>
						</sec:authorize>
					</p>
				</div>
				<div class="reply-body">
					<ul class="chat">
						
					</ul>
				</div>
				<div class="reply-footer">
					<div class="paging">
						<ul class="paginate">
							
						</ul>
					</div>
				</div>
			</div>

		</div>

	</div>
	<div class="modal">
        <div class="modal-dialog">
            <div class="modal-header">
                <h3>댓글 등록</h3>
            </div>
            <div class="modal-body">
                <input type="text" name="reply" placeholder="댓글"><br>
                <input type="text" name="replyer" readonly="readonly">
            </div>
            <div class="modal-footer">
                <button class="modalRegisterBtn">등록</button>
                <button class="modalModBtn">수정</button>
                <button class="modalRemoveBtn">삭제</button>
                <button class="modalCloseBtn">취소</button>
            </div>
        </div>
       
        <div class="modal-layer">

        </div>
    </div>
    
<script type="text/javascript">
$(document).ready(function(){
	
	var bnoValue = '<c:out value="${board.bno}"/>';
	
	$.getJSON("/board/getAttachList", {bno:bnoValue}, function(list){
		
		var str = "";
		
		for(var i=0; i<list.length; i++) {
			
			if(!list[i].fileType) {
				var fileCallPath = encodeURIComponent(list[i].uploadPath + "/" + list[i].uuid + "_" + list[i].fileName);
				
				str += "<li><a href='/download?fileName="+fileCallPath+"'><i class='fas fa-file-alt'></i> "+list[i].fileName+"</a></li>"
			}
		}
		
		$(".uploadResult ul").append(str);
		
	});
	
});
</script>
	
<script src="/resources/js/reply.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	var bnoValue = '<c:out value="${board.bno}"/>';
	var replyUL = $(".chat");
	
	showList(1);
	
	function showList(page) {
		
		replyService.getList({bno:bnoValue, page:page||1}, function(list, replyCnt){
			
			if(page == -1) {
				pageNum = Math.ceil(replyCnt / 10.0);
				showList(pageNum);
				return;
			}
			
			var str = "";
			if(list == null || list.length == 0) {
				replyUL.html("");
				return;
			}
			
			for(var i=0;i<list.length; i++) {
				str += "<li data-rno='"+list[i].rno+"'>";
				str += "<p><strong>"+list[i].replyer+"</strong><span>"+replyService.displayTime(list[i].replyDate)+"</span></p>";
				str += "<div>"+list[i].reply+"</div></li>";
			}
			
			replyUL.html(str);
			showReplyPage(replyCnt);
		});
	}
	
	var modal = $(".modal");
	var modalInputReply = modal.find("input[name='reply']");
	var modalInputReplyer = modal.find("input[name='replyer']");
	
	var modalRegisterBtn = $(".modalRegisterBtn");
	var modalModBtn = $(".modalModBtn");
	var modalRemoveBtn = $(".modalRemoveBtn");
	var modalCloseBtn = $(".modalCloseBtn");
	
	var replyer = null;
	
	<sec:authorize access="isAuthenticated()">
		replyer = '<sec:authentication property="principal.username"/>';
	</sec:authorize>
	
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";
	
	$("#addReplyBtn").on("click", function(){
		
		modal.find("input").val("");
		modal.find("input[name='replyer']").val(replyer);
		modal.find("button[class !='modalCloseBtn']").hide();
		modalRegisterBtn.show();
		
		modal.show();
	});
	
	$(document).ajaxSend(function(e, xhr, options){
		xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	});
	
	modalRegisterBtn.on("click", function(){
		var reply = {bno:bnoValue, reply:modalInputReply.val(),
				replyer:modalInputReplyer.val()};
		
		replyService.add(reply, function(result){
			alert(result);
			modal.find("input").val("");
			modal.hide();
			showList(-1);
		});
	});
	
	modalCloseBtn.on("click",function(){
		modal.hide();
	});
	
	replyUL.on("click", "li", function(){
		
		var rno = $(this).data('rno');
		
		replyService.get(rno, function(result){
			modalInputReply.val(result.reply);
			modalInputReplyer.val(result.replyer);
			
			if(replyer != modalInputReplyer.val()) {
				return false;
			}
			modal.data('rno', rno);
			
			modal.find("button[class != modalCloseBtn]").hide();
			modalModBtn.show();
			modalRemoveBtn.show();
			modal.show();
		});
		
	});
	
	modalModBtn.on("click", function(){
		var reply = {reply:modalInputReply.val(),
				rno:modal.data('rno'),
				replyer:modalInputReplyer.val()};
		
		replyService.update(reply, function(result){
			alert(result);
			modal.find('input').val("");
			modal.hide();
			showList(pageNum);
		});
	});
	
	modalRemoveBtn.on('click', function(){
		
		var rno = modal.data('rno');
		var originalReplyer = modalInputReplyer.val();
		
		if(confirm("삭제하시겠습니까?")) {
			
			replyService.remove(rno, originalReplyer, function(result){
			
				alert(result);
				showList(pageNum);
				modal.hide();
			});
		}
	});
	
	var pageNum = 1;
	
	function showReplyPage(replyCnt) {
		
		var endNum = Math.ceil(pageNum / 10.0) * 10;
		var startNum = endNum -9;
		
		var prev = startNum != 1;
		var next = false;
		
		if(endNum * 10 > replyCnt) {
			endNum = Math.ceil(replyCnt / 10.0);
		}
		
		if(endNum * 10 < replyCnt) {
			next = true;
		}
		
		var str = "";
		
		if(prev) {
			str += "<li><a href='"+(startNum-1)+"'>prev</a></li>";
		}
		
		for(var i=startNum; i<=endNum; i++) {
			var active = pageNum == i ? 'active' : '';
			
			str += "<li class='"+active+"'><a href='"+i+"'>"+i+"</a></li>";
		}
		
		if(next) {
			str += "<li><a href='"+(endNum+1)+"'>next</a></li>";
		}
			
		$(".paginate").html(str);
		
	}
	
	$(".paginate").on("click", "li a", function(e){
		e.preventDefault();
		
		pageNum = $(this).attr("href");
		showList(pageNum);
	});
	
});
</script>
<script type="text/javascript">
$(document).ready(function() {

	$(".form_contents").html(unescape($(".form_contents").html()));
	
	var formObj = $("#formObj");
	
	$("button[data-oper='list']").on("click", function(){
		formObj.attr("action", "/board/list");
		formObj.find($("#bno")).remove();
		formObj.submit();
	});
	
	var writer = null;
	
	
	$("button[data-oper='modify']").on("click", function(e){
		e.preventDefault();
		formObj.append("<input type='hidden' name='writer' value='${board.writer}' />");
		formObj.submit();
	});
	
});
</script>
</body>
</html>