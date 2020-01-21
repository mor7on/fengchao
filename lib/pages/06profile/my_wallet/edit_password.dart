import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/06_user_profile_fun.dart';
import 'package:fengchao/common/utils/encrypt_helper.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_toast.dart';
import 'package:fengchao/pages/widgets/num_keyboard.dart';
import 'package:fengchao/pages/widgets/uni_passwords.dart';
import 'package:flutter/material.dart';

class EditPasswordComponent extends StatefulWidget {
  EditPasswordComponent({Key key}) : super(key: key);

  @override
  _EditPasswordComponentState createState() => _EditPasswordComponentState();
}

class _EditPasswordComponentState extends State<EditPasswordComponent> with SingleTickerProviderStateMixin {
  List<int> _oldPass = [];
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
      if (_oldPass.length < 1) {
        return;
      }
      _oldPass.removeLast();
    } else if (step == 1) {
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
      if (_oldPass.length >= 6) {
        return;
      }
      _oldPass.add(n);
    } else if (step == 1) {
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

  void _confirmFunc() {
    if (step == 0) {
      print(_oldPass);
      if (_oldPass.length != 6) {
        BotToast.showText(text: '请输入6位密码', textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
        return;
      }
      _verifyPassword(_oldPass.join());
    } else if (step == 1) {
      if (_passwords.length != 6) {
        BotToast.showText(text: '请输入6位密码', textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
        return;
      }
      setState(() => step = 2);
    } else {
      print(_passwords.join());
      print(_confirm.join());
      String pass = _passwords.join();
      String confirm = _confirm.join();
      String oldpass = _oldPass.join();
      if (pass == confirm) {
        print('密码输入一致');
        _updatePassword(oldpass,pass);
      } else {
        BotToast.showText(text: '两次输入不一致，请重新输入', textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
      }
    }
  }

  Future _updatePassword(String oldpass,String newpass) async {
    BotToast.showLoading();
    var res = await toUpdatePassword(params: {'oldpassword': _encryptHelper.encode(oldpass),'newpassword': _encryptHelper.encode(newpass)});
    await Future.delayed(Duration(milliseconds: 600));
    BotToast.closeAllLoading();
    print(res);
    if (null != res) {
      if (res['data'] == true) {
        BotToast.showCustomLoading(
          duration: Duration(milliseconds: 600),
          toastBuilder: (cancelFunc) {
            return CustomToastWidget(title: '密码修改成功', icon: Icons.done);
          },
        );
        await Future.delayed(Duration(milliseconds: 600));
        Navigator.pop(context);
      }
    }
  }

  Future _verifyPassword(String pass) async {
    // 验证密码
    BotToast.showLoading();
    print(pass);
    var res = await toVerifyPassword(params: {'password': _encryptHelper.encode(pass)});
    await Future.delayed(Duration(milliseconds: 600));
    print(res);
    BotToast.closeAllLoading();
    if (null != res) {
      if (res['data'] == true) {
        BotToast.showCustomLoading(
          duration: Duration(milliseconds: 600),
          toastBuilder: (cancelFunc) {
            return CustomToastWidget(title: '密码验证成功', icon: Icons.done);
          },
        );
        await Future.delayed(Duration(milliseconds: 600));
        setState(() {
          step = 1;
        });
      } else {
        BotToast.showText(text: '密码输入错误', textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('修改密码'),
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
                title: step == 0 ? '请输入旧6位密码' : step == 1 ? '请输入新6位密码' : '请确认输入新密码',
                passwords: step == 0 ? _oldPass : step == 1 ? _passwords : _confirm,
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
                confirmWidget: step == 2 ? Icon(Icons.check) : Text('NEXT'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
