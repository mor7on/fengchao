import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServerExceptionDialog extends StatelessWidget {
  const ServerExceptionDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('服务器异常'),
      content: const Text('服务器状态异常，'
          '请稍后重试！'),
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
