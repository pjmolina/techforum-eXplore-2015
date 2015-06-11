/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ds.restds;

import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonParseException;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;

import android.util.Log;

import java.lang.reflect.Type;
import java.net.MalformedURLException;
import java.net.URL;

/**
 * Adapter for Radarc-type Backend URL type.
 */
public class URLJsonTypeAdapter implements JsonDeserializer<URL>, JsonSerializer<URL> {

    public URL deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context)
            throws JsonParseException {

        String jsonUrl = json.getAsString();
        URL result = null;
        try {
            result = new URL(jsonUrl);
        } catch (MalformedURLException e) {
            Log.d("ParseError", e.getMessage());
        }
        return result;
    }

    @Override
    public JsonElement serialize(URL src, Type typeOfSrc, JsonSerializationContext context) {
        return new JsonPrimitive(src.toExternalForm());
    }
}
