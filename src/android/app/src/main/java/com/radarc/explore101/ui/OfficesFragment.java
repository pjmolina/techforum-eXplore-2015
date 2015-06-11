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
import android.text.format.DateFormat;
import android.widget.TextView;
import com.radarc.explore101.ds.OfficesDS;
import com.radarc.explore101.ds.AppnowSchema3Item;
/**
 * "OfficesFragment" listing
 */
public class OfficesFragment extends ListGridFragment<AppnowSchema3Item> {
        public OfficesFragment(){
        super();
    }

    public static OfficesFragment newInstance(Bundle args){
        OfficesFragment fr = new OfficesFragment();

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
        return R.layout.offices_item;
    }

    @Override
    protected Datasource<AppnowSchema3Item> getDatasource(){
        return OfficesDS.getInstance(getActivity().getApplication());
    }

    @Override
    protected void bindView(AppnowSchema3Item item, View view, int position) {
        
        TextView title = ViewHolder.get(view, appworks.R.id.title);
        
        if (item.name != null && item.city != null){
            title.setText(item.name + item.city);
            
        }
        
        TextView subtitle = ViewHolder.get(view, appworks.R.id.subtitle);
        
        if (item.country != null){
            subtitle.setText(item.country);
            
        }
        
    }
}
