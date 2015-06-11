/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.dialogs;

import appworks.ds.Datasource;
import appworks.ds.ResourceDatasource;

/**
 * Selection dialog backed by an array resource (as a datasource)
 */
public class ResourceListSelectionDialog extends DatasourceSelectionDialog<String> {

    String mTitle;
    int mResId;

    public ResourceListSelectionDialog(){
        super();
    }

    public ResourceListSelectionDialog setTitle(String title){
        this.mTitle = title;
        return this;
    }

    public ResourceListSelectionDialog setResId(int resId){
        this.mResId = resId;
        return this;
    }

    // delegate methods

    @Override
     protected Datasource getDatasource() {
        return new ResourceDatasource(getActivity().getApplication(), mResId);
    }

    @Override
    protected String getItemValue(String item) {
        return item;
    }

    @Override
    protected String getTitle() {
        return mTitle;
    }
}
