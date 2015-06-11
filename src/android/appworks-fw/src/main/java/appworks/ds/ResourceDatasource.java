/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ds;

import android.app.Application;
import android.content.Context;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import appworks.util.FilterUtils;

/**
 * StringArray datasource, backed by android's resources
 */
public class ResourceDatasource
        implements Datasource<String>,
        Count,
        Pagination<String> {

    static final int PAGE_SIZE = 20;

    private Context mContext;

    private int mResourceId;

    private List<String> mItems;

    /**
     * Create a datasource given a resource id
     *
     * @param context an application context. It's enforced to avoid potential memory leaks
     * @param resId   a valid String Array resource identifier
     */
    public ResourceDatasource(Application context, int resId) {
        this.mContext = context;
        this.mResourceId = resId;
    }

    @Override
    public void getItems(Listener<List<String>> listener) {
        listener.onSuccess(getResourceItems());
    }

    @Override
    public int getPageSize() {
        return PAGE_SIZE;
    }

    @Override
    public void getItem(String id, Listener<String> listener) {
        final int pos = Integer.parseInt(id);
        String dc = getResourceItems().get(pos);
        if (dc != null) {
            listener.onSuccess(dc);
        } else {
            listener.onFailure(new IllegalArgumentException("Item not found: " + pos));
        }
    }

    @Override
    public int getCount() {
        return getResourceItems().size();
    }

    @Override
    public void getItems(int pagenum, int pagesize, SearchOptions options,
            Listener<List<String>> listener) {
        int first = pagenum * pagesize;
        int last = first + pagesize;

        ArrayList<String> result = new ArrayList<String>();
        List<String> filteredList = applyFilterOptions(getResourceItems(), options);

        if (first < filteredList.size()) {
            for (int i = first; (i < last) && (i < filteredList.size()); i++) {
                result.add(filteredList.get(i));
            }
        }

        listener.onSuccess(result);
    }

    private List<String> getResourceItems() {
        if (mItems == null) {
            mItems = Arrays.asList(mContext.getResources().getStringArray(mResourceId));
        }

        return mItems;
    }

    private List<String> applyFilterOptions(List<String> result, SearchOptions options) {

        List<String> filteredList = new ArrayList<String>();

        //Searching options
        String searchText = options.getSearchText();
        if (searchText != null && !"".equals(searchText)) {
            for (String item : result) {
                if (FilterUtils.searchInString(item, searchText)) {
                    filteredList.add(item);
                }
            }
        } else {
            filteredList.addAll(result);
        }

        //Sorting options
        Comparator comparator = options.getSortComparator();
        if (comparator != null) {
            if (options.isSortAscending()) {
                Collections.sort(filteredList, comparator);
            } else {
                Collections.sort(filteredList, Collections.reverseOrder(comparator));
            }
        }

        return filteredList;
    }
}


