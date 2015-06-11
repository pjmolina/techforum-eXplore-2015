/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.util;

import com.squareup.okhttp.OkHttpClient;
import com.squareup.picasso.Callback;
import com.squareup.picasso.OkHttpDownloader;
import com.squareup.picasso.Picasso;

import android.content.Context;
import android.net.Uri;
import android.view.View;
import android.widget.ImageView;

import java.io.IOException;
import java.net.HttpURLConnection;

import appworks.R;

/**
 * Utility class for loading images into ImageViews
 */
public class ImageLoader {

    /**
     * Load asynchronously and image into an ImageView
     *
     * @param context the context of the activity/fragment
     * @param url     the url of the image to load
     * @param view    the view to load  into
     */
    public static void load(Context context,
            String url,
            final ImageView view) {
        url = encodePath(url);

        Picasso picasso = getPicasso(context);
        picasso.load(url)
                .placeholder(android.R.color.black)
                .error(R.drawable.appworks_logo)
                .into(view);

    }

    /**
     * Helper to activate debug mode in picasso
     *
     * @param context the current context
     * @param url     the image url
     * @param view    the view to inject the image into
     * @param debug   true if debug mode should be activated
     */
    public static void load(Context context,
            String url,
            ImageView view, boolean debug) {
        url = encodePath(url);

        Picasso picasso = getPicasso(context);

        picasso.setIndicatorsEnabled(debug);
        picasso.load(url)
                .placeholder(android.R.color.black)
                .error(android.R.color.darker_gray)
                .into(view);

    }

    /**
     * Load asynchronously and image into an ImageView and show a placeholder meanwhile
     *
     * @param context       the context of the activity/fragment
     * @param url           the url of the image to load
     * @param containerView that holds the placeholder
     * @param view          the view to load  into
     * @param phTag         to look for the placeholder
     */
    public static void loadWithSpinner(Context context,
            String url, final View containerView,
            ImageView view, final String phTag) {
        url = encodePath(url);
        final View progressBar = containerView.findViewWithTag(phTag);
        progressBar.setVisibility(View.VISIBLE);

        Picasso picasso = getPicasso(context);

        picasso.load(url)
                .error(R.drawable.appworks_logo)
                .into(view, new Callback() {
                    @Override
                    public void onSuccess() {
                        progressBar.setVisibility(View.GONE);
                    }

                    @Override
                    public void onError() {
                        progressBar.setVisibility(View.GONE);
                    }
                });

    }

    /**
     * Load an image from a local resource
     *
     * @param resource the resource id
     * @param view     the image to load the resource into
     */
    public static void load(int resource, ImageView view) {
        if (resource > 0) {
            view.setImageResource(resource);
        }
    }

    /**
     * quick encode patch for spaces
     *
     * @param url the url to encode
     * @return the encoded url
     */
    private static String encodePath(String url) {
        return url.replace(" ", "%20");
    }

    static Picasso singleton;

    private static Picasso getPicasso(Context context) {
        if (singleton == null) {
            synchronized (Picasso.class) {
                if (singleton == null) {
                    OkHttpClient okHttpClient = new OkHttpClient();
                    OkHttpDownloader downloader = new OkHttpDownloaderFixed(okHttpClient);
                    singleton = new Picasso.Builder(context).downloader(downloader).build();
                }
            }
        }
        return singleton;
    }

    /**
     * Override the Picasso's class to avoid the caching issues
     */
    private static class OkHttpDownloaderFixed extends OkHttpDownloader {

        static final String RESPONSE_SOURCE_ANDROID = "X-Android-Response-Source";

        static final String RESPONSE_SOURCE_OKHTTP = "OkHttp-Response-Source";

        public OkHttpDownloaderFixed(OkHttpClient client) {
            super(client);
        }

        @Override
        public Response load(Uri uri, boolean localCacheOnly) throws IOException {
            HttpURLConnection connection = openConnection(uri);
            connection.setUseCaches(false);
            if (localCacheOnly) {
                connection.setRequestProperty("Cache-Control",
                        "only-if-cached,max-age=" + Integer.MAX_VALUE);
            }

            int responseCode = connection.getResponseCode();
            if (responseCode >= 300) {
                connection.disconnect();
                throw new ResponseException(responseCode + " " + connection.getResponseMessage());
            }

            String responseSource = connection.getHeaderField(RESPONSE_SOURCE_OKHTTP);
            if (responseSource == null) {
                responseSource = connection.getHeaderField(RESPONSE_SOURCE_ANDROID);
            }

            long contentLength = connection.getHeaderFieldInt("Content-Length", -1);
            boolean fromCache = parseResponseSourceHeader(responseSource);

            return new Response(connection.getInputStream(), fromCache, contentLength);
        }

        /**
         * Returns {@code true} if header indicates the response body was loaded from the disk
         * cache.
         */
        boolean parseResponseSourceHeader(String header) {
            if (header == null) {
                return false;
            }
            String[] parts = header.split(" ", 2);
            if ("CACHE".equals(parts[0])) {
                return true;
            }
            if (parts.length == 1) {
                return false;
            }
            try {
                return "CONDITIONAL_CACHE".equals(parts[0]) && Integer.parseInt(parts[1]) == 304;
            } catch (NumberFormatException e) {
                return false;
            }
        }
    }
}
