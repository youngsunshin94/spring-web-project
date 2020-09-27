package com.mycom.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class CommonController {

	@PreAuthorize("isAnonymous()")
	@GetMapping("/customLogin")
	public void customLogin() {
		
		log.info("login");
	}
	
	@PreAuthorize("isAnonymous()")
	@GetMapping("/signUp")
	public void signUp() {
		log.info("signUp");
	}
	
}
