/*
 * This App has been generated using http://www.radarconline.com , the Bright Enterprise App Builder.
 */


package com.radarc.explore101.ds;

import android.os.Parcel;
import android.os.Parcelable;
import java.util.ArrayList;

public class AppnowSchema2Item implements Parcelable{

    public String id;
    public String category;
    public String service;

    // Parcelable interface

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(id);
        dest.writeString(category);
        dest.writeString(service);
    }

    public static final Creator<AppnowSchema2Item> CREATOR = new Creator<AppnowSchema2Item>() {
        @Override
        public AppnowSchema2Item createFromParcel(Parcel in) {
            AppnowSchema2Item item = new AppnowSchema2Item();

            item.id = in.readString();
            item.category = in.readString();
            item.service = in.readString();
           
            return item; 
        }

        @Override
        public AppnowSchema2Item[] newArray(int size) {
            return new AppnowSchema2Item[size];
        }
    };

    public static class List extends ArrayList<AppnowSchema2Item>{}

}

