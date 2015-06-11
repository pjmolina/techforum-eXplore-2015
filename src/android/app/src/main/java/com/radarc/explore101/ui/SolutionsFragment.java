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
import com.radarc.explore101.ds.SolutionsDS;
import com.radarc.explore101.ds.AppnowSchema2Item;
/**
 * "SolutionsFragment" listing
 */
public class SolutionsFragment extends ListGridFragment<AppnowSchema2Item> {
        public SolutionsFragment(){
        super();
    }

    public static SolutionsFragment newInstance(Bundle args){
        SolutionsFragment fr = new SolutionsFragment();

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
        return R.layout.solutions_item;
    }

    @Override
    protected Datasource<AppnowSchema2Item> getDatasource(){
        return SolutionsDS.getInstance(getActivity().getApplication());
    }

    @Override
    protected void bindView(AppnowSchema2Item item, View view, int position) {
        
        TextView title = ViewHolder.get(view, appworks.R.id.title);
        
        if (item.service != null){
            title.setText(item.service);
            
        }
        
        TextView subtitle = ViewHolder.get(view, appworks.R.id.subtitle);
        
        if (item.category != null){
            subtitle.setText(item.category);
            
        }
        
    }
}
