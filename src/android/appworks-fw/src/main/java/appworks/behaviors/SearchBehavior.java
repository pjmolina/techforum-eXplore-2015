/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.behaviors;

import android.support.v4.view.MenuItemCompat;
import android.support.v7.widget.SearchView;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;

import appworks.R;
import appworks.ui.Filterable;

/**
 * Adds an action bar search interface
 */
public class SearchBehavior<T> extends AbstractBehavior {

    Filterable mFilterable;

    SearchView searchView;

    public SearchBehavior(Filterable f) {
        mFilterable = f;
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        inflater.inflate(R.menu.search_menu, menu);
        MenuItem searchMenuItem = menu.findItem(R.id.search);
        searchView = (SearchView) MenuItemCompat.getActionView(searchMenuItem);

        if (searchView != null) {
            searchView.setOnQueryTextListener(new SearchView.OnQueryTextListener() {
                @Override
                public boolean onQueryTextSubmit(String s) {
                    refreshSearch(s);
                    return false;
                }

                @Override
                public boolean onQueryTextChange(String s) {
                    if (s.equals("")) {
                        refreshSearch(null);
                    }
                    return false;
                }
            });

            MenuItemCompat.setOnActionExpandListener(searchMenuItem,
                    new MenuItemCompat.OnActionExpandListener() {
                        @Override
                        public boolean onMenuItemActionExpand(MenuItem menuItem) {
                            //nothing to override
                            return true;
                        }

                        @Override
                        public boolean onMenuItemActionCollapse(MenuItem menuItem) {
                            //reset the filtering string
                            refreshSearch(null);
                            return true;
                        }
                    });
        }
    }

    public void refreshSearch(String newFilter) {
        //set the filtering string
        mFilterable.setSearchText(newFilter);
        //refresh data after apply the filter
        mFilterable.refresh();
    }
}
