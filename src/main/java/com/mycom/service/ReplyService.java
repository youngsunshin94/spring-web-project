package com.mycom.service;

import com.mycom.domain.Criteria;
import com.mycom.domain.ReplyPageDTO;
import com.mycom.domain.ReplyVO;

public interface ReplyService {

	public int register(ReplyVO vo);
	
	public ReplyVO get(long rno);
	
	public int modify(ReplyVO vo);
	
	public int remove(long rno);
	
	public ReplyPageDTO getList(Criteria cri, long bno);
}
