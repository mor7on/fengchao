import 'package:dio/dio.dart';
import 'package:fengchao/common/utils/dio_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_baidu_map/flutter_baidu_map.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

class DioApi {
  ///示例请求
  static Future<dynamic> request({
    @required String path,
    @required String method,
    Map<String, dynamic> data,
    Options options,
    CancelToken cancelToken,
  }) async {
    return await DioUtil.getInstance().request(
      method: method,
      path: path,
      data: data,
      options: options,
      cancelToken: cancelToken,
    );
  }

  static Future<dynamic> uploade({
    @required String path,
    FormData data,
    ValueChanged onSend,
  }) async {
    return await DioUtil.getInstance().upLoad(path: path, data: data, onSend: onSend);
  }

  static Future<dynamic> getUserLocation() async {
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
    bool hasPermission = permission == PermissionStatus.granted;
    if (!hasPermission) {
      Map<PermissionGroup, PermissionStatus> map =
          await PermissionHandler().requestPermissions([PermissionGroup.location]);
      if (map.values.toList()[0] != PermissionStatus.granted) {
        return null;
      }
    }
    BaiduLocation location = await FlutterBaiduMap.getCurrentLocation();
    String str = location.province + location.city + location.district + location.street + '(${location.locationDescribe})';
    return str;

  }

}

