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

/**
 * Play video action
 */
public class VideoAction implements Action {

    String mLink;

    WeakReference<Context> mWeakContext;

    public VideoAction(Context context, String link) {
        this.mLink = link;
        this.mWeakContext = new WeakReference<Context>(context);
    }

    @Override
    public void execute(Bundle runtimeArgs) {
        Intent intent = new Intent(Intent.ACTION_VIEW,
                Uri.parse(mLink));

        Context context = mWeakContext.get();
        if (context != null) {
            context.startActivity(Intent.createChooser(intent, "Play video"));
        }
    }
}
