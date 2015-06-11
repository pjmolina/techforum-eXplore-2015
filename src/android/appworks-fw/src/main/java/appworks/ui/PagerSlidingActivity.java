/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ui;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.widget.Toolbar;

import appworks.R;
import appworks.util.FragmentUtils;
import appworks.views.SlidingTabLayout;

/**
 * Activity with {@link SlidingTabLayout}
 */
public abstract class PagerSlidingActivity extends ActionBarActivity implements NavigationActivity {

    ViewPager mPager;

    private Class<? extends Fragment>[] mFragments;

    private String[] mTitles;

    private SlidingTabLayout mTabs;

    @Override
    protected void onCreate(Bundle savedState) {
        super.onCreate(savedState);
        setContentView(R.layout.pager_sliding_activity);

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        if(toolbar != null) {
            setSupportActionBar(toolbar);
        }

        // inject views
        mPager = (ViewPager) findViewById(R.id.pager);
        mTabs = (SlidingTabLayout) findViewById(R.id.tabs);
        mFragments = getSectionFragmentClasses();   // implemented in child classes
        mTitles = getSectionTitles();               // implemented in child classes

        PagerAdapter adapter = new FragmentPagerAdapter(getSupportFragmentManager()){

            @Override
            public Fragment getItem(int i) {
                return FragmentUtils.instantiate(mFragments[i], new Bundle());
            }

            @Override
            public int getCount() {
                return mFragments.length;
            }

            @Override
            public String getPageTitle(int i){
                return mTitles[i];
            }
        };

        mPager.setAdapter(adapter);
        mTabs.setViewPager(mPager);
    }
}


