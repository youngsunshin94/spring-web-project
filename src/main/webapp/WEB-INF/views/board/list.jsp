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
    <link rel="stylesheet" href="/resources/css/feedList.css">
    <link rel="stylesheet" href="/resources/css/common.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.1/css/all.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="/resources/js/logout.js"></script>
</head>
<body>
    <div class="wrapper">
        <div class=header_wrapper>
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
                <h2>전체 게시글</h2>
                <a id="regBtn"><i class="fas fa-pen"></i> 글쓰기</a>
            </div>
            <div class="ct_body">
                <ul>
                	<c:forEach items="${list }" var="board">
                		<li data-bno="${board.bno }">
                			<div class="conts">
                				<div class="conts_text">
                					<h2>${board.title }</h2>
                					<p>${board.content }</p>
                					<div id="contsFooter">
                						<span>${board.writer }</span><span>조회수 ${board.hit }</span>
                						<span><fmt:formatDate value="${board.regdate }" pattern="yyyy-MM-dd"/></span><span><i class="fas fa-comment-dots"></i> ${board.replyCnt }</span>
                						<!-- <span><i class="fas fa-file-alt"></i></span> -->
                					</div>
                				</div>
                				<div class="thumbnail"></div>
                			</div>
                		</li>
                	</c:forEach>
                </ul>

            </div>
            <form action="/board/list" method="get" id="actionForm">
            	<input type='hidden' name='pageNum' value="${pageMaker.cri.pageNum }">
            	<input type='hidden' name='amount' value="${pageMaker.cri.amount }">
            	<input type='hidden' name='type' value="${pageMaker.cri.type }">
            	<input type='hidden' name='keyword' value="${pageMaker.cri.keyword }">
            </form>
            
            <div class="ct_footer">
                <div class="search-box">
                    <form action="/board/list" method="get" id="searchForm">
                        <select name="type">
                            <option value="" ${pageMaker.cri.type == '' ? 'selected' : '' }>--</option>
                            <option value="T" ${pageMaker.cri.type eq 'T' ? 'selected' : '' }>제목</option>
                            <option value="C" ${pageMaker.cri.type eq 'C' ? 'selected' : '' }>내용</option>
                            <option value="W" ${pageMaker.cri.type eq 'W' ? 'selected' : '' }>작성자</option>
                            <option value="TCW" ${pageMaker.cri.type eq 'TCW' ? 'selected' : '' }>제목+내용+작성자</option>
                        </select>
                        <input type="text" name="keyword" value="${pageMaker.cri.keyword }">
                        <input type='hidden' name='pageNum' value="${pageMaker.cri.pageNum }">
            			<input type='hidden' name='amount' value="${pageMaker.cri.amount }">
                        <button id="btn-search">검색</button>
                    </form>
                </div>
                <div class="paging">
                    <ul class="paginate">
                    	<c:forEach begin="${pageMaker.startPage }" end="${pageMaker.endPage }" var="num">
                    		<li class="${pageMaker.cri.pageNum == num ? 'active' : ''}">
                    			<a href="${num }">${num }</a>
                    		</li>
                    	</c:forEach>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    
<script type="text/javascript">
$(document).ready(function(){
	
	$(".conts_text p").each(function(i, content){		
		var content = unescape($(this).html());
		var img_tag = /<img(.*?)>/gi;
		content = content.replace(img_tag, "");
		
		$(this).html(content);
	});
	
	$("#regBtn").on("click", function(e){
		e.preventDefault();
		
		self.location = "/board/register";
	});
	
	var actionForm = $("#actionForm");
	
	$(".ct_body").on('click', "li", function(){
		actionForm.append("<input type='hidden' name='bno' value='"+$(this).data('bno')+"'>");
		actionForm.attr("action","/board/get").submit();
	});
	
	$(".paginate li a").on("click", function(e){
		e.preventDefault();
		
		actionForm.find("input[name='pageNum']").val($(this).attr("href"));
		actionForm.submit();
	});
	
	var searchForm = $("#searchForm");
	
	$("#btn-search").on("click", function(){
		searchForm.find("input[name='pageNum']").val("1");
		
		searchForm.submit();
	});
	
	$(".ct_body ul li").each(function(i, obj){
		
		var bnoValue = $(this).data("bno");
		var thumbnail = $(this).find(".thumbnail");
		var contsFooter = $(this).find("#contsFooter");
		
		$.getJSON("/board/getAttachList",{bno:bnoValue}, function(list){
			
			var str = "";
			var strF = "";
			
			for(var i=0;i<list.length;i++){
				
				if(list[i].fileType && str.length == 0) {

					str += "<img src='"+list[i].uploadUrl+"'>";
					
					thumbnail.append(str);
					
				} else if(!list[i].fileType && strF.length == 0) {
					strF += "<span><i class='fas fa-file-alt'></i></span>";
					contsFooter.append(strF);
				}
			}
			
		});
	
	});
		
});
</script>

</body>
</html>