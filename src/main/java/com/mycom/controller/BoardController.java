package com.mycom.controller;

import java.util.List;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.mycom.aws.AwsS3Util;
import com.mycom.domain.BoardAttachVO;
import com.mycom.domain.BoardVO;
import com.mycom.domain.Criteria;
import com.mycom.domain.PageDTO;
import com.mycom.service.BoardService;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board/*")
public class BoardController {

	@Autowired
	private BoardService service;
	
	AwsS3Util awsS3 = new AwsS3Util();
	
	private AmazonS3 s3Client;
	private String accessKey = awsS3.getAccessKey();
	private String secretKey = awsS3.getSecretKey();
	private String bucket = awsS3.getBucket();
	private String region = awsS3.getRegion();
	
	@PostConstruct
	public void setS3Client() {
		AWSCredentials credentials = new BasicAWSCredentials(accessKey, secretKey);
		
		s3Client = AmazonS3ClientBuilder.standard()
					.withCredentials(new AWSStaticCredentialsProvider(credentials))
					.withRegion(this.region)
					.build();
	}
	
	@GetMapping("/list")
	public void getList(Model model, Criteria cri) {
		log.info("list");
		model.addAttribute("list", service.getList(cri));
		int total = service.getTotal(cri);
		model.addAttribute("pageMaker", new PageDTO(cri, total));
	}
	
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/register")
	public void register() {
		log.info("register");
		
	}
	
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/register")
	public String register(BoardVO board, RedirectAttributes rttr) {
		log.info("register : " + board);
		
		if(board.getAttachList() != null && board.getAttachList().size() > 0) {
			board.getAttachList().forEach(attach -> log.info(attach));
		}
		
		service.register(board);
		rttr.addFlashAttribute("result", board.getBno());
		
		return "redirect:/board/list";
	}
	
	@GetMapping("/get")
	public void get(Model model, @RequestParam("bno") long bno, @ModelAttribute("cri") Criteria cri) {
		log.info("get");
		
		model.addAttribute("board", service.get(bno));
	}
	
	@PreAuthorize("authentication.principal.username == #writer")
	@GetMapping("/modify")
	public void modify(Model model, @RequestParam("bno") long bno, @ModelAttribute("cri") Criteria cri, @RequestParam("writer") String writer) {
		log.info("modify");
		
		log.info("writer : " + writer);
		
		model.addAttribute("board", service.get(bno));
	}
	
	@PreAuthorize("principal.username == #board.writer")
	@PostMapping("/modify")
	public String modify(BoardVO board, RedirectAttributes rttr, @ModelAttribute("cri") Criteria cri) {
		log.info("modify : " + board);
		
		if(service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
		}
		
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());
		
		return "redirect:/board/list";
	}

	@PreAuthorize("principal.username == #writer")
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") long bno, RedirectAttributes rttr, @ModelAttribute("cri") Criteria cri, String writer) {
		log.info("remove : " + bno);
		
		List<BoardAttachVO> attachList = service.getAttachList(bno);
		
		if(service.remove(bno)) {
			
			deleteFiles(attachList);
			
			rttr.addFlashAttribute("result", "success");
		}
		
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());
		
		return "redirect:/board/list";
	}
	
	@GetMapping(value = "/getAttachList", produces = {MediaType.APPLICATION_JSON_UTF8_VALUE})
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(long bno) {
		log.info("get attach list : " + bno);
		return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
	}
	
	private void deleteFiles(List<BoardAttachVO> attachList) {
		if(attachList == null || attachList.size() == 0) {
			return;
		}
		
		try {
			attachList.forEach(attach -> {
				s3Client.deleteObject(bucket, attach.getUploadPath() + "/" + attach.getUuid() + "_" + attach.getFileName());
			});
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
}
