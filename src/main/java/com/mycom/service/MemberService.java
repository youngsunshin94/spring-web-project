package com.mycom.service;

import com.mycom.domain.MemberVO;

public interface MemberService {

	public int checkId(String userid);

	public void doJoin(MemberVO vo);

}
