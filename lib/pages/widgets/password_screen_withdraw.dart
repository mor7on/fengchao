import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/pages/widgets/num_keyboard.dart';
import 'package:fengchao/pages/widgets/withdraw_passwords.dart';
import 'package:flutter/material.dart';

class PassScreenWithdrawDialog extends StatefulWidget {
  final double coin;
  PassScreenWithdrawDialog({Key key, this.coin}) : super(key: key);

  @override
  _PassScreenWithdrawDialogState createState() => _PassScreenWithdrawDialogState();
}

class _PassScreenWithdrawDialogState extends State<PassScreenWithdrawDialog> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animation;
  List<int> _passwords = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    final Animation curve = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    _animation = Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(curve);

    _controller.forward();
  }

  void _deleteFunc() {
    if (_passwords.length < 1) {
      return;
    }
    _passwords.removeLast();
    setState(() {});
  }

  void _numberFunc(n) {
    print(_passwords);
    if (_passwords.length >= 6) {
      return;
    }
    _passwords.add(n);
    setState(() {});
  }

  void _confirmFunc() {
    print(_passwords.join());
    if (_passwords.length != 6) {
      BotToast.showText(text: '请输入6位交易密码', textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
      return;
    }
    Navigator.pop(context, _passwords.join());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Stack(
        children: <Widget>[
          Container(),
          Container(
            padding: EdgeInsets.only(top: 120.0, left: 32.0, right: 32.0),
            height: 360.0,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
                  child: GestureDetector(
                    onTap: () {
                      if (_controller.isDismissed) {
                        _controller.forward();
                      }
                    },
                    child: WithdrawPasswordWidget(
                      passwords: _passwords,
                      title: '请输入交易密码',
                      coin: widget.coin,
                    ),
                  ),
                ),
                Positioned(
                  top: 10.0,
                  right: 10.0,
                  child: Container(
                    width: 30.0,
                    height: 30.0,
                    child: FlatButton(
                      padding: EdgeInsets.zero,
                      child: Icon(
                        Icons.close,
                        size: 20.0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: SlideTransition(
              position: _animation,
              child: Container(
                color: Colors.white,
                child: NumberKeyboardWidget(
                  controller: _controller,
                  numberFunc: _numberFunc,
                  deleteFunc: _deleteFunc,
                  confirmFunc: _confirmFunc,
                  confirmWidget: Text('确定'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
