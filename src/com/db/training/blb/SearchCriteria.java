package com.db.training.blb;

public class SearchCriteria {


	public String rating_low;
	public String rating_high;

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
	public int getNumericRating(String rating){
		for (int i = 0; i < snpRating.length; i++) {
			if(snpRating.equals(rating)||moodysRating.equals(rating)){
				return i;
			}
		}
		return -1;
	}
	
}
