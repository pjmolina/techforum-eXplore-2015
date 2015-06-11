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
 * "SolutionsDS" data source. (a2cf4995-73dc-4bb7-8d9c-af017d125e42)
 */
public class SolutionsDS extends RestDatasource<AppnowSchema2Item, AppnowSchema2ItemRest> implements 
    Pagination<AppnowSchema2Item>, Distinct{

    // default page size
    static final int PAGE_SIZE = 20;

    static SolutionsDS instance;

    private Context mContext;

    public static SolutionsDS getInstance(Context context){
        if(instance == null)
            instance = new SolutionsDS(context);

        return instance;
    }

    private SolutionsDS(Context context) {
        super(AppnowSchema2ItemRest.class);
        this.mContext = context;
    }

    @Override
    public void getItems(final Listener<List<AppnowSchema2Item>> listener) {
        getServiceProxy().getAll(new Callback<AppnowSchema2Item.List>() {
            @Override
            public void success(AppnowSchema2Item.List result, Response response) {
                listener.onSuccess(result);
            }

            @Override
            public void failure(RetrofitError error) {
                listener.onFailure(error);
            }
        });
    }

    @Override
    public void getItem(String id, final Listener<AppnowSchema2Item> listener) {
        // query first item
        getServiceProxy().search(null, null, true, 0, 1, null, new Callback<AppnowSchema2Item.List>() {
            @Override
            public void success(AppnowSchema2Item.List result, Response response) {
                if (result.size() > 0)
                    listener.onSuccess(result.get(0));
                else
                    listener.onSuccess(new AppnowSchema2Item());
            }

            @Override
            public void failure(RetrofitError error) {
                listener.onFailure(error);
            }
        });
    }

    @Override
    public void getItems(int pagenum, int pagesize, SearchOptions options, final Listener<List<AppnowSchema2Item>> listener) {
        String filter = FilterUtils.getFilterQuery(options.getFilters());
        getServiceProxy().search(options.getSearchText(), options.getSortColumn(), options.isSortAscending(),
                pagenum, pagesize, filter, new Callback<AppnowSchema2Item.List>() {
            @Override
            public void success(AppnowSchema2Item.List result, Response response) {
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
        return SolutionsDS.PAGE_SIZE;
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

