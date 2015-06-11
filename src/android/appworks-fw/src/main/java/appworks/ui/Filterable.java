/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ui;

/**
 * UI component (activity or fragment) that supports search operations
 */
public interface Filterable extends Refreshable {

    /**
     * Set the search parameter
     */
    public void setSearchText(String s);
}
