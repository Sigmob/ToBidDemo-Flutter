package com.windmill.windmill_ad_plugin.feedAd;


import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdClicked;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdDidDislike;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdFailedToLoad;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdLoaded;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdOpened;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdRenderFail;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdRenderSuccess;

import android.app.Activity;
import android.graphics.Color;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.windmill.sdk.WindMillAdRequest;
import com.windmill.sdk.WindMillError;
import com.windmill.sdk.models.AdInfo;
import com.windmill.sdk.natives.WMNativeAd;
import com.windmill.sdk.natives.WMNativeAdContainer;
import com.windmill.sdk.natives.WMNativeAdData;
import com.windmill.sdk.natives.WMNativeAdRender;
import com.windmill.sdk.natives.WMNativeAdRequest;
import com.windmill.windmill_ad_plugin.core.WindmillAd;
import com.windmill.windmill_ad_plugin.core.WindmillBaseAd;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class NativeAd extends WindmillBaseAd implements MethodChannel.MethodCallHandler {
    private MethodChannel channel;

    private Activity activity;
    private FlutterPlugin.FlutterPluginBinding flutterPluginBinding;
    protected WMNativeAd nativeAd;
    private WMNativeAdRequest nativeAdRequest;
    protected WMNativeAdContainer wmNativeContainer;
    private Map<String, Object> params;
    protected WMNativeAdData wmNativeAdData;
    protected FrameLayout contentView;
    protected boolean isShowAd;
    private WindmillAd<WindmillBaseAd> ad;
    protected AdInfo adInfo;

    public NativeAd() {
    }

    public NativeAd(Activity activity, FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        this.activity = activity;
        this.flutterPluginBinding = flutterPluginBinding;
        ResourceUtil.InitUtil(activity.getApplicationContext());
        ad = new WindmillAd<>();
    }

    @Override
    public void setup(MethodChannel channel, WindMillAdRequest adRequest,Activity activity ) {
        super.setup(channel, adRequest,activity);
        this.channel = channel;
        this.nativeAdRequest = (WMNativeAdRequest) adRequest;
        this.activity = activity;
        this.nativeAd = new WMNativeAd(activity, nativeAdRequest);
    }



    public void onAttachedToEngine() {
        Log.d("Codi", "onAttachedToEngine");
        MethodChannel channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.windmill/native");
        channel.setMethodCallHandler(this);
    }

    @Override
    public WindmillBaseAd getAdInstance(String uniqId) {
        if (ad != null) {
            return this.ad.getAdInstance(uniqId);
        }
        return null;
    }

    public void onDetachedFromEngine() {
        Log.d("Codi", "onDetachedFromEngine");
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        Log.d("Codi", "-- onMethodCall: " + call.method + ", arguments: " + call.arguments);
        String uniqId = call.argument("uniqId");

        WindmillBaseAd nativeAd = this.ad.getAdInstance(uniqId);
        if (nativeAd == null) {
            nativeAd = this.ad.createAdInstance(NativeAd.class, getArguments(call.arguments), flutterPluginBinding, WindmillAd.AdType.Native,activity);
        }
        nativeAd.excuted(call, result);
    }


    private Object destory(MethodCall call) {
        isShowAd = false;

        this.nativeAd.destroy();
        return null;
    }

    @Override
    public Object isReady(MethodCall o) {
        return wmNativeAdData != null;
    }

    public Object getAdInfo(MethodCall call) {
        if (this.adInfo != null) {
            return this.adInfo.toString();
        }
        return null;
    }

    public Object load(MethodCall call) {
        this.adInfo = null;
        nativeAd.loadAd(new IWMNativeAdLoadListener(channel, this));
        return null;
    }

    public void fillAd(WMNativeAdData nativeAdData) {

        this.wmNativeAdData = nativeAdData;
    }

    public void showAd(ViewGroup view, JSONObject customViewConfig) {
        JSONObject rootView = null;
        ViewConfigItem rootViewItem = null;

        if (customViewConfig != null) {
            try {
                rootView = customViewConfig.getJSONObject("rootView");
            } catch (JSONException e) {
                e.printStackTrace();
            }
            rootViewItem = new ViewConfigItem(rootView);

        }

        if (wmNativeContainer != null) {
            wmNativeContainer.removeAllViews();
        }

        if (contentView != null) {
            contentView.removeAllViews();
        }

        wmNativeContainer = new WMNativeAdContainer(activity);

        if (rootViewItem == null || TextUtils.isEmpty(rootViewItem.getBackgroundColor())) {
            wmNativeContainer.setBackgroundColor(Color.WHITE);
        } else {
            wmNativeContainer.setBackgroundColor(Color.parseColor(rootViewItem.getBackgroundColor()));
        }

        wmNativeAdData.setInteractionListener(new IWMNativeAdListener(this, channel));
        wmNativeAdData.setDislikeInteractionCallback(this.activity, new IWMNativeDislikeListener(channel));

        if (wmNativeAdData.isExpressAd()) {
            wmNativeAdData.render();
            View expressAdView = wmNativeAdData.getExpressAdView();
            wmNativeContainer.addView(expressAdView,new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,ViewGroup.LayoutParams.WRAP_CONTENT));
        }else {
            WMNativeAdRender adRender;
            if (customViewConfig == null || !customViewConfig.has("mainAdView")) {
                adRender = new NativeAdRender();
            } else {
                adRender = new NativeAdRenderCustomView(customViewConfig);
            }

            wmNativeAdData.connectAdToView(activity, wmNativeContainer, adRender);
        }


        FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        view.addView(wmNativeContainer, layoutParams);
    }


}


