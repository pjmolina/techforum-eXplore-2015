/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ds.filter;

/**
 * A float range filter
 */
public abstract class FloatRangeFilter implements Filter {

    String mField;

    float mMin = Float.MIN_VALUE;

    float mMax = Float.MAX_VALUE;

    public FloatRangeFilter(String field, float min, float max) {
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
        return new StringBuilder()
                .append("\"").append(mField)
                .append("\":{\"$gt\":").append(mMin)
                .append(",\"$lt\":").append(mMax).append("\"}")
                .toString();
    }
}
