/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.behaviors;

import android.database.DataSetObserver;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;

import java.lang.ref.WeakReference;

import appworks.ui.ListGridFragment;

/**
 * Pull to refresh pattern for listing fragments
 */
public class SwipeRefreshBehavior extends AbstractBehavior
        implements SwipeRefreshLayout.OnRefreshListener {

    private SwipeRefreshLayout mSwipeRefreshLayout;

    private WeakReference<ListGridFragment> mWeakFragment;

    public SwipeRefreshBehavior(ListGridFragment<?> fragment) {
        this.mWeakFragment = new WeakReference<ListGridFragment>(fragment);
    }

    @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        ListGridFragment fr = mWeakFragment.get();

        if (fr != null) {
            //setup
            mSwipeRefreshLayout = new SwipeRefreshLayout(fr.getActivity());
            mSwipeRefreshLayout.setOnRefreshListener(this);

            //layout modification
            AbsListView listView = (AbsListView) view.findViewById(android.R.id.list);
            ViewGroup parent = ((ViewGroup) listView.getParent());
            parent.removeView(listView);
            parent.addView(mSwipeRefreshLayout, 0);
            mSwipeRefreshLayout.addView(listView);

            //color customization
            mSwipeRefreshLayout.setColorSchemeResources(android.R.color.holo_blue_bright,
                    android.R.color.holo_green_light,
                    android.R.color.holo_orange_light,
                    android.R.color.holo_red_light);
        }
    }

    @Override
    public void onRefresh() {
        ListGridFragment fr = mWeakFragment.get();

        if (fr != null) {
            fr.getAdapter().registerDataSetObserver(new DataSetObserver() {
                // wait async for completion
                @Override
                public void onChanged() {
                    super.onChanged();
                    mSwipeRefreshLayout.setRefreshing(false);
                }
            });
            fr.refresh();
        }

    }
}