class IWMNativeDislikeListener implements WMNativeAdData.DislikeInteractionCallback {

    private MethodChannel channel;

    public IWMNativeDislikeListener(MethodChannel channel) {
        this.channel = channel;
    }

    @Override
    public void onShow() {

    }

    @Override
    public void onSelected(int i, String s, boolean b) {
        Map<String, Object> args = new HashMap<>() {{
            put("reason", s);
        }};
        channel.invokeMethod(kWindmillEventAdDidDislike, args);

    }

    @Override
    public void onCancel() {

    }
}

class IWMNativeMediaListener implements WMNativeAdData.NativeADMediaListener {
    @Override
    public void onVideoLoad() {

    }

    @Override
    public void onVideoError(WindMillError windMillError) {

    }

    @Override
    public void onVideoStart() {

    }

    @Override
    public void onVideoPause() {

    }

    @Override
    public void onVideoResume() {

    }

    @Override
    public void onVideoCompleted() {

    }
}

class IWMNativeAdListener implements WMNativeAdData.NativeAdInteractionListener {
    private MethodChannel channel;
    private NativeAd nativeAd;

    public IWMNativeAdListener(NativeAd nativeAd, MethodChannel channel) {
        this.channel = channel;
        this.nativeAd = nativeAd;
    }

    @Override
    public void onADExposed(AdInfo adInfo) {

        this.nativeAd.adInfo = adInfo;
        channel.invokeMethod(kWindmillEventAdOpened, null);

    }

    @Override
    public void onADClicked(AdInfo adInfo) {
        channel.invokeMethod(kWindmillEventAdClicked, null);

    }

    @Override
    public void onADRenderSuccess(AdInfo adInfo, View view, float width, float height) {
        view.post(new Runnable() {
            @Override
            public void run() {
                int view_width = view.getWidth();
                int view_height = view.getHeight();

                HashMap<String, Integer> args = new HashMap<>() {{
                    put("width", view_width);
                    put("height", view_height);
                }};

                if(view_width>0 && view_height>0){
                    FrameLayout.LayoutParams layoutParams = (FrameLayout.LayoutParams)nativeAd.wmNativeContainer.getLayoutParams();
                    layoutParams.width = view.getWidth();
                    layoutParams.height = view.getHeight();
                    layoutParams.gravity = Gravity.CENTER_HORIZONTAL;


                    nativeAd.wmNativeContainer.setLayoutParams(layoutParams);
                }


                nativeAd.adInfo = adInfo;

                channel.invokeMethod(kWindmillEventAdRenderSuccess, args);

            }
        });



    }

    @Override
    public void onADError(AdInfo adInfo, WindMillError windMillError) {

        Map<String, Object> args = new HashMap<>() {{
            put("code", windMillError.getErrorCode());
            put("message", windMillError.getMessage());
        }};
        channel.invokeMethod(kWindmillEventAdRenderFail, args);

    }


}

class IWMNativeAdLoadListener implements WMNativeAd.NativeAdLoadListener {

    private MethodChannel channel;
    private NativeAd nativeAd;

    public IWMNativeAdLoadListener(MethodChannel channel, NativeAd nativeAd) {
        this.channel = channel;
        this.nativeAd = nativeAd;
    }

    @Override
    public void onError(WindMillError windMillError, String s) {
        Map<String, Object> args = new HashMap<>() {{
            put("code", windMillError.getErrorCode());
            put("message", windMillError.getMessage());
        }};
        channel.invokeMethod(kWindmillEventAdFailedToLoad, args);
    }


    @Override
    public void onFeedAdLoad(String s) {

        if (this.nativeAd != null && this.nativeAd.nativeAd != null) {
            List<WMNativeAdData> nativeADDataList = this.nativeAd.nativeAd.getNativeADDataList();
            if (nativeADDataList != null && nativeADDataList.size() > 0) {
                this.nativeAd.fillAd(nativeADDataList.get(0));
            }
            channel.invokeMethod(kWindmillEventAdLoaded, null);
        }

    }


}

