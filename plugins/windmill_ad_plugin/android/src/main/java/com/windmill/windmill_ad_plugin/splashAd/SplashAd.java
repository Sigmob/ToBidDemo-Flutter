package com.windmill.windmill_ad_plugin.splashAd;

import static android.view.ViewGroup.LayoutParams.MATCH_PARENT;

import android.app.Activity;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.windmill.sdk.WindMillAdRequest;
import com.windmill.sdk.WindMillError;

import com.windmill.sdk.models.AdInfo;
import com.windmill.sdk.splash.IWMSplashEyeAd;
import com.windmill.sdk.splash.WMSplashAd;
import com.windmill.sdk.splash.WMSplashAdListener;
import com.windmill.sdk.splash.WMSplashAdRequest;
import com.windmill.windmill_ad_plugin.WindmillAdPlugin;
import com.windmill.windmill_ad_plugin.core.WindmillAd;
import com.windmill.windmill_ad_plugin.core.WindmillBaseAd;

import java.util.HashMap;
import java.util.Map;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class SplashAd extends WindmillBaseAd implements MethodChannel.MethodCallHandler {
    private MethodChannel channel;
    private Activity activity;
    private FlutterPlugin.FlutterPluginBinding flutterPluginBinding;
    private WMSplashAdRequest splashAdRequest;
    private Map<String, Object> params;
    private WMSplashAd splashAdView;
    private WindmillAd<WindmillBaseAd> ad;
    protected AdInfo adInfo;

    public SplashAd() {}
    public SplashAd(Activity activity, FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        this.activity = activity;
        this.flutterPluginBinding = flutterPluginBinding;
        ad = new WindmillAd<>();
    }

    public  WindmillBaseAd getAdInstance(String uniqId) {
        if(ad != null){
            return this.ad.getAdInstance(uniqId);
        }
        return null;
    }

    @Override
    public void setup(MethodChannel channel, WindMillAdRequest adRequest) {
        super.setup(channel, adRequest);
        this.splashAdRequest= (WMSplashAdRequest) adRequest;
        this.channel  = channel;
    }

    public void initAdView(Activity activity){
        this.splashAdView = new WMSplashAd(activity,this.splashAdRequest,new IWMSplashAdListener(this,channel));

    }
    public void onAttachedToEngine() {
        Log.d("Codi", "onAttachedToEngine");
        MethodChannel channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.windmill/splash");
        channel.setMethodCallHandler(this);
    }

    public void onDetachedFromEngine() {
        Log.d("Codi", "onDetachedFromEngine");
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onMethodCall( MethodCall call, MethodChannel.Result result) {
        Log.d("Codi", "-- onMethodCall: " + call.method + ", arguments: " + call.arguments);
        String uniqId = call.argument("uniqId");
        WindmillBaseAd splashAd=this.ad.getAdInstance(uniqId);

        if (splashAd == null) {

            splashAd = this.ad.createAdInstance(SplashAd.class, getArguments(call.arguments), flutterPluginBinding, WindmillAd.AdType.Splash);
            ((SplashAd)splashAd).initAdView(activity) ;
        }
        splashAd.excuted(call, result);
    }
    
    public Object getAdInfo(MethodCall call) {
        if(this.adInfo != null){
            return this.adInfo.toString();
        }
        return null;
     }

    public Object load(MethodCall call) {
        this.adInfo = null;
        this.splashAdView.loadAdOnly();
        return null;
    }

    public Object showAd(MethodCall call){
        this.splashAdView.showAd(null);
        return null;
    }

    public Object isReady(MethodCall call) {
        return this.splashAdView.isReady();
    }

    public Object destory(MethodCall call) {
        return null;
    }

}

class IWMSplashAdListener implements WMSplashAdListener {

    private MethodChannel channel;
    private SplashAd splashAd;

    public IWMSplashAdListener(SplashAd splashAd,MethodChannel channel) {
        this.channel = channel;
        this.splashAd = splashAd;
    }


    @Override
    public void onSplashAdSuccessPresent(AdInfo adInfo) {
        this.splashAd.adInfo = adInfo;
        channel.invokeMethod(WindmillAdPlugin.kWindmillEventAdOpened, null);

    }

    @Override
    public void onSplashAdSuccessLoad(String s) {
        channel.invokeMethod(WindmillAdPlugin.kWindmillEventAdLoaded, null);
    }

    @Override
    public void onSplashAdFailToLoad(WindMillError windMillError, String s) {
        Map<String, Object> args = new HashMap<>(){{
            put("code", windMillError.getErrorCode());
            put("message", windMillError.getMessage());
        }};
        channel.invokeMethod(WindmillAdPlugin.kWindmillEventAdFailedToLoad, args);
    }

    @Override
    public void onSplashAdClicked(AdInfo adInfo) {
        channel.invokeMethod(WindmillAdPlugin.kWindmillEventAdClicked, null);

    }

    @Override
    public void onSplashClosed(AdInfo adInfo, IWMSplashEyeAd iwmSplashEyeAd) {
        channel.invokeMethod(WindmillAdPlugin.kWindmillEventAdClosed, null);

    }
}


