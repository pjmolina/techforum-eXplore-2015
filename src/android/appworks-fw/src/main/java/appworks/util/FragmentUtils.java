/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.util;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.lang.reflect.Method;

import appworks.Screen;
import appworks.R;

/**
 * Utils for fragment instantiation
 */
public class FragmentUtils {

    // fragment instantiation
    public static Fragment instantiate(Class<? extends Fragment> clazz, Bundle defaults) {
        try {
            Method method = clazz.getMethod("newInstance", Bundle.class);
            return (Fragment) method.invoke(null, defaults);
        } catch (Exception e) {
            Log.d("AppWorks", "Exception instantiating the fragment [" + clazz.getName() + "]");
            throw new IllegalArgumentException("Couldn't instantie fragment: + clazz.getName()", e);
        }
    }

    /**
     * Get a view from a {@link Screen} spec
     *
     * @param inflater the inflater used to inflate layouts
     * @param root     the container
     * @param screen     the page spec
     * @return a view representing that page specification
     * @deprecated use resource layouts instead
     */
    public static View newView(LayoutInflater inflater, ViewGroup root, Screen screen) {
        return newView(inflater, root, screen.getLayout());
    }

    /**
     * Inflates a view given a {@link Screen} object
     * @param inflater a layout inflater
     * @param root the container
     * @param screen the screen specification
     * @return the inflated layout
     * @deprecated use the inflater with a layout resource instead
     */
    public static View newView(LayoutInflater inflater, ViewGroup root, Screen.Layout screen) {
        switch (screen) {

            case WEB:
                return inflater.inflate(R.layout.detail_webview, root, false);

            // menu
            case MENU_GRID_2COLS:
                return inflater.inflate(R.layout.fragment_grid, root, false);
            case MENU_NO_PHOTO:
            case MENU_PHOTO_LEFT:
                return inflater.inflate(R.layout.fragment_list, root, false);

            // listings
            case LIST_NO_PHOTO:     // title/subtitle
            case LIST_PHOTO_LEFT:    // title/subtitle/image
            case LIST_PHOTO_LEFT_CONTENT:    // title/subtitle/image/content
            case LIST_BIG_PICTURES:       // title/subtitle/image
            case LIST_HORIZONTAL_CARDS:  // title/subtitle/image
            case LIST_BIG_CARDS:         // title/subtitle/image
            case LIST_OVERLAY_CARDS: // title/subtitle/image
                return inflater.inflate(R.layout.fragment_list, root, false);
            case LIST_PHOTO_3COLS:        // image
                return inflater.inflate(R.layout.fragment_grid_3cols, root, false);
            case LIST_PHOTO_4COLS:         // image
                return inflater.inflate(R.layout.fragment_grid_4cols, root, false);

            default:
                throw new IllegalArgumentException(
                        "Invalid layout for Fragment: " + screen.name());
        }
    }

        /**
         * get the layout for list/grid items
         *
         * @param screen the page object describing the layout
         * @return the layout id for that list/grid item
         * @deprecated use resource layouts instead
         */
    public static int getItemLayout(Screen screen) {
        return getItemLayout(screen.getLayout());
    }

    /**
     * Gets the resource id from a given layout
     * @param layout the layout (@see {Screen.Layout})
     * @return a resource id
     * @deprecated use resources directly
     */
    public static int getItemLayout(Screen.Layout layout){
        switch (layout) {
            case MENU_GRID_2COLS:
                return R.layout.menu_item_grid;
            case MENU_PHOTO_LEFT:
                return R.layout.menu_item_photoleft;
            case MENU_NO_PHOTO:
                return R.layout.menu_item_nophoto;
            case LIST_NO_PHOTO:
                return R.layout.list_item_nophoto;
            case LIST_PHOTO_LEFT:
                return R.layout.list_item_photoleft;
            case LIST_PHOTO_LEFT_CONTENT:
                return R.layout.list_item_photoleft_content;
            case LIST_HORIZONTAL_CARDS:
                return R.layout.list_item_horizontalcard;
            case LIST_BIG_CARDS:
                return R.layout.list_item_bigcard;
            case LIST_OVERLAY_CARDS:
                return R.layout.list_item_overlaycard;
            case LIST_PHOTO_3COLS:
                return R.layout.list_item_grid;
            case LIST_PHOTO_4COLS:
                return R.layout.list_item_grid;
            case LIST_BIG_PICTURES:
                return R.layout.listing_item_bigpictures;
            default:
                return android.R.layout.simple_list_item_1;
        }
    }
}
