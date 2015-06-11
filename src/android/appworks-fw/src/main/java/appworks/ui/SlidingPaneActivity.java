/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ui;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.widget.SlidingPaneLayout;
import android.view.MenuItem;
import android.view.View;
import android.widget.FrameLayout;

import appworks.R;
import appworks.util.Constants;
import appworks.util.FragmentUtils;

/**
 * Base class for Master-Detail sliding pane activities
 */
public abstract class SlidingPaneActivity extends BaseActivity {

    private FragmentManager mFragmentManager;

    private SlidingPaneLayout mSlidingPane;

    private FrameLayout mListPane;

    private FrameLayout mDetailPane;

    private CharSequence mActivityTitle;

    private Class<? extends Fragment> mFragmentClass;

    @Override
    protected void onCreate(Bundle savedInstance) {
        super.onCreate(savedInstance);
        setContentView(R.layout.sliding_pane_activity);

        // save title for later restoration
        mActivityTitle = getTitle();

        // Sliding pane
        mSlidingPane = (SlidingPaneLayout) findViewById(R.id.slidingPane);
        mSlidingPane.setParallaxDistance(50);
        mSlidingPane.setShadowResourceLeft(R.drawable.sliding_pane_shadow);
        mSlidingPane.setPanelSlideListener(new PaneListener());

        mSlidingPane.openPane();

        mListPane = (FrameLayout) findViewById(R.id.content_frame);
        mDetailPane = (FrameLayout) findViewById(R.id.detail_frame);

        mFragmentManager = getSupportFragmentManager();

        // enable up navigation
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        // setup navigation
        mFragmentClass = getFragmentClass();

        // show first (listing) page
        if (mFragmentClass != null) {
            String tag = this.getClass().getName();

            Fragment fr = mFragmentManager.findFragmentByTag(tag);
            if (fr == null) {
                fr = FragmentUtils.instantiate(mFragmentClass, new Bundle());

                mFragmentManager.beginTransaction()
                        .replace(R.id.content_frame, fr, tag)
                        .commit();
            }
        }
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                finish();
                return true;
            default:
                break;
        }

        return super.onOptionsItemSelected(item);
    }

    @SuppressWarnings("unchecked")
    public void navigateToDetail(Class detailActivityClass, Class detailFragment, Bundle args) {

        DetailFragment fr = (DetailFragment) mFragmentManager.findFragmentById(R.id.detail_frame);
        if (fr == null) {
            mFragmentManager.beginTransaction()
                    .replace(R.id.detail_frame, FragmentUtils.instantiate(detailFragment, args))
                    .commit();
        } else {
            fr.setItem(args.getParcelable(Constants.CONTENT));
        }
        mSlidingPane.closePane();
    }

    /**
     * Update action bar actions
     *
     * @param isOpen whether the sliding pane is opened
     */
    private void showActions(boolean isOpen) {
        Fragment fr = mFragmentManager.findFragmentById(R.id.content_frame);
        if (fr != null) {
            fr.setHasOptionsMenu(isOpen);
        }

        fr = mFragmentManager.findFragmentById(R.id.detail_frame);
        if (fr != null) {
            fr.setHasOptionsMenu(!isOpen);
        }
    }

    private class PaneListener implements SlidingPaneLayout.PanelSlideListener {

        @Override
        public void onPanelClosed(View view) {
            showActions(false);
        }

        @Override
        public void onPanelOpened(View view) {
            setTitle(mActivityTitle);
            showActions(true);
        }

        @Override
        public void onPanelSlide(View view, float arg1) {
        }
    }

    /**
     * Get the fragment for this listing
     * @return
     */
    protected abstract Class<? extends Fragment> getFragmentClass();

}
