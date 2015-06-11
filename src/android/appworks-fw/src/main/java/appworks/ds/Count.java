/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ds;

/**
 * Use this interface to mark datasources as "countable"
 */
public interface Count {

    /**
     * Get the size of this datasource
     *
     * @return the number of elements that this datasource provides
     */
    public int getCount();
}
