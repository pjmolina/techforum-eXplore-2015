/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.adapters;

import com.squareup.otto.Bus;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.BaseAdapter;

import java.lang.ref.WeakReference;
import java.util.Comparator;
import java.util.List;

import appworks.ds.Cache;
import appworks.ds.Datasource;
import appworks.ds.Pagination;
import appworks.ds.SearchOptions;
import appworks.ds.filter.Filter;
import appworks.events.BusProvider;
import appworks.events.DatasourceFailureEvent;
import appworks.events.DatasourceUnauthorizedEvent;
import retrofit.RetrofitError;
import retrofit.client.Response;

/**
 * Adapter backed by a {@link Datasource}.
 * <p/>
 * Based on an implementation of {@link BaseAdapter} which uses the new/bind pattern for its views,
 * <a href="https://gist.github.com/JakeWharton/5423616">
 * https://gist.github.com/JakeWharton/5423616
 * </a>. Apache 2.0 licensed.
 */
public abstract class DatasourceAdapter<T> extends ArrayAdapter<T> {

    private final LayoutInflater inflater;

    private final Datasource<T> mDatasource;

    private Callback mCallback;

    private WeakReference<Context> mWeakContext;

    private final int mViewId;

    private int currentPage = -1;

    private boolean reachedEnd;

    private SearchOptions searchOptions;

    public DatasourceAdapter(Context context, int viewId, Datasource<T> datasource) {
        this(context, viewId, datasource, new SearchOptions());
    }

    public DatasourceAdapter(Context context, int viewId, Datasource<T> datasource,
            SearchOptions searchOptions) {
        super(context, viewId);
        this.inflater = LayoutInflater.from(context);
        this.mDatasource = datasource;
        this.mViewId = viewId;
        this.mWeakContext = new WeakReference<Context>(context);
        this.searchOptions = searchOptions;

        setNotifyOnChange(false); // we want to control when observers will be notified
    }

    /**
     * Sets a new callback for operations
     *
     * @param c the new callback to register
     */
    public void setCallback(Callback c) {
        this.mCallback = c;
    }

    /**
     * Perform a full query to the datasource
     */
    public void refresh() {
        // invalidate current data
        if (mDatasource instanceof Cache) {
            ((Cache) mDatasource).invalidate();
        }

        // fill in the array
        if (mDatasource instanceof Pagination) {
            // reset vars
            currentPage = -1;
            reachedEnd = false;

            // load first page
            loadNextPage(true); // clear and load first page
            return;
        }

        mDatasource.getItems(new Datasource.Listener<List<T>>() {
            @Override
            public void onSuccess(final List<T> result) {
                // ensure that datasource callbacks (which may be async) are run in ui thread
                Activity act = (Activity) mWeakContext.get();
                if (act != null) {
                    act.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            currentPage = 0;

                            clear();
                            addAll(result);

                            notifyDataSetChanged();
                            // signal that the data is available
                            if (mCallback != null) {
                                mCallback.onDataAvailable();
                            }
                        }
                    });
                }

            }

            @Override
            public void onFailure(final Exception e) {
                Activity act = (Activity) mWeakContext.get();
                if (act != null) {
                    act.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            // inform the user
                            if (mCallback != null) {
                                mCallback.onDataAvailable();
                            }
                            notifyDatasourceError(e);
                            notifyDataSetChanged();
                        }
                    });
                }
            }
        });
    }

    public void loadNextPage() {
        loadNextPage(false);
    }

    @SuppressWarnings("unchecked")
    public void loadNextPage(final boolean clear) {
        if (!(mDatasource instanceof Pagination)) {
            throw new IllegalStateException("This datasource doesn't support pagination");
        }

        if (!reachedEnd) {
            Log.d("Appworks", "loading page: " + (currentPage + 1));
            Pagination<T> pagedDS = (Pagination<T>) mDatasource;
            final int pageSize = pagedDS.getPageSize();

            // notify next page is being requested
            if (mCallback != null) {
                Activity act = (Activity) mWeakContext.get();
                if (act != null) {
                    act.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            mCallback.onPageRequested();
                        }
                    });
                }
            }

            pagedDS.getItems(++currentPage, pageSize, searchOptions,
                    new Datasource.Listener<List<T>>() {
                        @Override
                        public void onSuccess(final List<T> result) {
                            Activity act = (Activity) mWeakContext.get();
                            if (act != null) {
                                act.runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        if (result.size() < pageSize) {
                                            reachedEnd = true;
                                        }

                                        // clear if it is first page
                                        if (clear) {
                                            clear();
                                        }

                                        addAll(result);

                                        notifyDataSetChanged();
                                        if (mCallback != null) {
                                            mCallback.onDataAvailable();
                                        }
                                    }
                                });
                            }
                        }

                        @Override
                        public void onFailure(final Exception e) {
                            Activity act = (Activity) mWeakContext.get();
                            if (act != null) {
                                act.runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        // inform the user
                                        notifyDatasourceError(e);
                                        notifyDataSetChanged();
                                        if (mCallback != null) {
                                            mCallback.onDataAvailable();
                                        }
                                    }
                                });
                            }
                        }
                    });
        }
    }

    @Override
    public final View getView(int position, View view, ViewGroup container) {
        if (view == null) {
            view = newView(inflater, position, container);
            if (view == null) {
                throw new IllegalStateException("newView result must not be null.");
            }
        }

        bindView(getItem(position), position, view);
        return view;
    }

    public void notifyDatasourceError(Exception e) {

        Bus bus = BusProvider.getInstance();
        if (e instanceof RetrofitError) {
            Response r = ((RetrofitError) e).getResponse();
            if (r != null && r.getStatus() == 401) {
                bus.post(new DatasourceUnauthorizedEvent());
            } else {
                bus.post(new DatasourceFailureEvent());
            }
        } else {
            bus.post(new DatasourceFailureEvent());
        }
    }

    // Search methods

    public void setSearchText(String searchText) {
        searchOptions.setSearchText(searchText);
    }

    // Sorting methods

    public void setSortColumn(String sortColumn) {
        searchOptions.setSortColumn(sortColumn);
    }

    public void setSortComparator(Comparator c) {
        searchOptions.setSortComparator(c);
    }

    public void setSortAscending(boolean value) {
        searchOptions.setSortAscending(value);
    }

    // Filtering methods

    /**
     * Set filtering criteria against a field
     *
     * @param filter the filter object. {@see appworks.ds.filter.StringListFilter}
     */
    public void addFilter(Filter filter) {
        searchOptions.addFilter(filter);
    }

    public void removeFilterByField(String field){
        List<Filter> filters = searchOptions.getFilters();
        if(filters != null){
            for(Filter f: filters){
                if(f.getField().equals(field))
                    filters.remove(f);
            }
        }
    }

    public void resetFilters() {
        searchOptions.setFilters(null);
    }

    /**
     * Create a new instance of a view for the specified position.
     */
    private View newView(LayoutInflater inflater, int position, ViewGroup container) {
        return inflater.inflate(mViewId, container, false);
    }

    /**
     * Bind the data for the specified {@code position} to the view.
     */
    public abstract void bindView(T item, int position, View view);

    /**
     * Callback interface for datasource operations. All callbacks will be called on UI Thread
     */
    public interface Callback {

        public void onPageRequested();

        public void onDataAvailable();
    }
}