package com.mycom.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.mycom.domain.Criteria;
import com.mycom.domain.ReplyVO;

public interface ReplyMapper {

	public int insert(ReplyVO vo);
	
	public ReplyVO read(long rno);
	
	public int update(ReplyVO vo);
	
	public int delete(long rno);
	
	public List<ReplyVO> getList(@Param("cri") Criteria cri, @Param("bno") long bno);
	
	public int getCountByBno(long bno);
}
