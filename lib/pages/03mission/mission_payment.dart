import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/01_index_component_fun.dart';
import 'package:fengchao/common/utils/encrypt_helper.dart';
import 'package:fengchao/common/utils/sp_utils.dart';
import 'package:fengchao/models/wxpay_order_model.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_toast.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:fengchao/pages/widgets/password_screen_dialog.dart';
import 'package:fengchao/provider/login_user_model.dart';
import 'package:fengchao/provider/mission_steps_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tobias/tobias.dart' as tobias;
import 'package:fluwx/fluwx.dart' as fluwx;

class MissionPaymentComponent extends StatefulWidget {
  MissionPaymentComponent({Key key, this.arguments}) : super(key: key);
  final Map<String, dynamic> arguments;

  @override
  _MissionPaymentComponentState createState() => _MissionPaymentComponentState();
}

class _MissionPaymentComponentState extends State<MissionPaymentComponent> {
  Map<String, dynamic> _billInfo;

  String _groupValue = 'wxpay';

  int _loginId = SpUtil.getInt('xxUserId');
  // int _loginId = 3;
  bool _buttonState = true;
  EncryptHelper _encryptHelper = EncryptHelper();

  @override
  void initState() {
    super.initState();
    _billInfo = widget.arguments['billInfo'];
    _encryptHelper.init();
    fluwx.responseFromPayment.listen((data) {
      print('--------------->${data.errCode}');
      if (data.errCode == 0) {
        BotToast.showLoading(duration: Duration(milliseconds: 600));
        Provider.of<StepperModel>(context).initMissionSteps();
        Future.delayed(Duration(milliseconds: 600), () {
          Navigator.pop(context, true);
        });
      }
    });
    Future.microtask(
      () => Provider.of<LoginUserModel>(context, listen: false).fetchMyBlance(),
    );
  }

  Future _handlePayment() async {
    if (_buttonState = false) return;
    _buttonState = false;

    if (_groupValue == 'alipay') {
      var res = await _getOrderInfo(0);
      // 支付宝支付
      if (null != res) {
        tobias.aliPay(res['data']).then((data) {
          /// {resultStatus: 9000, result: {
          /// "alipay_trade_app_pay_response":{
          /// "code":"10000",
          /// "msg":"Success",
          /// "sign_type":"RSA2"}, memo: , platform: android}
          if (data['resultStatus'] == '9000') {
            BotToast.showLoading(duration: Duration(milliseconds: 600));
            Provider.of<StepperModel>(context).initMissionSteps();
            Future.delayed(Duration(milliseconds: 600), () {
              Navigator.pop(context, true);
            });
          }
        });
      }
    }
    if (_groupValue == 'wxpay') {
      var res = await _getOrderInfo(1);
      // 微信支付
      if (null != res) {
        WxPayOrderModel orderInfo = WxPayOrderModel.fromJson(res['data']);
        fluwx
            .payWithWeChat(
          appId: orderInfo.appid,
          partnerId: orderInfo.partnerid,
          nonceStr: orderInfo.noncestr,
          packageValue: orderInfo.package,
          prepayId: orderInfo.prepayid,
          sign: orderInfo.sign,
          timeStamp: orderInfo.timestamp,
        )
            .then((data) {
          print("---》$data");
        });
      }
    }
    if (_groupValue == 'fcpay') {
      // 调出密码输入框
      Navigator.push(
        context,
        PageRouteBuilder<String>(
          opaque: false,
          pageBuilder: (context, animation, secondaryAnimation) => PassScreenDialog(),
        ),
      ).then((val) {
        print(val);
        if (val != null) {
          _paymentWithFcpay(val);
        }
      });
    }
  }

  // 蜂巢支付
  Future _paymentWithFcpay(String pass) async {
    var data = {
      'number': _billInfo['number'],
      'trade_id': widget.arguments['trade_id'],
      'password': _encryptHelper.encode(pass),
    };
    var res = await toPayWithBill(params: data);
    print(res);
    if (null != res) {
      if (res['data'] == true) {
        BotToast.showLoading(duration: Duration(milliseconds: 500));
        Provider.of<StepperModel>(context).initMissionSteps();
        await Future.delayed(Duration(milliseconds: 500));
        BotToast.showCustomLoading(
          duration: Duration(milliseconds: 300),
          toastBuilder: (cancelFunc) {
            return CustomToastWidget(title: '支付成功', icon: Icons.done);
          },
        );
        await Future.delayed(Duration(milliseconds: 300));
        Navigator.pop(context,true);
      }else {
        BotToast.showText(text: res['msg'],textStyle: TextStyle(fontSize: 14.0,color: Colors.white));
      }
    }
  }

