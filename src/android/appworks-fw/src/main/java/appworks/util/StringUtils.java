/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.util;

import android.util.Log;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;

/**
 * String utility methods
 */
public class StringUtils {

    /**
     * returns the first chars from a String, or the entire string if its lenght is lower than
     * nChars
     *
     * @param theString the input string
     * @param nChars    the number of chars to be returned (if lenght < nchars)
     * @param ellipsize if a "..." should be appended to the output
     * @return the truncated char
     */
    public static String firstNChars(String theString, int nChars, boolean ellipsize) {
        if (theString == null) {
            return null;
        }

        int endIndex = theString.length() > nChars ? nChars : theString.length() - 1;

        return theString.substring(0, endIndex) + (ellipsize ? " ..." : "");
    }

    /**
     * Remove all &lt;img&gt; tags from the input string
     *
     * @param input the input string
     * @return the resulting string
     */
    public static String removeImgTag(String input) {
        return input.replaceAll("<img.+?>", "");
    }

    /**
     * returns a data object as a Number despite of its type. Used in charts.
     *
     * @param num the object to be converted to Number. Could be String or Double
     * @return the object converted to Number
     */
    public static Number StringToNumber(Object num) {
        if (num == null) {
            return null;
        }

        if (num instanceof Number) {
            return (Double) num;
        }

        Number res = null;

        try {
            if (num instanceof String) {
                res = Float.parseFloat((String) num);
            }
        } catch (NumberFormatException e) {
            Log.d("Parsing Error", "Error parsing string to number " + e.getMessage());
        }
        return res;
    }

    /**
     * Utility method to parse a date using ISO-8601
     *
     * @return the parsed date or null if an exception occurs
     */
    public static Date parseDate(String date) {
        Date res = null;
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
        // all dates must come in UTC timezone
        df.setTimeZone(TimeZone.getTimeZone("UTC"));
        try {
            res = df.parse(date);
        } catch (ParseException e) {
            Log.e("ParseError", e.getMessage());
        }

        return res;
    }

    /**
     * Returns the short month name, given its month number
     * @param month
     * @return the month name (JAN, FEB, etc). Months are 0-based
     */
    public static String monthName(int month){
        Calendar cal = Calendar.getInstance();
        try {
            cal.set(Calendar.MONTH, month);
            SimpleDateFormat format = new SimpleDateFormat("MMM");
            return format.format(cal.getTime());
        }catch(Exception e){
            return null;
        }
    }

    /*
     * Converts a double into a String for TextViews, removing optionally any
     * 0 decimals (ie: 34.00 -> 34)
     */
    public static String doubleToString(Double val, boolean removeTrailingZeroes){
        if (val == null)
            return null;

        String res = val.toString();
        return removeTrailingZeroes ?
                res.replaceAll("\\.0*$", "") :
                res;
    }
}
