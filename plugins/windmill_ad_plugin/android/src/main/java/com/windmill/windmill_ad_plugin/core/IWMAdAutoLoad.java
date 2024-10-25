package com.windmill.windmill_ad_plugin.core;

import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdAutoLoadFailed;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdAutoLoadSuccess;

import com.windmill.sdk.WindMillError;
import com.windmill.sdk.base.AutoAdLoadListener;

import java.util.HashMap;
import java.util.Map;

import io.flutter.Log;
import io.flutter.plugin.common.MethodChannel;

public class IWMAdAutoLoad implements AutoAdLoadListener {
    private static final String TAG = IWMAdAutoLoad.class.getSimpleName();
    final private MethodChannel channel;
    public IWMAdAutoLoad(MethodChannel channel) {
        this.channel = channel;
    }
    @Override
    public void onAutoAdLoadSuccess(String placementId) {
        Log.d(TAG, "onAutoAdLoadSuccess: ");
        channel.invokeMethod(kWindmillEventAdAutoLoadSuccess, null);
    }

    @Override
    public void onAutoAdLoadFail(WindMillError error, String placementId) {
        Log.d(TAG, "onAutoAdLoadFail: ");
        Map<String, Object> args = new HashMap<String, Object>();
        args.put("code", error.getErrorCode());
        args.put("message", error.getMessage());
        channel.invokeMethod(kWindmillEventAdAutoLoadFailed, args);
    }
}
