import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/06_user_profile_fun.dart';
import 'package:fengchao/pages/01index/qrcode_read_view.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_toast.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class QrCodeScanComponent extends StatefulWidget {
  QrCodeScanComponent({Key key}) : super(key: key);

  @override
  _QrCodeScanComponentState createState() => new _QrCodeScanComponentState();
}

class _QrCodeScanComponentState extends State<QrCodeScanComponent> {
  GlobalKey<QrcodeReaderViewState> _key = GlobalKey();

  bool isOK = false;

  @override
  void initState() {
    super.initState();
    initPermission();
  }

  Future initPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.camera]);

    if (permissions[PermissionGroup.camera] == PermissionStatus.granted) {
      setState(() {
        isOK = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: isOK
          ? QrcodeReaderView(
              key: _key,
              onScan: onScan,
              headerWidget: CustomAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
            )
          : Center(
              child: loadWidget,
            ),
    );
  }

  Map<String, dynamic> mapFromJson;
  Future onScan(String data) async {
    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle = theme.textTheme.subhead.copyWith(color: theme.textTheme.caption.color);
    if (data.startsWith('{') && data.endsWith('}')) {
      mapFromJson = jsonDecode(data);
    }

    if (null != mapFromJson) {
      if (mapFromJson['type'] == 'user') {
        showDemoDialog<String>(
          context: context,
          child: AlertDialog(
            content: Text(
              '要添加${mapFromJson['nickName']}为好友吗？',
              style: dialogTextStyle,
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('取消'),
                onPressed: () {
                  Navigator.pop(context, 'cancle');
                },
              ),
              FlatButton(
                child: const Text('确定'),
                onPressed: () {
                  Navigator.pop(context, 'addUser');
                },
              ),
            ],
          ),
        );
      }

      if (mapFromJson['type'] == 'team') {
        showDemoDialog<String>(
          context: context,
          child: AlertDialog(
            content: Text(
              '要申请加入团队${mapFromJson['teamName']}吗？',
              style: dialogTextStyle,
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('取消'),
                onPressed: () {
                  Navigator.pop(context, 'cancle');
                },
              ),
              FlatButton(
                child: const Text('确定'),
                onPressed: () {
                  Navigator.pop(context, 'joinTeam');
                },
              ),
            ],
          ),
        );
      }
    } else {
      _launchURL(data);
    }
  }

  _launchURL(String data) async {
    String url = data;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void showDemoDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((T val) async {
      if (val == 'joinTeam') {
        BotToast.showLoading(duration: Duration(milliseconds: 500));
        var res = await toJoinTeam(params: {'id': mapFromJson['teamId'], 'message': '通过扫码申请'});
        await Future.delayed(Duration(milliseconds: 500));
        if (null != res) {
          if (res['data'] == true) {
            BotToast.showCustomLoading(
              duration: Duration(milliseconds: 300),
              toastBuilder: (cancelFunc) {
                return CustomToastWidget(title: '已申请', icon: Icons.done);
              },
            );
          } else {
            BotToast.showText(text: '申请失败', textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
          }
        }
      }
      if (val == 'addUser') {
        BotToast.showLoading(duration: Duration(milliseconds: 500));
        print(mapFromJson['userId']);
        var res = await toApplyForFriend(params: {'friend_id': mapFromJson['userId'], 'message': '通过扫码申请'});
        print(res);
        await Future.delayed(Duration(milliseconds: 500));
        if (null != res) {
          if (res['data'] == true) {
            BotToast.showCustomLoading(
              duration: Duration(milliseconds: 300),
              toastBuilder: (cancelFunc) {
                return CustomToastWidget(title: '已申请', icon: Icons.done);
              },
            );
          } else {
            BotToast.showText(text: '申请失败', textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
          }
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
