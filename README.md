<h1>Yong`s Board</h1>
<p>Yong`s Board는 Spring을 사용해서 개발한 게시판입니다. 게시판, 댓글, 파일 업로드, 로그인 기능이 있습니다.<br>
그리고 AWS로 배포를 하였습니다.</p>
<br>
<a href="http://15.164.150.244:8080/boardProject/board/list">게시판 이동</a>
<br>
<h1>개발 환경</h1>
<ul>
<li>Eclipse</li>
<li>Java 8</li>
<li>Srping framework</li>
<li>Mysql</li>
<li>Tomcat 9</li>
<li>Mybatis</li>
</ul>
<h1>Skill</h1>
<ul>
<li>Java</li>
<li>Javascript</li>
<li>HTML</li>
<li>CSS</li>
<li>JQuery</li>
<li>Ajax</li>
<li>Mysql</li>
</ul>
<h1>AWS</h1>
<ul>
<li>EC2</li>
<li>RDS</li>
<li>S3</li>
</ul>

<h1>Spring Project</h1><br>
<h2>게시판</h2>
<p>게시판은 기본적으로 모델2 방식으로 개발하였습니다. GET/POST를 이용하여 CURD를 구현했고 <br>mybatis를 이용해서 데이터를 처리하였습니다.
또한 페이징처리와 검색 처리 기능이 있습니다.</p>
<br>
<h2>댓글</h2>
<p>댓글은 Rest방식을 사용했고 Ajax의 호출로 댓글 기능을 구현했습니다. 데이터베이스 상에서 댓글은<br>전형적인 1:N의 관계로 구성했습니다.
하나의 게시물에 여러 개의 댓글을 추가하는 형태로 구성하고,<br>화면은 조회 화면상에서 별도의 화면 이동 없이 처리하기 때문에 Ajax를 이용해서 구현했습니다.
그리고<br>트랜잭션을 이용해서 게시물의 전체 댓글 수를 처리했습니다.
</p>
<br>
<h2>파일 업로드</h2>
<p>파일 업로드는 Ajax를 이용해서 별도로 처리했습니다. 파일 등록, 삭제, 수정, 보기를 구현했고<br>Aws S3와 연동하여 파일 처리를 하였습니다.
또한 Quartz라이브러리를 이용해서 스케줄러를<br>구성해서 잘못 업로된 파일을 정리하는 기능을 구현했습니다.
</p>
<br>
<h2>로그인</h2>
<p>로그인은 스프링 시큐리티를 이용해서 구현했습니다. 스프링 시큐리티를 이용해서 글쓰기,<br> 글 수정, 댓글 작성 등 로그인 권한이 있어야 할 수 있게 구현했고
UserDetailsService를 구현해서<br>회원 정보를 이용했습니다.
</p>

<br>
<br>
