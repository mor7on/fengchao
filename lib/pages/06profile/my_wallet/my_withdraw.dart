import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/06_user_profile_fun.dart';
import 'package:fengchao/common/utils/common_utils.dart';
import 'package:fengchao/common/utils/encrypt_helper.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:fengchao/pages/widgets/password_screen_dialog.dart';
import 'package:fengchao/pages/widgets/password_screen_withdraw.dart';
import 'package:fengchao/provider/login_user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyWithdrawComponent extends StatefulWidget {
  MyWithdrawComponent({Key key}) : super(key: key);

  @override
  _MyWithdrawComponentState createState() => _MyWithdrawComponentState();
}

class _MyWithdrawComponentState extends State<MyWithdrawComponent> {
  TextEditingController _textEditingController;

  int _curIndex = 0;
  String _serviceCharge = '0.00';
  List _bankCard;
  EncryptHelper _encryptHelper = EncryptHelper();

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _encryptHelper.init();
    _textEditingController.addListener(() {
      if (_textEditingController.text.isNotEmpty) {
        _serviceCharge = (double.parse(_textEditingController.text) * 0.02).toStringAsFixed(2);
      } else {
        _serviceCharge = '0.00';
      }
      setState(() {});
    });
    initUserData();
  }

  Future initUserData() async {
    var res = await getUserBankCards();
    print(res);
    if (null != res) {
      _bankCard = res['data'];
      if (_bankCard.length == 0) {
        _showNoBankCard();
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _showNoBankCard() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                '提现前，请先绑定银行卡！',
                style: TextStyle(fontSize: 16.0),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('取消'),
                  onPressed: () {
                    Navigator.pop(context, 'cancle');
                  },
                ),
                FlatButton(
                  child: Text('确定'),
                  onPressed: () {
                    Navigator.pop(context, 'confirm');
                  },
                ),
              ],
            )).then((val) {
      if (val == 'confirm') {
        Navigator.pop(context);
      }
    });
  }

  void _toWithdraw() {
    double coin = double.tryParse(_textEditingController.text);
    if (coin == null) {
      CommonUtils.showToast('金额输入错误！');
      return;
    }
    LoginUserModel model = Provider.of<LoginUserModel>(context);
    double balance = model.myblance.all - model.myblance.bail;
    if (coin > balance) {
      CommonUtils.showToast('金额输入错误！');
      return;
    }
    // 调出密码输入框
    Navigator.push(
      context,
      PageRouteBuilder<String>(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) => PassScreenWithdrawDialog(coin: coin),
      ),
    ).then((val) {
      print(val);
      if (val != null) {
        _publishWithdraw(val,coin);
      }
    });
  }

  Future _publishWithdraw(String pass, double coin) async {
    BotToast.showLoading(duration: Duration(milliseconds: 300));
    await Future.delayed(Duration(milliseconds: 300));
    var data = {
      'type': 0, // 0银行1支付宝2微信
      'type_id': _bankCard[_curIndex]['id'], // 银行卡ID
      'coin': _encryptHelper.encode(coin.toStringAsFixed(2)),
      'password': _encryptHelper.encode(pass),
    };
    var res = await toPostWithdraw(params: data);
    print(res);
    if (null != res) {
      if (res['data'] == true) {
        String bankCardType = _bankCard[_curIndex]['bankcard_type'];
        String bankCardNum = _bankCard[_curIndex]['bankcard'];
        String trueName = _bankCard[_curIndex]['name'];
        String bankCard = bankCardType + '(' + bankCardNum.substring(10) + ')';
        Navigator.pushNamed(context, '/myWithdrawFinish',
            arguments: {'coin': coin, 'bankCard': bankCard, 'trueName': trueName, 'service': _serviceCharge});
      }
    }
  }

  void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<int>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((int value) {
      if (value != null) {
        setState(() => _curIndex = value);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
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
          title: Text('提现'),
        ),
        body: _bankCard == null
            ? loadWidget
            : ListView(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                children: <Widget>[
                  _bankCard.length > 0
                      ? ListTile(
                          dense: true,
                          leading: Text('提现方式'),
                          title: Container(
                            child: Text(_bankCard[_curIndex]['bankcard_type']),
                          ),
                          subtitle: Text(_bankCard[_curIndex]['bankcard']),
                          trailing: Icon(Icons.navigate_next),
                          onTap: () {
                            showDemoActionSheet(
                              context: context,
                              child: CupertinoActionSheet(
                                title: const Text('提现'),
                                message: const Text('请选择以下提现方式'),
                                actions: _bankCard.asMap().keys.map((index) {
                                  return CupertinoActionSheetAction(
                                    child: Text(
                                      _bankCard[index]['bankcard_type'],
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context, index);
                                    },
                                  );
                                }).toList(),
                                cancelButton: CupertinoActionSheetAction(
                                  child: const Text(
                                    '取消',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  isDefaultAction: true,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          height: 64.0,
                          alignment: Alignment.center,
                          child: Text('请先绑定提现银行卡'),
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
                        Consumer<LoginUserModel>(
                          builder: (context, model, _) {
                            return Container(
                              child: Text('可提现金额 ${model.myblance.all - model.myblance.bail}元'),
                            );
                          },
                        ),
                        Container(
                          child: TextFormField(
                            controller: _textEditingController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              // labelText: '充值金额',
                              hintText: '提现金额',
                              helperText: '手续费$_serviceCharge' + '元',
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
                                _toWithdraw();
                              }
                            },
                            child: Text('提现'),
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
