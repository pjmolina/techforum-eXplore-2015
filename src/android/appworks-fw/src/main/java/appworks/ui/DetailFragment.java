/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ui;

import android.app.Activity;
import android.os.Bundle;
import android.os.Parcelable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import appworks.R;
import appworks.behaviors.Behavior;
import appworks.behaviors.ShareBehavior;
import appworks.ds.Datasource;
import appworks.events.BusProvider;
import appworks.events.DatasourceFailureEvent;
import appworks.util.Constants;

/**
 * Fragments to show a detail view inside a {@link android.support.v4.app.Fragment}
 *
 * DetailFragments expect the {@link Constants#CONTENT} to be passed in
 * That argument is optional, given that you implement the {@link #getDatasource()}
 * method.
 */
public abstract class DetailFragment<T>
        extends BaseFragment
        implements Refreshable {

    int mItemPos;

    Datasource<T> mDatasource;

    T mItem;

    /**
     * Containers for views
     */
    View mContentContainer;

    View mProgressContainer;

    public DetailFragment() {
        super();
    }

    @Override
    @SuppressWarnings("unchecked")
    public void onCreate(Bundle state) {
        super.onCreate(state);
        Bundle args = getArguments();

        // restore state either from savedState or defaults
        if (state != null) {
            mItem = (T) state.getParcelable(Constants.CONTENT);
        }
        if (mItem == null) {
            mItem = (T) args.getParcelable(Constants.CONTENT);
        }

        mItemPos = args.getInt(Constants.ITEMPOS, 0);
    }

    /**
     * Trick to know when the fragment is being shown (onResume doesn't work for this when the
     * fragment is in the context of a viewpager)
     * This method is highly dependant on
     * {@link android.support.v4.app.FragmentStatePagerAdapter#setPrimaryItem(ViewGroup,
     * int, Object)}
     * but works in all cases.
     * {@inheritDoc}
     */
    @Override
    public void setMenuVisibility(boolean visible) {
        super.setMenuVisibility(visible);
        if (visible && mItem != null) {
            onShowCard(mItem);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
        View view = inflater.inflate(getLayout(), container, false);

        mProgressContainer = view.findViewById(R.id.progressContainer);
        mContentContainer = view.findViewById(R.id.contentContainer);

        return view;
    }

    @Override
    public void onViewCreated(View view, Bundle savedState) {
        super.onViewCreated(view, savedState);

        // we put this here to ensure all onCreate chain has been called,
        // and so getDatasource will return a valid (non null) value
        mDatasource = getDatasource();

        if (mItem != null) {
            bindView(mItem, view);
            setContentShown(true);
        } else {
            refresh();
        }
    }

    /**
     * Updates the item being shown, and perform the appropiate binding
     *
     * @param newItem the new item to show
     */
    public void setItem(T newItem) {
        mItem = newItem;

        View v = getView();
        if (v != null) {   // only bind to view if it already exists
            bindView(mItem, v);
            setContentShown(true);
            onShowCard(mItem);
        }
    }

    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        // save the current item into outState
        outState.putParcelable(Constants.CONTENT, (Parcelable) mItem);
    }

    @Override
    @SuppressWarnings("unchecked")
    public void onResume() {
        super.onResume();

        // update behaviors
        if (mBehaviors != null) {
            for (Behavior bhv : mBehaviors) {
                if (bhv instanceof ShareBehavior && mItem != null) {
                    ((ShareBehavior<T>) bhv).update(mItem);
                }
            }
        }

        if (mItem != null) {
            onShowCard(mItem);
        }
    }

    @Override
    public void onPause() {
        super.onPause();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();

        mDatasource = null;
        mItem = null;
    }

    // Refreshable interface
    public void refresh() {
        if (mDatasource != null) {
            setContentShown(false);
            mDatasource.getItem(String.valueOf(mItemPos), new Datasource.Listener<T>() {
                @Override
                public void onSuccess(final T result) {
                    mItem = result;
                    final View v = getView();
                    // force UI thread
                    Activity act = getActivity();
                    if (act != null) {
                        act.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                if (v != null)   // only bind to view if it already exists
                                {
                                    bindView(result, v);
                                }
                                setContentShown(true);
                            }
                        });
                    }
                }

                @Override
                public void onFailure(Exception e) {
                    // force UI thread
                    Activity act = getActivity();
                    if (act != null) {
                        act.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                // inform to users
                                BusProvider.getInstance().post(new DatasourceFailureEvent());
                                setContentShown(false);
                            }
                        });
                    }
                }
            });
        } else {
            throw new IllegalStateException("Either Item or Datasource should be implemented");
        }
    }

    private void setContentShown(boolean shown) {
        if (mProgressContainer != null && mContentContainer != null) {
            mProgressContainer.setVisibility(shown ? View.GONE : View.VISIBLE);
            mContentContainer.setVisibility(shown ? View.VISIBLE : View.GONE);
        }
    }

    /**
     * Gets the current item
     *
     * @return the current item, or null if it's not been retrieved yet
     */
    public T getItem() {
        return mItem;
    }

    /**
     * called when a view is ready to be binded to data, but maybe it's not
     * showing yet (i.e. in a {@link android.support.v4.view.ViewPager})
     *
     * @param item an instance of T data
     * @param view the view to bind data to
     */
    public abstract void bindView(T item, View view);

    /**
     * This method will return a datasource for data retrieval
     *
     * @return a datasource
     */
    public Datasource<T> getDatasource() {
        return null;
    }

    /**
     * Typed onResume event for fragment cards
     *
     * @param item the item being shown
     */
    protected abstract void onShowCard(T item);

    /**
     * The layout for this fragment
     * @return the layout id for this screen
     */
    protected abstract int getLayout();

}
