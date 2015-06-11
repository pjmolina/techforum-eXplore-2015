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
import com.radarc.explore101.ds.AppnowSchema3Item;

/**
 * OfficesActivity list activity
 */
public class OfficesActivity extends BaseListingActivity {

    private FragmentManager mFragmentManager;

    @Override
    protected void onCreate(Bundle savedInstance){
        super.onCreate(savedInstance);
        // at this point the first (list) fragment is shown

        mFragmentManager = getSupportFragmentManager();

        setTitle(getString(R.string.officesActivity));
    }

    @Override
    protected Class<? extends Fragment> getFragmentClass() {
        return OfficesFragment.class;
    }

    // Event Listener
    @Subscribe
    public void onItemSelected(ItemSelectedEvent ev){
        if(ev.target instanceof AppnowSchema3Item && "OfficesFragment".equals(ev.tag)){
            AppnowSchema3Item item = (AppnowSchema3Item) ev.target;
            
            Bundle args = new Bundle();
            
            args.putInt(Constants.ITEMPOS, ev.position);
            args.putParcelable(Constants.CONTENT, item);
            navigateToDetail(OfficesDetailActivity.class, OfficesDetailFragment.class, args);

        }
    }
}

