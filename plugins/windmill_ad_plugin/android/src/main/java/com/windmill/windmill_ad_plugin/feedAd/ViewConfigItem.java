package com.windmill.windmill_ad_plugin.feedAd;

import com.windmill.windmill_ad_plugin.utils.ResourceUtil;

import org.json.JSONException;
import org.json.JSONObject;

class ViewConfigItem {
    private JSONObject config;

    public ViewConfigItem(JSONObject item) {
        config = item;

    }

    public int getFontSize() {


        try {
            return config.getInt("fontSize");
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getX() {

        try {
            int x = config.getInt("x");
            if (!userPixel()) {
                x = (int) ResourceUtil.Instance().dip2Px(x);
            }
            return x;
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getY() {
        try {
            int y = config.getInt("y");
            if (!userPixel()) {
                y = (int) ResourceUtil.Instance().dip2Px(y);
            }
            return y;
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return 0;

    }

    public int getWidth() {
        try {
            int width = config.getInt("width");
            if (!userPixel()) {
                width = (int) ResourceUtil.Instance().dip2Px(width);
            }
            return width;
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getHeight() {
        try {
            int height = config.getInt("height");
            if (!userPixel()) {
                height = (int) ResourceUtil.Instance().dip2Px(height);
            }
            return height;
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTextAlign() {
        try {
            return config.getInt("textAlignment");
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean userPixel() {

        try {
            return config.getBoolean("pixel");
        } catch (Throwable e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getScaleType() {
        try {
            return config.getInt("scaleType");
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean isCtaClick() {
        try {
            return config.getBoolean("isCtaClick");
        } catch (Throwable e) {
            e.printStackTrace();
        }
        return false;
    }

    public String getTextColor() {
        try {
            return config.getString("textColor");
        } catch (Throwable e) {
            e.printStackTrace();
        }
        return null;
    }

    public String getBackgroundColor() {

        try {
            return config.getString("backgroundColor");
        } catch (Throwable e) {
            e.printStackTrace();
        }
        return null;
    }


}
