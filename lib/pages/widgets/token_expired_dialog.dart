import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TokenExpiredDialog extends StatelessWidget {
  const TokenExpiredDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('登录状态过期'),
      content: const Text('您的登录状态已经过期，或者当前用户已经在其他设备登录；'
          '若需要在当前设备操作，请您重新登录。'),
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
            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => route == null);
          },
        ),
      ],
    );
  }
}
