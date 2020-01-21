import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/01_index_component_fun.dart';
import 'package:fengchao/models/wxpay_order_model.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/provider/login_user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tobias/tobias.dart' as tobias;
import 'package:fluwx/fluwx.dart' as fluwx;

class MyRechargeComponent extends StatefulWidget {
  MyRechargeComponent({Key key}) : super(key: key);

  @override
  _MyRechargeComponentState createState() => _MyRechargeComponentState();
}

class _MyRechargeComponentState extends State<MyRechargeComponent> {
  TextEditingController _textEditingController;

  int rechargeType = 1;
  String _result = "";

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _textEditingController.addListener(() {
      if (!mounted) return;
      setState(() {});
    });
    fluwx.responseFromPayment.listen((data) {
      if (!mounted) return;
      print('--------------->${data.errCode}');
      if (data.errCode == 0) {
        BotToast.showLoading(duration: Duration(milliseconds: 600));
        Provider.of<LoginUserModel>(context).fetchMyBlance();
        Future.delayed(Duration(milliseconds: 600), () {
          Navigator.pop(context);
        });
      }
    });
  }

  Future _toRecharge() async {
    String charge = _textEditingController.text;
    int type = rechargeType;
    if (charge.trim().isEmpty) {
      return;
    }
    double doubleCharge = double.tryParse(charge);
    print(doubleCharge);
    if (doubleCharge == null || doubleCharge <= 0) {
      BotToast.showText(text: '输入金额有误', textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
      return;
    }
    FocusScope.of(context).requestFocus(FocusNode());
    var res = await _getOrderInfo(type, doubleCharge.toStringAsFixed(2));
    if (null != res) {
      if (type == 0) {
        // 支付宝支付
        tobias.aliPay(res['data']).then((data) {
          /// {resultStatus: 9000, result: {
          /// "alipay_trade_app_pay_response":{
          /// "code":"10000",
          /// "msg":"Success",
          /// "sign_type":"RSA2"}, memo: , platform: android}

          if (data['resultStatus'] == '9000') {
            BotToast.showLoading(duration: Duration(milliseconds: 600));
            Provider.of<LoginUserModel>(context).fetchMyBlance();
            Future.delayed(Duration(milliseconds: 600), () {
              Navigator.pop(context);
            });
          }
        });
      } else if (type == 1) {
        // 微信支付
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
  }

  /// type: 0支付宝1微信
  Future<Map<String, dynamic>> _getOrderInfo(type, amount) async {
    print(amount);
    Map<String, dynamic> data = {'type': type, 'amount': amount};
    var res = await getOrderInfo(params: data);
    print(res);
    if (null != res) {
      return res;
    }
    return null;
  }

  void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String value) {
      if (value == 'zhifubao') {
        setState(() => rechargeType = 0);
      }
      if (value == 'weixin') {
        setState(() => rechargeType = 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text('充值'),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          children: <Widget>[
            ListTile(
              dense: true,
              leading: Text('支付方式'),
              title: Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 18.0,
                      height: 18.0,
                      child: Image.asset(
                          rechargeType == 0 ? 'assets/images/zhifubaozhifu.png' : 'assets/images/weixinzhifu.png'),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Container(
                      child: Text(rechargeType == 0 ? '支付宝' : '微信'),
                    ),
                  ],
                ),
              ),
              subtitle: Text(rechargeType == 0 ? '数亿用户都在用，安全可托付' : '亿万用户的选择，更快更安全'),
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                showDemoActionSheet(
                  context: context,
                  child: CupertinoActionSheet(
                    title: const Text('充值'),
                    message: const Text('请选择以下充值方式'),
                    actions: <Widget>[
                      CupertinoActionSheetAction(
                        child: Text(
                          '支付宝',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context, 'zhifubao');
                        },
                      ),
                      CupertinoActionSheetAction(
                        child: const Text(
                          '微信',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context, 'weixin');
                        },
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      child: const Text(
                        '取消',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      isDefaultAction: true,
                      onPressed: () {
                        Navigator.pop(context, 'Cancel');
                      },
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 32.0,
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text('充值金额'),
                  ),
                  Container(
                    child: TextFormField(
                      controller: _textEditingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        // labelText: '充值金额',
                        hintText: '充值金额',
                        // isDense: true,
                        prefixIcon: Container(
                          width: 40.0,
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            '¥',
                            style: TextStyle(fontSize: 24.0),
                          ),
                        ),
                        suffix: Text(
                          'CNY',
                          style: TextStyle(fontSize: 40.0, color: Colors.green),
                        ),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 1,
                      style: TextStyle(fontSize: 40.0, height: 1.5, textBaseline: TextBaseline.alphabetic),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    width: double.infinity,
                    child: RaisedButton(
                      elevation: 0.0,
                      textColor: _textEditingController.text.isEmpty ? Colors.black : Colors.white,
                      color: _textEditingController.text.isEmpty ? Colors.grey[100] : Colors.blue,
                      onPressed: () {
                        if (_textEditingController.text.isNotEmpty) {
                          _toRecharge();
                        }
                      },
                      child: Text('充值'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
