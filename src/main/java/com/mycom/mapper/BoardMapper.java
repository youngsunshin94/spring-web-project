package com.mycom.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.mycom.domain.BoardVO;
import com.mycom.domain.Criteria;

public interface BoardMapper {
	
	public void insert(BoardVO board);
	
	public BoardVO read(long bno);
	
	public int update(BoardVO board);
	
	public int delete(long bno);
	
	public List<BoardVO> getList(Criteria cri);

	public void hitUp(long bno);

	public int getTotalCount(Criteria cri);
	
	public void updateReplyCnt(@Param("bno") long bno, @Param("amount") int amount);
	
}
