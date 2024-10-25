package com.windmill.windmill_ad_plugin.feedAd;


import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdClicked;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdDidDislike;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdFailedToLoad;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdLoaded;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdOpened;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdRenderFail;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdRenderSuccess;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.windmill.sdk.WMConstants;
import com.windmill.sdk.WindMillAdRequest;
import com.windmill.sdk.WindMillError;
import com.windmill.sdk.models.AdInfo;
import com.windmill.sdk.natives.WMNativeAd;
import com.windmill.sdk.natives.WMNativeAdContainer;
import com.windmill.sdk.natives.WMNativeAdData;
import com.windmill.sdk.natives.WMNativeAdRender;
import com.windmill.sdk.natives.WMNativeAdRequest;
import com.windmill.windmill_ad_plugin.core.IWMAdAutoLoad;
import com.windmill.windmill_ad_plugin.core.IWMAdSourceStatus;
import com.windmill.windmill_ad_plugin.core.WindmillAd;
import com.windmill.windmill_ad_plugin.core.WindmillBaseAd;
import com.windmill.windmill_ad_plugin.utils.ResourceUtil;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class NativeAd extends WindmillBaseAd implements MethodChannel.MethodCallHandler {
    private MethodChannel channel;

    private MethodChannel adChannel;

    private Activity activity;
    private FlutterPlugin.FlutterPluginBinding flutterPluginBinding;
    protected WMNativeAd nativeAd;
    private WMNativeAdRequest nativeAdRequest;
    protected WMNativeAdContainer wmNativeContainer;
    protected WMNativeAdData wmNativeAdData;
    protected boolean isShowAd;
    private WindmillAd<WindmillBaseAd> ad;
    protected AdInfo adInfo;
    private int mWidth = 0;

    public NativeAd() {

    }

    public NativeAd(Activity activity, FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        this.activity = activity;
        this.flutterPluginBinding = flutterPluginBinding;
        ResourceUtil.InitUtil(activity.getApplicationContext());
        ad = new WindmillAd<>();
    }

    public int dp2px(Context context, float dp) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (dp * scale + 0.5f);
    }

    @Override
    public void setup(MethodChannel channel, WindMillAdRequest adRequest, Activity activity) {
        super.setup(channel, adRequest, activity);
        this.adChannel = channel;
        this.nativeAdRequest = (WMNativeAdRequest) adRequest;
        this.activity = activity;
        this.nativeAd = new WMNativeAd(activity, nativeAdRequest);
        this.nativeAd.setAdSourceStatusListener(new IWMAdSourceStatus(channel));
        this.nativeAd.setAutoLoadListener(new IWMAdAutoLoad(channel));
        try {
            Map<String, Object> options = nativeAdRequest.getOptions();
            if (options != null) {
                Object o = options.get(WMConstants.AD_WIDTH);
                if (o != null) {
                    mWidth = (int) o;
                }
            }

            if (mWidth != 0) {
                mWidth = dp2px(activity, mWidth);
            } else {
                mWidth = activity.getResources().getDisplayMetrics().widthPixels - dp2px(activity, 20);
            }
        } catch (Exception e) {
            e.printStackTrace();
            mWidth = 1080;
        }
    }

    public void onAttachedToEngine() {
        Log.d("ToBid", "onAttachedToEngine");
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.windmill/native");
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
        Log.d("ToBid", "onDetachedFromEngine");
        if (channel != null) {
            channel.setMethodCallHandler(null);
        }
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        Log.d("ToBid", "-- onMethodCall: " + call.method + ", arguments: " + call.arguments);
        String uniqId = call.argument("uniqId");

        WindmillBaseAd nativeAd = this.ad.getAdInstance(uniqId);
        if (nativeAd == null) {
            nativeAd = this.ad.createAdInstance(NativeAd.class, getArguments(call.arguments), flutterPluginBinding, WindmillAd.AdType.Native, activity);
        }
        if (call.method.equals("initRequest")) {
            // 实例化adRequest对象
            return;
        }
        if (nativeAd != null) {
            nativeAd.excuted(call, result);
        }
    }

    public Object getAppInfo(MethodCall call) {

        if (wmNativeAdData != null) {
            WMNativeAdData.AppInfo appInfo = wmNativeAdData.getAppInfo();

            if (appInfo != null) {
                HashMap map = new HashMap<>();

                map.put("appName", appInfo.getAppName());
                map.put("developerName", appInfo.getDeveloperName());
                map.put("appVersion", appInfo.getAppVersion());
                map.put("privacyUrl", appInfo.getPrivacyUrl());
                map.put("permissionInfoUrl", appInfo.getPermissionInfoUrl());
                map.put("permissionInfo", appInfo.getPermissionInfo());
                map.put("functionDescUrl", appInfo.getFunctionDescUrl());

                return map;

            }
        }
        return null;
    }

    public Object getCacheAdInfoList(MethodCall call) {

        List<AdInfo> adInfoList = this.nativeAd.checkValidAdCaches();
        if (adInfoList != null) {
            ArrayList<String> list = new ArrayList<>(adInfoList.size());

            for (AdInfo info : adInfoList) {
                list.add(info.toString());
            }
            return list;
        }

        return null;
    }

    private Object destroy(MethodCall call) {
        isShowAd = false;
        if (this.nativeAd != null) {
            this.nativeAd.destroy();
        }
        if (this.adChannel != null) {
            this.adChannel.setMethodCallHandler(null);
        }
        return null;
    }

    @Override
    public Object isReady(MethodCall o) {
        return nativeAd.isReady();
    }

    public Object getAdInfo(MethodCall call) {
        if (this.adInfo != null) {
            return this.adInfo.toString();
        }
        return null;
    }

    public Object load(MethodCall call) {
        this.adInfo = null;
        nativeAd.loadAd(new IWMNativeAdLoadListener(this.adChannel, this));
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

        wmNativeContainer = new WMNativeAdContainer(activity);

        if (rootViewItem == null || TextUtils.isEmpty(rootViewItem.getBackgroundColor())) {
            wmNativeContainer.setBackgroundColor(Color.WHITE);
        } else {
            wmNativeContainer.setBackgroundColor(Color.parseColor(rootViewItem.getBackgroundColor()));
        }

        wmNativeAdData.setInteractionListener(new IWMNativeAdListener(this, this.adChannel, mWidth));
        wmNativeAdData.setDislikeInteractionCallback(this.activity, new IWMNativeDislikeListener(this.adChannel));
        if (wmNativeAdData.isExpressAd()) {
            wmNativeAdData.render();
            View expressAdView = wmNativeAdData.getExpressAdView();
            wmNativeContainer.addView(expressAdView, new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        } else {
            WMNativeAdRender adRender;
            if (customViewConfig == null || !customViewConfig.has("mainAdView")) {//走自己内部的模板
                android.util.Log.d("lance", "showAd: --------111---------");
                adRender = new NativeAdRender(mWidth);
            } else {
                android.util.Log.d("lance", "showAd: -------222-------");
                adRender = new NativeAdRenderCustomView(customViewConfig);
            }

            wmNativeAdData.connectAdToView(activity, wmNativeContainer, adRender);
            wmNativeContainer.post(new Runnable() {
                @Override
                public void run() {
                    // 指定宽高测量规范，例如AT_MOST、EXACTLY或UNSPECIFIED
                    int widthMeasureSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                    int heightMeasureSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);

                    // 调用measure方法进行测量
                    wmNativeContainer.measure(widthMeasureSpec, heightMeasureSpec);

                    int view_width = wmNativeContainer.getMeasuredWidth();
                    int view_height = wmNativeContainer.getMeasuredHeight();

                    Map<String, Object> args = new HashMap<String, Object>();
                    args.put("width", view_width);
                    args.put("height", view_height);

                    android.util.Log.d("lance", "444--------onADRenderSuccess: " + view_width + ":" + view_height);

                    adChannel.invokeMethod(kWindmillEventAdRenderSuccess, args);
                }
            });
        }

        FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);

        view.addView(wmNativeContainer, layoutParams);
    }
}

