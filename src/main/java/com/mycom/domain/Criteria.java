package com.mycom.domain;

import lombok.Data;

@Data
public class Criteria {
	private int pageNum, amount;
	private boolean prev, next;
	
	private String keyword, type;
	
	public Criteria(int pageNum, int amount) {
		this.pageNum = pageNum;
		this.amount = amount;
	}
	
	public Criteria() {
		this(1, 10);
	}
	
	public int getSkipCount() {
		return (this.pageNum -1) * this.amount;
	}
	
	public String[] getTypeArr() {
		return type == null ? new String[] {} : type.split("");
	}
}
