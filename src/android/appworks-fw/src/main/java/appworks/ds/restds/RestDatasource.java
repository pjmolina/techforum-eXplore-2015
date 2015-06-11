/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ds.restds;

import com.google.gson.FieldNamingPolicy;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import com.squareup.okhttp.OkHttpClient;

import android.util.Base64;

import java.net.URL;
import java.util.Date;
import java.util.concurrent.TimeUnit;

import appworks.ds.Datasource;
import retrofit.RequestInterceptor;
import retrofit.RestAdapter;
import retrofit.client.Client;
import retrofit.client.OkClient;
import retrofit.converter.Converter;
import retrofit.converter.GsonConverter;

/**
 * Datasource backed with Retrofit framework
 *
 * @param <T> the entity type this datasource returns
 * @param <R> the interface class that defines this retrofit service
 */
public abstract class RestDatasource<T, R> implements Datasource<T> {

    Class<R> mServiceInterface;

    Converter mConverter;

    R mServiceProxy;

    public RestDatasource(Class<R> clazz) {
        this.mServiceInterface = clazz;
    }

    /**
     * Get the service proxy
     *
     * @return the R retrofit proxy
     */
    protected R getServiceProxy() {
        if (mServiceProxy == null) {
            RestAdapter restAdapter = createRestAdapterBuilder().build();
            mServiceProxy = restAdapter.create(mServiceInterface);
        }
        return mServiceProxy;
    }

    /**
     * Sets the service interface for this Retrofit datasource
     *
     * @param clazz the service interface
     */
    public void setServiceInterface(Class clazz) {
        this.mServiceInterface = clazz;
    }

    /**
     * Creates the Retrofit Converter used for this datasource. Override this
     * to set your own configuration
     *
     * @return the Converter object
     */
    protected Converter createConverter() {
        // Initialize the rest backend
        Gson gson = new GsonBuilder()
                .setFieldNamingPolicy(FieldNamingPolicy.IDENTITY)    // field policy
                .registerTypeAdapter(Double.class, new DecimalJsonTypeAdapter())
                .registerTypeAdapter(Date.class,
                        new DateJsonTypeAdapter())  // Date conversions for allowed formats
                .registerTypeAdapter(URL.class, new URLJsonTypeAdapter())
                .create();

        return new GsonConverter(gson);
    }

    protected Converter getConverter() {
        if (mConverter == null) {
            mConverter = createConverter();
        }

        return mConverter;
    }

    /**
     * Create a builder for this datasource
     *
     * @return the Retrofit builder object
     */
    protected RestAdapter.Builder createRestAdapterBuilder() {
        RestAdapter.Builder builder = new RestAdapter.Builder()
                .setClient(getClient())
                .setEndpoint(getServerUrl())
                .setConverter(getConverter())
                .setLogLevel(getLogLevel());

        // we use basic auth based on app-id:api-key
        if (getApiKey() != null) {
            builder.setRequestInterceptor(new RequestInterceptor() {
                @Override
                public void intercept(RequestFacade request) {
                    String credentials = getAppId() + ":" + getApiKey();
                    String base64EncodedCredentials = Base64
                            .encodeToString(credentials.getBytes(), Base64.NO_WRAP);
                    request.addHeader("Authorization", "Basic " + base64EncodedCredentials);

                    String token = getToken();
                    if (token != null) {
                        request.addHeader("UserToken", token);
                    }
                }
            });
        }

        return builder;
    }

    /**
     * Override this to customise the log level
     *
     * @return the LogLevel
     */
    protected RestAdapter.LogLevel getLogLevel() {
        return RestAdapter.LogLevel.NONE;
    }

    /**
     * Override this to customize client
     */
    protected Client getClient() {
        OkHttpClient c = new OkHttpClient();
        c.setConnectTimeout(getHttpClientTimeout(), TimeUnit.SECONDS);
        return new OkClient(c);
    }

    // API

    /**
     * Get the base url for this retrofit endpoint
     *
     * @return the base url
     */
    public abstract String getServerUrl();

    /**
     * Get the api key for this datasource
     *
     * @return null if no api key is present, or the api key to enable basic auth
     */
    protected String getApiKey() {
        return null;
    }

    /**
     * Get the App Id (given by appworks)
     *
     * @return the app id
     */
    protected String getAppId() {
        return null;
    }

    /**
     * Get the token required for retrieve secured data
     *
     * @return the token
     */
    protected String getToken() {
        return null;
    }

    /**
     * Get the username required for retrieve secured data
     *
     * @return the user
     */
    protected String getUserId() {
        return null;
    }

    /**
     * Set the connection timeout, override to customize
     *
     * @return the timeout in seconds
     */
    protected long getHttpClientTimeout() {
        return 5;
    }
}
