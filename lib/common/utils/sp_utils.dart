import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';


/// 用来做shared_preferences的存储
class SpUtil {
  static SpUtil _instance;
  static Future<SpUtil> get instance async {
    return await getInstance();
  }

  static SharedPreferences _spf;


  SpUtil._();

  Future _init() async {
    _spf = await SharedPreferences.getInstance();
  }

  static Future<SpUtil> getInstance() async  {
    if (_instance == null) {
      _instance = new SpUtil._();
      await _instance._init();

    }
    return _instance;
  }

  static bool _beforeCheck() {
    if (_spf == null) {
      return true;
    }
    return false;
  }
  // 判断是否存在数据
  static bool hasKey(String key) {
    Set keys = getKeys();
    return keys.contains(key);
  }

  static Set<String> getKeys() {
    if (_beforeCheck()) return null;
    return _spf.getKeys();
  }

  static get(String key) {
    if (_beforeCheck()) return null;
    return _spf.get(key);
  }

  static getString(String key) {
    if (_beforeCheck()) return null;
    return _spf.getString(key);
  }

  static Future<bool> putString(String key, String value) {
    if (_beforeCheck()) return null;
    return _spf.setString(key, value);
  }

  static bool getBool(String key) {
    if (_beforeCheck()) return null;
    return _spf.getBool(key);
  }

  static Future<bool> putBool(String key, bool value) {
    if (_beforeCheck()) return null;
    return _spf.setBool(key, value);
  }

  static int getInt(String key) {
    if (_beforeCheck()) return null;
    return _spf.getInt(key);
  }

  static Future<bool> putInt(String key, int value) {
    if (_beforeCheck()) return null;
    return _spf.setInt(key, value);
  }

  static double getDouble(String key) {
    if (_beforeCheck()) return null;
    return _spf.getDouble(key);
  }

  static Future<bool> putDouble(String key, double value) {
    if (_beforeCheck()) return null;
    return _spf.setDouble(key, value);
  }

  static List<String> getStringList(String key) {
    return _spf.getStringList(key);
  }

  static Future<bool> putStringList(String key, List<String> value) {
    if (_beforeCheck()) return null;
    return _spf.setStringList(key, value);
  }

  static dynamic getDynamic(String key) {
    if (_beforeCheck()) return null;
    return _spf.get(key);
  }



  static Future<bool> remove(String key) {
    if (_beforeCheck()) return null;
    return _spf.remove(key);
  }

  static Future<bool> clear() {
    if (_beforeCheck()) return null;
    return _spf.clear();
  }
}