package com.windmill.windmill_ad_plugin.core;

import android.app.Activity;
import android.text.TextUtils;
import android.util.Log;

import com.windmill.sdk.WMConstants;
import com.windmill.sdk.WindMillAd;
import com.windmill.sdk.WindMillAdRequest;
import com.windmill.sdk.banner.WMBannerAdRequest;
import com.windmill.sdk.interstitial.WMInterstitialAdRequest;
import com.windmill.sdk.natives.WMNativeAdRequest;
import com.windmill.sdk.reward.WMRewardAdRequest;
import com.windmill.sdk.splash.WMSplashAdRequest;
import com.windmill.windmill_ad_plugin.utils.ResourceUtil;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodChannel;

public class WindmillAd<T> {

    public enum AdType {
        Reward,
        Splash,
        Interstitial,
        Banner,
        Native,
    }

    private Map<String, WindmillBaseAd> map = new HashMap<String, WindmillBaseAd>();

    public WindmillBaseAd getAdInstance(String uniqId) {
        if (map.containsKey(uniqId)) {
            return map.get(uniqId);
        }
        return null;
    }

    public T createAdInstance(Class<? extends T> cls, Map<String, Object> arguments,
                              FlutterPlugin.FlutterPluginBinding binding, WindmillAd.AdType adType, Activity activity) {

        try {
            Map<String, Object> options = new HashMap<String, Object>();

            String uniqId = (String) arguments.get("uniqId");
            Map<String, Object> requestMap = (Map<String, Object>) arguments.get("request");
            String placementId = (String) requestMap.get("placementId");
            String userId = (String) requestMap.get("userId");

            if (TextUtils.isEmpty(userId)) {
                userId = WindMillAd.getUserId();
            }

            if (requestMap.get("options") != null) {
                Map<String, String> options1 = (Map<String, String>) requestMap.get("options");
                if (options1 != null) {
                    options.putAll(options1);
                }
            }

            WindMillAdRequest adRequest = null;
            String channelName = null;
            switch (adType) {
                case Banner: {
                    channelName = "com.windmill/banner." + uniqId;

                    if (arguments.containsKey("width")) {
                        Double width = (Double) arguments.get("width");

                        if (width.intValue() > 0) {
                            options.put(WMConstants.AD_WIDTH, width.intValue());// 针对于模版广告有效、单位dp
                            if (arguments.containsKey("height")) {
                                Double height = (Double) arguments.get("height");
                                options.put(WMConstants.AD_HEIGHT, height.intValue());// 自适应高度
                            } else {
                                options.put(WMConstants.AD_HEIGHT, WMConstants.AUTO_SIZE);// 自适应高度
                            }
                        }

                    }

                    adRequest = new WMBannerAdRequest(placementId, userId, options);

                }
                break;
                case Native: {
                    Double width = (Double) arguments.get("width");
                    options.put(WMConstants.AD_WIDTH, width.intValue());// 针对于模版广告有效、单位dp
                    Log.d("TAG", "createAdInstance: " + arguments);
                    if (arguments.containsKey("height")) {
                        Double height = (Double) arguments.get("height");
                        options.put(WMConstants.AD_HEIGHT, height.intValue());// 自适应高度
                    } else {
                        options.put(WMConstants.AD_HEIGHT, WMConstants.AUTO_SIZE);// 自适应高度
                    }

                    adRequest = new WMNativeAdRequest(placementId, userId, 1, options);

                    channelName = "com.windmill/native." + uniqId;
                }
                break;
                case Reward: {
                    adRequest = new WMRewardAdRequest(placementId, userId, options);

                    channelName = "com.windmill/reward." + uniqId;
                }
                break;
                case Interstitial: {
                    adRequest = new WMInterstitialAdRequest(placementId, userId, options);

                    channelName = "com.windmill/interstitial." + uniqId;
                }
                break;
                case Splash: {

                    String title = (String) arguments.get("title");
                    String desc = (String) arguments.get("desc");

                    if (!TextUtils.isEmpty(title)) {

                        int width = ResourceUtil.Instance().getWidth();
                        int height = ResourceUtil.Instance().getHeight() + ResourceUtil.Instance().getStatusBarHeight() - ResourceUtil.Instance().dip2Px(100);
                        options.put(WMConstants.AD_WIDTH, width);
                        options.put(WMConstants.AD_HEIGHT, height);
                    }

                    adRequest = new WMSplashAdRequest(placementId, userId, options);
                    ((WMSplashAdRequest) adRequest).setAppTitle(title);
                    ((WMSplashAdRequest) adRequest).setAppDesc(desc);

                    channelName = "com.windmill/splash." + uniqId;
                }
                break;
                default: {
                }
                break;

            }
            if (!TextUtils.isEmpty(channelName)) {
                MethodChannel channel = new MethodChannel(binding.getBinaryMessenger(), channelName);
                T t = cls.newInstance();
                WindmillBaseAd windmillBaseAd = (WindmillBaseAd) t;
                windmillBaseAd.setup(channel, adRequest, activity);
                map.put(uniqId, windmillBaseAd);
                return t;
            }

        } catch (Exception e) {
            // TODO: handle exception
        }
        return null;

    }

}
