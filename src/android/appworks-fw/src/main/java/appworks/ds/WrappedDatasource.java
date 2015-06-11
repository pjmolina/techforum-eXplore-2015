/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ds;

import java.util.List;

/**
 * A datasource that wraps another one and add features to it
 */
public abstract class WrappedDatasource<T, W> implements
        Datasource<T> {

    static final int PAGE_SIZE = 20;

    Datasource<W> mWrapped;

    @Override
    public void getItems(final Listener<List<T>> listener) {

        mWrapped.getItems(new Listener<List<W>>() {
            @Override
            public void onSuccess(List<W> ts) {
                listener.onSuccess(mapItems(ts));
            }

            @Override
            public void onFailure(Exception e) {
                listener.onFailure(e);
            }
        });

    }

    @Override
    public void getItem(String id, final Listener<T> listener) {
        mWrapped.getItem(id, new Listener<W>() {
            @Override
            public void onSuccess(W item) {
                listener.onSuccess(mapItem(item));
            }

            @Override
            public void onFailure(Exception e) {
                listener.onFailure(e);
            }
        });
    }



    public void setWrappedDatasource(Datasource<W> wrappedDatasource){
        this.mWrapped = wrappedDatasource;
    };

    protected abstract T mapItem(W item);

    protected abstract List<T> mapItems(List<W> items);

}
