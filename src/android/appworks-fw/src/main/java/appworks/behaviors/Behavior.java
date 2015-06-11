/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.behaviors;

import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;

/**
 * Try to abstract some android patterns as plugable behaviors
 * in the fragment lifecycle
 */
public interface Behavior {

    public void init();

    public void shutdown();

    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater);

    public boolean onOptionsItemSelected(MenuItem item);

    public void onViewCreated(View view, Bundle savedInstanceState);

    public void onActivityResult(int requestCode, int resultCode, Intent data);

    // for lists
    public void onItemClick(AdapterView<?> parent, View view, int position, long id);

    public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id);
}
