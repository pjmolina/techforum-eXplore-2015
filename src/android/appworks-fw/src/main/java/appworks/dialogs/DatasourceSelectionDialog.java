/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.dialogs;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.support.v7.widget.SearchView;
import android.util.SparseBooleanArray;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.CheckedTextView;
import android.widget.ListView;

import java.util.ArrayList;

import appworks.R;
import appworks.adapters.DatasourceAdapter;
import appworks.ds.Datasource;
import appworks.ds.Pagination;
import appworks.util.EndlessScrollListener;
import appworks.util.ViewHolder;

/**
 * Simple dialog that display a datasource-backed multiselection list
 * Developers must subclass appropriately. This is usefull for master-detail selection scenarios
 *
 */
public abstract class DatasourceSelectionDialog<T> extends SelectionDialog {

    DatasourceAdapter mAdapter;

    ListView mListView;

    boolean multipleChoice = false;

    boolean haveSearch = true;

    SelectionListener mListener;

    ArrayList<String> checkedValues;

    // this is NOT Filterable interface, but a custom filter for datasources
    boolean isFiltering = false;

    private Datasource mDatasource;

    public DatasourceSelectionDialog() {
        // default constructor
    }

    @Override
    public Dialog onCreateDialog(Bundle savedInstance) {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());

        // Get the layout inflater
        LayoutInflater inflater = getActivity().getLayoutInflater();

        // Set up the listview
        View view = inflater.inflate(R.layout.selection_dialog, null);
        mListView = (ListView) view.findViewById(android.R.id.list);

        mAdapter = createAdapter();
        mListView.setAdapter(mAdapter);
        mAdapter.setCallback(new DatasourceAdapter.Callback() {
            @Override
            public void onDataAvailable() {
                if (mEndlessScrollListener != null) {
                    mEndlessScrollListener.finishLoading();
                }
            }

            @Override
            public void onPageRequested() {}
        });

        // set single or multiple selection mode
        mListView.setChoiceMode(
                multipleChoice ? AbsListView.CHOICE_MODE_MULTIPLE : AbsListView.CHOICE_MODE_SINGLE);

        if (haveSearch) {
            SearchView searchView = (SearchView) view.findViewById(R.id.search);
            searchView.setVisibility(View.VISIBLE);

            searchView.setOnQueryTextListener(new SearchView.OnQueryTextListener() {
                @Override
                public boolean onQueryTextSubmit(String s) {
                    if (!"".equals(s)) {
                        isFiltering = true;
                        doSearch(s);
                        return true;
                    }
                    return false;
                }

                @Override
                public boolean onQueryTextChange(String s) {
                    return false;
                }
            });

            searchView.setOnCloseListener(new SearchView.OnCloseListener() {
                @Override
                public boolean onClose() {
                    if (isFiltering) {
                        doSearch("");
                        isFiltering = false;
                        return true;
                    }
                    return false;
                }
            });
        }

        // add an OK button and listener
        Button okBtn = (Button) view.findViewById(R.id.search_btn);
        okBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                DatasourceSelectionDialog.this.dismiss();
            }
        });

        checkedValues = getArguments().getStringArrayList(INITIAL_VALUES);

        builder.setTitle(getTitle())
                .setView(view);

        return builder.create();
    }

    private void doSearch(String s) {
        mListView.clearChoices();
        checkedValues = new ArrayList<String>();

        // Do datasource filtering
        if(mDatasource instanceof Pagination) {
            mAdapter.setSearchText(s);
            mAdapter.refresh();
        }
        else{
            // or native android filtering
            mAdapter.getFilter().filter(s);
        }
    }

    @Override
    public void onStart() {
        super.onStart();
        // load first batch
        mAdapter.refresh();
    }

    EndlessScrollListener mEndlessScrollListener = new EndlessScrollListener() {
        @Override
        public void onLoadMore(int page, int totalItemsCount) {
            mAdapter.loadNextPage();
        }
    };

    private DatasourceAdapter createAdapter() {
        // create datasource and get layout and binding

        final DatasourceAdapter adapter = new DatasourceAdapter<T>(
                getActivity(),
                multipleChoice ?
                        android.R.layout.simple_list_item_multiple_choice :
                        android.R.layout.simple_list_item_single_choice,
                setupDatasource()
        ) {

            @Override
            public void bindView(T item, int position, View view) {
                String value = getItemValue(item);

                CheckedTextView textView = (CheckedTextView) ViewHolder
                        .get(view, android.R.id.text1);
                textView.setText(value);

                // if value is in current selection list, check it
                if (checkedValues != null && checkedValues.contains(value)) {
                    mListView.setItemChecked(position, true);
                }
            }
        };

        return adapter;
    }

    private Datasource setupDatasource() {
        mDatasource = getDatasource();

        // set up pagination
        if (mDatasource instanceof Pagination) {
            mListView.setOnScrollListener(mEndlessScrollListener);
        }
        return mDatasource;
    }

    @Override
    public void onDismiss(final DialogInterface dialog) {
        if (mListener != null) {
            SparseBooleanArray checked = mListView.getCheckedItemPositions();
            ArrayList<String> res = new ArrayList<String>(checked.size());
            for (int i = 0; i < checked.size(); i++) {
                if (checked.valueAt(i)) {
                    res.add(getItemValue((T) mListView.getAdapter().getItem(checked.keyAt(i))));
                }
            }

            // invoke callback
            mListener.onSelected(res);
        }

        super.onDismiss(dialog);
    }

    // public API

    /**
     * Gets the datasource that backs this dialog
     */
    protected abstract Datasource getDatasource();

    /**
     * Make the binding. Since android.R.layout.simple_list_item_checked is being used for item,
     * only android.R.id.text1 needs to be bind, so we only need to return the string to be
     * rendered here.
     *
     * @param item the item to bind
     * @return the string to be rendered in the item
     */
    protected abstract String getItemValue(T item);

    protected abstract String getTitle();
}
