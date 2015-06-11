/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ds;

import java.util.List;

/**
 * Interface for unique values retrieval operations
 */
public interface Distinct {

    /**
     * Get the unique values for a given column
     * @param columnName the column name in the datasource
     * @param listener the async listener for this operation
     * @return The list of unique values
     */
    public void getUniqueValuesFor(
            String columnName,
            Datasource.Listener<List<Object>> listener);
}
