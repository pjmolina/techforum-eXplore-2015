/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ui;

import android.content.Intent;
import android.os.Bundle;
import android.os.Parcelable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v7.widget.Toolbar;

import appworks.R;
import appworks.util.Constants;
import appworks.util.FragmentUtils;

/**
 * Activity that uses a {@link android.widget.SpinnerAdapter} for main navigation, and a
 * {@link android.support.v4.view.ViewPager} for sibling navigation.
 * See the <a href="http://developer.android.com/guide/topics/ui/actionbar.html#Dropdown">
 * Drop down navigation pattern</a> and
 * <a href="http://developer.android.com/design/patterns/navigation.html#within-app">
 * Navigation within your app</a>
 */
public abstract class BaseDetailActivity extends BaseActivity {

    private Class<? extends Fragment> mFragmentClass;

    String mTitle;

    Parcelable mItem;

    @Override
    protected void onCreate(Bundle savedState) {
        super.onCreate(savedState);
        setContentView(R.layout.detail_activity);

        // enable up navigation
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        if(toolbar != null) {
            setSupportActionBar(toolbar);
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        }

        Intent intent = getIntent();
        mTitle = intent.getStringExtra(Constants.TITLE);
        mItem = intent.getParcelableExtra(Constants.CONTENT);

        if (mTitle != null) {
            setTitle(mTitle);
        }

        // this adapter is for fragment creation based on spinner selection
        Bundle args = new Bundle();
        if (mItem != null)   // pass the actual content if it is passed in to the activity
        {
            args.putParcelable(Constants.CONTENT, mItem);
        }

        loadFragment(args);
    }

    private void loadFragment(Bundle args){
        // setup navigation
        mFragmentClass = getFragmentClass();

        FragmentManager manager = getSupportFragmentManager();

        // show first (listing) page
        if (mFragmentClass != null) {
            String tag = this.getClass().getName();

            Fragment fr = manager.findFragmentByTag(tag);
            if (fr == null) {
                fr = FragmentUtils.instantiate(mFragmentClass, args);

                manager.beginTransaction()
                    .replace(R.id.content_frame, fr, tag)
                    .commit();
            }
        }

    }

    protected abstract Class<? extends Fragment> getFragmentClass();
}


