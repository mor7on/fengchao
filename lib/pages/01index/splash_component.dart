import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fengchao/common/api/01_index_component_fun.dart';
import 'package:fengchao/common/config/config.dart';
import 'package:fengchao/common/utils/common_utils.dart';
import 'package:fengchao/common/utils/global_dialog.dart';
import 'package:fengchao/common/utils/sp_utils.dart';
import 'package:fengchao/models/app_info.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_component.dart';
import 'user_login.dart';

class SplashComponent extends StatefulWidget {
  SplashComponent({Key key}) : super(key: key);

  @override
  _SplashComponentState createState() => _SplashComponentState();
}

const brightYellow = Color(0xFFFFD300);
const darkYellow = Color(0xFFFFB900);

class _SplashComponentState extends State<SplashComponent> {
  bool _hasToken;

  int _seconds = 5;

  /// 倒计时的计时器。
  Timer _timer;

  @override
  void initState() {
    super.initState();
    initUserData();
  }

  void initUserData() async {
    // Map<String, dynamic> res = await getInboxInfo();
    _hasToken = CommonUtils.dateToCompare(SpUtil.getString('xxLoginTime'));
    checkAppUpdate();
  }

  void checkAppUpdate() async {
    try {
      Dio dio = new Dio();
      Response response;
      response = await dio.get('http://www.4u2000.com/sesame/api/center/version');
      print(response);
      if (response.statusCode == 200) {
        Map<String, dynamic> res = response.data;
        if (res['code'] == 1) {
          AppInfo appInfo = AppInfo.fromJson(res['data']);
          if (appInfo.versioncode > CONFIG.APP_VER) {
            _showCustomDialog(AppUpdateDialog(appInfo: appInfo));
          }else {
            _startCountdown();
          }
        }
      }
    } catch (e) {
      throw Exception('系统错误');
    }
  }

  void _showCustomDialog(Widget child) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => child,
    ).then((val) {
      if (val == 'confirm') {
        Navigator.pushNamed(context, '/appUpdate');
      } else {
        _startCountdown();
      }
    });
  }

  /// 启动倒计时的计时器。
  void _startCountdown() {
    // 计时器（`Timer`）组件的定期（`periodic`）构造函数，创建一个新的重复计时器。
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _navigateToNext();
      } else {
        _seconds--;
        setState(() {});
      }
    });
  }

  void _navigateToNext() {
    Widget next = _hasToken ? HomeComponent() : UserLoginComponent();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => next));
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brightYellow,
      body: Column(
        children: [
          Flexible(
            flex: 8,
            child: FlareActor(
              'assets/animation/bus.flr',
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: 'driving',
            ),
          ),
          Flexible(
            flex: 2,
            child: RaisedButton(
              color: darkYellow,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              child: Text(
                '$_seconds SKIP',
                style: TextStyle(color: Colors.black54),
              ),
              onPressed: _navigateToNext,
            ),
          ),
        ],
      ),
    );
  }
}

class AppUpdateDialog extends StatelessWidget {
  final AppInfo appInfo;
  const AppUpdateDialog({Key key, this.appInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('版本更新'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('当前版本：${CONFIG.APP_VER_NAME}'),
          Text('最新版本：${appInfo.versionname}'),
          Text('发现新版本，是否现在就进行更新？'),
        ],
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: const Text('取消'),
          onPressed: () {
            Navigator.pop(context, 'cancle');
          },
        ),
        CupertinoDialogAction(
          child: const Text('确认'),
          onPressed: () {
            Navigator.pop(context, 'confirm');
          },
        ),
      ],
    );
  }
}
