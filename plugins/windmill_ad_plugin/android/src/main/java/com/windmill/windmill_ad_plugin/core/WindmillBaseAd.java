package com.windmill.windmill_ad_plugin.core;



import android.app.Activity;

import com.windmill.sdk.WindMillAdRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class WindmillBaseAd {

    public void setup(MethodChannel channel, WindMillAdRequest adRequest, Activity activity) {
        // TODO document why this method is empty
    }


    public  WindmillBaseAd getAdInstance(String uniqId) {
        return null;
    }
    public static  <T> T getArgument(Object arguments, String key) {
        if (arguments == null) {
            return null;
        } else if (arguments instanceof Map) {
            return (T) ((Map<?, ?>) arguments).get(key);
        } else if (arguments instanceof JSONObject) {
            return (T) ((JSONObject) arguments).opt(key);
        } else {
            throw new ClassCastException();
        }
    }

    public static Map<String, Object> getArguments(Object arguments)  {

        if (arguments instanceof Map){
            return (Map)arguments;
        }else if (arguments instanceof JSONObject){
            try {
                return toMap((JSONObject)arguments);
            } catch (JSONException e) {
                return null;
            }
        }
        return null;
    }


    public static List<Object> toList(JSONArray array) throws JSONException {
        List<Object> list = new ArrayList<Object>();
        for(int i = 0; i < array.length(); i++) {
            Object value = array.get(i);
            if (value instanceof JSONArray) {
                value = toList((JSONArray) value);
            }
            else if (value instanceof JSONObject) {
                value = toMap((JSONObject) value);
            }
            list.add(value);
        }   return list;
    }

    public static Map<String, Object> toMap(JSONObject jsonobj)  throws JSONException {
        Map<String, Object> map = new HashMap<String, Object>();
        Iterator<String> keys = jsonobj.keys();
        while(keys.hasNext()) {
            String key = keys.next();
            Object value = jsonobj.get(key);
            if (value instanceof JSONArray) {
                value = toList((JSONArray) value);
            } else if (value instanceof JSONObject) {
                value = toMap((JSONObject) value);
            }
            map.put(key, value);
        }   return map;
    }
    public void excuted( MethodCall call,  MethodChannel.Result result) {
        Class<? extends WindmillBaseAd> cls = this.getClass();
        try {
            Method method = cls.getDeclaredMethod(call.method, call.getClass());
            method.setAccessible(true);
            result.success(method.invoke(this, call));
        } catch (NoSuchMethodException | InvocationTargetException | IllegalAccessException e) {
            e.printStackTrace();
        }
    }


    public void onAttachedToEngine() {

    }

    public Object isReady(MethodCall o) {
        return null;
    }

    public Object load(MethodCall o) {

        return null;
    }
}
