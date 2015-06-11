/*
 * This App has been generated using http://www.radarconline.com , the Bright Enterprise App Builder.
 */


package com.radarc.explore101.ui;

import android.os.Bundle;
import android.support.v4.app.Fragment;

import appworks.ui.DrawerActivity;
import appworks.events.ItemSelectedEvent;

import java.util.ArrayList;
import java.util.List;

import com.squareup.otto.Subscribe;

import appworks.actions.StartActivityAction;
import appworks.util.Constants;
import com.radarc.explore101.ds.AppnowItem;
import com.radarc.explore101.ds.AppnowSchema2Item;
import com.radarc.explore101.ds.AppnowSchema3Item;

public class EXplore101Main extends DrawerActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public Class<? extends Fragment>[] getSectionFragmentClasses() {
        return new Class[]{
            OfficesFragment.class,
            CountriesFragment.class,
            SolutionsFragment.class
        };
    }        

    @Override
    public String[] getSectionTitles() {
        return new String[]{
            "offices",
            "countries",
            "solutions"
        };
    }

    //List of navigation actions
    @Override
    public List<String> getNavigationActions() {
        List<String> actions = new ArrayList<String>();

        return actions;
    }

    //used to perform the navigation action based on its index on the actions list
    @Override
    public void callAction(int i) {

        switch (i){

        }
    }

    // Events
    @Subscribe
    public void onItemSelectedEvent(ItemSelectedEvent ev){
        if(ev.target instanceof AppnowSchema3Item && "OfficesFragment".equals(ev.tag)){
            AppnowSchema3Item item = (AppnowSchema3Item) ev.target;
            
            Bundle args = new Bundle();
            
            args.putInt(Constants.ITEMPOS, ev.position);
            args.putParcelable(Constants.CONTENT, item);
            new StartActivityAction(this, OfficesDetailActivity.class).execute(args);

        }
        if(ev.target instanceof AppnowItem && "CountriesFragment".equals(ev.tag)){
            AppnowItem item = (AppnowItem) ev.target;
            
            Bundle args = new Bundle();
            
            args.putInt(Constants.ITEMPOS, ev.position);
            args.putParcelable(Constants.CONTENT, item);
            new StartActivityAction(this, CountriesDetailActivity.class).execute(args);

        }
        if(ev.target instanceof AppnowSchema2Item && "SolutionsFragment".equals(ev.tag)){
            AppnowSchema2Item item = (AppnowSchema2Item) ev.target;
            
            Bundle args = new Bundle();
            
            args.putInt(Constants.ITEMPOS, ev.position);
            args.putParcelable(Constants.CONTENT, item);
            new StartActivityAction(this, SolutionsDetailActivity.class).execute(args);

        }
    }
}
