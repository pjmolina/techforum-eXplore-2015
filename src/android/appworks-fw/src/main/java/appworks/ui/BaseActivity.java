/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ui;

import com.squareup.otto.Subscribe;

import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.MenuItem;
import android.widget.Toast;

import appworks.R;
import appworks.events.BusProvider;
import appworks.events.DatasourceFailureEvent;
import appworks.events.DatasourceUnauthorizedEvent;

/**
 * Base activity for all appworks activities
 */
public class BaseActivity extends ActionBarActivity {

    private Object busEventListener;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    protected void onResume() {
        super.onResume();
        BusProvider.getInstance().register(this);

        // set up generic event listeners
        busEventListener = new Object() {
            @Subscribe
            public void onReceiveDatasourceFailureEvent(final DatasourceFailureEvent event) {
                Toast.makeText(BaseActivity.this, R.string.error_data_generic,
                        Toast.LENGTH_SHORT).show();
            }

            @Subscribe
            public void onReceiveDatasourceUnauthorizedEvent(
                    final DatasourceUnauthorizedEvent event) {
                Toast.makeText(BaseActivity.this, R.string.error_data_unauthorized,
                        Toast.LENGTH_SHORT).show();
            }
        };

        BusProvider.getInstance().register(busEventListener);
    }

    @Override
    protected void onPause() {
        super.onPause();
        BusProvider.getInstance().unregister(this);
        BusProvider.getInstance().unregister(busEventListener);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            finish();
            return true;
        }
        return super.onOptionsItemSelected(item);
    }
}
