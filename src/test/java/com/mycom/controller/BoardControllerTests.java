package com.mycom.controller;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@Log4j
@ContextConfiguration({"file:src/main/webapp/WEB-INF/spring/root-context.xml",
	"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"})
public class BoardControllerTests {

	@Autowired
	private WebApplicationContext ctx;
	
	private MockMvc mockMvc;
	
	@Before
	public void setUp() {
		this.mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
	}
	
//	@Test
//	public void getList() throws Exception {
//		log.info(mockMvc.perform(MockMvcRequestBuilders.get("/board/list")).andReturn().getModelAndView().getModelMap());
//	}
	
//	@Test
//	public void register() throws Exception {
//		String resultPage = mockMvc.perform(MockMvcRequestBuilders.post("/board/register")
//				.param("title", "제목!").param("content", "내용!").param("writer", "user0")).andReturn().getModelAndView().getViewName();
//		
//		log.info("result : " + resultPage);
//	}
	
//	@Test
//	public void get() throws Exception {
//		log.info(mockMvc.perform(MockMvcRequestBuilders.get("/board/get").param("bno", "105")).andReturn().getModelAndView().getModelMap());
//	}
	
//	@Test
//	public void modify() throws Exception {
//		String resultPage = mockMvc.perform(MockMvcRequestBuilders.post("/board/modify")
//				.param("bno","105").param("title", "제목수정!").param("content", "내용수정!").param("writer", "user1")).andReturn().getModelAndView().getViewName();
//		
//		log.info("result : " + resultPage);
//	}
	
	@Test
	public void remove() throws Exception {
		String resultPage = mockMvc.perform(MockMvcRequestBuilders.post("/board/remove")
				.param("bno","105")).andReturn().getModelAndView().getViewName();
		
		log.info("result : " + resultPage);
	}
	
	
}
