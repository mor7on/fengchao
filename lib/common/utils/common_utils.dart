import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/utils/sp_utils.dart';
import 'package:flutter/material.dart';

class CommonUtils {
  static const double MILLIS_LIMIT = 1000.0;

  static const double SECONDS_LIMIT = 60 * MILLIS_LIMIT;

  static const double MINUTES_LIMIT = 60 * SECONDS_LIMIT;

  static const double HOURS_LIMIT = 24 * MINUTES_LIMIT;

  static const double DAYS_LIMIT = 30 * HOURS_LIMIT;

  static Locale curLocale = new Locale(systemLocale.split('_')[0], systemLocale.split('_')[1]);

  static String get systemLocale => SpUtil.getString('xxLocale') ?? 'zh_CN';

  static String getDateStr(DateTime date) {
    if (date == null || date.toString() == null) {
      return "";
    } else if (date.toString().length < 10) {
      return date.toString();
    }
    return date.toString().substring(0, 10);
  }

  ///日期格式转换
  static String dateToPretty(String str) {
    DateTime date = DateTime.parse(str);
    int subTimes = DateTime.now().millisecondsSinceEpoch - date.millisecondsSinceEpoch;

    if (subTimes < MILLIS_LIMIT) {
      return (curLocale != null) ? (curLocale.languageCode != "zh") ? "right now" : " 刚刚" : " 刚刚";
    } else if (subTimes < SECONDS_LIMIT) {
      return ' ' +
          (subTimes / MILLIS_LIMIT).round().toString() +
          ((curLocale != null) ? (curLocale.languageCode != "zh") ? " seconds ago" : "秒前" : "秒前");
    } else if (subTimes < MINUTES_LIMIT) {
      return ' ' +
          (subTimes / SECONDS_LIMIT).round().toString() +
          ((curLocale != null) ? (curLocale.languageCode != "zh") ? " min ago" : "分钟前" : "分钟前");
    } else if (subTimes < HOURS_LIMIT) {
      return ' ' +
          (subTimes / MINUTES_LIMIT).round().toString() +
          ((curLocale != null) ? (curLocale.languageCode != "zh") ? " hours ago" : "小时前" : "小时前");
    } else if (subTimes < DAYS_LIMIT) {
      return ' ' +
          (subTimes / HOURS_LIMIT).round().toString() +
          ((curLocale != null) ? (curLocale.languageCode != "zh") ? " days ago" : "天前" : "天前");
    } else {
      return ' ' + getDateStr(date);
    }
  }

  // 登录与当前时间比较，大于29天返回false
  static bool dateToCompare(String str) {
    if (str == null) return false;

    DateTime date = DateTime.parse(str);
    int subTimes = DateTime.now().millisecondsSinceEpoch - date.millisecondsSinceEpoch;
    if ((subTimes / HOURS_LIMIT) >= 29.0) {
      return false;
    } else {
      return true;
    }
  }

  // 任务锁定时间对比
  static bool toCompareExpiredTime(String str) {
    if (str == null) return false;

    DateTime date = DateTime.parse(str);
    int subTimes = DateTime.now().millisecondsSinceEpoch - date.millisecondsSinceEpoch;
    if (subTimes >= 0) {
      return true;
    } else {
      return false;
    }
  }

  static String timeToString(DateTime time) {
    var timeStr =
        "${time.year.toString()}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
    return timeStr;
  }

  static void showToast(String text) {
    BotToast.showText(
      text: text,
      textStyle: TextStyle(fontSize: 14.0,color: Colors.white),
    );
  }
}
