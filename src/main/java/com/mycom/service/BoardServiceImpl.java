package com.mycom.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.mycom.domain.BoardAttachVO;
import com.mycom.domain.BoardVO;
import com.mycom.domain.Criteria;
import com.mycom.mapper.BoardAttachMapper;
import com.mycom.mapper.BoardMapper;

@Service
public class BoardServiceImpl implements BoardService {

	@Autowired
	private BoardMapper mapper;
	
	@Autowired
	private BoardAttachMapper attachMapper;

	@Transactional
	@Override
	public void register(BoardVO board) {
		
		mapper.insert(board);
		
		if(board.getAttachList() == null || board.getAttachList().size() == 0) {
			return;
		}
		
		board.getAttachList().forEach(attach -> {
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
	}

	@Transactional
	@Override
	public BoardVO get(long bno) {
		mapper.hitUp(bno);
		return mapper.read(bno);
	}

	@Transactional
	@Override
	public boolean modify(BoardVO board) {
		
		attachMapper.deleteAll(board.getBno());
		
		boolean result = mapper.update(board) == 1;
		
		if(result && board.getAttachList() != null && board.getAttachList().size() != 0) {
			board.getAttachList().forEach(attach -> {
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}
		
		return result;
	}

	@Transactional
	@Override
	public boolean remove(long bno) {
		attachMapper.deleteAll(bno);
		return mapper.delete(bno) == 1;
	}

	@Override
	public List<BoardVO> getList(Criteria cri) {

		return mapper.getList(cri);
	}

	@Override
	public int getTotal(Criteria cri) {
		
		return mapper.getTotalCount(cri);
	}

	@Override
	public List<BoardAttachVO> getAttachList(long bno) {
		
		return attachMapper.findByBno(bno);
	}
	
	
}
