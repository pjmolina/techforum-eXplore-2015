/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ds;

import java.util.List;

/**
 * Public interface for Asynchronous datasource
 * Fragments or activities tied to a datasource should invoke init() and shutdown() methods
 * in its own lifecycle methods(i.e onResume() and onPause()). This will guarantee that Datasource
 * implementations will save resources and prevent memory leaks.
 * Depending on the implementation, init() and shutdown() could be called several times in the same
 * datasource object.
 */
public interface Datasource<T> {

    /**
     * Get all items
     *
     * @param listener the callback to call when this operation has finished
     */
    public void getItems(Listener<List<T>> listener);

    /**
     * Get a concrete item
     *
     * @param id       the id of the item in the datasource
     * @param listener the callback to call when this operation has finished
     */
    public void getItem(String id, Listener<T> listener);

    /**
     * Public interface for datasource operation callbacks
     *
     * @param <RESULT> the type of the results
     */
    public interface Listener<RESULT> {

        /**
         * Called on succesful operations
         *
         * @param result the result of the operation
         */
        public void onSuccess(RESULT result);

        /**
         * Called when something has failed
         *
         * @param e the exception details
         */
        public void onFailure(Exception e);
    }
}
