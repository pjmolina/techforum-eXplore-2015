/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.util;

import org.apache.http.HttpResponse;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class LoginUtils {

    /**
     * Last date the app was suspended
     */
    public static String SUSPENDED_DATE = "suspendedDate";

    /**
     * Session time (in minutes)
     */
    public static String EXPIRATION_TIME = "expirationTime";

    /**
     * Last user who successfuly logged in
     */
    public static String LAST_USER = "lastUser";

    /**
     * Data-Securitization Token
     */
    public static String TOKEN = "token";

    public static long NEVER_EXPIRES = 0;

    public static long SESSION_EXPIRED = -1;

    /**
     * Check if the user is still logged in, and redirect to login activity if needed
     *
     * @param mSharedPreferences a SecurePreferences instance for storing and reading the info
     * @param loginActivity      the login activity class
     * @param activity           the current activity
     */
    public static void checkLoggedStatus(SecurePreferences mSharedPreferences, Class loginActivity,
            Activity activity) {

        Long suspendedDate = mSharedPreferences.getLong(SUSPENDED_DATE, 0);
        Long currentDate = System.currentTimeMillis();
        Long mins = (currentDate - suspendedDate) / (1000 * 60);

        Long expirationTime = mSharedPreferences.getLong(EXPIRATION_TIME, SESSION_EXPIRED);

        // check whether session has expired or not
        if (expirationTime != NEVER_EXPIRES && mins >= expirationTime) {

            Intent goToLogin = new Intent(activity, loginActivity);
            goToLogin.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK
                    | Intent.FLAG_ACTIVITY_NO_HISTORY);

            activity.startActivity(goToLogin);
            activity.finish();
        }
    }

    public static void storeLastActiveStatus(SecurePreferences mSharedPreferences) {
        mSharedPreferences.edit().putLong(SUSPENDED_DATE, System.currentTimeMillis()).commit();
    }

    public static void logOut(SecurePreferences mSharedPreferences, Class loginActivity,
            Activity activity) {
        mSharedPreferences.edit().putLong(EXPIRATION_TIME, SESSION_EXPIRED).commit();
        Intent goToLogin = new Intent(activity, loginActivity);
        goToLogin.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK
                | Intent.FLAG_ACTIVITY_NO_HISTORY);
        activity.startActivity(goToLogin);
        activity.finish();
    }

    public static String getResponseString(HttpResponse response) {
        BufferedReader reader;
        String res = null;

        try {
            reader = new BufferedReader(
                    new InputStreamReader(response.getEntity().getContent(), "UTF-8"));
            res = reader.readLine();
        } catch (IOException e) {
            Log.e("getResponseString", e.getMessage());
        }

        return res;
    }

    public static JSONObject parseJSON(String responseString) {

        JSONObject json = null;
        try {
            json = new JSONObject(responseString);
        } catch (JSONException e) {
            Log.e("getResponseString", e.getMessage());
        }
        return json;
    }
}
