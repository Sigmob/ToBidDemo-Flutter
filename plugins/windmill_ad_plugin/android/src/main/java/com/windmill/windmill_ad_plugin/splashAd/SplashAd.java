package com.windmill.windmill_ad_plugin.splashAd;

import static android.view.ViewGroup.LayoutParams.MATCH_PARENT;

import android.app.Activity;
import android.os.Build;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
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
    private MethodChannel adChannel;

    private Activity activity;
    private FlutterPlugin.FlutterPluginBinding flutterPluginBinding;
    private WMSplashAdRequest splashAdRequest;
    private Map<String, Object> params;
    private WMSplashAd splashAdView;
    private WindmillAd<WindmillBaseAd> ad;
    protected AdInfo adInfo;
    private WindowManager.LayoutParams layoutParams;

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
    public void setup(MethodChannel channel, WindMillAdRequest adRequest,Activity activity ) {
        super.setup(channel, adRequest,activity);
        this.splashAdRequest= (WMSplashAdRequest) adRequest;
        this.adChannel  = channel;
        this.activity = activity;
        this.splashAdView = new WMSplashAd(activity,this.splashAdRequest,new IWMSplashAdListener(this,channel));

    }

    public void onAttachedToEngine() {
        Log.d("ToBid", "onAttachedToEngine");
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.windmill/splash");
        channel.setMethodCallHandler(this);
    }

    public void onDetachedFromEngine() {
        Log.d("ToBid", "onDetachedFromEngine");
        if(channel != null){
            channel.setMethodCallHandler(null);
        }
    }

    @Override
    public void onMethodCall( MethodCall call, MethodChannel.Result result) {
        Log.d("ToBid", "-- onMethodCall: " + call.method + ", arguments: " + call.arguments);
        String uniqId = call.argument("uniqId");
        WindmillBaseAd splashAd=this.ad.getAdInstance(uniqId);

        if (splashAd == null) {

            splashAd = this.ad.createAdInstance(SplashAd.class, getArguments(call.arguments), flutterPluginBinding, WindmillAd.AdType.Splash,activity);
        }
        if(splashAd != null){
            splashAd.excuted(call, result);
        }
    }


    void restoreNavigationBar() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            Window _window = this.activity.getWindow();
            if((layoutParams.flags&WindowManager.LayoutParams.FLAG_FULLSCREEN) != WindowManager.LayoutParams.FLAG_FULLSCREEN){
                _window.clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
            }
            _window.setAttributes(layoutParams);
        }
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

        Window _window = this.activity.getWindow();
        layoutParams = new WindowManager.LayoutParams();
        layoutParams.copyFrom(_window.getAttributes());


        this.splashAdView.showAd(null);
        return null;
    }

    public Object isReady(MethodCall call) {
        return this.splashAdView.isReady();
    }

    public Object destroy(MethodCall call) {
        if(this.adChannel != null){
            this.adChannel.setMethodCallHandler(null);
        }
        return null;
    }

}

class IWMSplashAdListener implements WMSplashAdListener {

    private MethodChannel channel;
    private SplashAd splashAd;

    public IWMSplashAdListener(final SplashAd splashAd,final MethodChannel channel) {
        this.channel = channel;
        this.splashAd = splashAd;
    }


    @Override
    public void onSplashAdSuccessPresent(final AdInfo adInfo) {
        this.splashAd.adInfo = adInfo;
        channel.invokeMethod(WindmillAdPlugin.kWindmillEventAdOpened, null);

    }

    @Override
    public void onSplashAdSuccessLoad(final String placementId) {
        channel.invokeMethod(WindmillAdPlugin.kWindmillEventAdLoaded, null);
    }

    @Override
    public void onSplashAdFailToLoad(final WindMillError windMillError,final String placementId) {
        Map<String, Object> args = new HashMap<String, Object>();
        args.put("code", windMillError.getErrorCode());
        args.put("message", windMillError.getMessage());
        channel.invokeMethod(WindmillAdPlugin.kWindmillEventAdFailedToLoad, args);
    }

    @Override
    public void onSplashAdClicked(final AdInfo adInfo) {
        channel.invokeMethod(WindmillAdPlugin.kWindmillEventAdClicked, null);

    }

    @Override
    public void onSplashClosed(final AdInfo adInfo, final IWMSplashEyeAd iwmSplashEyeAd) {
        channel.invokeMethod(WindmillAdPlugin.kWindmillEventAdClosed, null);
        splashAd.restoreNavigationBar();

    }
}


