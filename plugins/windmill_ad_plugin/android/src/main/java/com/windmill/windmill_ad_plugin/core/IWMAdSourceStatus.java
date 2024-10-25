package com.windmill.windmill_ad_plugin.core;

import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdSourceFailed;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdSourceStartLoading;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdSourceSuccess;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventBidAdSourceFailed;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventBidAdSourceStart;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventBidAdSourceSuccess;

import android.os.Handler;
import android.os.Looper;

import com.windmill.sdk.WMAdSourceStatusListener;
import com.windmill.sdk.base.WMAdapterError;
import com.windmill.sdk.models.AdInfo;

import java.util.HashMap;
import java.util.Map;

import io.flutter.Log;
import io.flutter.plugin.common.MethodChannel;

public class IWMAdSourceStatus implements WMAdSourceStatusListener {
    private static final String TAG = IWMAdSourceStatus.class.getSimpleName();
    final private MethodChannel channel;
    public IWMAdSourceStatus(MethodChannel channel) {
        this.channel = channel;
    }
    @Override
    public void onAdSourceBiddingStart(AdInfo adInfo) {
        Log.d(TAG, "onAdSourceBiddingStart: ");
        Map<String, Object> args = new HashMap<String, Object>();
        args.put("adInfo", adInfo.toString());
        Handler mainHandler = new Handler(Looper.getMainLooper());
        mainHandler.post(new Runnable() {
            @Override
            public void run() {
                channel.invokeMethod(kWindmillEventBidAdSourceStart, args);
            }
        });
//        channel.invokeMethod(kWindmillEventBidAdSourceStart, args);
    }

    @Override
    public void onAdSourceBiddingSuccess(AdInfo adInfo) {
        Log.d(TAG, "onAdSourceBiddingSuccess: ");
        Map<String, Object> args = new HashMap<String, Object>();
        args.put("adInfo", adInfo.toString());
        Handler mainHandler = new Handler(Looper.getMainLooper());
        mainHandler.post(new Runnable() {
            @Override
            public void run() {
                channel.invokeMethod(kWindmillEventBidAdSourceSuccess, args);
            }
        });
//        channel.invokeMethod(kWindmillEventBidAdSourceSuccess, args);
    }

    @Override
    public void onAdSourceBiddingFailed(AdInfo adInfo, WMAdapterError errorMessage) {
        Log.d(TAG, "onAdSourceBiddingFailed: ");
        Map<String, Object> args = new HashMap<String, Object>();
        args.put("code", errorMessage.getErrorCode());
        args.put("message", errorMessage.getMessage());
        args.put("adInfo", adInfo.toString());
        Handler mainHandler = new Handler(Looper.getMainLooper());
        mainHandler.post(new Runnable() {
            @Override
            public void run() {
                channel.invokeMethod(kWindmillEventBidAdSourceFailed, args);
            }
        });

    }

    @Override
    public void onAdSourceLoadStart(AdInfo adInfo) {
        Log.d(TAG, "onAdSourceLoadStart: ");
        Map<String, Object> args = new HashMap<String, Object>();
        args.put("adInfo", adInfo.toString());
        Handler mainHandler = new Handler(Looper.getMainLooper());
        mainHandler.post(new Runnable() {
            @Override
            public void run() {
                channel.invokeMethod(kWindmillEventAdSourceStartLoading, args);
            }
        });
//        channel.invokeMethod(kWindmillEventAdSourceStartLoading, args);
    }

    @Override
    public void onAdSourceLoadSuccess(AdInfo adInfo) {
        Log.d(TAG, "onAdSourceLoadSuccess: ");
        Map<String, Object> args = new HashMap<String, Object>();
        args.put("adInfo", adInfo.toString());
        Handler mainHandler = new Handler(Looper.getMainLooper());
        mainHandler.post(new Runnable() {
            @Override
            public void run() {
                channel.invokeMethod(kWindmillEventAdSourceSuccess, args);
            }
        });
//        channel.invokeMethod(kWindmillEventAdSourceSuccess, args);
    }

    @Override
    public void onAdSourceLoadFailed(AdInfo adInfo, WMAdapterError errorMessage) {
        Log.d(TAG, "onAdSourceLoadFailed: ");
        Map<String, Object> args = new HashMap<String, Object>();
        args.put("code", errorMessage.getErrorCode());
        args.put("message", errorMessage.getMessage());
        args.put("adInfo", adInfo.toString());
        Handler mainHandler = new Handler(Looper.getMainLooper());
        mainHandler.post(new Runnable() {
            @Override
            public void run() {
                channel.invokeMethod(kWindmillEventAdSourceFailed, args);
            }
        });
//        channel.invokeMethod(kWindmillEventAdSourceFailed, args);
    }
}
