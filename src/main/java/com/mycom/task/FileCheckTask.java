package com.mycom.task;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.stream.Collectors;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.ListObjectsRequest;
import com.amazonaws.services.s3.model.ObjectListing;
import com.amazonaws.services.s3.model.S3ObjectSummary;
import com.mycom.aws.AwsS3Util;
import com.mycom.domain.BoardAttachVO;
import com.mycom.mapper.BoardAttachMapper;

import lombok.extern.log4j.Log4j;

@Component
@Log4j
public class FileCheckTask {
	
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
	
	@Autowired
	private BoardAttachMapper attachMapper;
	
	private String getFolderYesterDay() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -1);
		String str = sdf.format(cal.getTime());
		
		return str.replace("-", "/");
	}
	
	@Scheduled(cron = "0 0 2 * * *")
	public void checkFiles() throws Exception {
		log.warn("file check task");
		
		ObjectListing objectListing = s3Client.listObjects(new ListObjectsRequest()
				.withBucketName(bucket)
				.withPrefix(getFolderYesterDay()));
		
		List<String> s3FileList = new ArrayList<>();
		
		for(S3ObjectSummary summary : objectListing.getObjectSummaries()) {
			log.warn("key :" + summary.getKey());
			s3FileList.add(summary.getKey());
		}
		
		List<BoardAttachVO> fileList = attachMapper.getOldFiles();
		List<String> oldFileList = fileList.stream()
				.map(vo -> vo.getUploadPath() + "/" + vo.getUuid() +"_" + vo.getFileName())
				.collect(Collectors.toList());
		
		log.warn("---------------------------------------------");
		
		oldFileList.forEach(attach -> log.warn(attach));
		
		for(String str : s3FileList) {
			if(!oldFileList.contains(str)) {
				try {
					s3Client.deleteObject(bucket, str);
					log.warn("remove file : " + str);
				} catch(Exception e) {
					e.printStackTrace();
				}
			}
		}
		
	}
}
