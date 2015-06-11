/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ds.restds;

import android.text.TextUtils;
import android.util.Base64;

import java.util.ArrayList;
import java.util.List;

import appworks.ds.Datasource;
import appworks.ds.SearchOptions;
import appworks.ds.filter.Filter;
import retrofit.RequestInterceptor;
import retrofit.RestAdapter;

/**
 * AppNow Datasource
 */
public abstract class AppNowDatasource<T, R> extends RestDatasource<T, R> {

    public AppNowDatasource(Class<R> clazz){
        super(clazz);
    }

    @Override
    protected RestAdapter.Builder createRestAdapterBuilder() {
        RestAdapter.Builder builder = new RestAdapter.Builder()
                .setClient(getClient())
                .setEndpoint(getServerUrl())
                .setConverter(getConverter())
                .setLogLevel(getLogLevel());

        if (!(tryApiKey(builder) || tryBasicAuth(builder))) {
            throw new IllegalArgumentException("AppNow datasource needs an api key or user-pwd pair !");
        }

        return builder;
    }

    protected boolean tryApiKey(RestAdapter.Builder builder) {
        final String apiKey = getApiKey();
        if (apiKey == null){
            return false;
        }

        builder.setRequestInterceptor(new RequestInterceptor() {
            @Override
            public void intercept(RequestFacade request) {
                request.addHeader("apikey", apiKey);
            }
        });

        return true;
    }

    protected boolean tryBasicAuth(RestAdapter.Builder builder) {
        final String user = getApiUser();
        final String pwd = getApiPassword();

        if(user == null || pwd == null){
            return false;
        }

        builder.setRequestInterceptor(new RequestInterceptor() {
            @Override
            public void intercept(RequestFacade request) {
                String credentials = user + ":" + pwd;
                String base64EncodedCredentials = Base64
                        .encodeToString(credentials.getBytes(), Base64.NO_WRAP);
                request.addHeader("Authorization", "Basic " + base64EncodedCredentials);
            }
        });

        return true;
    }

    protected String getConditions(SearchOptions options, String[] searchCols){
        if(options == null)
            return null;

        ArrayList<String> exps = new ArrayList<>();
        if(options.getFilters() != null) {
            for (Filter filter : options.getFilters()) {
                String qs = filter.getQueryString();
                if (qs != null)
                    exps.add(qs);
            }
        }

        // TODO: Add full text search $text
        String st = options.getSearchText();
        if (st != null && searchCols != null && searchCols.length > 0){
            ArrayList<String> searches = new ArrayList<>();
            for(String col: searchCols){
                searches.add("{\"" + col + "\":{\"$regex\":\"" + st + "\",\"$options\":\"i\"}}");
            }
            String searchExp = "\"$or\":[" + TextUtils.join(",", searches) + "]";
            exps.add(searchExp);
        }

        if (exps.size() > 0)
            return "{" + TextUtils.join(",", exps) + "}";

        return null;
    }

    protected String getSort(SearchOptions options){
        String col = options.getSortColumn();
        boolean asc = options.isSortAscending();

        if(col == null)
            return null;

        if (!asc)
            col = "-" + col;

        return col;
    }

    protected String getApiUser(){
        return null;
    }

    protected String getApiPassword(){
        return null;
    }

    // search (without pagination)
    public abstract void getItems(SearchOptions options, Listener<List<T>> listener);
}
