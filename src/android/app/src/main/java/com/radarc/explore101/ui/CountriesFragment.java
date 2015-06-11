/*
 * This App has been generated using http://www.radarconline.com , the Bright Enterprise App Builder.
 */

package com.radarc.explore101.ui;
import android.os.Bundle;
import android.view.View;

import appworks.ds.Datasource;
import appworks.ui.ListGridFragment;
import appworks.util.ViewHolder;
import com.radarc.explore101.R;
import android.widget.TextView;
import com.radarc.explore101.ds.CountriesDS;
import com.radarc.explore101.ds.AppnowItem;
/**
 * "CountriesFragment" listing
 */
public class CountriesFragment extends ListGridFragment<AppnowItem> {
        public CountriesFragment(){
        super();
    }

    public static CountriesFragment newInstance(Bundle args){
        CountriesFragment fr = new CountriesFragment();

        fr.setArguments(args);
        return fr;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Custom behaviors
    }

    // ListGridFragment interface

    /**
    * Layout for the list itselft
    */
    @Override
    protected int getLayout() {
        return appworks.R.layout.fragment_list;
    }

    /**
    * Layout for each element in the list
    */
    @Override
    protected int getItemLayout() {
        return R.layout.countries_item;
    }

    @Override
    protected Datasource<AppnowItem> getDatasource(){
        return CountriesDS.getInstance(getActivity().getApplication());
    }

    @Override
    protected void bindView(AppnowItem item, View view, int position) {
        
        TextView title = ViewHolder.get(view, appworks.R.id.title);
        
        if (item.name != null){
            title.setText(item.name);
            
        }
        
    }
}
