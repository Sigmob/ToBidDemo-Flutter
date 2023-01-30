package com.windmill.windmill_ad_plugin.feedAd;


import android.content.Context;
import android.graphics.Color;
import android.text.TextUtils;
import android.util.Log;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.czhj.sdk.common.utils.ImageManager;
import com.windmill.sdk.natives.WMNativeAdData;
import com.windmill.sdk.natives.WMNativeAdDataType;
import com.windmill.sdk.natives.WMNativeAdRender;
import com.czhj.sdk.common.utils.ResourceUtil;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class NativeAdRenderCustomView implements WMNativeAdRender<WMNativeAdData> {

    private static final String TAG = "NativeAdRender";

    /**
     * 多布局根据adPatternType复用不同的根视图
     */
    private ImageView iconView;
    private ImageView ad_logo;
    private ImageView iv_dislike;
    private TextView text_desc;

    private FrameLayout mMediaViewLayout;
    private ImageView mMainImageView;
    private ImageView mImageView1;
    private ImageView mImageView2;
    private ImageView mImageView3;

    private TextView text_title;
    private JSONObject mCustomViewConfig;
    private Button mCTAButton;



    NativeAdRenderCustomView(JSONObject customViewConfig){
        mCustomViewConfig = customViewConfig;
    }
    /**
     * NativeAdPatternType 取值范围
     *
     * @param context
     * @param adPatternType 这里可以根据 adPatternType创建不用的根视图容器
     * @return
     */
    @Override
    public View createView(Context context, int adPatternType) {
        Log.d(TAG, "---------createView----------" + adPatternType);
        if(context == null ) return null;

        View developView = new RelativeLayout(context);
        developView.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        return developView;
    }





    private void updateViewProperty(View view, ViewConfigItem viewConfigItem){

        if(view == null || viewConfigItem == null){
            return;
        }

        if(!TextUtils.isEmpty(viewConfigItem.getBackgroundColor())){
            view.setBackgroundColor(Color.parseColor(viewConfigItem.getBackgroundColor()));
        }

        if(view instanceof ImageView){
            ImageView imageView = (ImageView) view;
            switch (viewConfigItem.getScaleType()){
                case 0:{
                    imageView.setScaleType(ImageView.ScaleType.FIT_CENTER);
                }break;
                case 1:{
                    imageView.setScaleType(ImageView.ScaleType.FIT_XY);
                }break;
                case 2:{
                    imageView.setScaleType(ImageView.ScaleType.CENTER);
                }break;
                default:{

                }break;
            }
        }


        if (view instanceof TextView){
            TextView textView = (TextView)view;

            if(!TextUtils.isEmpty(viewConfigItem.getTextColor())){
                textView.setTextColor(Color.parseColor(viewConfigItem.getTextColor()));
            }

            if(viewConfigItem.getFontSize()>0){
                textView.setTextSize(TypedValue.COMPLEX_UNIT_SP,viewConfigItem.getFontSize());
            }
            switch (viewConfigItem.getTextAlign()){
                case 0:{
                    textView.setTextAlignment(View.TEXT_ALIGNMENT_INHERIT);
                }break;
                case 1:{
                    textView.setTextAlignment(View.TEXT_ALIGNMENT_CENTER);
                }break;
                case 2:{
                    textView.setTextAlignment(View.TEXT_ALIGNMENT_TEXT_END);
                }break;
                default:{

                }break;
            }
        }





    }
    @Override
    public void renderAdView(View view, final WMNativeAdData adData) {

        if(view == null || adData == null) return;

        ViewGroup rootView = (ViewGroup)view;
        Context context = view.getContext();
        Log.d(TAG, "renderAdView:" + adData.getTitle());
        List<View> clickableViews = new ArrayList<>();

        int patternType = adData.getAdPatternType();
        Log.d(TAG, "patternType:" + patternType);

        if (patternType == WMNativeAdDataType.NATIVE_VIDEO_AD){
            try {
                mMediaViewLayout = new FrameLayout(context);

                JSONObject config = mCustomViewConfig.getJSONObject("mainAdView");
                if(config != null){
                    ViewConfigItem item = new ViewConfigItem(config);

                    RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(item.getWidth(),item.getHeight());
                    lp.setMargins(item.getX(),item.getY(),0,0);

                    updateViewProperty(mMediaViewLayout,item);
                    rootView.addView(mMediaViewLayout,lp);

                    clickableViews.add(mMediaViewLayout);

                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }



        try {
            text_title = new TextView(context);

            JSONObject config = mCustomViewConfig.getJSONObject("titleView");
            if(config != null){
                ViewConfigItem item = new ViewConfigItem(config);
                updateViewProperty(text_title,item);
                RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(item.getWidth(),item.getHeight());
                lp.setMargins(item.getX(),item.getY(),0,0);
                rootView.addView(text_title,lp);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }


        try {
            text_desc = new TextView(context);

            JSONObject config = mCustomViewConfig.getJSONObject("descriptView");
            if(config != null){
                ViewConfigItem item = new ViewConfigItem(config);
                updateViewProperty(text_desc,item);
                RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(item.getWidth(),item.getHeight());
                lp.setMargins(item.getX(),item.getY(),0,0);
                rootView.addView(text_desc,lp);
                if(item.isCtaClick()){
                    clickableViews.add(text_desc);
                }
            }

        } catch (JSONException e) {
            e.printStackTrace();
        }

        try {
            iv_dislike = new ImageView(context);


            JSONObject config = mCustomViewConfig.getJSONObject("dislikeButton");
            if(config != null){
                ViewConfigItem item = new ViewConfigItem(config);
                updateViewProperty(iv_dislike,item);
                RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(item.getWidth(),item.getHeight());
                lp.setMargins(item.getX(),item.getY(),0,0);
                rootView.addView(iv_dislike,lp);
                if(item.isCtaClick()){
                    clickableViews.add(iv_dislike);
                }
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }


        iv_dislike.setImageResource(ResourceUtil.getDrawableId(view.getContext(),"sig_dislike"));


        try {
            mCTAButton = new Button(context);

            JSONObject config = mCustomViewConfig.getJSONObject("ctaButton");
            if(config != null){
                ViewConfigItem item = new ViewConfigItem(config);

                updateViewProperty(mCTAButton,item);
                RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(item.getWidth(),item.getHeight());
                lp.setMargins(item.getX(),item.getY(),0,0);
                rootView.addView(mCTAButton,lp);

            }
        } catch (JSONException e) {
            e.printStackTrace();
        }

        if (patternType == WMNativeAdDataType.NATIVE_SMALL_IMAGE_AD || patternType == WMNativeAdDataType.NATIVE_BIG_IMAGE_AD) {
            try {
                mMainImageView = new ImageView(context);
                JSONObject config = mCustomViewConfig.getJSONObject("mainAdView");
                if(config != null){
                    ViewConfigItem item = new ViewConfigItem(config);
                    updateViewProperty(mMainImageView,item);
                    RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(item.getWidth(),item.getHeight());
                    lp.setMargins(item.getX(),item.getY(),0,0);
                    rootView.addView(mMainImageView,lp);
                    clickableViews.add(mMainImageView);
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }else if(patternType == WMNativeAdDataType.NATIVE_GROUP_IMAGE_AD){
            try {
                LinearLayout  linearLayout = new LinearLayout(context);
                JSONObject config = mCustomViewConfig.getJSONObject("mainAdView");
                linearLayout.setOrientation(LinearLayout.HORIZONTAL);
                linearLayout.setWeightSum(3);

                LinearLayout.LayoutParams layoutParams = new LinearLayout
                        .LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                        ViewGroup.LayoutParams.WRAP_CONTENT);
                layoutParams.weight = 1;
                layoutParams.setMargins(3,3,3,3);


                LinearLayout.LayoutParams layoutParams2 = new LinearLayout
                        .LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                        ViewGroup.LayoutParams.WRAP_CONTENT);
                layoutParams2.weight = 1;
                layoutParams2.setMargins(3,3,3,3);

                LinearLayout.LayoutParams layoutParams3 = new LinearLayout
                        .LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                        ViewGroup.LayoutParams.WRAP_CONTENT);
                layoutParams3.weight = 1;
                layoutParams3.setMargins(3,3,3,3);

                mImageView1 = new ImageView(context);
                mImageView1.setScaleType(ImageView.ScaleType.FIT_XY);
                mImageView1.setAdjustViewBounds(true);
                linearLayout.addView(mImageView1, layoutParams);

                mImageView2 = new ImageView(context);
                linearLayout.addView(mImageView2, layoutParams2);
                mImageView2.setAdjustViewBounds(true);
                mImageView2.setScaleType(ImageView.ScaleType.FIT_XY);


                mImageView3 = new ImageView(context);
                linearLayout.addView(mImageView3, layoutParams3);
                mImageView3.setAdjustViewBounds(true);
                mImageView3.setScaleType(ImageView.ScaleType.FIT_XY);

                if(config != null){
                    ViewConfigItem item = new ViewConfigItem(config);
                    updateViewProperty(linearLayout,item);
                    RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(item.getWidth(),item.getHeight());
                    lp.setMargins(item.getX(),item.getY(),0,0);
                    rootView.addView(linearLayout,lp);
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }

        try {
            ad_logo = new ImageView(context);

            JSONObject config = mCustomViewConfig.getJSONObject("adLogoView");
            if(config != null){
                ViewConfigItem item = new ViewConfigItem(config);
                updateViewProperty(ad_logo,item);
                RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(item.getWidth(),item.getHeight());
                lp.setMargins(item.getX(),item.getY(),0,0);
                rootView.addView(ad_logo,lp);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }

        try {
            iconView = new ImageView(context);

            JSONObject config = mCustomViewConfig.getJSONObject("iconView");
            if(config != null){
                ViewConfigItem item = new ViewConfigItem(config);
                updateViewProperty(iconView,item);
                RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(item.getWidth(),item.getHeight());
                lp.setMargins(item.getX(),item.getY(),0,0);
                rootView.addView(iconView,lp);
                if(item.isCtaClick()){
                    clickableViews.add(iconView);
                }
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }

        //渲染UI
        if (!TextUtils.isEmpty(adData.getIconUrl())) {
            iconView.setVisibility(View.VISIBLE);
            ImageManager.with(view.getContext()).load(adData.getIconUrl()).into(iconView);
        } else {
            iconView.setVisibility(View.GONE);
        }

        if (!TextUtils.isEmpty(adData.getTitle())) {
            text_title.setText(adData.getTitle());
        } else {
            text_title.setText("点开有惊喜");
        }

        if (!TextUtils.isEmpty(adData.getDesc())) {
            text_desc.setText(adData.getDesc());
        } else {
            text_desc.setText("听说点开它的人都交了好运!");
        }

        if (adData.getAdLogo() != null) {
            ad_logo.setVisibility(View.VISIBLE);
            ad_logo.setImageBitmap(adData.getAdLogo());
        } else {
            ad_logo.setVisibility(View.GONE);
        }

        //clickViews数量必须大于等于1
        //可以被点击的view, 也可以把convertView放进来意味item可被点击
        clickableViews.add(view);
        ////触发创意广告的view（点击下载或拨打电话）
        List<View> creativeViewList = new ArrayList<>();
        // 所有广告类型，注册mDownloadButton的点击事件
        creativeViewList.add(mCTAButton);
//        clickableViews.add(mDownloadButton);

        List<ImageView> imageViews = new ArrayList<>();

        //ITEM_VIEW_TYPE_LARGE_PIC_AD
        if (patternType == WMNativeAdDataType.NATIVE_SMALL_IMAGE_AD || patternType == WMNativeAdDataType.NATIVE_BIG_IMAGE_AD) {
            // 双图双文、单图双文：注册mImagePoster的点击事件
            imageViews.add(mMainImageView);
        }else  if (patternType == WMNativeAdDataType.NATIVE_GROUP_IMAGE_AD) {

            imageViews.add(mImageView1);
            imageViews.add(mImageView2);
            imageViews.add(mImageView3);
        }


        //重要! 这个涉及到广告计费，必须正确调用。convertView必须使用ViewGroup。
        //作为creativeViewList传入，点击不进入详情页，直接下载或进入落地页，视频和图文广告均生效
        adData.bindViewForInteraction(context, view, clickableViews, creativeViewList, iv_dislike);



        //需要等到bindViewForInteraction后再去添加media
        if (!imageViews.isEmpty()) {
            adData.bindImageViews(context, imageViews, 0);
        } else if (patternType == WMNativeAdDataType.NATIVE_VIDEO_AD) {
            // 视频广告，注册mMediaView的点击事件
            adData.bindMediaView(context, mMediaViewLayout);

        }

        /**
         * 营销组件
         * 支持项目：智能电话（点击跳转拨号盘），外显表单
         *  bindCTAViews 绑定营销组件监听视图，注意：bindCTAViews的视图不可调用setOnClickListener，否则SDK功能可能受到影响
         *  ad.getCTAText 判断拉取广告是否包含营销组件，如果包含组件，展示组件按钮，否则展示download按钮
         */
        String ctaText = adData.getCTAText(); //获取组件文案
        Log.d(TAG, "ctaText:" + ctaText);
        updateAdAction(ctaText);
    }

    private void updateAdAction(String ctaText) {
        if (!TextUtils.isEmpty(ctaText)) {
            //如果拉取广告包含CTA组件，则渲染该组件
            mCTAButton.setText(ctaText);
            mCTAButton.setVisibility(View.VISIBLE);
        } else {
            mCTAButton.setVisibility(View.INVISIBLE);
        }
    }
}