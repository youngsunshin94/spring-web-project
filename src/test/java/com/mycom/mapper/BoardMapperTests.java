package com.mycom.mapper;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.mycom.domain.Criteria;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@Log4j
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class BoardMapperTests {

	@Autowired
	private BoardMapper mapper;
	
//	@Test
//	public void insert() {
//		BoardVO board = new BoardVO();
//		board.setTitle("제목~");
//		board.setContent("내용~");
//		board.setWriter("user0");
//		
//		mapper.insert(board);
//		log.info(board);
//	}
	
//	@Test
//	public void read() {
//		log.info(mapper.read(104L));
//	}
	
//	@Test
//	public void update() {
//		BoardVO board = mapper.read(104L);
//		board.setTitle("제목!");
//		board.setContent("내용!");
//		board.setWriter("user1");
//		
//		log.info("update : " + mapper.update(board));
//	}
	
//	@Test
//	public void getList() {
//		mapper.getList().forEach(board -> log.info(board));
//	}
	
//	@Test
//	public void delete() {
//		log.info("delete : " + mapper.delete(104L));
//	}
	
//	@Test
//	public void testPaging() {
//		mapper.getList(new Criteria()).forEach(board -> log.info(board));
//	}
	
	@Test
	public void search() {
		Criteria cri = new Criteria();
		cri.setKeyword("제목");
		cri.setType("C");
		mapper.getList(cri).forEach(board -> log.info(board));
	}
}
