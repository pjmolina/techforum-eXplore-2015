/*
 * This App has been generated using http://www.radarconline.com , the Bright Enterprise App Builder.
 */

package com.radarc.explore101.ui;
import android.annotation.SuppressLint;
import android.os.Bundle;
import android.view.View;
import android.view.LayoutInflater;
import android.view.ViewGroup;

import com.radarc.explore101.R;
import android.text.format.DateFormat;
import android.widget.ImageView;
import android.widget.TextView;
import appworks.actions.PhoneAction;
import appworks.util.ImageLoader;
import java.net.URL;
import com.radarc.explore101.ds.AppnowSchema3Item;

public class OfficesDetailFragment extends appworks.ui.DetailFragment<AppnowSchema3Item> {

    public static OfficesDetailFragment newInstance(Bundle args){
        OfficesDetailFragment card = new OfficesDetailFragment();
        card.setArguments(args);

        return card;
    }

    public OfficesDetailFragment(){
        super();
    }        

    // Bindings

    @Override
    protected int getLayout() {
        return R.layout.officesdetail_detail;
    }

    @Override
    @SuppressLint("WrongViewCast")
    public void bindView(final AppnowSchema3Item item, View view) {
        
        ImageView view0 = (ImageView) view.findViewById(R.id.view0);
        URL view0Media = item.imageUrl;
        if(view0Media != null){
            ImageLoader.loadWithSpinner(getActivity(),
                    view0Media.toExternalForm(), view,
                    view0,"view0");
            
        }
        if (item.city != null){
            
            TextView view1 = (TextView) view.findViewById(R.id.view1); 
            view1.setText("City: " + item.city);
            
        }
        if (item.address != null){
            
            TextView view2 = (TextView) view.findViewById(R.id.view2); 
            view2.setText(item.address);
            
        }
        if (item.name != null){
            
            TextView view3 = (TextView) view.findViewById(R.id.view3); 
            view3.setText(item.name);
            
        }
        if (item.phone != null){
            
            TextView view4 = (TextView) view.findViewById(R.id.view4); 
            view4.setText(item.phone);
            bindAction(view4, new PhoneAction(getActivity(), item.phone));
        }
    }

    @Override
    protected void onShowCard(AppnowSchema3Item item) {
        // set the title for this fragment
        if(item.name != null){
            getActivity().setTitle(item.name);
        }
    }

}
