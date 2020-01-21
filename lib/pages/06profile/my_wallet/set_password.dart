import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/06_user_profile_fun.dart';
import 'package:fengchao/common/utils/encrypt_helper.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_toast.dart';
import 'package:fengchao/pages/widgets/num_keyboard.dart';
import 'package:fengchao/pages/widgets/uni_passwords.dart';
import 'package:fengchao/provider/login_user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetPasswordComponent extends StatefulWidget {
  SetPasswordComponent({Key key}) : super(key: key);

  @override
  _SetPasswordComponentState createState() => _SetPasswordComponentState();
}

class _SetPasswordComponentState extends State<SetPasswordComponent> with SingleTickerProviderStateMixin {
  List<int> _passwords = [];
  List<int> _confirm = [];
  int step = 0;
  AnimationController _controller;
  Animation<Offset> _animation;
  EncryptHelper _encryptHelper = EncryptHelper();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    final Animation curve = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    _animation = Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(curve);

    _controller.forward();
    _encryptHelper.init();
  }

  void _deleteFunc() {
    if (step == 0) {
      if (_passwords.length < 1) {
        return;
      }
      _passwords.removeLast();
    } else {
      if (_confirm.length < 1) {
        return;
      }
      _confirm.removeLast();
    }

    setState(() {});
  }

  void _numberFunc(n) {
    print(_passwords);
    if (step == 0) {
      if (_passwords.length >= 6) {
        return;
      }
      _passwords.add(n);
    } else {
      if (_confirm.length >= 6) {
        return;
      }
      _confirm.add(n);
    }
    setState(() {});
  }

  Future _confirmFunc() async {
    if (step == 0) {
      if (_passwords.length != 6) {
        BotToast.showText(text: '请输入6位密码', textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
        return;
      }
      setState(() => step = 1);
    } else {
      print(_passwords.join());
      print(_confirm.join());
      bool res = _passwords.join() == _confirm.join();
      if (res) {
        print('密码输入一致');
        BotToast.showLoading();
        String pass = _passwords.join();
        var res = await toSetPassword(params: {'password': _encryptHelper.encode(pass)});
        print(res);
        if (null != res) {
          BotToast.closeAllLoading();
          if (res['data'] == true) {
            BotToast.showCustomLoading(
              duration: Duration(milliseconds: 300),
              toastBuilder: (cancelFunc) {
                return CustomToastWidget(title: '密码设置成功', icon: Icons.done);
              },
            );
            Provider.of<LoginUserModel>(context).fetchUpdatePayPass();
            await Future.delayed(Duration(milliseconds: 300));
            Navigator.of(context).pop();
          }else {
            BotToast.showCustomLoading(
              duration: Duration(milliseconds: 300),
              toastBuilder: (cancelFunc) {
                return CustomToastWidget(title: '密码设置失败', icon: Icons.error_outline);
              },
            );
            await Future.delayed(Duration(milliseconds: 300));
            Navigator.of(context).pop();
          }
        }
      } else {
        BotToast.showText(text: '两次输入不一致，请重新输入', textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('设置密码'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            padding: EdgeInsets.all(32.0),
            child: GestureDetector(
              onTap: () {
                if (_controller.isDismissed) {
                  _controller.forward();
                }
              },
              child: UNIPasswordWidget(
                title: step == 0 ? '请输入6位密码' : '请确认输入密码',
                passwords: step == 0 ? _passwords : _confirm,
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: SlideTransition(
              position: _animation,
              child: new NumberKeyboardWidget(
                controller: _controller,
                deleteFunc: _deleteFunc,
                numberFunc: _numberFunc,
                confirmFunc: _confirmFunc,
                confirmWidget: step == 0 ? Text('NEXT') : Icon(Icons.check),
              ),
            ),
          )
        ],
      ),
    );
  }
}
