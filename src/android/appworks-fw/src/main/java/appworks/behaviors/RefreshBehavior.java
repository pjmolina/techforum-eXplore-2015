/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.behaviors;

import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;

import appworks.R;
import appworks.ui.Refreshable;

/**
 * Add refresh pattern to lists
 */
public class RefreshBehavior extends AbstractBehavior {

    private Refreshable mFragment;

    public RefreshBehavior(Refreshable fragment) {
        mFragment = fragment;
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        inflater.inflate(R.menu.refresh_menu, menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == R.id.action_refresh) {
            mFragment.refresh();
            return true;
        }
        return false;
    }
}
