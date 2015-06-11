/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ui;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.widget.Toolbar;
import android.view.ActionMode;
import android.view.Menu;
import android.view.MenuItem;

import appworks.R;
import appworks.util.Constants;
import appworks.util.FragmentUtils;

/**
 * Base class for Listing Activities
 */
public abstract class BaseListingActivity
        extends BaseActivity{

    private Class<? extends Fragment> mFragmentClass;

    private FragmentManager mFragmentManager;

    Toolbar mToolbar;

    @Override
    protected void onCreate(Bundle savedInstance) {
        super.onCreate(savedInstance);
        setContentView(R.layout.listing_activity);

        mFragmentManager = getSupportFragmentManager();

        // enable up navigation
        mToolbar = (Toolbar) findViewById(R.id.toolbar);
        if(mToolbar != null) {
            setSupportActionBar(mToolbar);
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        }

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

        if (getResources().getBoolean(R.bool.tabletLayout)) {

            DetailFragment fr = (DetailFragment) mFragmentManager
                    .findFragmentById(R.id.detail_frame);
            if (fr == null) {
                FragmentTransaction replaceTransaction = mFragmentManager.beginTransaction();
                replaceTransaction.replace(R.id.detail_frame,
                        FragmentUtils.instantiate(detailFragment, args));
                replaceTransaction.commit();
            } else {
                fr.setItem(args.getParcelable(Constants.CONTENT));
            }
        } else {
            // show detail activity.
            Intent intent = new Intent(this, detailActivityClass);
            intent.putExtras(args);
            startActivity(intent);
        }
    }

    /**
     * get the fragment associated with this activity
     * @return
     */
    protected abstract Class<? extends Fragment> getFragmentClass();
}
