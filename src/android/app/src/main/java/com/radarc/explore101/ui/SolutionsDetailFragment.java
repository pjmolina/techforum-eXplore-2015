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
import com.radarc.explore101.ds.AppnowSchema2Item;

public class SolutionsDetailFragment extends appworks.ui.DetailFragment<AppnowSchema2Item> {

    public static SolutionsDetailFragment newInstance(Bundle args){
        SolutionsDetailFragment card = new SolutionsDetailFragment();
        card.setArguments(args);

        return card;
    }

    public SolutionsDetailFragment(){
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
        return R.layout.solutionsdetail_detail;
    }

    @Override
    @SuppressLint("WrongViewCast")
    public void bindView(final AppnowSchema2Item item, View view) {
        if (item.category != null){
            
            TextView view0 = (TextView) view.findViewById(R.id.view0); 
            view0.setText(item.category);
            
        }
    }

    @Override
    protected void onShowCard(AppnowSchema2Item item) {
        // set the title for this fragment
        if(item.service != null){
            getActivity().setTitle(item.service);
        }
    }

    public class MyShareBehavior extends ShareBehavior<AppnowSchema2Item> {
        AppnowSchema2Item item;
        public MyShareBehavior(FragmentActivity activity, AppnowSchema2Item item) {
            super(activity);
            this.item = item;
        }

        @Override
        public void update(AppnowSchema2Item item) {            
            Intent intent = new Intent();
            intent.setAction(Intent.ACTION_SEND);
            intent.setType("text/plain");

            intent.putExtra(Intent.EXTRA_TEXT, (item.category != null ? item.category : "" ));
            intent.putExtra(Intent.EXTRA_SUBJECT, item.service);

            setIntent(intent);
        }
    }
}
