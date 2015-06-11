/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.dialogs;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v7.widget.SearchView;
import android.util.SparseBooleanArray;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;

import java.util.ArrayList;
import java.util.List;

import appworks.R;
import appworks.ds.Datasource;
import appworks.ds.Distinct;
import appworks.events.BusProvider;
import appworks.events.DatasourceFailureEvent;

/**
 * Selection dialog that takes unique values from a datasource column. Useful for implementing filters
 */
public class ValuesSelectionDialog extends SelectionDialog {
    ArrayAdapter<String> mAdapter;

    private Distinct mDatasource;

    private String mColumnName;

    private ListView mListView;

    private boolean isFiltering;

    private ArrayList<String> checkedValues;

    private boolean mCanceled;

    @NonNull
    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        AlertDialog.Builder builder = new AlertDialog.Builder(
                getActivity(),
                // http://stackoverflow.com/a/28561766/3344594
                Build.VERSION.SDK_INT > Build.VERSION_CODES.KITKAT ?
                        R.style.SelectionDialog :
                        R.style.SelectionDialog_PreL);

        // Get the layout inflater
        LayoutInflater inflater = getActivity().getLayoutInflater();

        mCanceled = false;

        // Set up the listview
        View view = inflater.inflate(R.layout.selection_dialog, null);
        mListView = (ListView) view.findViewById(android.R.id.list);

        createAdapter();
        mListView.setAdapter(mAdapter);
        mListView.setChoiceMode(
                mMultipleChoice ? AbsListView.CHOICE_MODE_MULTIPLE : AbsListView.CHOICE_MODE_SINGLE);

        if (mHaveSearch) {
            SearchView searchView = (SearchView) view.findViewById(R.id.search);
            searchView.setVisibility(View.VISIBLE);

            searchView.setOnQueryTextListener(new SearchView.OnQueryTextListener() {
                @Override
                public boolean onQueryTextSubmit(String s) {
                    if (!"".equals(s)) {
                        isFiltering = true;
                        mAdapter.getFilter().filter(s);

                        // clear previous selection
                        mListView.clearChoices();
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
                        mAdapter.getFilter().filter(null);
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
                ValuesSelectionDialog.this.dismiss();
            }
        });

        if(getArguments() != null)
            checkedValues = getArguments().getStringArrayList(INITIAL_VALUES);

        builder.setTitle(mTitle)
                .setView(view);

        if(mDatasource != null) {
            mDatasource.getUniqueValuesFor(mColumnName, new Datasource.Listener<List<Object>>() {
                @Override
                public void onSuccess(List<Object> objects) {
                    mAdapter.clear();
                    mAdapter.addAll(new ArrayList(objects));
                }

                @Override
                public void onFailure(Exception e) {
                    BusProvider.getInstance().post(new DatasourceFailureEvent());
                    ValuesSelectionDialog.this.dismiss();
                }
            });
        }

        builder.setTitle(mTitle);

        return builder.create();
    }

    public ValuesSelectionDialog setDatasource(Datasource datasource){
        if(!(datasource instanceof Distinct)){
            throw new IllegalArgumentException("Datasource must implement Distinct interface");
        }

        this.mDatasource = (Distinct)datasource;
        return this;
    };

    public ValuesSelectionDialog setColumnName(String columnName){
        this.mColumnName = columnName;
        return this;
    };

    private void createAdapter(){
        mAdapter = new ArrayAdapter<String>(
                getActivity(),
                mMultipleChoice ?
                        R.layout.dialog_item_multiple_choice :
                        R.layout.dialog_item_single_choice){
            @Override
            public View getView(int position, View convertView, ViewGroup parent) {
                String value = mAdapter.getItem(position);
                if (checkedValues != null && checkedValues.contains(value)) {
                    mListView.setItemChecked(position, true);
                }

                return  super.getView(position, convertView, parent);
            }
        };

    }

    @Override
    public void onCancel(final DialogInterface dialog){
        super.onCancel(dialog);
        mCanceled = true;
    }

    @Override
    public void onDismiss(final DialogInterface dialog) {
        if (!mCanceled && mSelectionListener != null) {
            SparseBooleanArray checked = mListView.getCheckedItemPositions();
            ArrayList<String> res = new ArrayList<String>(checked.size());
            for (int i = 0; i < checked.size(); i++) {
                if (checked.valueAt(i)) {
                    res.add(mAdapter.getItem(checked.keyAt(i)));
                }
            }

            // invoke callback
            mSelectionListener.onSelected(res);
        }

        super.onDismiss(dialog);
    }

}
