package com.windmill.windmill_ad_plugin.utils;

import com.windmill.sdk.WMAdFilter;
import com.windmill.sdk.models.WMFilter;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

public class WindmillUtils {

    public static WMAdFilter getCurrentFilter(ArrayList<HashMap<String, Object>> list) {
        if (list != null && !list.isEmpty()) {
            WMAdFilter filter = new WMAdFilter();
            for (HashMap<String, Object> map : list) {
                if (map == null) continue;
                // 渠道
                Object obj = map.get("channelIdList");
                List<Integer> channelIdList = WindmillUtils.castList(obj, Integer.class);
                if (channelIdList != null && !channelIdList.isEmpty()) {
                    List<String> channelIds = new ArrayList<>();
                    for (Integer channelId : channelIdList) {
                        channelIds.add(String.valueOf(channelId));
                    }
                    filter.in(WMAdFilter.KEY_CHANNEL_ID, channelIds);
                }
                // 渠道广告位id
                obj = map.get("adnIdList");
                List<String> adnIdList = WindmillUtils.castList(obj, String.class);
                if (adnIdList != null && !adnIdList.isEmpty()) {
                    filter.in(WMAdFilter.KEY_ADN_PLACEMENT_ID, adnIdList);
                }
                // 渠道ecpm
                obj = map.get("ecpmList");
                List<HashMap> ecpmList = WindmillUtils.castList(obj, HashMap.class);
                if (ecpmList != null && !ecpmList.isEmpty()) {
                    for (HashMap<String, Object> hashMap : ecpmList) {
                        if (hashMap == null) continue;
                        Object operator = hashMap.get("operator");
                        Object ecpmObj = hashMap.get("ecpm");
                        String ecpm = null;
                        if (ecpmObj != null && ecpmObj instanceof Double) {
                            ecpm = String.valueOf(ecpmObj);
                        }
                        String[] operatorList = new String[]{">", "<", ">=", "<="};
                        boolean isOperatorValid = operator != null && operator instanceof String && Arrays.asList(operatorList).contains(operator);
                        boolean isEcpmValid = ecpm != null;
                        if (isOperatorValid && isEcpmValid) {
                            if (operator.equals(">")) {
                                filter.greaterThan(WMAdFilter.KEY_E_CPM, ecpm);
                            } else if (operator.equals("<")) {
                                filter.lessThan(WMAdFilter.KEY_E_CPM, ecpm);
                            } else if (operator.equals(">=")) {
                                filter.greaterThanEqual(WMAdFilter.KEY_E_CPM, ecpm);
                            } else if (operator.equals("<=")) {
                                filter.lessThanEqual(WMAdFilter.KEY_E_CPM, ecpm);
                            }
                        }

                    }
                }

                // 竞价类型
                obj = map.get("bidTypeList");
                List<Integer> bidTypeList = WindmillUtils.castList(obj, Integer.class);
                if (bidTypeList != null && !bidTypeList.isEmpty()) {
                    List<String> bidTypes = new ArrayList<>();
                    for (Integer type : bidTypeList) {
                        if (type == 0) {
                            bidTypes.add(WMAdFilter.S2S);
                        } else if (type == 1) {
                            bidTypes.add(WMAdFilter.C2S);
                        } else if (type == 2) {
                            bidTypes.add(WMAdFilter.NORMAL);
                        }
                    }
                    filter.in(WMAdFilter.KEY_BIDDING_TYPE, bidTypes);
                }

                //开启新表达式
                filter.or();
            }
            return filter;
        }
        return null;
    }

    public static <T> List<T> castList(Object obj, Class<T> cls) {
        List<T> result = new ArrayList<>();
        if (obj instanceof List<?>) {
            for (Object o : (List<?>) obj) {
                result.add(cls.cast(o));
            }
            return result;
        }
        return null;
    }
}
