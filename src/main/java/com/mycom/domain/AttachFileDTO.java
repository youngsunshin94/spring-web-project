package com.mycom.domain;

import lombok.Data;

@Data
public class AttachFileDTO {
	private String uploadPath;
	private String fileName;
	private String uuid;
	private String uploadUrl;
	private boolean image;
}
