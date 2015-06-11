/*
 * This App has been generated using http://www.radarconline.com , the Bright Enterprise App Builder.
 */


package com.radarc.explore101.ui;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;

import com.radarc.explore101.R;
import com.squareup.otto.Subscribe;

import appworks.events.ItemSelectedEvent;
import appworks.ui.BaseListingActivity;

import appworks.actions.StartActivityAction;
import appworks.util.Constants;
import com.radarc.explore101.ds.AppnowItem;

/**
 * CountriesActivity list activity
 */
public class CountriesActivity extends BaseListingActivity {

    private FragmentManager mFragmentManager;

    @Override
    protected void onCreate(Bundle savedInstance){
        super.onCreate(savedInstance);
        // at this point the first (list) fragment is shown

        mFragmentManager = getSupportFragmentManager();

        setTitle(getString(R.string.countriesActivity));
    }

    @Override
    protected Class<? extends Fragment> getFragmentClass() {
        return CountriesFragment.class;
    }

    // Event Listener
    @Subscribe
    public void onItemSelected(ItemSelectedEvent ev){
        if(ev.target instanceof AppnowItem && "CountriesFragment".equals(ev.tag)){
            AppnowItem item = (AppnowItem) ev.target;
            
            Bundle args = new Bundle();
            
            args.putInt(Constants.ITEMPOS, ev.position);
            args.putParcelable(Constants.CONTENT, item);
            navigateToDetail(CountriesDetailActivity.class, CountriesDetailFragment.class, args);

        }
    }
}

