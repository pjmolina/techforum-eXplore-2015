/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks;

import android.os.Parcel;
import android.os.Parcelable;
import android.support.v4.app.Fragment;

import appworks.actions.Action;

/**
 * A Screen is an abstraction that helps app developers to describe the structure and navigation of
 * an application. A screen consist on a descriptive label, a layout (for menus, listings and
 * details),
 * an image (for menus), an action (for menus), and a fragment (for showing its contents).
 * All those attributes are mandatory depending on the context.
 * Some examples,
 * <ul>
 * <li>a menu will use a label, an action and (optionally) an image</li>.
 * <li>Similarly {@link appworks.ui.BaseListingActivity} subclasses will use a label,
 * a layout and a fragment (an instance of {@link appworks.ui.ListGridFragment} or other).</li>
 * </ul>
 */
public class Screen implements Parcelable {

    /**
     * page name
     */
    String label;

    /**
     * Layout type
     */
    Layout layout;

    /**
     * An image resource for this page
     */
    int imageResource;

    /**
     * The class of the fragment represented by this page
     */
    Class<Fragment> fragmentClass;

    /**
     * The action to execute, for menu items
     */
    Action action;

    public String getLabel() {
        return label;
    }

    public Screen setLabel(String label) {
        this.label = label;
        return this;
    }

    public Layout getLayout() {
        return layout;
    }

    public Screen setLayout(Layout layout) {
        this.layout = layout;
        return this;
    }

    public int getImage() {
        return imageResource;
    }

    public Screen setImage(int imgRes) {
        this.imageResource = imgRes;
        return this;
    }

    public Action getAction() {
        return action;
    }

    public Screen setAction(Action action) {
        this.action = action;
        return this;
    }

    public Class<Fragment> getFragmentClass() {
        return fragmentClass;
    }

    public Screen setFragmentClass(Class fragmentClass) {
        this.fragmentClass = fragmentClass;
        return this;
    }

    public String toString() {
        return this.label;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel parcel, int flags) {
        parcel.writeString(label);
        parcel.writeInt(layout.ordinal());
        parcel.writeInt(imageResource);
    }

    public static final Creator CREATOR = new Creator() {

        @Override
        public Object createFromParcel(Parcel parcel) {
            Screen res = new Screen();
            res.setLabel(parcel.readString());
            res.setLayout(Layout.values()[parcel.readInt()]);
            res.setImage(parcel.readInt());

            return res;
        }

        @Override
        public Object[] newArray(int size) {
            return new Screen[size];
        }
    };

    /**
     * layout to apply in case of list/grid and detail view
     */
    public static enum Layout {
        // menupages
        MENU_NO_PHOTO,           // list/grid
        MENU_PHOTO_LEFT,         // list/grid
        MENU_GRID_2COLS,         // grid

        // lists
        LIST_NO_PHOTO,      // title/subtitle
        LIST_PHOTO_LEFT,    // title/subtitle/image
        LIST_PHOTO_LEFT_CONTENT,    // title/subtitle/image/content
        LIST_BIG_PICTURES,       // title/subtitle/image
        LIST_HORIZONTAL_CARDS,   // title/subtitle/image
        LIST_BIG_CARDS,          // title/subtitle/image
        LIST_OVERLAY_CARDS, // title/subtitle/image
        LIST_PHOTO_3COLS,        // image
        LIST_PHOTO_4COLS,         // image

        // detail
        CONTENT,
        TITLE_CONTENT,
        IMAGE,
        IMAGE_CONTENT,
        TITLE_IMAGE_CONTENT,
        IMAGE_TITLE_CONTENT,
        WEB,
        NONE,

        // todo: take this out of here
        // Charts
        CHART_PIE,
        CHART_BARS,
        CHART_LINES,

        // call
        CALL
    }
}
