package com.mycom.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.mycom.aws.AwsS3Util;
import com.mycom.domain.AuthVO;
import com.mycom.domain.MemberVO;
import com.mycom.mapper.MemberMapper;

@Service
public class MemberServiceImpl implements MemberService {
	
	@Autowired
	private MemberMapper mapper;

	@Override
	public int checkId(String userid) {
		
		int result = mapper.checkId(userid);
		
		if(result != 1) {
			result = 0;
		}
		return result;
	}

	@Transactional
	@Override
	public void doJoin(MemberVO vo) {
		AuthVO auth = new AuthVO();
		
		auth.setAuth("ROLE_USER");
		auth.setUserid(vo.getUserid());
		
		mapper.doJoin(vo);	
		mapper.doAuth(auth);
	}
}
