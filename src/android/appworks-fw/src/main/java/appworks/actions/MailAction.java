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

/**
 * Mail sender action
 */
public class MailAction implements Action {

    String mMail;

    WeakReference<Context> mWeakContext;

    public MailAction(Context context, String mail) {
        this.mMail = mail;
        if (!mMail.startsWith("mailto:")) {
            mMail = "mailto:" + mail;
        }
        this.mWeakContext = new WeakReference<Context>(context);
    }

    @Override
    public void execute(Bundle runtimeArgs) {
        Intent intent = new Intent(Intent.ACTION_SENDTO, Uri.parse(mMail));

        Context context = mWeakContext.get();
        if (context != null) {
            context.startActivity(
                    Intent.createChooser(intent, context.getString(R.string.send_email)));
        }
    }
}