class IWMNativeDislikeListener implements WMNativeAdData.DislikeInteractionCallback {

    private MethodChannel channel;

    public IWMNativeDislikeListener(final MethodChannel channel) {
        this.channel = channel;
    }

    @Override
    public void onShow() {

    }

    @Override
    public void onSelected(final int i, final String reason, final boolean b) {
        Map<String, Object> args = new HashMap<String, Object>();
        args.put("reason", reason);
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
    private int mWidth;

    public IWMNativeAdListener(final NativeAd nativeAd, final MethodChannel channel, int width) {
        this.channel = channel;
        this.nativeAd = nativeAd;
        this.mWidth = width;
    }

    @Override
    public void onADExposed(final AdInfo adInfo) {
        this.nativeAd.adInfo = adInfo;
        channel.invokeMethod(kWindmillEventAdOpened, null);
    }

    @Override
    public void onADClicked(final AdInfo adInfo) {
        channel.invokeMethod(kWindmillEventAdClicked, null);
    }

    @Override
    public void onADRenderSuccess(final AdInfo adInfo, final View view, final float width, final float height) {
        try {
            android.util.Log.d("lance", "111--------onADRenderSuccess: " + view.getWidth() + ":" + view.getHeight());

            android.util.Log.d("lance", "222--------onADRenderSuccess: " + width + ":" + height);

            view.postDelayed(new Runnable() {
                @Override
                public void run() {

                    int makeMeasureSpec;

                    ViewGroup.LayoutParams layoutParams = view.getLayoutParams();
                    if (layoutParams == null) {
                        layoutParams = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
                        view.setLayoutParams(layoutParams);
                    }

                    int childMeasureSpec = ViewGroup.getChildMeasureSpec(0, 0, layoutParams.width);

                    android.util.Log.d("lance", "333------childMeasureSpec--onADRenderSuccess: " + childMeasureSpec);

                    if (childMeasureSpec == 0) {
                        childMeasureSpec = View.MeasureSpec.makeMeasureSpec(mWidth, View.MeasureSpec.EXACTLY);
                    }

                    android.util.Log.d("lance", "444------childMeasureSpec--onADRenderSuccess: " + childMeasureSpec);

                    int i2 = layoutParams.height;
                    if (i2 > 0) {
                        makeMeasureSpec = View.MeasureSpec.makeMeasureSpec(i2, View.MeasureSpec.EXACTLY);
                    } else {
                        makeMeasureSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
                    }

                    view.measure(childMeasureSpec, makeMeasureSpec);
                    final int view_width = view.getMeasuredWidth();
                    final int view_height = view.getMeasuredHeight();

                    Map<String, Object> args = new HashMap<>();
                    args.put("width", view_width > width ? view_width : width);
                    args.put("height", view_height > height ? view_height : height);

                    android.util.Log.d("lance", "555--------onADRenderSuccess: " + view_width + ":" + view_height + ":" + adInfo.getNetworkId());

//                if (view_width > 0 && view_height > 0) {
//                    FrameLayout.LayoutParams layoutParams = (FrameLayout.LayoutParams) nativeAd.wmNativeContainer.getLayoutParams();
//                    layoutParams.width = view.getWidth();
//                    layoutParams.height = view.getHeight();
//                    layoutParams.gravity = Gravity.CENTER_HORIZONTAL;
//
//
//                    nativeAd.wmNativeContainer.setLayoutParams(layoutParams);
//                }

                    nativeAd.adInfo = adInfo;

                    channel.invokeMethod(kWindmillEventAdRenderSuccess, args);
                }
            }, 300);


//            view.post(new Runnable() {
//                @Override
//                public void run() {
//
//                    // 指定宽高测量规范，例如AT_MOST、EXACTLY或UNSPECIFIED
//                    int widthMeasureSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
//                    int heightMeasureSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
//
//                    // 调用measure方法进行测量
//                    view.measure(widthMeasureSpec, heightMeasureSpec);
//
//                    final int view_width = view.getMeasuredWidth();
//                    final int view_height = view.getMeasuredHeight();
//
//                    Map<String, Object> args = new HashMap<String, Object>();
//                    args.put("width", view_width);
//                    args.put("height", view_height);
//
//                    android.util.Log.d("lance", "333--------onADRenderSuccess: " + view_width + ":" + view_height);
//
//                    nativeAd.adInfo = adInfo;
//
//                    channel.invokeMethod(kWindmillEventAdRenderSuccess, args);
//                }
//            });

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onADError(final AdInfo adInfo, final WindMillError windMillError) {

        Map<String, Object> args = new HashMap<String, Object>();
        args.put("code", windMillError.getErrorCode());
        args.put("message", windMillError.getMessage());

        channel.invokeMethod(kWindmillEventAdRenderFail, args);

    }


}

class IWMNativeAdLoadListener implements WMNativeAd.NativeAdLoadListener {

    private MethodChannel channel;
    private NativeAd nativeAd;

    public IWMNativeAdLoadListener(final MethodChannel channel, final NativeAd nativeAd) {
        this.channel = channel;
        this.nativeAd = nativeAd;
    }

    @Override
    public void onError(final WindMillError windMillError, final String placementId) {
        Map<String, Object> args = new HashMap<String, Object>();
        args.put("code", windMillError.getErrorCode());
        args.put("message", windMillError.getMessage());
        channel.invokeMethod(kWindmillEventAdFailedToLoad, args);
    }


    @Override
    public void onFeedAdLoad(final String placementId) {

        if (this.nativeAd != null && this.nativeAd.nativeAd != null) {
            List<WMNativeAdData> nativeADDataList = this.nativeAd.nativeAd.getNativeADDataList();
            if (nativeADDataList != null && nativeADDataList.size() > 0) {
                this.nativeAd.fillAd(nativeADDataList.get(0));
            }
            channel.invokeMethod(kWindmillEventAdLoaded, null);
        }

    }


}

