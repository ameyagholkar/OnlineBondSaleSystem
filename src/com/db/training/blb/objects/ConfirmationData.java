package com.db.training.blb.objects;

public class ConfirmationData {
	private int status;
	private String processingTime;

	public ConfirmationData() {

	}

	public ConfirmationData(int status) {
		this.status = status;
		this.processingTime = null;
	}

	public ConfirmationData(int status, String processingTime) {
		this.status = status;
		this.processingTime = processingTime;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public String getProcessingTime() {
		return processingTime;
	}

	public void setProcessingTime(String processingTime) {
		this.processingTime = processingTime;
	}

}