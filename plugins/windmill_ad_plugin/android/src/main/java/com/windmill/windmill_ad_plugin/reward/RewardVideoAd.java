package com.windmill.windmill_ad_plugin.reward;

import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdClicked;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdClosed;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdFailedToLoad;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdLoaded;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdOpened;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdReward;
import static com.windmill.windmill_ad_plugin.WindmillAdPlugin.kWindmillEventAdVideoPlayFinished;

import android.app.Activity;

import com.windmill.sdk.WMConstants;
import com.windmill.sdk.WindMillAdRequest;
import com.windmill.sdk.WindMillError;
import com.windmill.sdk.models.AdInfo;
import com.windmill.sdk.reward.WMRewardAd;
import com.windmill.sdk.reward.WMRewardAdListener;
import com.windmill.sdk.reward.WMRewardAdRequest;
import com.windmill.sdk.reward.WMRewardInfo;
import com.windmill.windmill_ad_plugin.core.WindmillBaseAd;
import com.windmill.windmill_ad_plugin.core.WindmillAd;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class RewardVideoAd extends WindmillBaseAd implements MethodChannel.MethodCallHandler {

    private MethodChannel channel;
    private MethodChannel adChannel;

    private Activity activity;
    private FlutterPlugin.FlutterPluginBinding flutterPluginBinding;
    private WMRewardAd rewardAd;
    private WindmillAd<WindmillBaseAd> ad;
    protected AdInfo adInfo;

    public RewardVideoAd() {}
    public RewardVideoAd(Activity activity, FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        this.activity = activity;
        this.flutterPluginBinding = flutterPluginBinding;
        ad = new WindmillAd<>();

    }

    @Override
    public void setup(MethodChannel channel, WindMillAdRequest adRequest,Activity activity ) {
        super.setup(channel, adRequest,activity);
        this.adChannel = channel;
        this.activity = activity;
        this.rewardAd = new WMRewardAd(activity, new WMRewardAdRequest(adRequest.getPlacementId(),adRequest.getUserId(),adRequest.getOptions()));
        this.rewardAd.setRewardedAdListener(new IWMRewardAdListener(this,channel));
    }


    public void onAttachedToEngine() {
        Log.d("ToBid", "onAttachedToEngine");
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.windmill/reward");
        channel.setMethodCallHandler(this);
    }

    public void onDetachedFromEngine() {
        Log.d("ToBid", "onDetachedFromEngine");
        if(channel != null){
            channel.setMethodCallHandler(null);
        }
    }

    @Override
    public void onMethodCall( MethodCall call,  MethodChannel.Result result) {
        Log.d("ToBid", "-- onMethodCall: " + call.method + ", arguments: " + call.arguments);
        String uniqId = call.argument("uniqId");

        WindmillBaseAd rewardVideoAd = this.ad.getAdInstance(uniqId);
        if (rewardVideoAd == null) {
            rewardVideoAd = this.ad.createAdInstance(RewardVideoAd.class,getArguments(call.arguments), flutterPluginBinding, WindmillAd.AdType.Reward,activity);
        }
        if(rewardVideoAd != null){
            rewardVideoAd.excuted(call, result);
        }
    }

    public Object isReady(MethodCall call) {
        return this.rewardAd.isReady();
    }
    public Object load(MethodCall call) {

        this.adInfo = null; 
        this.rewardAd.loadAd();
        return null;
    }

    public Object getAdInfo(MethodCall call) {
        if(this.adInfo != null){
            return this.adInfo.toString();
        }
        return null;
     }


     public Object getCacheAdInfoList(MethodCall call){

         List<AdInfo> adinfoList =  this.rewardAd.checkValidAdCaches();
         if(adinfoList != null){
             ArrayList<String> list = new ArrayList<>(adinfoList.size());

             for (AdInfo info :adinfoList) {
                 list.add(info.toString());
             }
             return list;
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

        this.rewardAd.show(this.activity, opt);
        return null;
    }
    private Object destroy(MethodCall call) {
        if(this.rewardAd != null){
            this.rewardAd.destroy();
        }
        if(this.adChannel != null){
            this.adChannel.setMethodCallHandler(null);
        }
        return null;
    }
}

class IWMRewardAdListener implements WMRewardAdListener {

    private MethodChannel channel;
    private RewardVideoAd rewardVideoAd;
    public IWMRewardAdListener(final RewardVideoAd rewardVideoAd,final MethodChannel channel) {
        this.channel = channel;
        this.rewardVideoAd = rewardVideoAd;
    }

    @Override
    public void onVideoAdLoadSuccess(final String placemnetId) {
        channel.invokeMethod(kWindmillEventAdLoaded, null);
    }

    @Override
    public void onVideoAdLoadError(final WindMillError windMillError,final String placemnetId) {
        Map<String, Object> args = new HashMap<String, Object>();
        args.put("code", windMillError.getErrorCode());
        args.put("message", windMillError.getMessage());

        channel.invokeMethod(kWindmillEventAdFailedToLoad, args);
    }

    @Override
    public void onVideoAdPlayStart(final AdInfo adInfo) {

        rewardVideoAd.adInfo = adInfo;
        channel.invokeMethod(kWindmillEventAdOpened, null);
    }

    @Override
public void onVideoAdPlayError(final WindMillError windMillError,final String placemnetId) {
    }

    @Override
    public void onVideoAdPlayEnd(final AdInfo adInfo) {
        channel.invokeMethod(kWindmillEventAdVideoPlayFinished, null);
    }

    @Override
    public void onVideoAdClicked(final AdInfo adInfo) {
        channel.invokeMethod(kWindmillEventAdClicked, null);
    }

    @Override
    public void onVideoAdClosed(final AdInfo adInfo) {
        channel.invokeMethod(kWindmillEventAdClosed, null);
    }

    @Override
    public void onVideoRewarded(final AdInfo adInfo,final  WMRewardInfo wmRewardInfo) {

        Map<String, Object> args = new HashMap<String, Object>();
        args.put("trans_id", wmRewardInfo.getTrans_id());
        args.put("user_id", wmRewardInfo.getUser_id());

        if(wmRewardInfo.getCustomData() != null){
            args.put("customData", wmRewardInfo.getCustomData());
        }
        channel.invokeMethod(kWindmillEventAdReward, args);
    }
}

