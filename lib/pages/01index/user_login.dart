import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:fengchao/common/utils/sp_utils.dart';
import 'package:fengchao/pages/widgets/login_animation.dart';
import 'package:fengchao/pages/widgets/login_background.dart';
import 'package:flutter/material.dart';

class UserLoginComponent extends StatefulWidget {
  UserLoginComponent({Key key}) : super(key: key);

  _UserLoginComponentState createState() => _UserLoginComponentState();
}

class _UserLoginComponentState extends State<UserLoginComponent> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  int _lastClickTime = 0;
  int animationStatus = 0;

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 2000));

    animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  // 双击退出
  Future<bool> _doubleExit() {
    int nowTime = new DateTime.now().microsecondsSinceEpoch;
    if (_lastClickTime != 0 && nowTime - _lastClickTime > 1500) {
      return new Future.value(true);
    } else {
      _lastClickTime = new DateTime.now().microsecondsSinceEpoch;
      BotToast.showText(text: "连续按两次返回键返回桌面", textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
      new Future.delayed(const Duration(milliseconds: 1500), () {
        _lastClickTime = 0;
      });
      return new Future.value(false);
    }
  }

  Future<Null> _playAnimation() async {
    animationStatus = 1;
    setState(() {});
    try {
      animationController.reset();
      await animationController.forward();
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _doubleExit,
      child: Scaffold(
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Stack(
            children: <Widget>[
              Background(),
              Container(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      animationStatus == 0
                          ? ScaleTransition(
                              scale: animationController,
                              child: Container(
                                width: 80.0,
                                height: 80.0,
                                margin: EdgeInsets.only(top: 80.0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 2.0, color: Colors.white),
                                    image: DecorationImage(
                                        image: AssetImage('assets/images/avatar.png'), fit: BoxFit.cover)),
                                child: Container(),
                              ),
                            )
                          : LoginAnimation(buttonController: animationController.view),
                      Container(
                        padding: EdgeInsets.all(16.0),
                        child: Text('蜂巢-ForYou', style: TextStyle(fontSize: 20.0)),
                      ),
                      SizedBox(
                        height: 100.0,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: UserLoginFormWidget(onTaped: _playAnimation),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserLoginFormWidget extends StatefulWidget {
  final VoidCallback onTaped;
  UserLoginFormWidget({Key key, this.onTaped}) : super(key: key);

  _UserLoginFormWidgetState createState() => _UserLoginFormWidgetState();
}

class _UserLoginFormWidgetState extends State<UserLoginFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _captcha, _phoneNumber, _inviteCode;

  bool _autovalidate = false;
  bool _loginButtonState = true;
  bool _isReadIns = true;

  String _validatePhoneNumber(String value) {
    if (value.isEmpty) return '手机号码不能为空';
    if (value.length != 11) return '手机号码输入错误';
    return null;
  }

  String _handlePhoneNumber() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      return null;
    } else {
      form.save();
      return _phoneNumber;
    }
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      BotToast.showText(text: "输入有误，请重新输入", textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
    } else {
      form.save();
      if (_captcha == null || _captcha.length != 6) {
        BotToast.showText(text: "验证码输入错误", textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
      } else {
        _loginButtonState = false;
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
        _loginOrRegister({'phone': _phoneNumber, 'sms': _captcha, 'code': _inviteCode});
      }
    }
  }

  String _timeToString(time) {
    var timeStr =
        "${time.year.toString()}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
    return timeStr;
  }

  Future _loginOrRegister(params) async {
    try {
      Dio dio = new Dio();
      Response response;
      response = await dio.post('http://www.4u2000.com/sesame/api/usernofiler/login', data: params);
      print(response);
      if (response.data['code'] == 1) {
        if (response.data['data'] == null) {
          BotToast.showText(
              text: "登录失败，${response.data['msg']}", textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
          _loginButtonState = true;
        } else {
          SpUtil.putInt('xxUserId', response.data['data']['userid']);
          SpUtil.putString('xxToken', response.data['data']['token']);
          String date = _timeToString(new DateTime.now());
          SpUtil.putString('xxLoginTime', date);
          widget.onTaped();
        }
      } else {
        BotToast.showText(text: "登录失败，请重新登录", textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
        _loginButtonState = true;
      }
    } catch (e) {
      throw Exception('系统错误');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidate: _autovalidate,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.phone),
                  labelText: '手机号码',
                  hintText: '请输入手机号码',
                  prefixText: '+86 ',
                  alignLabelWithHint: true,
                  isDense: true,
                  filled: true,
                  errorText: '',
                  errorStyle: TextStyle(fontSize: 12.0, color: Colors.red)),
              maxLines: 1,
              maxLength: 11,
              style: TextStyle(fontSize: 14.0, height: 1.5, textBaseline: TextBaseline.alphabetic),
              validator: _validatePhoneNumber,
              onSaved: (val) {
                _phoneNumber = val;
              },
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '验证码',
                      hintText: '验证码',
                      alignLabelWithHint: true,
                      isDense: true,
                      filled: true,
                      suffixIcon: CaptchaButton(
                        onTap: _handlePhoneNumber,
                      ),
                    ),
                    maxLines: 1,
                    maxLength: 6,
                    style: TextStyle(fontSize: 14.0, height: 1.5, textBaseline: TextBaseline.alphabetic),
                    onSaved: (val) {
                      _captcha = val;
                    },
                  ),
                ),
              ),
            ],
          ),
          // Container(
          //   padding: const EdgeInsets.all(10.0),
          //   child: TextFormField(
          //     keyboardType: TextInputType.number,
          //     decoration: const InputDecoration(
          //       suffixIcon: Icon(Icons.text_fields),
          //       labelText: '邀请码',
          //       hintText: '请输入邀请码',
          //       alignLabelWithHint: true,
          //       isDense: true,
          //       filled: true,
          //     ),
          //     maxLines: 1,
          //     style: TextStyle(fontSize: 14.0, height: 1.5, textBaseline: TextBaseline.alphabetic),
          //     onSaved: (val) {},
          //   ),
          // ),
          Container(
            width: double.infinity,
            height: 60.0,
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Checkbox(
                          value: _isReadIns,
                          onChanged: (val) {
                            if (val) {
                              _loginButtonState = true;
                            } else {
                              _loginButtonState = false;
                            }
                            setState(() {
                              _isReadIns = val;
                            });
                          },
                        ),
                        Container(
                          child: FlatButton(
                            padding: EdgeInsets.zero,
                            child: Text('已阅读用户须知'),
                            onPressed: () {
                              Navigator.pushNamed(context, '/userInstro');
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                RaisedButton(
                  color: Colors.blue,
                  elevation: 2.0,
                  shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                  ),
                  child: const Text('登录 | 注册', style: TextStyle(color: Colors.white)),
                  onPressed: _loginButtonState ? _handleSubmitted : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CaptchaButton extends StatefulWidget {
  CaptchaButton({Key key, this.onTap}) : super(key: key);
  final VoidCallback onTap;

  _CaptchaButtonState createState() => _CaptchaButtonState();
}

class _CaptchaButtonState extends State<CaptchaButton> {
  bool _hasHandleCaptcha = false;
  int _seconds = 30;

  /// 倒计时的计时器。
  Timer _timer;

  Future _handleCapcha() async {
    if (_hasHandleCaptcha) {
      BotToast.showText(text: "验证码已发，5分钟内有效", textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
      return;
    } else {
      String phoneNumber = widget.onTap();
      if (phoneNumber == null) {
        BotToast.showText(text: "输入有误，请重新输入", textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
      } else {
        _hasHandleCaptcha = true;
        _startCountdown();
        setState(() {});
        requestCaptcha(phoneNumber);
      }
    }
  }

  Future requestCaptcha(number) async {
    try {
      Dio dio = new Dio();
      Response response;
      response = await dio.get('http://www.4u2000.com/sesame/api/user/code', queryParameters: {'phone': number});
      print(response);
    } catch (e) {
      throw Exception('系统错误' + e);
    }
  }

  /// 启动倒计时的计时器。
  void _startCountdown() {
    // 计时器（`Timer`）组件的定期（`periodic`）构造函数，创建一个新的重复计时器。
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        _hasHandleCaptcha = false;
        _seconds = 30;
        setState(() {});
        return;
      }
      _seconds--;
      setState(() {});
    });
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
  }

  String _numberToString(int number) {
    String counter;
    if (number < 10) {
      counter = number.toString().padLeft(2, '0');
    } else {
      counter = number.toString();
    }
    return counter;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton.icon(
        icon: Icon(Icons.security),
        label: _hasHandleCaptcha ? Text('(${_numberToString(_seconds)}) 验证码') : Text('验证码'),
        onPressed: _hasHandleCaptcha ? null : _handleCapcha,
      ),
    );
  }
}
