package com.windmill.windmill_ad_plugin.banner;

import static android.view.ViewGroup.LayoutParams.MATCH_PARENT;

import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdAutoRefreshFail;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdAutoRefreshed;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdClicked;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdFailedToLoad;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdLoaded;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdOpened;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdClosed;

import android.app.Activity;
import android.view.ViewGroup;
import android.widget.FrameLayout;


import com.windmill.sdk.WindMillAdRequest;
import com.windmill.sdk.WindMillError;
import com.windmill.sdk.banner.WMBannerAdListener;
import com.windmill.sdk.banner.WMBannerAdRequest;
import com.windmill.sdk.banner.WMBannerView;
import com.windmill.windmill_ad_plugin.WindmillAdPlugin;
import com.windmill.windmill_ad_plugin.core.WindmillAd;
import com.windmill.sdk.models.AdInfo;
import com.windmill.windmill_ad_plugin.core.WindmillBaseAd;

import java.util.HashMap;
import java.util.Map;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class BannerAd extends WindmillBaseAd implements MethodChannel.MethodCallHandler {

    private MethodChannel channel;
    private Activity activity;
    private FlutterPlugin.FlutterPluginBinding flutterPluginBinding;
    private WMBannerAdRequest bannerAdRequest;
    private Map<String, Object> params;
    protected WMBannerView bannerAdView;
    private WindmillAd<WindmillBaseAd> ad;
    protected AdInfo adInfo;

    public BannerAd() {}
    public BannerAd(Activity activity, FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        this.activity = activity;
        this.flutterPluginBinding = flutterPluginBinding;
        ad = new WindmillAd<>();
    }

    @Override
    public  WindmillBaseAd getAdInstance(String uniqId) {
        if(ad != null){
            return this.ad.getAdInstance(uniqId);
        }
        return null;
    }

    @Override
    public void setup(MethodChannel channel, WindMillAdRequest adRequest,Activity activity ) {
        super.setup(channel, adRequest,activity);
        this.bannerAdRequest= (WMBannerAdRequest) adRequest;
        this.channel  = channel;
        this.activity = activity;
        this.bannerAdView = new WMBannerView(activity);
        this.bannerAdView.setAdListener(new IWMBannerAdListener(channel,this));
    }


    public void onAttachedToEngine() {
        Log.d("Codi", "onAttachedToEngine");
        MethodChannel channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.windmill/banner");
        channel.setMethodCallHandler(this);
    }

    public void onDetachedFromEngine() {
        Log.d("Codi", "onDetachedFromEngine");
        if(channel != null){
            channel.setMethodCallHandler(null);
        }
    }

    public void showAd(ViewGroup adContainer){
        if (adContainer != null){
    
            adContainer.addView(bannerAdView,new FrameLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT));
        }
    }

    @Override
    public void onMethodCall(final MethodCall call,final MethodChannel.Result result) {
        Log.d("Codi", "-- onMethodCall: " + call.method + ", arguments: " + call.arguments);
        String uniqId = call.argument("uniqId");
        WindmillBaseAd bannerAd=this.ad.getAdInstance(uniqId);

        if (bannerAd == null) {

            bannerAd = this.ad.createAdInstance(BannerAd.class, getArguments(call.arguments), flutterPluginBinding, WindmillAd.AdType.Banner,activity);
        }
        bannerAd.excuted(call, result);
    }

    public Object load(MethodCall call) {

        this.adInfo = null;
        this.bannerAdView.loadAd(bannerAdRequest);
        return null;
    }

    public Object getAdInfo(MethodCall call) {
        if(this.adInfo != null){
            return this.adInfo.toString();
        }
        return null;
     }

    public Object isReady(MethodCall call) {
        return this.bannerAdView.isReady();
    }

    public Object destory(MethodCall call) {
        this.bannerAdView.destroy();
        return null;
    }

}

class IWMBannerAdListener implements WMBannerAdListener {

    private static final String TAG = IWMBannerAdListener.class.getSimpleName();
    private final BannerAd bannerAd;
    private MethodChannel channel;

    public IWMBannerAdListener(MethodChannel channel,BannerAd bannerAd) {
        this.channel = channel;
        this.bannerAd = bannerAd;
    }
    @Override
    public void onAdLoadSuccess(String placmentId) {
        Log.d(TAG, "onAdLoadSuccess: ");
        Map<String, Object> args = new HashMap<String, Object>();
        args.put("width", bannerAd.bannerAdView.getWidth()*1.0f);
        args.put("height", bannerAd.bannerAdView.getHeight()*1.0f);
        channel.invokeMethod(kWindmillEventAdLoaded, args);
    }

    @Override
    public void onAdLoadError(final WindMillError windMillError,final String placementId) {
        Log.d(TAG, "onAdLoadError: ");
        Map<String, Object> args = new HashMap<String, Object>();
            args.put("code", windMillError.getErrorCode());
            args.put("message", windMillError.getMessage());
        channel.invokeMethod(kWindmillEventAdFailedToLoad, args);
    }

    @Override
    public void onAdShown(final AdInfo adInfo) {
        Log.d(TAG, "onAdShown: ");

        this.bannerAd.adInfo = adInfo;

        Map<String, Object> args = new HashMap<String, Object>();
        args.put("width", bannerAd.bannerAdView.getWidth()*1.0f);
        args.put("height", bannerAd.bannerAdView.getHeight()*1.0f);

        channel.invokeMethod(kWindmillEventAdOpened, null);

    }

    @Override
    public void onAdClicked(final AdInfo adInfo) {
        Log.d(TAG, "kWindmillEventAdClicked: ");
        channel.invokeMethod(kWindmillEventAdClicked, null);

    }

    @Override
    public void onAdClosed(final AdInfo adInfo) {
        Log.d(TAG, "onAdClosed: ");
        channel.invokeMethod(kWindmillEventAdClosed, null);

    }

    @Override
    public void onAdAutoRefreshed(final AdInfo adInfo) {
        Log.d(TAG, "onAdAutoRefreshed: ");
        channel.invokeMethod(kWindmillEventAdAutoRefreshed, null);

    }

    @Override
    public void onAdAutoRefreshFail(final WindMillError windMillError, final String placementId) {

        Log.d(TAG, "onAdAutoRefreshFail: ");
        Map<String, Object> args = new HashMap<String, Object>();
        args.put("code", windMillError.getErrorCode());
        args.put("message", windMillError.getMessage());
        channel.invokeMethod(kWindmillEventAdAutoRefreshFail, args);

    }
}


