/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.util;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import appworks.ds.filter.Filter;

/**
 * Utility class to ease the sorting and searching actions in lists.
 */
public class FilterUtils {

    public static int compareString(Object o1, Object o2) {
        int res;
        if (o1 == null || o2 == null) {
            res = 0;
        } else {
            res = ((String) o1).compareToIgnoreCase((String) o2);
        }
        return res;
    }

    public static int compareDouble(Object o1, Object o2) {
        // params will come as Strings
        int res;
        if (o1 == null || o2 == null) {
            res = 0;
        } else {
            try {
                Double d1 = Double.parseDouble((String) o1);
                Double d2 = Double.parseDouble((String) o2);
                res = d1.compareTo(d2);
            } catch (Exception e) {
                Log.e("ParseError", e.getMessage());
                res = 0;
            }
        }
        return res;
    }

    public static int compareDate(Context context, Object o1, Object o2) {
        // params will come as Strings
        int res;
        if (o1 == null || o2 == null) {
            res = 0;
        } else {
            try {
                Date d1 = android.text.format.DateFormat.getMediumDateFormat(context)
                        .parse((String) o1);
                Date d2 = android.text.format.DateFormat.getMediumDateFormat(context)
                        .parse((String) o2);
                res = d1.compareTo(d2);
            } catch (Exception e) {
                Log.e("ParseError", e.getMessage());
                res = 0;
            }
        }
        return res;
    }


    public static boolean searchInString(String columnText, String filterText) {
        boolean res = false;
        if (columnText != null && filterText != null) {
            res = columnText.toLowerCase().contains(filterText.toLowerCase());
        }
        return res;
    }

    public static boolean searchInDouble(Double columnText, String filterText) {
        boolean res = false;
        if (columnText != null && filterText != null) {
            res = columnText.toString().toLowerCase().contains(filterText.toString().toLowerCase());
        }
        return res;
    }

    public static boolean searchInDate(Date columnText, String filterText) {
        boolean res = false;
        if (columnText != null && filterText != null) {
            res = columnText.toString().toLowerCase().contains(filterText.toString().toLowerCase());
        }
        return res;
    }

    public static boolean applyFilters(String name, Object value, List<Filter> filters) {
        if (filters != null) {
            for (Filter filter : filters) {
                if (filter.getField().equals(name)) {
                    if (!filter.applyFilter(value)) {
                        return false;
                    }
                }
            }
        }

        return true;
    }

    public static String getFilterQuery(List<Filter> filters){
        if(filters == null || filters.size() == 0)
            return null;

        ArrayList<String> conditions = new ArrayList<String>();
        for (Filter filter : filters){
            String qs = filter.getQueryString();
            if(qs != null)
                conditions.add("{" + qs + "}");
        }

        if (conditions.size() > 0){
            return "[" + TextUtils.join(",", conditions) + "]";
        }

        return null;
    }

}
