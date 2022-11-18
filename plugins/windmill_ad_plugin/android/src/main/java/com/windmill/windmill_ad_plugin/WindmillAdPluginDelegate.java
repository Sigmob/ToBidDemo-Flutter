package com.windmill.windmill_ad_plugin;

import android.app.Activity;

import androidx.annotation.NonNull;

import com.windmill.sdk.WindMillAd;
import com.windmill.sdk.WindMillConsentStatus;
import com.windmill.sdk.WindMillUserAgeStatus;
import com.windmill.windmill_ad_plugin.banner.BannerAd;
import com.windmill.windmill_ad_plugin.feedAd.NativeAd;
import com.windmill.windmill_ad_plugin.reward.RewardVideoAd;
import com.windmill.windmill_ad_plugin.interstitial.InterstitialAd;
import com.windmill.windmill_ad_plugin.splashAd.SplashAd;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformViewRegistry;

public class WindmillAdPluginDelegate implements MethodChannel.MethodCallHandler {

    private final String TAG = "flutter";
    private Activity activity;

    private FlutterPlugin.FlutterPluginBinding flutterPluginBinding;

    private RewardVideoAd rewardVideoAd;
    private InterstitialAd interstitialAd;
    private BannerAd bannerAd;
    private NativeAd nativeAd;
    private SplashAd splashAd;

    public WindmillAdPluginDelegate(FlutterPlugin.FlutterPluginBinding flutterPluginBinding, Activity activity) {
        this.activity = activity;
        this.flutterPluginBinding = flutterPluginBinding;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        Log.d(TAG, "onMethodCall: " + call.method);
        if (call.method.equals("setupSdkWithAppId")) {
            setupSdkWithAppId(call, result);
        }else if (call.method.equals("getSdkVersion")) {
            getSdkVersion(call, result);
        }else if (call.method.equals("setUserId")) {
            String userId = call.argument("userId");
            WindMillAd.setUserId(userId);
        } else if(call.method.equals("setAdultStatus")){
            int state = call.argument("state");
            WindMillAd.sharedAds().setAdult(state ==0);
        } else if(call.method.equals("setPersonalizedStatus")){
            int state = call.argument("state");
            WindMillAd.sharedAds().setPersonalizedAdvertisingOn(state == 0);
        } else if(call.method.equals("setAge")){
            int age = call.argument("age");
            WindMillAd.sharedAds().setUserAge(age);
        } else if(call.method.equals("setOAIDCertPem")){
            String certPemStr = call.argument("certPem");
            WindMillAd.sharedAds().setOAIDCertPem(certPemStr);
        } else if(call.method.equals("setCOPPAStatus")){
            int state = call.argument("state");
            switch(state){
                case 0:{
                    WindMillAd.sharedAds().setIsAgeRestrictedUser(WindMillUserAgeStatus.WindAgeRestrictedStatusUnknown);
                }
                break;
                case 1:{
                    WindMillAd.sharedAds().setIsAgeRestrictedUser(WindMillUserAgeStatus.WindAgeRestrictedStatusYES);

                }break;
                case 2:{
                    WindMillAd.sharedAds().setIsAgeRestrictedUser(WindMillUserAgeStatus.WindAgeRestrictedStatusNO);

                }break;
                default:{

                }break;
            }

        } else if(call.method.equals("setCCPAStatus")){

        } else if(call.method.equals("setGDPRStatus")){
            int state = call.argument("state");

            switch(state){
                case 0:{
                    WindMillAd.sharedAds().setUserGDPRConsentStatus(WindMillConsentStatus.UNKNOWN);
                }
                break;
                case 1:{
                    WindMillAd.sharedAds().setUserGDPRConsentStatus(WindMillConsentStatus.ACCEPT);

                }break;
                case 2:{
                    WindMillAd.sharedAds().setUserGDPRConsentStatus(WindMillConsentStatus.DENIED);

                }break;
                default:{

                }break;
            }
        } else if(call.method.equals("sceneExpose")){
            String sceneId = call.argument("sceneId");
            String sceneName = call.argument("sceneName");
            WindMillAd.sharedAds().reportSceneExposure(sceneId,sceneName);
        } else if(call.method.equals("getUid")){

        } else if(call.method.equals("setDebugEnable")){

        }else {
            result.notImplemented();
        }
    }

    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        rewardVideoAd = new RewardVideoAd(this.activity, this.flutterPluginBinding);
        rewardVideoAd.onAttachedToEngine();

        interstitialAd = new InterstitialAd(this.activity,this.flutterPluginBinding);
        interstitialAd.onAttachedToEngine();

        bannerAd = new BannerAd(activity,flutterPluginBinding);
        bannerAd.onAttachedToEngine();

        nativeAd = new NativeAd(activity,flutterPluginBinding);
        nativeAd.onAttachedToEngine();
        splashAd = new SplashAd(activity,flutterPluginBinding);
        splashAd.onAttachedToEngine();

        PlatformViewRegistry platformViewRegistry = this.flutterPluginBinding.getPlatformViewRegistry();

        platformViewRegistry.registerViewFactory(WindmillAdPlugin.kWindmillBannerAdViewId,
                new WindMillNativeAdViewFactory(WindmillAdPlugin.kWindmillBannerAdViewId,this.bannerAd,
                        this.activity));

        platformViewRegistry.registerViewFactory(WindmillAdPlugin.kWindmillFeedAdViewId,
                new WindMillNativeAdViewFactory(WindmillAdPlugin.kWindmillFeedAdViewId,
                        this.nativeAd,
                        this.activity));

    }

    public void onDetachedFromActivity() {
        rewardVideoAd.onDetachedFromEngine();
        interstitialAd.onDetachedFromEngine();
        bannerAd.onDetachedFromEngine();
        nativeAd.onDetachedFromEngine();
        splashAd.onDetachedFromEngine();
    }

    private void getSdkVersion(MethodCall call, MethodChannel.Result result) {
        result.success(WindMillAd.getVersion());
    }

    private void setupSdkWithAppId(MethodCall call, MethodChannel.Result result) {
        String appId = call.argument("appId");
        WindMillAd.sharedAds().startWithAppId(this.activity.getApplicationContext(), appId);
        result.success(null);
    }



}
