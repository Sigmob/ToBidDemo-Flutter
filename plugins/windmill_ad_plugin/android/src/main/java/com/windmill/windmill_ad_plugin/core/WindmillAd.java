package com.windmill.windmill_ad_plugin.core;

import android.text.TextUtils;

import com.windmill.sdk.WMConstants;
import com.windmill.sdk.WindMillAd;
import com.windmill.sdk.WindMillAdRequest;
import com.windmill.sdk.banner.WMBannerAdRequest;
import com.windmill.sdk.interstitial.WMInterstitialAdRequest;
import com.windmill.sdk.natives.WMNativeAdRequest;
import com.windmill.sdk.reward.WMRewardAdRequest;
import com.windmill.sdk.splash.WMSplashAdRequest;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodChannel;

public class WindmillAd<T> {

    public enum AdType{
        Reward,
        Splash,
        Interstitial,
        Banner,
        Native,

    }

    private Map<String, WindmillBaseAd> map =  new HashMap<>();

    public  WindmillBaseAd getAdInstance(String uniqId) {
        if(map.containsKey(uniqId)) {
            return map.get(uniqId);
        }
        return null;
    }

    public T createAdInstance(Class<? extends T> cls, Map<String, Object> arguments, FlutterPlugin.FlutterPluginBinding binding, WindmillAd.AdType adType)  {
        String uniqId = (String) arguments.get("uniqId");
        Map<String, Object> requestMap = (Map<String, Object>)arguments.get("request");
        String placementId = (String) requestMap.get("placementId");
        String userId = (String) requestMap.get("userId");

        if (TextUtils.isEmpty(userId)){
            userId = WindMillAd.getUserId();
        }
        Map<String, Object> options = new HashMap<>();

        if (requestMap.get("options") != null) {
            Map<String, String> options1 = (Map<String, String>) requestMap.get("options");
            if (options1 != null) {
                options.putAll(options1);
            }
        }

        WindMillAdRequest adRequest = null;
        String channelName = null;
        switch (adType) {
            case Banner:{
                channelName = "com.windmill/banner."+uniqId;

                adRequest = new WMBannerAdRequest(placementId,userId,options);

            }break;
            case Native: {
                Double width = (Double) arguments.get("width");
                options.put(WMConstants.AD_WIDTH, width.intValue());//针对于模版广告有效、单位dp
                if(arguments.containsKey("height")){
                    Double height = (Double) arguments.get("height");
                    options.put(WMConstants.AD_HEIGHT, height.intValue());//自适应高度
                }else {
                    options.put(WMConstants.AD_HEIGHT, WMConstants.AUTO_SIZE);//自适应高度
                }

                adRequest = new WMNativeAdRequest(placementId,userId,1,options);

                channelName = "com.windmill/native."+uniqId;
            }break;
            case Reward:{
                adRequest = new WMRewardAdRequest(placementId,userId,options);

                channelName = "com.windmill/reward."+uniqId;
            }break;
            case Interstitial:{
                adRequest = new WMInterstitialAdRequest(placementId,userId,options);

                channelName = "com.windmill/interstitial."+uniqId;
            }break;
            case Splash:{

                String title = (String) arguments.get("title");
                String desc = (String) arguments.get("desc");

                adRequest = new WMSplashAdRequest(placementId,userId,options);
                ((WMSplashAdRequest)adRequest).setAppTitle(title);
                ((WMSplashAdRequest)adRequest).setAppDesc(desc);

                channelName = "com.windmill/splash."+uniqId;
            }break;
            default:{
            }break;

        }

        MethodChannel channel = new MethodChannel(binding.getBinaryMessenger(),channelName);
        try {
            T t = cls.newInstance();
            WindmillBaseAd windmillBaseAd = (WindmillBaseAd)t;
            windmillBaseAd.setup(channel, adRequest);
            map.put(uniqId, windmillBaseAd);
            return t;
        } catch (IllegalAccessException | InstantiationException e) {
            e.printStackTrace();
            return null;
        }
    }

}
