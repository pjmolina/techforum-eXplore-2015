/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ds.filter;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;

/**
 * A date range filter
 */
public class DateRangeFilter implements Filter<Date> {

    String mField;

    Date mMin;

    Date mMax;

    public DateRangeFilter(String field, Date min, Date max) {
        this.mField = field;
        this.mMax = max;
        this.mMin = min;
    }

    @Override
    public String getField() {
        return mField;
    }

    @Override
    public String getQueryString() {
        StringBuilder sb = new StringBuilder()
                .append("\"").append(mField).append("\":");

        sb.append("{");
        if (mMin != null) {
            sb.append("\"$gte\":").append(dateToISO(mMin));
        }

        if (mMax != null) {
            if (mMin != null) {
                sb.append(",");
            }
            sb.append("\"$lte\":").append(dateToISO(mMax));
        }
        sb.append("}");

        return sb.toString();
    }

    @Override
    public boolean applyFilter(Date fieldValue) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(fieldValue);

        if (mMin != null) {
            Calendar minCal = Calendar.getInstance();
            minCal.setTime(mMin);
            if (!cal.after(minCal)) {
                return false;
            }
        }
        if (mMax != null) {
            Calendar maxCal = Calendar.getInstance();
            maxCal.setTime(mMax);
            if (!cal.before(maxCal)) {
                return false;
            }
        }

        return true;
    }

    private String dateToISO(Date date) {

        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
        format.setTimeZone(TimeZone.getTimeZone("UTC"));
        return new StringBuilder("\"")
                .append(format.format(date))
                        .append("\"")
                        .toString();
    }
}
