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
import android.content.Intent;
import android.support.v4.app.FragmentActivity;
import android.widget.TextView;
import appworks.behaviors.ShareBehavior;
import com.radarc.explore101.ds.AppnowItem;

public class CountriesDetailFragment extends appworks.ui.DetailFragment<AppnowItem> {

    public static CountriesDetailFragment newInstance(Bundle args){
        CountriesDetailFragment card = new CountriesDetailFragment();
        card.setArguments(args);

        return card;
    }

    public CountriesDetailFragment(){
        super();
    }        
     
    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
   
        addBehavior(new MyShareBehavior(getActivity(), getItem()));
    }

    // Bindings

    @Override
    protected int getLayout() {
        return R.layout.countriesdetail_detail;
    }

    @Override
    @SuppressLint("WrongViewCast")
    public void bindView(final AppnowItem item, View view) {
        if (item.name != null){
            
            TextView view0 = (TextView) view.findViewById(R.id.view0); 
            view0.setText(item.name);
            
        }
    }

    @Override
    protected void onShowCard(AppnowItem item) {
        // set the title for this fragment
        if(item.name != null){
            getActivity().setTitle(item.name);
        }
    }

    public class MyShareBehavior extends ShareBehavior<AppnowItem> {
        AppnowItem item;
        public MyShareBehavior(FragmentActivity activity, AppnowItem item) {
            super(activity);
            this.item = item;
        }

        @Override
        public void update(AppnowItem item) {            
            Intent intent = new Intent();
            intent.setAction(Intent.ACTION_SEND);
            intent.setType("text/plain");

            intent.putExtra(Intent.EXTRA_TEXT, (item.name != null ? item.name : "" ));
            intent.putExtra(Intent.EXTRA_SUBJECT, item.name);

            setIntent(intent);
        }
    }
}
