/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ui;

import android.content.res.Configuration;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.LinearLayout;
import android.widget.ListView;

import java.util.List;

import appworks.R;
import appworks.util.FragmentUtils;
import appworks.views.ActionView;

/**
 * Base activity for drawer-based navigations
 */
public abstract class DrawerActivity extends BaseActivity implements NavigationActivity {

    public static String DRAWER_POSITION_KEY = "DRAWER_POSITION";

    DrawerLayout mDrawerLayout;

    LinearLayout mLeftDrawer;

    ListView mDrawerListView;

    LinearLayout navActionsContainer;

    int lastPosition = -1;

    protected String[] mSections;

    protected ActionBarDrawerToggle mDrawerToggle;

    private Class<? extends Fragment>[] mFragments;

    private List<String> mNavActions;

    /**
     * ActionBar title
     */
    protected String mTitle;

    private FragmentManager mFragmentManager;

    private Toolbar mToolbar;

    private boolean mHasDrawer = false;

    @Override
    protected void onCreate(Bundle savedInstance) {
        super.onCreate(savedInstance);

        setContentView(R.layout.drawer_activity_main);

        // inject views
        mToolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(mToolbar);

        mDrawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
        mLeftDrawer = (LinearLayout) findViewById(R.id.left_drawer);
        mDrawerListView = (ListView) findViewById(R.id.drawer_listView);
        navActionsContainer = (LinearLayout) findViewById(R.id.nav_actions_container);

        mFragments = getSectionFragmentClasses();
        mNavActions = getNavigationActions();
        mSections = getSectionTitles();

        // setup drawer (if there are at least two sections, or at least one action)
        setupDrawer();

        mFragmentManager = getSupportFragmentManager();

        // select first item
        int currentItem = 0;
        if (savedInstance != null) {
            currentItem = savedInstance.getInt(DRAWER_POSITION_KEY, 0);
            lastPosition = currentItem;
        }

        //init the title to avoid null pointers when the device is rotated
        mTitle = mSections[currentItem];
        selectDrawerItem(currentItem);
    }

    private void setupDrawer(){
        mHasDrawer = mSections.length > 1 || (mNavActions != null && mNavActions.size() > 0);
        if(!mHasDrawer) {
            mDrawerLayout.setDrawerLockMode(DrawerLayout.LOCK_MODE_LOCKED_CLOSED);
        }
        else {
            mDrawerListView.setAdapter(new ArrayAdapter<String>(this,
                    android.R.layout.simple_list_item_1,
                    mSections));

            // item selected event
            mDrawerListView.setOnItemClickListener(new ListView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> adapterView, View view, int position,
                        long id) {
                    selectDrawerItem(position);
                    mDrawerListView.setItemChecked(position, true);
                    mDrawerLayout.closeDrawer(mLeftDrawer);
                }
            });

            //add the actions to the drawer
            setNavigationActions();

            // drawer open/close event
            mDrawerToggle = new ActionBarDrawerToggle(this,
                    mDrawerLayout,
                    mToolbar,
                    R.string.drawer_open,
                    R.string.drawer_close) {

                @Override
                public void onDrawerClosed(View drview) {
                    super.onDrawerClosed(drview);
                    getSupportActionBar().setTitle(mTitle);
                    // forces a call to prepareOptionsMenu
                    supportInvalidateOptionsMenu();
                }

                @Override
                public void onDrawerOpened(View drview) {
                    super.onDrawerOpened(drview);
                    // save current title
                    mTitle = getSupportActionBar().getTitle().toString();
                    getSupportActionBar().setTitle(R.string.app_name);

                    // forces a call to prepareOptionsMenu
                    supportInvalidateOptionsMenu();
                }
            };

            mDrawerLayout.setDrawerListener(mDrawerToggle);
        }
    }

    @Override
    public void onSaveInstanceState(Bundle bundle) {
        super.onSaveInstanceState(bundle);
        bundle.putInt(DRAWER_POSITION_KEY, lastPosition);
    }

    @Override
    public void onPostCreate(Bundle bundle) {
        super.onPostCreate(bundle);

        //Syncs the drawer indicator
        if(mHasDrawer)
            mDrawerToggle.syncState();
    }

    @Override
    public boolean onPrepareOptionsMenu(Menu menu) {
        if(mHasDrawer) {
            boolean drawerIsOpen = mDrawerLayout.isDrawerOpen(mLeftDrawer);

            // if the drawer is open, hide all options
            if (drawerIsOpen) {
                for (int index = 0; index < menu.size(); index++) {
                    MenuItem item = menu.getItem(index);
                    item.setVisible(false);
                }
            }
        }
        return super.onPrepareOptionsMenu(menu);
    }

    @Override
    public void onConfigurationChanged(Configuration config) {
        super.onConfigurationChanged(config);

        // Pass the config object to the drawer toggle
        if(mHasDrawer)
            mDrawerToggle.onConfigurationChanged(config);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Pass the event to ActionBarDrawerToggle, if it returns
        // true, then it has handled the app icon touch event
        return (mDrawerToggle != null && mDrawerToggle.onOptionsItemSelected(item))
                || super.onOptionsItemSelected(item);
    }

    public void selectDrawerItem(int position) {
        // only replace fragment if it is not the same
        if (position != lastPosition) {
            lastPosition = position;
            String tag = "FrDrawer" + position;
            Fragment fr = mFragmentManager.findFragmentByTag(tag);
            if (fr == null) {
                fr = FragmentUtils.instantiate(mFragments[position], new Bundle());
            }

            FragmentTransaction replaceTransaction = mFragmentManager.beginTransaction();
            replaceTransaction.replace(R.id.content_frame, fr, tag);
            replaceTransaction.commit();

            // change title in case the section has changed
            mTitle = mSections[position];
        }
    }

    public void setNavigationActions() {
        for (String action : mNavActions) {
            final ActionView actionView = new ActionView(this);
            actionView.setText(action);
            actionView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    callAction(((ViewGroup) actionView.getParent()).indexOfChild(actionView));
                }
            });

            navActionsContainer.addView(actionView);
        }
    }
}
