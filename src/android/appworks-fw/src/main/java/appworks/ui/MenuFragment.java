/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ui;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.List;

import appworks.MenuItem;
import appworks.R;
import appworks.actions.Action;
import appworks.events.BusProvider;
import appworks.events.ItemSelectedEvent;
import appworks.util.ImageLoader;

/**
 * Fragment that represent Appworks' Menu Pages
 * These fragments has 3 possible layouts: list, list with image and grid (2-cols)
 */
public abstract class MenuFragment extends BaseFragment implements AbsListView.OnItemClickListener {

    /**
     * The Adapter which will be used to populate the ListView/GridView with
     * Views.
     */
    private List<MenuItem> mMenuItems;

    private AbsListView mList;

    @Override
    public void onCreate(Bundle savedInstance) {
        super.onCreate(savedInstance);

        mMenuItems = getMenuItems();
    }

    @Override
    @SuppressWarnings("unchecked")
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {

        View view = inflater.inflate(getLayout(), container, false);

        mList = (AbsListView) view.findViewById(android.R.id.list);
        if (mList == null) {
            throw new IllegalStateException("Layout is not a menu layout");
        }

        // set adapter
        ((AdapterView) mList).setAdapter(getAdapter());

        // bind clicklistener
        mList.setOnItemClickListener(this);

        return view;
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        mList = null;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        mMenuItems = null;
    }

    private ArrayAdapter<MenuItem> getAdapter() {
        MenuItem[] pagesArr = mMenuItems.toArray(new MenuItem[]{});

        return new ArrayAdapter<MenuItem>(getActivity(),
                getItemLayout(),
                android.R.id.text1, // all layouts have a TextView field with id "text1"
                pagesArr) {

            @Override
            public View getView(int position, View convertView, ViewGroup container) {
                View v; // = super.getView(position, convertView, container);
                if (convertView != null) {
                    v = convertView;
                } else {
                    v = getActivity().getLayoutInflater()
                            .inflate(getItemLayout(), container, false);
                }

                defaultItemBinding(getItem(position), v);
                return v;
            }
        };
    }

    // specific bindings for menu pages
    private void defaultItemBinding(MenuItem item, View view) {

        ImageView image = (ImageView) view.findViewById(R.id.image);
        if(image != null) {
            if (item.getIconUrl() != null) {
                ImageLoader.load(getActivity(), item.getIconUrl(), image);
            } else {
                image.setImageResource(item.getIcon());
            }
        }

        TextView text = (TextView) view.findViewById(R.id.title);
        if(text != null)
            text.setText(item.getLabel());
    }

    // OnItemClickListener interface
    @Override
    public void onItemClick(AdapterView<?> adapterView, View view, int position, long id) {
        // broadcast event
        BusProvider.getInstance()
                .post(new ItemSelectedEvent(position, this.getClass().getSimpleName(),
                        mMenuItems.get(position)));
        // execute local action
        executeAction(mMenuItems.get(position), position);
    }


    /**
     * invoke the action to execute when an item is selected
     *
     * @param item     the menu item
     * @param position the position in the menu
     */
    public void executeAction(MenuItem item, int position) {
        Action cmd = item.getAction();
        if (cmd != null) {
            cmd.execute(null);
        }
    }

    // delegates

    /**
     * get this menu's items. Only Page label is used, since the layout is inferred from parent
     *
     * @return the list of menu items
     */
    public abstract List<MenuItem> getMenuItems();

    /**
     * Gets the layout for this fragment
     * @return a valid layout for menus
     */
    public abstract int getLayout();

    /**
     * Gets the layout for this menu items
     * @return the resource id for item layouts
     */
    public abstract int getItemLayout();
}
