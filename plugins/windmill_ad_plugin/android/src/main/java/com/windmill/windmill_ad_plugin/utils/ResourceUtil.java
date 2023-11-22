package com.windmill.windmill_ad_plugin.utils;

import android.content.Context;

/**
 * Create by lance on 2019/5/24/0024
 * 工具类，可以通过资源名来获取资源id
 */
public class ResourceUtil {


    private static ResourceUtil gInstance;


    public static synchronized void InitUtil(Context context) {
        if (gInstance == null) {
            gInstance = new ResourceUtil(context);
        }
    }

    public static ResourceUtil Instance() {
        return gInstance;
    }

    Context context;

    ResourceUtil(Context context) {
        this.context = context.getApplicationContext();
    }


    public int dip2Px(int dipValue) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (dipValue * scale + 0.5f);
    }

    public int px2dip(int pxValue) {
        if (pxValue != 0) {
            final float scale = context.getResources().getDisplayMetrics().density;
            return (int) (pxValue / scale + 0.5f);
        }

        return pxValue;
    }

    public int getWidth() {
        return context.getResources().getDisplayMetrics().widthPixels;
    }

    public int getHeight() {
        return context.getResources().getDisplayMetrics().heightPixels;
    }

    //获取状态栏高度
    public int getStatusBarHeight() {
        int height = 0;
        int resourceId = context.getResources().getIdentifier("status_bar_height", "dimen", "android");
        if (resourceId > 0) {
            height = context.getResources().getDimensionPixelSize(resourceId);
        }
        return height;
    }

    public static int getId(Context context, String resourceName) {
        return getIdentifierByType(context, resourceName, "id");
    }

    public static int getLayoutId(Context context, String resourceName) {
        return getIdentifierByType(context, resourceName, "layout");
    }

    public static int getDrawableId(Context context, String resourceName) {
        return getIdentifierByType(context, resourceName, "drawable");
    }

    public static int getStringId(Context context, String resourceName) {
        return getIdentifierByType(context, resourceName, "string");
    }


    public static int getMipmapId(Context context, String resourceName) {
        return getIdentifierByType(context, resourceName, "mipmap");
    }

    public static int getColorId(Context context, String resourceName) {
        return getIdentifierByType(context, resourceName, "color");
    }

    public static int getDimenId(Context context, String resourceName) {
        return getIdentifierByType(context, resourceName, "dimen");
    }

    public static int getAttrId(Context context, String resourceName) {
        return getIdentifierByType(context, resourceName, "attr");
    }

    public static int getStyleId(Context context, String resourceName) {
        return getIdentifierByType(context, resourceName, "style");
    }

    public static int getAnimId(Context context, String resourceName) {
        return getIdentifierByType(context, resourceName, "anim");
    }

    public static int getArrayId(Context context, String resourceName) {
        return getIdentifierByType(context, resourceName, "array");
    }

    public static int getIntegerId(Context context, String resourceName) {
        return getIdentifierByType(context, resourceName, "integer");
    }

    public static int getBoolId(Context context, String resourceName) {
        return getIdentifierByType(context, resourceName, "bool");
    }

    private static int getIdentifierByType(Context context, String resourceName, String defType) {
        return context.getResources().getIdentifier(resourceName,
                defType,
                context.getPackageName());
    }
}
