/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ds.filter;

import android.text.TextUtils;

import java.util.List;

/**
 * A filter that match a field against a value list
 */
public class StringListFilter implements Filter<String> {

    String mField;

    List<String> mValues;

    public StringListFilter(String field, List<String> values) {
        this.mField = field;
        this.mValues = values;
    }

    @Override
    public String getField() {
        return mField;
    }

    @Override
    public String getQueryString() {

        StringBuilder sb = new StringBuilder();
        sb.append("\"").append(mField).append("\":{\"$in\":[\"");
        sb.append(TextUtils.join("\", \"", mValues));
        sb.append("\"]}");

        return sb.toString();
    }

    @Override
    public boolean applyFilter(String fieldValue) {
        return mValues == null || mValues.size() == 0 || mValues.contains(fieldValue);
    }
}
