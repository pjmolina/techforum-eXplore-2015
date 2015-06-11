/*
 * This App has been generated using http://www.radarconline.com , the Bright Enterprise App Builder.
 */


package com.radarc.explore101.ds;
import java.net.URL;

import android.os.Parcel;
import android.os.Parcelable;
import java.util.ArrayList;

public class AppnowSchema3Item implements Parcelable{

    public String id;
    public String name;
    public String country;
    public String city;
    public String address;
    public String phone;
    public URL imageUrl;

    // Parcelable interface

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(id);
        dest.writeString(name);
        dest.writeString(country);
        dest.writeString(city);
        dest.writeString(address);
        dest.writeString(phone);
        dest.writeString(imageUrl != null ? imageUrl.toString() : null);
    }

    public static final Creator<AppnowSchema3Item> CREATOR = new Creator<AppnowSchema3Item>() {
        @Override
        public AppnowSchema3Item createFromParcel(Parcel in) {
            AppnowSchema3Item item = new AppnowSchema3Item();

            item.id = in.readString();
            item.name = in.readString();
            item.country = in.readString();
            item.city = in.readString();
            item.address = in.readString();
            item.phone = in.readString();
            try {
                item.imageUrl = new URL(in.readString());
            } catch (java.net.MalformedURLException e) { /* do nothing */ };
           
            return item; 
        }

        @Override
        public AppnowSchema3Item[] newArray(int size) {
            return new AppnowSchema3Item[size];
        }
    };

    public static class List extends ArrayList<AppnowSchema3Item>{}

}

