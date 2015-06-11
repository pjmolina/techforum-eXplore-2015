/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.behaviors;

import android.content.Context;
import android.content.Intent;
import android.support.v4.view.MenuCompat;
import android.support.v4.view.MenuItemCompat;
import android.support.v7.widget.ShareActionProvider;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;

import appworks.R;

/**
 * Creates a Share action provider
 */
public abstract class ShareBehavior<T> extends AbstractBehavior {

    Context mContext;

    Intent mIntent;

    private ShareActionProvider mSharer;

    public ShareBehavior(Context context) {
        this.mContext = context;
    }

    /**
     * Set the Share intnt
     *
     * @param intent the new intent
     * @return this object (fluent api)
     */
    public ShareBehavior setIntent(Intent intent) {
        this.mIntent = intent;
        if(mSharer != null) mSharer.setShareIntent(intent);
        return this;
    }

    private Intent getDefaultIntent() {
        Intent intent = new Intent(Intent.ACTION_SEND);
        intent.setType("image/*");
        return intent;
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        inflater.inflate(R.menu.share_menu, menu);
        MenuItem item = menu.findItem(R.id.action_share);
        mSharer = (ShareActionProvider) MenuItemCompat.getActionProvider(item);
        mSharer.setShareIntent(getDefaultIntent());
    }

    /**
     * Updates this sharing action
     *
     * @param t a typed item
     */
    public abstract void update(T t);

}
