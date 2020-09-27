

package com.mycom.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.mycom.domain.Criteria;
import com.mycom.domain.ReplyPageDTO;
import com.mycom.domain.ReplyVO;
import com.mycom.mapper.BoardMapper;
import com.mycom.mapper.ReplyMapper;

@Service
public class ReplyServiceImpl implements ReplyService {
	
	@Autowired
	private ReplyMapper mapper;

	@Autowired
	private BoardMapper boardMapper;
	
	@Transactional
	@Override
	public int register(ReplyVO vo) {
		boardMapper.updateReplyCnt(vo.getBno(), 1);
		
		return mapper.insert(vo);
	}

	@Override
	public ReplyVO get(long rno) {
		
		return mapper.read(rno);
	}

	@Override
	public int modify(ReplyVO vo) {

		return mapper.update(vo);
	}

	@Transactional
	@Override
	public int remove(long rno) {
		ReplyVO vo = mapper.read(rno);
		boardMapper.updateReplyCnt(vo.getBno(), -1);
		
		return mapper.delete(rno);
	}

	@Override
	public ReplyPageDTO getList(Criteria cri, long bno) {
		
		if(cri.getPageNum() == -1) {
			int page = (int)(Math.ceil(mapper.getCountByBno(bno) / 10.0));
			
			cri.setPageNum(page);
		}

		return new ReplyPageDTO(mapper.getList(cri, bno), mapper.getCountByBno(bno));
	}
	
	
}
