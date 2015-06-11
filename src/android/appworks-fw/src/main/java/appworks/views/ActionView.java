/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.views;

import android.content.Context;
import android.view.LayoutInflater;
import android.widget.LinearLayout;
import android.widget.TextView;

import appworks.R;

/**
 * TextView used in drawer actions section
 */
public class ActionView extends LinearLayout {

    public ActionView(Context context) {
        super(context);
        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        if (inflater != null) {
            inflater.inflate(R.layout.nav_action_view, this);
        }
        //this.setClickable(true);
    }

    public void setText(String s) {
        ((TextView) this.findViewById(R.id.action_view_label)).setText(s);
    }

}