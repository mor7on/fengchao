import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool globalDialogState = false;

class GlobalDialog {
  static BuildContext ctx;

  static void showGlobalDialog(Widget child) {
    // 已有弹窗，则不再显示弹窗, dict.length >= 2 保证了有一个执行弹窗即可，
    if (globalDialogState == true) {
      return;
    }
    globalDialogState = true; // 修改状态
    // 请求前显示弹窗
    showCupertinoDialog(
      context: ctx,
      builder: (BuildContext context) => child,
    ).then((_) => globalDialogState = false);
  }
}
