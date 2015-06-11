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

/**
 * Adapter for Radarc-type Backend Decimal type.
 */
public class DecimalJsonTypeAdapter implements JsonDeserializer<Double>, JsonSerializer<Double> {

    public Double deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context)
            throws JsonParseException {

        String jsonDouble = json.getAsString();
        Double res = 0.0;
        try {
            res = Double.parseDouble(jsonDouble);
        } catch (Exception e) {
            Log.d("ParseError", e.getMessage());
        }
        return res;
    }

    @Override
    public JsonElement serialize(Double src, Type typeOfSrc, JsonSerializationContext context) {
        return new JsonPrimitive(src.toString());
    }
}
