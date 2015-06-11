/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ui;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;

import java.util.ArrayList;
import java.util.List;

import appworks.Screen;
import appworks.actions.Action;
import appworks.behaviors.Behavior;
import appworks.events.BusProvider;
import appworks.util.FragmentUtils;

/**
 * Base fragment with common support code (bus registration, etc)
 */
public class BaseFragment extends Fragment {

    protected List<Behavior> mBehaviors;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // we want to add buttons to the actionbar
        setHasOptionsMenu(true);
    }

    // fragment lifecygle

    @Override
    public void onResume() {
        super.onResume();
        BusProvider.getInstance().register(this);

        // intialize behaviors
        if (mBehaviors != null) {
            for (Behavior b : mBehaviors) {
                b.init();
            }
        }
    }

    @Override
    public void onPause() {
        super.onResume();
        BusProvider.getInstance().unregister(this);

        // shutdown behaviors
        if (mBehaviors != null) {
            for (Behavior b : mBehaviors) {
                b.shutdown();
            }
        }
    }

    @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        if (mBehaviors != null) {
            for (Behavior b : mBehaviors) {
                b.onViewCreated(view, savedInstanceState);
            }
        }
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        if (mBehaviors != null) {
            for (Behavior b : mBehaviors) {
                b.onCreateOptionsMenu(menu, inflater);
            }
        }
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        boolean managed = false;
        if (mBehaviors != null) {
            for (Behavior b : mBehaviors) {
                managed = managed || b.onOptionsItemSelected(item);
            }
        }

        return managed || super.onOptionsItemSelected(item);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if(mBehaviors != null){
            for (Behavior b : mBehaviors){
                b.onActivityResult(requestCode, resultCode, data);
            }
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();

        // clear resources
        if (mBehaviors != null) {
            mBehaviors.clear();
        }
        mBehaviors = null;
    }

    // layout creation methods.

    /**
     * Get a view from a {@link Screen} spec
     *
     * @param inflater the inflater used to inflate layouts
     * @param root     the container
     * @param screen     the page spec
     * @return a view representing that page specification
     * @deprecated use resource layouts instead
     */
    protected View newView(LayoutInflater inflater, ViewGroup root, Screen screen) {
        return FragmentUtils.newView(inflater, root, screen);
    }

    /**
     * get the layout for list/grid items
     *
     * @param screen the page object describing the layout
     * @return the layout id for that list/grid item
     * @deprecated use resource layouts instead
     */
    protected int getItemLayout(Screen screen) {
        return FragmentUtils.getItemLayout(screen);
    }

    /**
     * Adds a {@link Behavior} to this fragment
     *
     * @param behavior the behavior to add to this fragment
     */
    public void addBehavior(Behavior behavior) {
        if (mBehaviors == null) {
            mBehaviors = new ArrayList<Behavior>();
        }

        this.mBehaviors.add(behavior);
    }

    /**
     * Binds a view to an action, so that the action is executed on click event
     *
     * @param view   the view to bind the action to
     * @param action the action to bind to the view
     */
    protected void bindAction(View view, final Action action) {
        view.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                action.execute(null);
            }
        });
    }
}
