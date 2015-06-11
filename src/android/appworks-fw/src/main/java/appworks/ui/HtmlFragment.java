/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ui;

import android.content.Intent;
import android.net.Uri;
import android.view.View;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import appworks.R;
import appworks.ds.HtmlDatasource;

/**
 * Simple Html (WebView) fragment for using as HTML containers
 */
public abstract class HtmlFragment extends DetailFragment<HtmlDatasource.WebContent> {

    @Override
    public void bindView(HtmlDatasource.WebContent item, View view) {
        WebView wv = (WebView) view.findViewById(R.id.webView);
        wv.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                // open links in device's browser
                Uri uri = Uri.parse(url);
                Intent intent = new Intent(Intent.ACTION_VIEW, uri);
                startActivity(intent);
                return true;
            }
        });
        wv.getSettings().setCacheMode(WebSettings.LOAD_CACHE_ELSE_NETWORK);
        wv.loadDataWithBaseURL(getBaseUrl(), item.content, "text/html", null, null);
        wv.setBackgroundColor(0x00000000);
    }

    @Override
    protected int getLayout() {
        return R.layout.detail_webview;
    }

    /**
     * Call this to set a defaul base url for relative links and resources
     *
     * @return the base url
     */
    protected String getBaseUrl() {
        return "http://dummy.base.url.org";
    }
}
