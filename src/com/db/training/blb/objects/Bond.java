package com.db.training.blb.objects;

public class Bond {
	
	private String cusip;
	private String bondName;
	private String issuerName;
	private String rating;
	private double couponRate;
	private double currentYield;
	private double maturityYield;
	private double maturityDate;
	private double parValue;
	private double price;
	private int groupId;
	private int quantityOwned;
	private int bondType;
	
	public Bond(String cusip, String bondName, String issuerName,
			String rating, double couponRate, double currentYield,
			double maturityYield, double maturityDate, double parValue,
			double price, int groupId, int quantityOwned, int bondType) {
		this.cusip = cusip;
		this.bondName = bondName;
		this.issuerName = issuerName;
		this.rating = rating;
		this.couponRate = couponRate;
		this.currentYield = currentYield;
		this.maturityYield = maturityYield;
		this.maturityDate = maturityDate;
		this.parValue = parValue;
		this.price = price;
		this.groupId = groupId;
		this.quantityOwned = quantityOwned;
		this.bondType = bondType;
	}

	public Bond(){
		
	}

	public String getCusip() {
		return cusip;
	}

	public void setCusip(String cusip) {
		this.cusip = cusip;
	}

	public String getBondName() {
		return bondName;
	}

	public void setBondName(String bondName) {
		this.bondName = bondName;
	}

	public String getIssuerName() {
		return issuerName;
	}

	public void setIssuerName(String issuerName) {
		this.issuerName = issuerName;
	}

	public String getRating() {
		return rating;
	}

	public void setRating(String rating) {
		this.rating = rating;
	}

	public double getCouponRate() {
		return couponRate;
	}

	public void setCouponRate(double couponRate) {
		this.couponRate = couponRate;
	}

	public double getCurrentYield() {
		return currentYield;
	}

	public void setCurrentYield(double currentYield) {
		this.currentYield = currentYield;
	}

	public double getMaturityYield() {
		return maturityYield;
	}

	public void setMaturityYield(double maturityYield) {
		this.maturityYield = maturityYield;
	}

	public double getMaturityDate() {
		return maturityDate;
	}

	public void setMaturityDate(double maturityDate) {
		this.maturityDate = maturityDate;
	}

	public double getParValue() {
		return parValue;
	}

	public void setParValue(double parValue) {
		this.parValue = parValue;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public double getGroupId() {
		return groupId;
	}

	public void setGroupId(int groupId) {
		this.groupId = groupId;
	}

	public double getQuantityOwned() {
		return quantityOwned;
	}

	public void setQuantityOwned(int quantityOwned) {
		this.quantityOwned = quantityOwned;
	}

	public double getBondType() {
		return bondType;
	}

	public void setBondType(int bondType) {
		this.bondType = bondType;
	}
	
}
