package com.windmill.windmill_ad_plugin.interstitial;

import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdClicked;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdClosed;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdFailedToLoad;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdLoaded;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdOpened;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdVideoPlayFinished;

import android.app.Activity;

import androidx.annotation.NonNull;

import com.windmill.sdk.WMConstants;
import com.windmill.sdk.WindMillAdRequest;
import com.windmill.sdk.WindMillError;
import com.windmill.sdk.interstitial.WMInterstitialAd;
import com.windmill.sdk.interstitial.WMInterstitialAdListener;
import com.windmill.sdk.interstitial.WMInterstitialAdRequest;
import com.windmill.sdk.models.AdInfo;
import com.windmill.windmill_ad_plugin.core.WindmillAd;
import com.windmill.windmill_ad_plugin.core.WindmillBaseAd;

import java.util.HashMap;
import java.util.Map;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class InterstitialAd extends WindmillBaseAd implements MethodChannel.MethodCallHandler {

    private MethodChannel channel;
    private Activity activity;
    private FlutterPlugin.FlutterPluginBinding flutterPluginBinding;
    private WMInterstitialAd interstitialAd;
    private WindmillAd<WindmillBaseAd> ad;
    protected AdInfo adInfo;

    public InterstitialAd() {}
    public InterstitialAd(Activity activity, FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        this.activity = activity;
        this.flutterPluginBinding = flutterPluginBinding;
        ad = new WindmillAd<>();
    }
    @Override
    public void setup(MethodChannel channel, WindMillAdRequest adRequest,Activity activity ) {
        super.setup(channel, adRequest,activity);
        this.channel = channel;
        this.activity = activity;
        this.interstitialAd = new WMInterstitialAd(activity,new WMInterstitialAdRequest(adRequest.getPlacementId(),adRequest.getUserId(),adRequest.getOptions()));
        this.interstitialAd.setInterstitialAdListener(new IWMIntersititialAdListener(this,channel));
    }
    public void onAttachedToEngine() {
        Log.d("Codi", "onAttachedToEngine");
        MethodChannel channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.windmill/interstitial");
        channel.setMethodCallHandler(this);
    }

    public void onDetachedFromEngine() {
        Log.d("Codi", "onDetachedFromEngine");
        if(channel != null){
            channel.setMethodCallHandler(null);
        }
    }


    public WindmillBaseAd getAdInstance(String uniqId){
        return this.ad.getAdInstance(uniqId);
    }


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        Log.d("Codi", "-- onMethodCall: " + call.method + ", arguments: " + call.arguments);
        String uniqId = call.argument("uniqId");

        WindmillBaseAd interstitialAd = this.ad.getAdInstance(uniqId);
        if (interstitialAd == null) {
            interstitialAd = this.ad.createAdInstance(InterstitialAd.class, getArguments(call.arguments), flutterPluginBinding,  WindmillAd.AdType.Interstitial,activity);
        }
        if(interstitialAd != null){
            interstitialAd.excuted(call, result);
        }
    }

    public Object isReady(MethodCall call) {
        return this.interstitialAd.isReady();
    }

    public Object load(MethodCall call) {
        this.adInfo = null;
        this.interstitialAd.loadAd();
        return null;
    }

    public Object getAdInfo(MethodCall call) {
        if(this.adInfo != null){
            return this.adInfo.toString();
        }
        return null;
     }

    private Object showAd(MethodCall call) {
        HashMap<String, String> options = call.argument("options");

        String scene_desc = options.get("AD_SCENE_DESC");
        String scene_id = options.get("AD_SCENE_ID");
        HashMap<String,String> opt =new HashMap<String,String>();
        opt.put(WMConstants.AD_SCENE_ID,scene_desc);
        opt.put(WMConstants.AD_SCENE_DESC,scene_id);
        this.interstitialAd.show(this.activity, options);
        return null;
    }
    private Object destory(MethodCall call) {
        return null;
    }
}

class IWMIntersititialAdListener implements WMInterstitialAdListener {

    private MethodChannel channel;
    private InterstitialAd interstitialAd;
    private static final String TAG = IWMIntersititialAdListener.class.getSimpleName();
    public IWMIntersititialAdListener(InterstitialAd interstitialAd,MethodChannel channel) {
        this.channel = channel;
        this.interstitialAd = interstitialAd;
    }


    @Override
    public void onInterstitialAdLoadSuccess(final String s) {
        android.util.Log.d(TAG, "onInterstitialAdLoadSuccess: "+ channel);
        channel.invokeMethod(kWindmillEventAdLoaded, null);
    }

    @Override
    public void onInterstitialAdPlayStart(final AdInfo adInfo) {
        interstitialAd.adInfo = adInfo;
        android.util.Log.d(TAG, "onInterstitialAdPlayStart: ");
        channel.invokeMethod(kWindmillEventAdOpened, null);
    }

    @Override
    public void onInterstitialAdPlayEnd(final AdInfo adInfo) {
        android.util.Log.d(TAG, "onInterstitialAdPlayEnd: ");
        channel.invokeMethod(kWindmillEventAdVideoPlayFinished, null);
    }

    @Override
    public void onInterstitialAdClicked(final AdInfo adInfo) {
        android.util.Log.d(TAG, "onInterstitialAdClicked: ");
        channel.invokeMethod(kWindmillEventAdClicked, null);
    }

    @Override
    public void onInterstitialAdClosed(final AdInfo adInfo) {
        android.util.Log.d(TAG, "onInterstitialAdClosed: ");
        channel.invokeMethod(kWindmillEventAdClosed, null);
       }

    @Override
    public void onInterstitialAdLoadError(final WindMillError windMillError, final String s) {
        android.util.Log.d(TAG, "onInterstitialAdLoadError: ");
        Map<String, Object> args = new HashMap<String, Object>();
        args.put("code", windMillError.getErrorCode());
        args.put("message", windMillError.getMessage());

        channel.invokeMethod(kWindmillEventAdFailedToLoad, args);
    }

    @Override
    public void onInterstitialAdPlayError(final WindMillError windMillError, final String s) {
        android.util.Log.d(TAG, "onInterstitialAdPlayError: ");

    }
}

