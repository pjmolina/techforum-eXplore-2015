/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.actions;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import java.lang.ref.WeakReference;

import appworks.R;

public class OpenUriAction implements Action {

    String mUri;

    WeakReference<Context> mWeakContext;

    public OpenUriAction(Context context, String uri) {
        this.mUri = uri;
        this.mWeakContext = new WeakReference<Context>(context);
    }

    @Override
    public void execute(Bundle runtimeArgs) {
        if (mUri != null) {
            Uri parsedUri = Uri.parse(mUri);
            if (parsedUri.getScheme() == null) {
                parsedUri = Uri.parse("http://" + mUri);
            }
            Intent intent = new Intent(Intent.ACTION_VIEW, parsedUri);
            Context context = mWeakContext.get();
            if (context != null) {
                context.startActivity(
                        Intent.createChooser(intent, context.getString(R.string.open_url)));
            }
        }
    }
}
