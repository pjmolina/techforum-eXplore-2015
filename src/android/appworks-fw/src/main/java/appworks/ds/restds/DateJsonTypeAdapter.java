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
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

/**
 * Adapter for Radarc-type Backend Date type.
 */
public class DateJsonTypeAdapter implements JsonDeserializer<Date>, JsonSerializer<Date> {

    final private static String[] isoFormats = {
            "yyyy-MM-dd'T'HH:mm:ss'Z'",
            "yyyy-MM-dd'T'HH:mm'Z'",
            "yyyy-MM-dd'T'HH:mm.SSS'Z'",
            "yyyy-MM-dd",
            "yyyyMMdd",
            "yy-MM-dd",
            "yyMMdd"
    };


    public Date deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context)
            throws JsonParseException {

        String jsonDate = json.getAsString();

        for (String format : isoFormats) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat(format);
                // all dates must come in UTC timezone
                sdf.setTimeZone(TimeZone.getTimeZone("UTC"));
                return sdf.parse(jsonDate);
            } catch (Exception e) {
                Log.d("ParseError", e.getMessage());
            }
        }

        return null;
    }

    @Override
    public JsonElement serialize(Date src, Type typeOfSrc, JsonSerializationContext context) {
        return new JsonPrimitive(src.toString());
    }
}
