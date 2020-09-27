package com.mycom.service;

import java.util.List;

import com.mycom.domain.BoardAttachVO;
import com.mycom.domain.BoardVO;
import com.mycom.domain.Criteria;

public interface BoardService {
	
	public void register(BoardVO board);
	
	public BoardVO get(long bno);
	
	public boolean modify(BoardVO board);
	
	public boolean remove(long bno);
	
	public List<BoardVO> getList(Criteria cri);

	public int getTotal(Criteria cri);

	public List<BoardAttachVO> getAttachList(long bno);
	
}
