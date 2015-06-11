/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ds.filter;

/**
 * Interface for datasource filtering
 */
public interface Filter<T> {

    /**
     * The field this filter is based on
     *
     * @return the field that this field is targeting
     */
    public String getField();

    /**
     * Get the query string for this filter (for remote datasources)
     *
     * @return the query string representation for this filter, MongoDB format. Example:
     * "country":"Spain","date":"10/14"
     * <br>
     *     Note: Don't surround it with curly brackets.
     */
    public String getQueryString();

    /**
     * Apply this filter
     */
    public boolean applyFilter(T fieldValue);
}
