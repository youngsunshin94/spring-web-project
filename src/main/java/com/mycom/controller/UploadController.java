package com.mycom.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.annotation.PostConstruct;

import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.GetObjectRequest;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.amazonaws.services.s3.model.S3Object;
import com.amazonaws.services.s3.model.S3ObjectInputStream;
import com.amazonaws.util.IOUtils;
import com.mycom.aws.AwsS3Util;
import com.mycom.domain.AttachFileDTO;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class UploadController {
	
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

	@PreAuthorize("isAuthenticated()")
	@PostMapping(value = "/uploadAjaxAction", produces = {MediaType.APPLICATION_JSON_UTF8_VALUE})
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> uploadAjax(MultipartFile[] uploadFile) {
	
		List<AttachFileDTO> list = new ArrayList<>();
		
		String folderPath = getFolder();
		
		for(MultipartFile multipartFile : uploadFile) {
			log.info("-----------------------------");
			log.info("upload file name : " + multipartFile.getOriginalFilename());
			log.info("upload file size : " + multipartFile.getSize());
			
			AttachFileDTO attach = new AttachFileDTO();
			
			String uploadFileName = multipartFile.getOriginalFilename();
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") +1);
			
			attach.setFileName(uploadFileName);
			
			UUID uuid = UUID.randomUUID();
			
			uploadFileName = uuid.toString() + "_" + uploadFileName;
							
			try {
				
				s3Client.putObject(new PutObjectRequest(bucket + "/" + folderPath, uploadFileName, multipartFile.getInputStream(), null)
						.withCannedAcl(CannedAccessControlList.PublicRead));
				
				String uploadFolderPath = s3Client.getUrl(bucket + "/" + folderPath, uploadFileName).toString();
				
				attach.setUploadUrl(uploadFolderPath);
				attach.setUploadPath(getFolder());
				attach.setUuid(uuid.toString());
				
				if(multipartFile.getContentType().contains("image")) {
					
					attach.setImage(true);
				}
				list.add(attach);
			} catch(Exception e) {
				e.printStackTrace();
			}
		}
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
	
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str = sdf.format(date);
		
		return str.replace("-", "/");
	}
	
	
	@PreAuthorize("isAuthenticated()")
	@PostMapping(value = "/deleteFiles", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public ResponseEntity<String> deleteFiles(String fileName) {
		
		log.info("key name : " + fileName);
		
		try {
			
			s3Client.deleteObject(bucket, fileName);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return new ResponseEntity<>("삭제되었습니다.", HttpStatus.OK);
	}
	
	@GetMapping(value = "/download", produces = {MediaType.APPLICATION_OCTET_STREAM_VALUE})
	@ResponseBody
	public ResponseEntity<Resource> download(@RequestHeader("User-Agent") String userAgent, String fileName) throws IOException {
		
		S3Object s3Object = s3Client.getObject(new GetObjectRequest(bucket, fileName));
		S3ObjectInputStream objectInputStream = s3Object.getObjectContent();
		byte[] bytes = IOUtils.toByteArray(objectInputStream);
		
		Resource resource = new ByteArrayResource(bytes);
		fileName = fileName.substring(fileName.indexOf("_") +1);
		
		HttpHeaders headers = new HttpHeaders();
		try {
			
			if(userAgent.contains("Trident")) {
				log.info("IE browser");
				fileName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", " ");
			} else if(userAgent.contains("Edge")) {
				log.info("Edge browser");
				fileName = URLEncoder.encode(fileName, "UTF-8");
			} else {
				log.info("Chrome");
				fileName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
			}
			
			headers.add("Content-Disposition", "attachment; filename=" + fileName);
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}
	
}
