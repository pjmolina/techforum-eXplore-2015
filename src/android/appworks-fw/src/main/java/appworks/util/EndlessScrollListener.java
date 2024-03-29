/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.util;

import android.widget.AbsListView;

/**
 * Scroll listener for endless lists/grids
 * Simplified version of: https://github.com/thecodepath/android_guides/wiki/Endless-Scrolling-with-AdapterViews
 */
public abstract class EndlessScrollListener implements AbsListView.OnScrollListener {

    // The minimum amount of items to have below your current scroll position
    // before loading more.
    private int visibleThreshold = 5;

    // The current offset index of data you have loaded
    private int currentPage = 0;

    // The total number of items in the dataset after the last load
    private int previousTotalItemCount = 0;

    // True if we are still waiting for the last set of data to load.
    private boolean loading = false;

    // Sets the starting page index
    private int startingPageIndex = 0;

    public EndlessScrollListener() {
    }

    public EndlessScrollListener(int visibleThreshold) {
        this.visibleThreshold = visibleThreshold;
    }

    public EndlessScrollListener(int visibleThreshold, int startPage) {
        this.visibleThreshold = visibleThreshold;
        this.startingPageIndex = startPage;
        this.currentPage = startPage;
    }

    // This happens many times a second during a scroll, so be wary of the code you place here.
    // We are given a few useful parameters to help us work out if we need to load some more data,
    // but first we check if we are waiting for the previous load to finish.
    @Override
    public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount,
            int totalItemCount) {
        // If the total item count is zero assume the
        // list is invalidated and should be reset back to initial state
        if (totalItemCount == 0) {
            this.currentPage = this.startingPageIndex;
            return;
        }

        // if the last item is visible, load next batch
        if (!loading && (firstVisibleItem + visibleItemCount
                >= totalItemCount - visibleThreshold)) {
            loading = true;
            onLoadMore(++currentPage, totalItemCount);
        }
    }

    public void finishLoading() {
        this.loading = false;
    }

    // Defines the process for actually loading more data based on page
    public abstract void onLoadMore(int page, int totalItemsCount);

    @Override
    public void onScrollStateChanged(AbsListView view, int scrollState) {
        // Don't take any action on changed
    }
}