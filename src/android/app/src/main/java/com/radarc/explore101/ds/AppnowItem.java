/*
 * This App has been generated using http://www.radarconline.com , the Bright Enterprise App Builder.
 */


package com.radarc.explore101.ds;

import android.os.Parcel;
import android.os.Parcelable;
import java.util.ArrayList;

public class AppnowItem implements Parcelable{

    public String id;
    public String name;

    // Parcelable interface

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(id);
        dest.writeString(name);
    }

    public static final Creator<AppnowItem> CREATOR = new Creator<AppnowItem>() {
        @Override
        public AppnowItem createFromParcel(Parcel in) {
            AppnowItem item = new AppnowItem();

            item.id = in.readString();
            item.name = in.readString();
           
            return item; 
        }

        @Override
        public AppnowItem[] newArray(int size) {
            return new AppnowItem[size];
        }
    };

    public static class List extends ArrayList<AppnowItem>{}

}

