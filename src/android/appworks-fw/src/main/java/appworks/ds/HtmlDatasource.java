/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ds;

import android.os.Parcel;
import android.os.Parcelable;

import java.util.ArrayList;
import java.util.List;

/**
 * Simple HTML Datasource for using in WebViews
 */
public class HtmlDatasource implements Datasource<HtmlDatasource.WebContent>, Count {

    WebContent web = new WebContent();

    public HtmlDatasource(String content) {
        this.web.content = content;
    }

    @Override
    public void getItems(Listener<List<WebContent>> listener) {
        List<WebContent> list = new ArrayList<WebContent>(1);
        list.add(web);

        listener.onSuccess(list);
    }

    @Override
    public void getItem(String id, Listener<WebContent> listener) {
        listener.onSuccess(web);
    }

    @Override
    public int getCount() {
        return 1;
    }

    /**
     * Bean for representing HTML content inside Webviews
     */
    public static class WebContent implements Parcelable {

        public String content;

        @Override
        public int describeContents() {
            return 0;
        }

        @Override
        public void writeToParcel(Parcel dest, int flags) {
            dest.writeString(content);
        }

        public static final Creator<WebContent> CREATOR = new Creator<WebContent>() {
            @Override
            public WebContent createFromParcel(Parcel source) {
                WebContent item = new WebContent();
                item.content = source.readString();
                return item;
            }

            @Override
            public WebContent[] newArray(int size) {
                return new WebContent[size];
            }
        };
    }
}
