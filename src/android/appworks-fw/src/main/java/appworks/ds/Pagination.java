/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ds;

import java.util.List;

/**
 * interface to paginated datasources
 *
 * @param <T> the item type
 */
public interface Pagination<T> {

    /**
     * return the preferred pagesize for this datasource
     *
     * @return the page size
     */
    public int getPageSize();

    /**
     * Return paginated items
     *
     * @param pagenum       the page number
     * @param pagesize      the page size. This should be equal to the value returned by {@link
     *                      #getPageSize()}
     * @param searchOptions contains the filtering and sorting options
     * @param listener      the listener to send the results to
     */
    public void getItems(int pagenum, int pagesize, SearchOptions searchOptions,
                         Datasource.Listener<List<T>> listener);
}
