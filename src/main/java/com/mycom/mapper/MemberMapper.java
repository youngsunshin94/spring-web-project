package com.mycom.mapper;

import com.mycom.domain.AuthVO;
import com.mycom.domain.MemberVO;

public interface MemberMapper {
	
	public MemberVO read(String userid);

	public int checkId(String userid);

	public void doJoin(MemberVO vo);

	public void doAuth(AuthVO auth);
}
