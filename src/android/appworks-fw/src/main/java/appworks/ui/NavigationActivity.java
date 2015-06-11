/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ui;

import android.support.v4.app.Fragment;

import java.util.List;

/**
 * Interface for Navigation activities. Navigation Activities are mainly used for the upper
 * navigation level, and are composed by sectionns, implemnented as {@link
 * Fragment}.
 * Navigation between sections is up to concrete implementations.
 * Each concrete activity may implement its own navigation pattern.
 * See {@link DrawerActivity}
 */
public interface NavigationActivity {

    /**
     * Get the array of fragment classes that implements each section
     * @return an array of fragment classes
     */
    public Class<? extends Fragment>[] getSectionFragmentClasses();

    /**
     * Get the section titles
     * @return an array of strings
     */
    public String[] getSectionTitles();

    /**
     * Get an array of custom actions to be created in this navigation activity
     * @return the list of custom actions
     */
    public List<String> getNavigationActions();

    /**
     * Calls an action
     * @param i the action index
     */
    public void callAction(int i);
}
