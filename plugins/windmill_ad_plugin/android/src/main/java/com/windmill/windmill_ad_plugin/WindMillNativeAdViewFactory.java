package com.windmill.windmill_ad_plugin;

import android.app.Activity;
import android.content.Context;


import com.windmill.windmill_ad_plugin.banner.BannerAd;
import com.windmill.windmill_ad_plugin.banner.BannerAdView;
import com.windmill.windmill_ad_plugin.core.WindmillBaseAd;
import com.windmill.windmill_ad_plugin.feedAd.NativeAd;
import com.windmill.windmill_ad_plugin.feedAd.NativeAdView;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class WindMillNativeAdViewFactory extends PlatformViewFactory {


    private String viewName;
    private Activity activity;
    private FlutterPlugin.FlutterPluginBinding flutterPluginBinding;

    private WindmillBaseAd windmillBaseAd;

    public WindMillNativeAdViewFactory(String viewName, WindmillBaseAd windmillBaseAd, Activity activity) {
        super(StandardMessageCodec.INSTANCE);
        this.viewName = viewName;
        this.activity = activity;
        this.windmillBaseAd = windmillBaseAd;
    }


    @Override
    public PlatformView create(Context context, int viewId, Object args) {

        String uniqId = WindmillBaseAd.getArgument(args, "uniqId");
        WindmillBaseAd baseAd = windmillBaseAd.getAdInstance(uniqId);

        if (this.viewName.equals(WindmillAdPlugin.kWindmillBannerAdViewId)) {

            return new BannerAdView(this.activity, baseAd);

        } else if (this.viewName.equals(WindmillAdPlugin.kWindmillFeedAdViewId)) {

            Object nativeCustomConfig = WindmillBaseAd.getArgument(args, "nativeCustomViewConfig");

            JSONObject config = null;

            if (nativeCustomConfig instanceof Map) {
                config = new JSONObject((Map) nativeCustomConfig);
            } else if (nativeCustomConfig instanceof JSONObject) {
                config = (JSONObject) nativeCustomConfig;
            }
            return new NativeAdView(this.activity, baseAd, config);
        }

        return null;
    }


}