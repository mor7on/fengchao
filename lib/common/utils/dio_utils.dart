import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fengchao/common/config/config.dart';
import 'package:fengchao/common/utils/sp_utils.dart';
import 'package:fengchao/pages/widgets/network_exception_dialog.dart';
import 'package:fengchao/pages/widgets/server_exception_dialog.dart';
import 'package:fengchao/pages/widgets/token_expired_dialog.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'global_dialog.dart';

class DioUtil {
  static DioUtil _instance = DioUtil._init();
  static Dio _dio;
  BaseOptions _options = getDefOptions();

  factory DioUtil() => _instance;

  ///通用全局单例，第一次使用时初始化
  DioUtil._init() {
    _dio = new Dio(_options);
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (Options options) async {
      // If no token, request token firstly and lock this interceptor
      // to prevent other request enter this interceptor.
      _dio.interceptors.requestLock.lock();
      // We use a Dio(to avoid dead lock) instance to request token.
      //Set the token to headers
      options.headers["XX-Token"] = SpUtil.getString('xxToken');
      options.headers["XX-Device-Type"] = 'mobile';
      _dio.interceptors.requestLock.unlock();
      return options; //continue
    }));
  }

  static DioUtil getInstance() {
    if (_dio == null) {
      _instance = DioUtil._init();
    }
    return _instance;
  }

  Future<dynamic> request({
    @required String path,
    @required String method,
    Map<String, dynamic> data,
    Options options,
    CancelToken cancelToken,
  }) async {
    Response response;
    try {
      response = await _dio.request(
        path,
        data: method == 'POST' ? data : null,
        queryParameters: method == 'GET' ? data : null,
        options: _checkOptions(method, options),
        cancelToken: cancelToken,
      );
    } on DioError catch (e) {
      throw Exception(e);
    }

    if (response.statusCode == 200) {
      Map<String,dynamic> res;
      if (response.data.runtimeType is String) {
        res = jsonDecode(response.data);
      }else{
        res = response.data;
      }
      int code = res['code'];
      if (code == 2) {
        GlobalDialog.showGlobalDialog(TokenExpiredDialog());
      } else if(code == 0){
        print(res);
        GlobalDialog.showGlobalDialog(ServerExceptionDialog());
      }else {
        return res;
      }
    } else {
      GlobalDialog.showGlobalDialog(NetworkExceptionDialog());
    }
  }

  Future<dynamic> upLoad({
    @required String path,
    FormData data,
    ValueChanged onSend,
  }) async {
    Response response;
    try {
      response = await _dio.post(
        path,
        data: data,
        onSendProgress: (int sent, int total) {
          double progress = sent / total;
          onSend(progress);
        },
      );
    } on DioError catch (e) {
      throw Exception(e);
    }

    if (response.statusCode == 200) {
      return response.data;
    } else {
      print(response);
    }
  }

  /// check Options.
  Options _checkOptions(method, options) {
    if (options == null) {
      options = new Options();
    }
    options.method = method;
    return options;
  }

  /// get Def Options.
  static BaseOptions getDefOptions() {
    BaseOptions options = new BaseOptions();
    options.baseUrl = CONFIG.BASE_URL;
    options.connectTimeout = 1000 * 6;
    options.receiveTimeout = 1000 * 6;
    options.contentType = Headers.jsonContentType;
    return options;
  }
}
