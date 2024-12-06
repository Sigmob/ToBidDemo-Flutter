package com.windmill.windmill_ad_plugin;

import android.app.Activity;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.location.Location;
import android.text.TextUtils;
import android.webkit.WebView;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.stream.Collectors;

import com.windmill.sdk.WMAdConfig;
import com.windmill.sdk.WMAdnInitConfig;
import com.windmill.sdk.WMCustomController;
import com.windmill.sdk.WMNetworkConfig;
import com.windmill.sdk.WMWaterfallFilter;
import com.windmill.sdk.WindMillAd;
import com.windmill.sdk.WindMillConsentStatus;
import com.windmill.sdk.WindMillUserAgeStatus;
import com.windmill.windmill_ad_plugin.banner.BannerAd;
import com.windmill.windmill_ad_plugin.feedAd.NativeAd;
import com.windmill.windmill_ad_plugin.reward.RewardVideoAd;
import com.windmill.windmill_ad_plugin.interstitial.InterstitialAd;
import com.windmill.windmill_ad_plugin.splashAd.SplashAd;

import org.json.JSONException;
import org.json.JSONObject;

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

    private WMCustomController wmCustomController;

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

        if (call.method.equals("setPresetLocalStrategyPath")) {
            setPresetLocalStrategyPath(call, result);
        } else if (call.method.equals("networkPreInit")) {
            networkPreInit(call, result);
        } else if (call.method.equals("setupSdkWithAppId")) {
            setupSdkWithAppId(call, result);
        } else if (call.method.equals("getSdkVersion")) {
            getSdkVersion(call, result);
        } else if (call.method.equals("setUserId")) {
            String userId = call.argument("userId");
            WindMillAd.setUserId(userId);
        } else if (call.method.equals("setAdultStatus")) {
            int state = call.argument("state");
            WindMillAd.sharedAds().setAdult(state == 0);
        } else if (call.method.equals("requestPermission")) {
            WindMillAd.requestPermission(this.activity);
        } else if (call.method.equals("setPersonalizedStatus")) {
            int state = call.argument("state");
            WindMillAd.sharedAds().setPersonalizedAdvertisingOn(state == 0);
        } else if (call.method.equals("customDevice")) {
            final Boolean isCanUseAppList = call.argument("isCanUseAppList");
            final Boolean isCanUseWifiState = call.argument("isCanUseWifiState");
            final Boolean isCanUseWriteExternal = call.argument("isCanUseWriteExternal");
            final Boolean isCanUsePermissionRecordAudio = call.argument("isCanUsePermissionRecordAudio");
            final Boolean isCanUseAndroidId = call.argument("isCanUseAndroidId");
            final Boolean isCanUseLocation = call.argument("isCanUseLocation");
            final Boolean isCanUsePhoneState = call.argument("isCanUsePhoneState");
            final String customAndroidId = call.argument("customAndroidId");
            final String customIMEI = call.argument("customIMEI");
            final String customOAID = call.argument("customOAID");
            final String customMacAddress = call.argument("customMacAddress");
            HashMap customLocation = call.argument("customLocation");

//            Log.d(TAG, "customDevice: isCanUseAppList:" + isCanUseAppList +
//                    ":isCanUseWifiState:" + isCanUseWifiState +
//                    ":isCanUseWriteExternal:" + isCanUseWriteExternal +
//                    ":isCanUsePermissionRecordAudio:" + isCanUsePermissionRecordAudio +
//                    ":isCanUseAndroidId:" + isCanUseAndroidId +
//                    ":isCanUseLocation:" + isCanUseLocation +
//                    ":isCanUsePhoneState:" + isCanUsePhoneState +
//                    ":customAndroidId:" + customAndroidId +
//                    ":customIMEI:" + customIMEI +
//                    ":customOAID:" + customOAID +
//                    ":customMacAddress:" + customMacAddress +
//                    ":customLocation:" + customLocation);

            try {
                final Location location = new Location("");

                if (customLocation != null) {
                    double longitude = customLocation.get("longitude") == null ? 0 : (Double) customLocation.get("longitude");
                    double latitude = customLocation.get("latitude") == null ? 0 : (Double) customLocation.get("latitude");
                    location.setLongitude(longitude);
                    location.setLatitude(latitude);
                }

                wmCustomController = new WMCustomController() {
                    @Override
                    public boolean isCanUseLocation() {
                        return isCanUseLocation == null ? true : isCanUseLocation;
                    }

                    @Override
                    public Location getLocation() {
                        return location;
                    }

                    @Override
                    public boolean isCanUsePhoneState() {
                        return isCanUsePhoneState == null ? true : isCanUsePhoneState;
                    }

                    @Override
                    public String getDevImei() {
                        return customIMEI;
                    }

                    @Override
                    public boolean isCanUseAndroidId() {
                        return isCanUseAndroidId == null ? true : isCanUseAndroidId;
                    }

                    @Override
                    public String getAndroidId() {
                        return customAndroidId;
                    }

                    @Override
                    public String getDevOaid() {
                        return customOAID;
                    }

                    @Override
                    public boolean isCanUseAppList() {
                        return isCanUseAppList == null ? true : isCanUseAppList;
                    }

                    @Override
                    public List<PackageInfo> getInstalledPackages() {
                        if (isCanUseAppList != null && !isCanUseAppList) {
                            return getAllUserInstalledApps();
                        }
                        return super.getInstalledPackages();
                    }

                    @Override
                    public boolean isCanUseWifiState() {
                        return isCanUseWifiState == null ? true : isCanUseWifiState;
                    }

                    @Override
                    public boolean isCanUseWriteExternal() {
                        return isCanUseWriteExternal == null ? true : isCanUseWriteExternal;
                    }

                    @Override
                    public boolean isCanUsePermissionRecordAudio() {
                        return isCanUsePermissionRecordAudio == null ? true : isCanUsePermissionRecordAudio;
                    }

                    @Override
                    public String getMacAddress() {
                        return customMacAddress;
                    }
                };
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if (call.method.equals("initCustomGroup")) {

            String customGroup = call.argument("customGroup");
            try {
                JSONObject jsonObject = new JSONObject(customGroup);
                HashMap map = new HashMap();
                Iterator<String> keys = jsonObject.keys();
                while (keys.hasNext()) {
                    String next = keys.next();
                    map.put(next, jsonObject.getString(next));
                }

                WindMillAd.sharedAds().initCustomMap(map);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        } else if (call.method.equals("initCustomGroupForPlacement")) {

            String customGroup = call.argument("customGroup");
            String placementId = call.argument("placementId");
            try {
                JSONObject jsonObject = new JSONObject(customGroup);
                HashMap map = new HashMap();
                Iterator<String> keys = jsonObject.keys();
                while (keys.hasNext()) {
                    String next = keys.next();
                    map.put(next, jsonObject.getString(next));
                }

                WindMillAd.sharedAds().initPlacementCustomMap(placementId, map);

            } catch (JSONException e) {
                e.printStackTrace();
            }
        } else if (call.method.equals("setAge")) {
            int age = call.argument("age");
            WindMillAd.sharedAds().setUserAge(age);
        } else if (call.method.equals("setOAIDCertPem")) {
            String certPemStr = call.argument("certPem");
            WindMillAd.sharedAds().setOAIDCertPem(certPemStr);
        } else if (call.method.equals("setCOPPAStatus")) {
            int state = call.argument("state");
            switch (state) {
                case 0: {
                    WindMillAd.sharedAds().setIsAgeRestrictedUser(WindMillUserAgeStatus.WindAgeRestrictedStatusUnknown);
                }
                break;
                case 1: {
                    WindMillAd.sharedAds().setIsAgeRestrictedUser(WindMillUserAgeStatus.WindAgeRestrictedStatusYES);
                }
                break;
                case 2: {
                    WindMillAd.sharedAds().setIsAgeRestrictedUser(WindMillUserAgeStatus.WindAgeRestrictedStatusNO);
                }
                break;
                default: {
                }
                break;
            }
        } else if (call.method.equals("setCCPAStatus")) {

        } else if (call.method.equals("setGDPRStatus")) {
            int state = call.argument("state");
            switch (state) {
                case 0: {
                    WindMillAd.sharedAds().setUserGDPRConsentStatus(WindMillConsentStatus.UNKNOWN);
                }
                break;
                case 1: {
                    WindMillAd.sharedAds().setUserGDPRConsentStatus(WindMillConsentStatus.ACCEPT);
                }
                break;
                case 2: {
                    WindMillAd.sharedAds().setUserGDPRConsentStatus(WindMillConsentStatus.DENIED);
                }
                break;
                default: {
                }
                break;
            }
        } else if (call.method.equals("sceneExpose")) {
            String sceneId = call.argument("sceneId");
            String sceneName = call.argument("sceneName");
            WindMillAd.sharedAds().reportSceneExposure(sceneId, sceneName);
        } else if (call.method.equals("getUid")) {

        } else if (call.method.equals("setDebugEnable")) {
            boolean flags = call.argument("flags");
            WindMillAd.sharedAds().setDebugEnable(flags);
        } else if (call.method.equals("setSupportMultiProcess")) {
            boolean flags = call.argument("flags");
            WindMillAd.sharedAds().setSupportMultiProcess(flags);
        } else if (call.method.equals("setWxOpenAppIdAndUniversalLink")) {
            String wxAppId = call.argument("wxAppId");
            WindMillAd.sharedAds().setWxOpenAppId(wxAppId);
        } else if (call.method.equals("setFilterNetworkFirmIdList")) {
            String placementId = call.argument("placementId");
            List<String> networkFirmIdList = call.argument("networkFirmIdList");
            WindMillAd.sharedAds().setFilterNetworkFirmIdList(placementId, networkFirmIdList);
        } else if (call.method.equals("addFilter")) {
            addFilter(call, result);
        } else if (call.method.equals("addWaterfallFilter")) {
            addWaterfallFilter(call, result);
        } else if (call.method.equals("removeFilter")) {
            WindMillAd.sharedAds().removeFilters();
        } else if (call.method.equals("removeFilterWithPlacementId")) {
            String placementId = call.argument("placementId");
            if (placementId != null) {
                WindMillAd.sharedAds().removeFilterWithPlacementIds(placementId);
            }
        } else {
            result.notImplemented();
        }
    }

    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        rewardVideoAd = new RewardVideoAd(this.activity, this.flutterPluginBinding);
        rewardVideoAd.onAttachedToEngine();

        interstitialAd = new InterstitialAd(this.activity, this.flutterPluginBinding);
        interstitialAd.onAttachedToEngine();

        bannerAd = new BannerAd(activity, flutterPluginBinding);
        bannerAd.onAttachedToEngine();

        nativeAd = new NativeAd(activity, flutterPluginBinding);
        nativeAd.onAttachedToEngine();

        splashAd = new SplashAd(activity, flutterPluginBinding);
        splashAd.onAttachedToEngine();

        PlatformViewRegistry platformViewRegistry = this.flutterPluginBinding.getPlatformViewRegistry();

        platformViewRegistry.registerViewFactory(WindmillAdPlugin.kWindmillBannerAdViewId, new WindMillNativeAdViewFactory(WindmillAdPlugin.kWindmillBannerAdViewId, this.bannerAd, this.activity));

        platformViewRegistry.registerViewFactory(WindmillAdPlugin.kWindmillFeedAdViewId, new WindMillNativeAdViewFactory(WindmillAdPlugin.kWindmillFeedAdViewId, this.nativeAd, this.activity));
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

    private void addFilter(MethodCall call, MethodChannel.Result result) {

        String placementId = call.argument("placementId");

        ArrayList<HashMap<String, Object>> list = call.argument("filterInfoList");

        Log.d(TAG, "----------addFilter----------" + placementId + ":" + list);

        if (!TextUtils.isEmpty(placementId)) {

            if (list != null && !list.isEmpty()) {

                WMWaterfallFilter filter = new WMWaterfallFilter(placementId);

                for (HashMap map : list) {
                    int networkId = -1;
                    List<String> unitIdList = null;

                    Object obj = map.get("networkId");
                    if (obj instanceof Integer) {
                        networkId = (int) obj;
                    }

                    obj = map.get("unitIdList");
                    if (obj instanceof List) {
                        unitIdList = (List<String>) obj;
                    }

                    if (networkId != -1) {
                        filter.equalTo(WMWaterfallFilter.KEY_CHANNEL_ID, String.valueOf(networkId));
                    }
                    if (unitIdList != null && !unitIdList.isEmpty()) {
                        filter.in(WMWaterfallFilter.KEY_ADN_PLACEMENT_ID, unitIdList);
                    }
                    filter.or();
                }

                WindMillAd.sharedAds().addFilter(filter);
            }
        }
    }

    private void addWaterfallFilter(MethodCall call, MethodChannel.Result result) {
        String placementId = call.argument("placementId");
        ArrayList<HashMap<String, Object>> list = call.argument("modelList");
        Log.d(TAG, "----------addWaterfallFilter----------" + placementId + ":" + list);
        if (!TextUtils.isEmpty(placementId)) {
            if (list != null && !list.isEmpty()) {
                WMWaterfallFilter filter = new WMWaterfallFilter(placementId);
                for (HashMap<String, Object> map : list) {
                    if (map == null) continue;
                    // 渠道
                    Object obj = map.get("channelIdList");
                    List<Integer> channelIdList = castList(obj, Integer.class);
                    if (channelIdList != null && !channelIdList.isEmpty()) {
                        List<String> channelIds = new ArrayList<>();
                        for (Integer channelId : channelIdList) {
                            channelIds.add(String.valueOf(channelId));
                        }
                        filter.in(WMWaterfallFilter.KEY_CHANNEL_ID, channelIds);
                    }
                    // 渠道广告位id
                    obj = map.get("adnIdList");
                    List<String> adnIdList = castList(obj, String.class);
                    if (adnIdList != null && !adnIdList.isEmpty()) {
                        filter.in(WMWaterfallFilter.KEY_ADN_PLACEMENT_ID, adnIdList);
                    }
                    // 渠道ecpm
                    obj = map.get("ecpmList");
                    List<HashMap> ecpmList = castList(obj, HashMap.class);
                    if (ecpmList != null && !ecpmList.isEmpty()) {
                        for (HashMap<String, Object> hashMap : ecpmList) {
                            if (hashMap == null) continue;
                            Object operator = hashMap.get("operator");
                            Object ecpmObj = hashMap.get("ecpm");
                            String ecpm = null;
                            if (ecpmObj != null && ecpmObj instanceof Double) {
                                ecpm = String.valueOf(ecpmObj);
                            }
                            String[]  operatorList = new String[]{">", "<", ">=", "<="};
                            boolean isOperatorValid = operator != null && operator instanceof String && Arrays.asList(operatorList).contains(operator);
                            boolean isEcpmValid = ecpm != null;
                            if (isOperatorValid && isEcpmValid) {
                                if (operator.equals(">")) {
                                    filter.greaterThan(WMWaterfallFilter.KEY_E_CPM, ecpm);
                                } else if (operator.equals("<")) {
                                    filter.lessThan(WMWaterfallFilter.KEY_E_CPM, ecpm);
                                } else if (operator.equals(">=")) {
                                    filter.greaterThanEqual(WMWaterfallFilter.KEY_E_CPM, ecpm);
                                } else if (operator.equals("<=")) {
                                    filter.lessThanEqual(WMWaterfallFilter.KEY_E_CPM, ecpm);
                                }
                            }

                        }
                    }

                    // 竞价类型
                    obj = map.get("bidTypeList");
                    List<Integer> bidTypeList = castList(obj, Integer.class);
                    if (bidTypeList != null && !bidTypeList.isEmpty()) {
                        List<String> bidTypes = new ArrayList<>();
                        for (Integer type : bidTypeList) {
                            if (type == 0) {
                                bidTypes.add(WMWaterfallFilter.S2S);
                            } else if (type == 1) {
                                bidTypes.add(WMWaterfallFilter.C2S);
                            } else if (type == 2) {
                                bidTypes.add(WMWaterfallFilter.NORMAL);
                            }
                        }
                        filter.in(WMWaterfallFilter.KEY_BIDDING_TYPE, bidTypes);
                    }

                    //开启新表达式
                    filter.or();
                }
                WindMillAd.sharedAds().addFilter(filter);
            }
        }
    }

    private static <T> List<T> castList(Object obj, Class<T> cls) {
        List<T> result = new ArrayList<>();
        if (obj instanceof List<?>) {
            for (Object o : (List<?>) obj) {
                result.add(cls.cast(o));
            }
            return result;
        }
        return null;
    }

    private void networkPreInit(MethodCall call, MethodChannel.Result result) {

        ArrayList<HashMap<String, Object>> list = call.argument("networksMap");

        WMNetworkConfig.Builder builder = new WMNetworkConfig.Builder();
        if (list != null) {

            for (HashMap map : list) {
                int networkId = 0;
                String appId = "";
                String appKey = "";
                Object obj = map.get("networkId");
                if (obj instanceof Integer) {
                    networkId = (int) obj;
                }
                obj = map.get("appId");
                if (obj instanceof String) {
                    appId = (String) obj;
                }
                obj = map.get("appKey");
                if (obj instanceof String) {
                    appKey = (String) obj;
                }

                builder.addInitConfig(new WMAdnInitConfig(networkId, appId, appKey));

            }
        }

        WindMillAd.sharedAds().setInitNetworkConfig(builder.build());
    }

    private void setPresetLocalStrategyPath(MethodCall call, MethodChannel.Result result) {

        String path = call.argument("path");

        WindMillAd.sharedAds().setLocalStrategyAssetPath(this.activity, path);

    }

    //{@ - 获取所有安装的APK (MATCH_UNINSTALLED_PACKAGES 表示未卸载的APK, 包括APK已被删除但是保留数据的)
    // 需要获取所有apk 添加permission <uses-permission android:name="android.permission.QUERY_ALL_PACKAGES"/>
    public List<PackageInfo> getAllUserInstalledApps() {
        try {
            if (this.activity != null) {
                List<PackageInfo> apps = new ArrayList<>();
                PackageManager packageManager = this.activity.getPackageManager();
                List<PackageInfo> installedApps = packageManager.getInstalledPackages(PackageManager.MATCH_UNINSTALLED_PACKAGES);

                for (PackageInfo packageInfo : installedApps) {
                    // 过滤掉系统应用
                    if ((packageInfo.applicationInfo.flags & ApplicationInfo.FLAG_SYSTEM) == 0) {
                        apps.add(packageInfo);
                    }
                }
                return apps;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private void setupSdkWithAppId(MethodCall call, MethodChannel.Result result) {
        String appId = call.argument("appId");
        if (wmCustomController != null) {

            WMAdConfig wmAdConfig = new WMAdConfig.Builder().customController(wmCustomController).build();
            WindMillAd.sharedAds().startWithAppId(this.activity.getApplicationContext(), appId, wmAdConfig);

        } else {
            WindMillAd.sharedAds().startWithAppId(this.activity.getApplicationContext(), appId);
        }

        result.success(null);
    }
}
