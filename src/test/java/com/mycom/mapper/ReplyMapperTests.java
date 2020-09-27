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
public class ReplyMapperTests {
	
	@Autowired
	private ReplyMapper mapper;
	
//	@Test
//	public void insert() {
//		ReplyVO vo = new ReplyVO();
//		vo.setReply("댓글ㅋㅋ");
//		vo.setReplyer("user0");
//		vo.setBno(1L);
//		
//		mapper.insert(vo);
//		log.info(vo);
//	}
	
//	@Test
//	public void read() {
//		log.info(mapper.read(64L));
//	}
	
//	@Test
//	public void update() {
//		ReplyVO vo = mapper.read(64L);
//		vo.setReply("ㅋㅋㅋㅋㅋ수정");
//		
//		log.info("modify : " + mapper.update(vo));
//	}
	
//	@Test
//	public void getList() {
//		mapper.getList(new Criteria(), 1L).forEach(board->log.info(board));
//	}
	
//	@Test
//	public void delete() {
//		log.info("delete : " + mapper.delete(64L));
//	}

//	@Test
//	public void paging() {
//		mapper.getList(new Criteria(), 1L).forEach(board->log.info(board));
//	}
	
}
