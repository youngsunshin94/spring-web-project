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
    <title>Yong`s Board</title>
    <link rel="stylesheet" href="/resources/css/common.css">
    <link rel="stylesheet" href="/resources/css/register1.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.1/css/all.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
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
                <h2>게시글 작성</h2>
            </div>
            <div class="ct_body">
                <form action="/board/register" method="post" id="boardForm">
                	<input type='hidden' name="${_csrf.parameterName }" value="${_csrf.token }">
                    <div class="form-group">
                        <input type="text" placeholder="Title" name="title" class="input_title" style="font-family: Georgia, 'Times New Roman', Times, serif;">
                    </div>
                    <div class="form-group">
                        <div contenteditable="true" placeholder="contents..." class="form_contents" spellcheck="false" id="text_content"></div>
                        <textarea name='content' style="display:none;"></textarea>
                    </div>  
                    <div class="form-group">
                        <input type="text" name="writer" value="<sec:authentication property='principal.username'/>" readonly="readonly">
                    </div>

                </form>
                <div class="uploadDiv">
                    <label>첨부파일</label><br>
                    <input type="file" name="uploadFile" multiple="multiple">
                    <div class="uploadResult">
                        <ul>
                            
                        </ul>
                    </div>
                </div>
                <button class="btn" id="submitBtn">등록</button>
            </div>
            
        </div>

    </div>
    
<script type="text/javascript">
$(document).ready(function(){
	
	$("#submitBtn").click(function(){
		var content = escape($("#text_content").html());
		
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
		
		$("#boardForm").append(str);
		$("#boardForm").submit();
	});
	
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";
	
	$("input[type='file']").change(function(){
		
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
			url:"/uploadAjaxAction",
			type:'post',
			contentType:false,
			processData:false,
			beforeSend:function(xhr) {
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			data:formData,
			dataType:"json",
			success:function(result){
				showUploadFile(result);
			}
		});
		
	});
	
	var maxSize = 5242880;
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	
	function checkExtension(fileName, fileSize) {
		
		if(fileSize > maxSize) {
			alert("파일 용량 초과");
			return false;
		}
		
		if(regex.test(fileName)) {
			alert("해당 종류의 파일은 업로드 할 수 없습니다.");
			return false;
		}
		
		return true;
	}
	
	function showUploadFile(uploadResultArr) {
		
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
	
	/* $(".uploadResult").on("click", "span", function(){
		var targetLi = $(this).closest("li");
		var fileName = $(this).data('file');
		var type = $(this).data('type');
		
		$.ajax({
			url:'/deleteFile',
			type:'post',
			data:{fileName:fileName, type:type},
			dataType:'text',
			beforeSend:function(xhr) {
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			success:function(result){
				alert(result);
				targetLi.remove();
			}
		});
		
	}); */
	
	$(".uploadResult").on("click", "span", function(){
		var targetLi = $(this).closest("li");
		var fileName = targetLi.data('path') + "/" + targetLi.data('uuid') + "_" + targetLi.data('filename');
		
		$.ajax({
			url:'/deleteFiles',
			type:'post',
			data:{fileName:fileName},
			dataType:'text',
			beforeSend:function(xhr) {
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			success:function(result){
				alert(result);
				targetLi.remove();
			}
		});
		
	});
	
});
</script>

</body>
</html>