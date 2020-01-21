import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/06_user_profile_fun.dart';
import 'package:fengchao/common/utils/encrypt_helper.dart';
import 'package:fengchao/models/bank_card.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_loading_widget.dart';
import 'package:fengchao/pages/widgets/custom_toast.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:fengchao/pages/widgets/password_screen_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QueryBankCardComponent extends StatefulWidget {
  QueryBankCardComponent({Key key}) : super(key: key);

  @override
  _QueryBankCardComponentState createState() => _QueryBankCardComponentState();
}

class _QueryBankCardComponentState extends State<QueryBankCardComponent> {
  List<UserCard> _bankCard;
  EncryptHelper _encryptHelper = EncryptHelper();

  @override
  void initState() {
    super.initState();
    initUserData();
    _encryptHelper.init();
  }

  Future initUserData() async {
    _bankCard = [];
    var res = await getUserBankCards();
    print(res);
    if (null != res) {
      res['data'].forEach((v) {
        _bankCard.add(UserCard.fromJson(v));
      });
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('卡包'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: _biuldWithBankCard(),
      ),
    );
  }

  List<Widget> _biuldWithBankCard() {
    List<Widget> children;
    if (_bankCard == null) {
      return <Widget>[loadWidget];
    }
    if (_bankCard.length == 0) {
      children = <Widget>[CustomEmptyWidget()];
    } else {
      children = _bankCard.map<Widget>((item) {
        return _BankCardWidget(
          userCard: item,
          onTap: _showBankCardActionSheet,
        );
      }).toList();
    }
    if (_bankCard.length <= 3) {
      children.add(_AddBankCardWidget(
        onTap: () {
          _showPassScreenDialog('add');
        },
      ));
    }
    children.insert(0, _BankCardWarnWidget());

    return children;
  }

  void _showBankCardActionSheet() {
    showActionSheet(
      context: context,
      child: CupertinoActionSheet(
        title: const Text('卡包'),
        message: const Text('请选择以下操作'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(
              '添加银行卡',
              style: TextStyle(fontSize: 16.0),
            ),
            onPressed: () {
              Navigator.pop(context, 'add');
            },
          ),
          CupertinoActionSheetAction(
            child: const Text(
              '删除银行卡',
              style: TextStyle(fontSize: 16.0),
            ),
            onPressed: () {
              Navigator.pop(context, 'del');
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
  }

  void showActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String value) {
      if (value == 'del') {
        print('删除银行卡');
        _showPassScreenDialog('del');
      }
      if (value == 'add') {
        print('添加银行卡');
        _showPassScreenDialog('add');
      }
    });
  }

  void _showPassScreenDialog(String action) {
    Navigator.push(
      context,
      PageRouteBuilder<String>(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) => PassScreenDialog(),
      ),
    ).then((val) {
      print(val);
      if (val != null) {
        _verifyPassword(val, action);
      }
    });
  }

  Future _verifyPassword(String pass, String action) async {
    // 验证密码
    BotToast.showLoading();
    print(pass);
    var res = await toVerifyPassword(params: {'password': _encryptHelper.encode(pass)});
    await Future.delayed(Duration(milliseconds: 600));
    print(res);
    BotToast.closeAllLoading();
    if (null != res) {
      if (res['data'] == true) {
        if (action == 'add') {
          Navigator.pushNamed(context, '/bindBankCard').then((isRefresh) {
            if (isRefresh == true) {
              initUserData();
            }
          });
        }else {
          _deleteBankCard();
        }
      } else {
        BotToast.showText(text: '密码输入错误', textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
      }
    }
  }

  Future _deleteBankCard() async {
    BotToast.showLoading();
    var res = await toDeleteBankCard();
    await Future.delayed(Duration(milliseconds: 600));
    print(res);
    BotToast.closeAllLoading();
    if (null != res) {
      if (res['data'] == true) {
        BotToast.showText(text: '删除成功', textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
        initUserData();
      }
    }
  }
}

class _BankCardWidget extends StatelessWidget {
  const _BankCardWidget({
    Key key,
    @required UserCard userCard,
    this.onTap,
  })  : _uankCard = userCard,
        super(key: key);

  final UserCard _uankCard;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(color: Colors.blue[100], borderRadius: BorderRadius.circular(5.0)),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 50.0,
              child: Row(
                children: <Widget>[
                  Container(
                    width: 40.0,
                    height: 40.0,
                    child: Image.memory(
                      base64.decode(_uankCard.bankType.icon.split(',')[1]),
                      fit: BoxFit.contain,
                      gaplessPlayback: true,
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(_uankCard.bankcardType),
                  Text("(${_uankCard.bankcard.substring(_uankCard.bankcard.length - 4)})"),
                ],
              ),
            ),
            Divider(),
            Container(
              width: double.infinity,
              height: 40.0,
              alignment: Alignment.centerRight,
              child: Text(_uankCard.createTime),
            )
          ],
        ),
      ),
    );
  }
}

class _AddBankCardWidget extends StatelessWidget {
  const _AddBankCardWidget({Key key, this.onTap}) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
      child: Container(
        width: double.infinity,
        height: 100.0,
        child: FlatButton(
          child: Icon(
            Icons.add,
            size: 60.0,
          ),
          onPressed: onTap,
        ),
      ),
    );
  }
}

class _BankCardWarnWidget extends StatelessWidget {
  const _BankCardWarnWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Container(
        width: double.infinity,
        height: 80.0,
        child: Text(
          '绑定银行卡为用户提现时使用，所有数据均经过加密处理；\n我们保证严守客户信息安全，杜绝一切信息泄露的途径。',
          style: TextStyle(fontSize: 14.0),
        ),
      ),
    );
  }
}
