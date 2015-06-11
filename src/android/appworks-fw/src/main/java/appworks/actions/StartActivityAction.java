/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.actions;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import java.lang.ref.WeakReference;

public class StartActivityAction implements Action {

    Class mClazz;

    WeakReference<Context> mWeakContext;

    public StartActivityAction(Context context, Class clazz) {
        this.mClazz = clazz;
        this.mWeakContext = new WeakReference<Context>(context);
    }

    @Override
    public void execute(Bundle runtimeArgs) {
        Context context = mWeakContext.get();
        if (context != null) {
            Intent intent = new Intent(context, this.mClazz);
            if (runtimeArgs != null) {
                intent.putExtras(runtimeArgs);
            }

            context.startActivity(intent);
        }
    }
}
