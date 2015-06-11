/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ds.filter;

import java.util.regex.Pattern;

/**
 * A filter that match a field against a regular expression
 */
public class RegularExpFilter implements Filter<String> {

    String mField;

    String mValue;

    public RegularExpFilter(String field, String value) {
        this.mField = field;
        this.mValue = value;
    }

    @Override
    public String getField() {
        return mField;
    }

    @Override
    public String getQueryString() {
        StringBuilder sb = new StringBuilder();
        //searches.add("{\"" + col + "\":{\"$regex\":\"" + st + "\",\"$options\":\"i\"}}");
        sb.append("\"")
                .append(mField)
                .append("\":{\"$regex\":\"")
                .append(mValue)
                .append("\",\"$options\":\"i\"}");

        return sb.toString();
    }

    @Override
    public boolean applyFilter(String fieldValue) {
        Pattern p = Pattern.compile(mValue);
        return p.matcher(fieldValue).matches();
    }
}
