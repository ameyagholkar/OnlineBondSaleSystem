package com.db.training.blb;

public class SearchCriteria {

	public String ratingLow;
	public String ratingHigh;
	public String couponRateLow;
	public String couponRateHigh;
	public String currentYieldLow;
	public String currentYieldHigh;
	public String yield2MaturityLow;
	public String yield2MaturityHigh;
	public String maturityDateLow;
	public String maturityDateHigh;
	public String parValueLow;
	public String parValueHigh;
	public String priceLow;
	public String priceHigh;
	
	public void checkCriteria(){
		if(ratingLow==null||ratingLow.equalsIgnoreCase("")){ratingLow="D";}
		if(ratingHigh==null||ratingHigh.equalsIgnoreCase("")){ratingHigh="AAA";}
		if(couponRateLow==null||couponRateLow.equalsIgnoreCase("")){couponRateLow="0";}
		if(couponRateHigh==null||couponRateHigh.equalsIgnoreCase("")){couponRateHigh="100";}
		if(currentYieldLow==null||currentYieldLow.equalsIgnoreCase("")){currentYieldLow="0";}
		if(currentYieldHigh==null||currentYieldHigh.equalsIgnoreCase("")){currentYieldHigh="100";}
		if(yield2MaturityLow==null||yield2MaturityLow.equalsIgnoreCase("")){yield2MaturityLow="0";}
		if(yield2MaturityHigh==null||yield2MaturityHigh.equalsIgnoreCase("")){yield2MaturityHigh="100";}
		if(maturityDateLow==null||maturityDateLow.equalsIgnoreCase("")){maturityDateLow="1900-01-01 00:00:00";}
		if(maturityDateHigh==null||maturityDateHigh.equalsIgnoreCase("")){maturityDateHigh="2100-01-01 00:00";}
		if(parValueLow==null||parValueLow.equalsIgnoreCase("")){parValueLow="0";}
		if(parValueHigh==null||parValueHigh.equalsIgnoreCase("")){parValueHigh="1000000000";}
		if(priceLow==null||priceLow.equalsIgnoreCase("")){priceLow="0";}
		if(priceHigh==null||priceHigh.equalsIgnoreCase("")){priceHigh="1000000000";}
	}

	public static final String[] snpRating={
		"D",
		"C","CC",
		"CCC-","CCC","CCC+",
		"B-","B","B+",
		"BB-","BB","BB+",
		"BBB-","BBB","BBB+",
		"A-","A","A+",
		"AA-","AA","AA+",
		"AAA"
	};
	public static final String[] moodysRating={
		"C",
		"Ca","Ca",
		"Caa3","Caa2","Caa1",
		"B3","B2","B1",
		"Ba3","Ba2","Ba1",
		"Baa3","Baa2","Baa1",
		"A3","A2","A1",
		"Aa3","Aa2","Aa1",
		"Aaa"
	};
	
	public static String getSnpRating(String bondRating){
		return getSnpRating(Integer.parseInt(bondRating));
	}
	
	public static String getSnpRating(int bondRating){
		return snpRating[bondRating];
	}
	
	public static String getMoodysRating(String bondRating){
		return getMoodysRating(Integer.parseInt(bondRating));
	}
	
	public static String getMoodysRating(int bondRating){
		return moodysRating[bondRating];
	}
	
	/**
	 * Returns rating number from 0 to 21 inclusively
	 * @param rating
	 * @return rating index, -1 otherwise
	 */
	public static int getNumericRating(String rating){
		for (int i = 0; i < snpRating.length; i++) {
			if(snpRating[i].equals(rating)||moodysRating[i].equals(rating)){
				return i;
			}
		}
		return -1;
	}
	
}
