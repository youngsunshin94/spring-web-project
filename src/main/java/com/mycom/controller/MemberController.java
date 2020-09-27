package com.mycom.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mycom.domain.MemberVO;
import com.mycom.service.MemberService;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class MemberController {

	@Autowired
	private MemberService service;
	
	@Autowired
	private PasswordEncoder pwEncoder;
	
	@PostMapping("checkId")
	@ResponseBody
	public int checkId(String userid) {
		return service.checkId(userid);
	}
	
	@PostMapping("member/join")
	public String memberJoin(MemberVO vo) {
		
		vo.setUserpw(pwEncoder.encode(vo.getUserpw()));
		log.info(vo);
		service.doJoin(vo);
		
		return "redirect:/customLogin";
		
	}
}
