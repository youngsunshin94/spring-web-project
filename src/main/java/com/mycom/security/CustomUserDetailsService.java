package com.mycom.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.mycom.domain.MemberVO;
import com.mycom.mapper.MemberMapper;
import com.mycom.security.domain.CustomUser;

import lombok.extern.log4j.Log4j;

@Log4j
public class CustomUserDetailsService implements UserDetailsService {
	
	@Autowired
	private MemberMapper mapper;
	
	@Override
	public UserDetails loadUserByUsername(String userName) throws UsernameNotFoundException {
		
		log.warn("username : " + userName);
		
		MemberVO vo = mapper.read(userName);		
		
		log.warn("quried by member mapper : " +vo);
		
		return vo == null ? null : new CustomUser(vo);
	}

}