  /// type: // 0支付宝1微信
  Future<Map<String, dynamic>> _getOrderInfo(int type) async {
    Map<String, dynamic> data = {
      'type': type,
      'number': _billInfo['number'],
      'state': 1,
      'trade_id': widget.arguments['trade_id'],
    };
    var res = await getMissionOrderInfo(params: data);
    print(res);
    if (null != res) {
      return res;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('支付订单'),
      ),
      body: Consumer<LoginUserModel>(
        builder: (context, model, _) {
          return model.myblance == null
              ? loadWidget
              : Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: Column(
                        children: <Widget>[
                          // 头部信息
                          Container(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '本次支付金额',
                                    style: TextStyle(fontSize: 14.0, color: Colors.grey),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text(
                                        '¥',
                                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      _billInfo['coin'],
                                      style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.0),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    _billInfo['number'],
                                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 16.0,
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: Container(
                                        width: 40.0,
                                        height: 40.0,
                                        child: Image.asset('assets/images/avatar.png'),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('蜂巢支付'),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
                                      decoration: BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5.0),
                                          topRight: Radius.circular(5.0),
                                          bottomRight: Radius.circular(5.0),
                                        ),
                                      ),
                                      child: Text(
                                        '推荐',
                                        style: TextStyle(fontSize: 10.0, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                RadioListTile(
                                  value: 'fcpay',
                                  groupValue: _groupValue,
                                  title: Text(
                                    '账户余额支付',
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                  subtitle:
                                      Text('账户可用余额：' + (model.myblance.all - model.myblance.bail).toStringAsFixed(2)),
                                  secondary: Container(
                                    width: 40.0,
                                    height: 40.0,
                                  ),
                                  dense: true,
                                  controlAffinity: ListTileControlAffinity.trailing,
                                  selected: _groupValue == 'fcpay',
                                  onChanged:
                                      (model.myblance.all - model.myblance.bail - double.tryParse(_billInfo['coin'])) >=
                                              0
                                          ? (val) {
                                              setState(() {
                                                _groupValue = val;
                                              });
                                            }
                                          : null,
                                ),
                                Divider(),
                                RadioListTile(
                                  value: 'wxpay',
                                  groupValue: _groupValue,
                                  title: Text(
                                    '微信支付',
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                  subtitle: Text('亿万用户的选择，更快更安全'),
                                  secondary: Container(
                                    width: 40.0,
                                    height: 40.0,
                                    child: Image.asset('assets/images/weixinzhifu.png'),
                                  ),
                                  dense: true,
                                  controlAffinity: ListTileControlAffinity.trailing,
                                  selected: _groupValue == 'wxpay',
                                  onChanged: (val) {
                                    setState(() {
                                      _groupValue = val;
                                    });
                                  },
                                ),
                                Divider(),
                                RadioListTile(
                                  value: 'alipay',
                                  groupValue: _groupValue,
                                  title: Text(
                                    '支付宝支付',
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                  subtitle: Text('数亿用户都在用，安全可托付'),
                                  secondary: Container(
                                    width: 40.0,
                                    height: 40.0,
                                    child: Image.asset('assets/images/zhifubaozhifu.png'),
                                  ),
                                  dense: true,
                                  controlAffinity: ListTileControlAffinity.trailing,
                                  selected: _groupValue == 'alipay',
                                  onChanged: (val) {
                                    setState(() {
                                      _groupValue = val;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0.0,
                      bottom: 0.0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 72.0,
                        padding: const EdgeInsets.all(16.0),
                        child: RaisedButton(
                          elevation: 0.0,
                          color: Colors.blue,
                          child: Text(
                            '确认支付',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: _handlePayment,
                        ),
                      ),
                    )
                  ],
                );
        },
      ),
    );
  }
}
