/*
 * This App has been generated using http://www.radarconline.com , the Bright Enterprise App Builder.
 */


package com.radarc.explore101.ds;
 
import android.content.Context;

import java.util.ArrayList;
import java.util.List;

import appworks.ds.Distinct;
import appworks.util.FilterUtils;
import appworks.ds.SearchOptions;
import appworks.ds.Pagination;
import appworks.ds.restds.RestDatasource;

import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;

import com.radarc.explore101.R;

/**
 * "OfficesDS" data source. (364f27d4-8618-4041-925a-7c3da527af22)
 */
public class OfficesDS extends RestDatasource<AppnowSchema3Item, AppnowSchema3ItemRest> implements 
    Pagination<AppnowSchema3Item>, Distinct{

    // default page size
    static final int PAGE_SIZE = 20;

    static OfficesDS instance;

    private Context mContext;

    public static OfficesDS getInstance(Context context){
        if(instance == null)
            instance = new OfficesDS(context);

        return instance;
    }

    private OfficesDS(Context context) {
        super(AppnowSchema3ItemRest.class);
        this.mContext = context;
    }

    @Override
    public void getItems(final Listener<List<AppnowSchema3Item>> listener) {
        getServiceProxy().getAll(new Callback<AppnowSchema3Item.List>() {
            @Override
            public void success(AppnowSchema3Item.List result, Response response) {
                listener.onSuccess(result);
            }

            @Override
            public void failure(RetrofitError error) {
                listener.onFailure(error);
            }
        });
    }

    @Override
    public void getItem(String id, final Listener<AppnowSchema3Item> listener) {
        // query first item
        getServiceProxy().search(null, null, true, 0, 1, null, new Callback<AppnowSchema3Item.List>() {
            @Override
            public void success(AppnowSchema3Item.List result, Response response) {
                if (result.size() > 0)
                    listener.onSuccess(result.get(0));
                else
                    listener.onSuccess(new AppnowSchema3Item());
            }

            @Override
            public void failure(RetrofitError error) {
                listener.onFailure(error);
            }
        });
    }

    @Override
    public void getItems(int pagenum, int pagesize, SearchOptions options, final Listener<List<AppnowSchema3Item>> listener) {
        String filter = FilterUtils.getFilterQuery(options.getFilters());
        getServiceProxy().search(options.getSearchText(), options.getSortColumn(), options.isSortAscending(),
                pagenum, pagesize, filter, new Callback<AppnowSchema3Item.List>() {
            @Override
            public void success(AppnowSchema3Item.List result, Response response) {
                listener.onSuccess(result);
            }

            @Override
            public void failure(RetrofitError error) {
                listener.onFailure(error);
            }
        });
    }

    @Override
    public String getServerUrl(){
        return mContext.getString(R.string.dynamic_url);
    }

    @Override
    protected String getApiKey(){
        String apikey = mContext.getString(R.string.api_key);
        return "NoApiKey".equals(apikey) ? null : apikey;
    }

    @Override
    protected String getAppId(){
        return mContext.getString(R.string.app_id);
    }

    // Pagination

    @Override
    public int getPageSize(){
        return OfficesDS.PAGE_SIZE;
    }

    @Override
    public void getUniqueValuesFor(String searchStr, final Listener<List<Object>> listener) {
        getServiceProxy().getDistinctValues(searchStr, new Callback<List<String>>() {
            @Override
            public void success(List<String> result, Response response) {
                listener.onSuccess(new ArrayList(result));
            }

            @Override
            public void failure(RetrofitError error) {
                listener.onFailure(error);
            }
        });
    }
}

