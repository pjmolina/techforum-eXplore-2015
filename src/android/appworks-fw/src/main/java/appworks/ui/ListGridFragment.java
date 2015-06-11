/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ui;

import android.os.Bundle;
import android.text.Selection;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import java.util.Comparator;
import java.util.Date;
import java.util.List;

import appworks.R;
import appworks.adapters.DatasourceAdapter;
import appworks.behaviors.Behavior;
import appworks.behaviors.SelectionBehavior;
import appworks.behaviors.SwipeRefreshBehavior;
import appworks.ds.Datasource;
import appworks.ds.Pagination;
import appworks.ds.filter.DateRangeFilter;
import appworks.ds.filter.StringListFilter;
import appworks.events.BusProvider;
import appworks.events.ItemSelectedEvent;
import appworks.util.EndlessScrollListener;

/**
 * A fragment representing a list of Items that come from a datasource. Subclasses must
 * implement the {@link ListGridFragment#getDatasource()}, and
 * {@link #bindView(Object, View, int)} methods.
 * <p/>
 * Large screen devices (such as tablets) are supported by replacing the ListView
 * with a GridView, dinamically.
 * <p/>
 */
public abstract class ListGridFragment<T>
        extends BaseFragment
        implements Refreshable, Filterable,
        AbsListView.OnItemClickListener, AbsListView.OnItemLongClickListener {

    /**
     * The fragment's ListView/GridView.
     */
    private AbsListView mListView;

    /**
     * The Adapter which will be used to populate the ListView/GridView with
     * Views.
     */
    private DatasourceAdapter<T> mAdapter;

    private Datasource<T> mDatasource;

    // set to true when the fragment is created the first time (this fragment is sticky)
    private boolean mJustCreated;

    /**
     * If we should notify (send a bus event) when the user selects an item
     */
    private boolean mNotifyOnSelected = true;

    /**
     * Containers for views
     */
    View mListContainer;

    View mProgressContainer;

    /**
     * Loading more... item
     */
    View mFooter;

    /**
     * List header
     */
    int mHeaderRes;
    View mHeaderView;

    EndlessScrollListener mScrollListener;

    /**
     * Mandatory empty constructor for the fragment manager to instantiate the
     * fragment (e.g. upon screen orientation changes).
     */
    public ListGridFragment() {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // lists are refreshable
        addBehavior(new SwipeRefreshBehavior(this));

        // we set this fragments sticky to cache list contents on configuration changes
        setRetainInstance(true);
        mJustCreated = true;

        // create datasource and adapter
        mDatasource = getDatasource();
        // adapter instantation
        mAdapter = createAdapter();
        mAdapter.setCallback(new DatasourceAdapter.Callback() {
            @Override
            public void onDataAvailable() {
                setListShown(true);

                // remove footer view
                if (mFooter != null) {
                    ((ListView) mListView).removeFooterView(mFooter);
                }

                // inform the scroll listener so that it continues processing scrolls
                if (mScrollListener != null) {
                    mScrollListener.finishLoading();
                }
            }

            @Override
            public void onPageRequested() {
                // add loading ... view
                if (mFooter != null) {
                    ((ListView) mListView).addFooterView(mFooter);
                }
            }
        });
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
        View view = inflater.inflate(getLayout(), container, false);

        // Set up the listview
        mListView = (AbsListView) view.findViewById(android.R.id.list);

        // Set OnItemClickListener so we can be notified on item clicks
        mListView.setOnItemClickListener(this);
        mListView.setOnItemLongClickListener(this);

        // set up pagination
        if (mDatasource instanceof Pagination) {
            mScrollListener = new EndlessScrollListener() {
                @Override
                public void onLoadMore(int page, int totalItemsCount) {
                    mAdapter.loadNextPage();
                }
            };

            mListView.setOnScrollListener(mScrollListener);

            // set the footer loading more... item
            // this must be done BEFORE assigning the adapter (in KitKat this is fixed)
            if (mListView instanceof ListView) {
                mFooter = inflater.inflate(R.layout.list_footer, null, false);
                ((ListView) mListView).addFooterView(mFooter);
            }
        }

        // register header
        if(mListView instanceof ListView && mHeaderRes != 0) {
            mHeaderView = inflater.inflate(mHeaderRes, null, false);
            ((ListView) mListView).addHeaderView(mHeaderView, null, false);
        }

        // register adapter (after any header or footer)
        mListView.setAdapter(mAdapter);

        // again, remove the footer from the list
        if (mDatasource instanceof Pagination && mListView instanceof ListView) {
            ((ListView) mListView).removeFooterView(mFooter);
        }

        return view;
    }

    @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        mListContainer = view.findViewById(R.id.listContainer);
        mProgressContainer = view.findViewById(R.id.progressContainer);
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
    }

    @Override
    public void onResume() {
        super.onResume();

        // load first batch of data
        if (mJustCreated) {
            refresh();
        }
    }

    @Override
    public void onPause() {
        super.onPause();

        // set the created flag off (this fragment is retained)
        mJustCreated = false;
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
    }

    @Override
    public void onDestroy() {
        // this actually is not called, since this fragment is retained
        mDatasource = null;
        mAdapter = null;

        super.onDestroy();
    }

    private DatasourceAdapter<T> createAdapter() {
        // create datasource and get layout and binding
        return new DatasourceAdapter<T>(
                getActivity(),
                getItemLayout(),
                mDatasource) {

            @Override
            public void bindView(T item, int position, View view) {
                ListGridFragment.this.bindView(item, view, position);
            }
        };
    }

    private void setListShown(boolean shown) {
        if (mProgressContainer != null && mListContainer != null) {
            mProgressContainer.setVisibility(shown ? View.GONE : View.VISIBLE);
            mListContainer.setVisibility(shown ? View.VISIBLE : View.GONE);
        }
    }

    public AbsListView getListView(){
        return mListView;
    }

    public void setHeaderResource(int resource){
        this.mHeaderRes = resource;
    }

    public View getHeaderView(){
        return mHeaderView;
    }

    // Click listeners
    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        // Notify all suscribers that an item has been selected.
        if (mNotifyOnSelected) {
            BusProvider.getInstance()
                    .post(new ItemSelectedEvent(position, this.getClass().getSimpleName(),
                            mAdapter.getItem(position)));
        }
    }

    @Override
    public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id){
        boolean res = false;
        if(mBehaviors != null){
            for (Behavior b: mBehaviors){
                res = b.onItemLongClick(parent, view, position, id) || res;
            }
        }
        return res;
    }

    /**
     * Sets the notify on selected behavior. Eventually we'll want this to be deactivated (i.e.
     * when selection mode is active)
     *
     * @param notify if an event should be raised when the user selects an item.
     */
    public void notifyOnSelected(boolean notify) {
        this.mNotifyOnSelected = notify;
    }

    // Refreshable interface

    public void refresh() {
        setListShown(false);
        mListView.clearChoices();
        mAdapter.refresh();
    }

    /**
     * The default content for this Fragment has a TextView that is shown when
     * the list is empty. If you would like to change the text, call this method
     * to supply the text it should use.
     */
    public void setEmptyText(CharSequence emptyText) {
        View emptyView = mListView.getEmptyView();

        if (emptyText instanceof TextView) {
            ((TextView) emptyView).setText(emptyText);
        }
    }

    /**
     * get the adapter this fragment is attached to
     *
     * @return the adapter
     */
    public DatasourceAdapter<T> getAdapter() {
        return mAdapter;
    }

    // Search methods

    /**
     * set the filtering criteria for the adapter. This criteria belongs of the page
     */
    public void setSearchText(String searchText) {
        mAdapter.setSearchText(searchText);
    }

    // Sorting

    /**
     * set the sorting column for the adapter.
     */
    public void setSortColumn(String sortColumn) {
        mAdapter.setSortColumn(sortColumn);
    }

    /**
     * set the comparator object that will be used to sort the local data
     */
    public void setSortComparator(Comparator c) {
        mAdapter.setSortComparator(c);
    }

    /**
     * set the sorting order.
     */
    public void setSortAscending(boolean value) {
        mAdapter.setSortAscending(value);
    }

    // Filtering

    /**
     * @see DatasourceAdapter#addFilter(appworks.ds.filter.Filter)
     */
    public void addStringFilter(String field, List<String> values) {
        mAdapter.addFilter(new StringListFilter(field, values));
    }

    public void addDateRangeFilter(String field, long value1, long value2) {
        Date min = (value1 != -1) ? new Date(value1) : null;
        Date max = (value2 != -1) ? new Date(value2) : null;
        mAdapter.addFilter(new DateRangeFilter(field, min, max));
    }

    public void resetFilters() {
        mAdapter.resetFilters();
    }

    // Delegates

    /**
     * Get the datasource for this list
     * @return a @link Datasource object
     */
    protected abstract Datasource<T> getDatasource();

    /**
     * Get the layout for this fragment.
     * @return a valid layout for lists (fragment_list, fragment_grid3cols and fragment_grid4cols)
     */
    protected abstract int getLayout();

    /**
     * Get the layout for this list's items
     * @return the item layout
     */
    protected abstract int getItemLayout();

    /**
     * Binds the item layout to each list item.
     * @param item The item to bind to the view
     * @param view The view inflated from #getItemLayout()
     * @param position the current position
     */
    protected abstract void bindView(T item, View view, int position);
}
