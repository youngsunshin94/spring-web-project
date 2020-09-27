package com.mycom.mapper;

import java.util.List;

import com.mycom.domain.BoardAttachVO;

public interface BoardAttachMapper {
	
	public void insert(BoardAttachVO vo);

	public List<BoardAttachVO> findByBno(long bno);

	public void deleteAll(long bno);
	
	public List<BoardAttachVO> getOldFiles();
	
}
