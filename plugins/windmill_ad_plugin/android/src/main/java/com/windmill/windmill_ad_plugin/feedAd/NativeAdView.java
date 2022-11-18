package com.windmill.windmill_ad_plugin.feedAd;

import static android.view.ViewGroup.LayoutParams.MATCH_PARENT;

import android.app.Activity;

import android.view.View;

import com.windmill.sdk.natives.WMNativeAd;
import com.windmill.sdk.natives.WMNativeAdContainer;
import com.windmill.sdk.natives.WMNativeAdData;
import com.windmill.windmill_ad_plugin.core.WindmillBaseAd;

import java.util.Map;

import io.flutter.plugin.platform.PlatformView;


import android.widget.FrameLayout;


import org.json.JSONObject;

public class NativeAdView  implements PlatformView {

    protected FrameLayout contentView;

    public NativeAdView() {}
    public NativeAdView(Activity activity, WindmillBaseAd nativeAd, JSONObject customViewConfig) {
        contentView = new FrameLayout(activity);
        contentView.setLayoutParams(new FrameLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT));

        if(nativeAd != null){
            ((NativeAd)nativeAd).showAd(contentView, customViewConfig);
        }
    }


    @Override
    public View getView() {
        return contentView;
    }

    @Override
    public void dispose() {
    }


}



