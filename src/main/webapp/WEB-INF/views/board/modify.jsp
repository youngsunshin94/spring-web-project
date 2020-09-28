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
    <link rel="stylesheet" href="/boardProject/resources/css/common.css">
    <link rel="stylesheet" href="/boardProject/resources/css/register1.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.1/css/all.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="/boardProject/resources/js/logout.js"></script>
</head>
<body>
    <div class="wrapper">
        <div class="header_wrapper">
            <div class="header">
                <div class="logo">
                    <a href="/boardProject/board/list">Yong`s board</a>
                </div>      
                <sec:authorize access="isAnonymous()">
					<div class="hd_link">
                    	<a href="/boardProject/customLogin"><i class="fas fa-sign-in-alt"></i> 로그인</a>
                	</div>                
                </sec:authorize>

				<sec:authorize access="isAuthenticated()">
					<div class="hd_link">
						<form action="/boardProject/customLogout" method="post" id="logoutForm">
							<input type='hidden' name="${_csrf.parameterName }" value="${_csrf.token }">
						</form>
                    	<a id="logoutTag"><i class="fas fa-sign-out-alt"></i> 로그아웃</a>
                	</div>
				</sec:authorize>	
            </div>
        </div>
        <div class="contents">
            <div class="ct_head">
                <h2>게시글 수정</h2>
            </div>
            <div class="ct_body">
                <form action="/boardProject/board/modify" method="post" id="form">
                	<input type='hidden' name="bno" value="${board.bno }">
                	<input type="hidden" name="pageNum" value="${cri.pageNum }">
					<input type="hidden" name="amount" value="${cri.amount }">
					<input type="hidden" name="type" value="${cri.type }">
					<input type="hidden" name="keyword" value="${cri.keyword }">
					<input type='hidden' name="${_csrf.parameterName }" value="${_csrf.token }">
					
                    <div class="form-group">
                        <input type="text" name="title" value="${board.title }" placeholder="Title" class="input_title" style="font-family: Georgia, 'Times New Roman', Times, serif;">
                    </div>
                    <div class="form-group">
                        <div contenteditable="true" placeholder="contents..." class="form_contents" spellcheck="false">${board.content }</div>
                        <textarea style="display:none;" name='content'></textarea>
                    </div>
                    <div class="form-group">
                        <input type="text" name="writer" value="${board.writer }">
                    </div>

                </form>
                <div class="uploadDiv">
                    <label>첨부파일</label><br>
                    <input type="file" name='uploadFile' multiple="multiple">
                    <div class="uploadResult">
                        <ul>
                        </ul>
                    </div>
                </div>
                
                <sec:authentication property="principal" var="pinfo"/>
                <sec:authorize access="isAuthenticated()">
                	<c:if test="${pinfo.username eq board.writer }">
                		<button class="btn" data-oper='modify'>수정</button>
                		<button class="btn" data-oper='remove'>삭제</button>                	
                	</c:if>
                </sec:authorize>

                <button class="btn" data-oper='list'>List</button>
            </div>

        </div>

    </div>
<script type="text/javascript">
$(document).ready(function(){
	
	$(".form_contents").html(unescape($(".form_contents").html()));
	
	$("button[data-oper='modify']").on("click", function(){
		var content = escape($(".form_contents").html());
		
		$("textarea[name='content']").val(content);
		
		var str = "";
		var fileCount = 0;
		
		$(".form_contents div img").each(function(){
			
			str += "<input type='hidden' name='attachList["+fileCount+"].fileName' value='"+$(this).data("filename")+"'>";
			str += "<input type='hidden' name='attachList["+fileCount+"].uuid' value='"+$(this).data("uuid")+"'>";
			str += "<input type='hidden' name='attachList["+fileCount+"].uploadPath' value='"+$(this).data("path")+"'>";
			str += "<input type='hidden' name='attachList["+fileCount+"].fileType' value='"+$(this).data("type")+"'>";
			str += "<input type='hidden' name='attachList["+fileCount+"].uploadUrl' value='"+$(this).data("url")+"'>";
			
			fileCount++;
		});

		$(".uploadResult ul li").each(function(){
			
			str += "<input type='hidden' name='attachList["+fileCount+"].fileName' value='"+$(this).data("filename")+"'>";
			str += "<input type='hidden' name='attachList["+fileCount+"].uuid' value='"+$(this).data("uuid")+"'>";
			str += "<input type='hidden' name='attachList["+fileCount+"].uploadPath' value='"+$(this).data("path")+"'>";
			str += "<input type='hidden' name='attachList["+fileCount+"].fileType' value='"+$(this).data("type")+"'>";
			str += "<input type='hidden' name='attachList["+fileCount+"].uploadUrl' value='"+$(this).data("url")+"'>";
			
			fileCount++;
		});
		
		$("#form").append(str);
		$("#form").submit();
	});
	
	$("button[data-oper='list']").on("click", function(){
		var pageNumTag = $("#form").find("input[name='pageNum']").clone();
		var amountTag = $("#form").find("input[name='amount']").clone();
		var typeTag = $("#form").find("input[name='type']").clone();
		var keywordTag = $("#form").find("input[name='keyword']").clone();
		
		$("#form").empty();
		$("#form").attr("action","/boardProject/board/list").attr("method","get");
		
		$("#form").append(pageNumTag);
		$("#form").append(amountTag);
		$("#form").append(keywordTag);
		$("#form").append(typeTag);
		$("#form").submit();
	});
	
	$("button[data-oper='remove']").on("click", function(){

		if(confirm("삭제하시겠습니까?")){
			$("#form").attr("action","/boardProject/board/remove");
			
			$("#form").submit();			
		}
	});	
	
	var bnoValue = '<c:out value="${board.bno}"/>';
	
	$.getJSON("/boardProject/board/getAttachList", {bno:bnoValue}, function(list){
		
		var str = "";
		
		for(var i=0; i<list.length; i++) {
			
			if(!list[i].fileType) {
				
				str += "<li data-path='"+list[i].uploadPath+"' data-uuid='"+list[i].uuid+"' data-filename='"+list[i].fileName+"' data-type='"+list[i].fileType+"'><i class='fas fa-file-alt'></i> "+list[i].fileName+" <span><i class='fas fa-trash'></i></span></li>"
			}
		}
		
		$(".uploadResult ul").append(str);
		
	});
	
	$(".uploadResult").on("click", "li span", function(){
		console.log("click span");
		var targetLi = $(this).closest("li");
		
		targetLi.remove();
		
	});
	
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";
	
	$("input[name='uploadFile']").change(function(){
		
		var formData = new FormData();
		var inputFile = $("input[name='uploadFile']");
		var files = inputFile[0].files;
		
		for(var i=0; i<files.length; i++) {
			
			if(!checkExtension(files[i].name, files[i].size)) {
				return false;
			}
			
			formData.append("uploadFile", files[i]);
		}
		
		$.ajax({
			url:'/boardProject/uploadAjaxAction',
			type:'post',
			contentType:false,
			processData:false,
			beforeSend:function(xhr) {
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			data:formData,
			dataType:'json',
			success:function(result) {
				showUploadResult(result);
			}
		});
		
	});
	
	var maxSize = 5242880;
	var regex = new RegExp("(.*?)\.(exe|sh|alz|zip)$");
	
	function checkExtension(fileName, fileSize) {
		if(regex.test(fileName)) {
			alert("해당종류의 파일을 업로드 할 수 없습니다.");
			return false;
		}
		
		if(maxSize < fileSize) {
			alert("파일 용량 초과");
			return false;
		}
		return true;
	}	
	
	function showUploadResult(uploadResultArr) {
		if(uploadResultArr == null || uploadResultArr.length == 0) {return;}
		
		$(uploadResultArr).each(function(i, obj){
			
			var str = "";
			
			if(obj.image) {
				str += "<div><img src='"+obj.uploadUrl+"' data-url='"+obj.uploadUrl+"' data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"' ></div>";
				
				$(".form_contents").append(str);
			} else {
				str += "<li data-url='"+obj.uploadUrl+"' data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'><i class='fas fa-file-alt'></i> "+obj.fileName+" <span><i class='fas fa-trash'></i></span></li>"
					
				$(".uploadResult ul").append(str);
			}
		});
	}
	
	
});
</script>
</body>
</html>