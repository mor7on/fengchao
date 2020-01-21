import 'dart:convert';

import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/provider/login_user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQrcodeComponent extends StatelessWidget {
  const MyQrcodeComponent({Key key, this.arguments}) : super(key: key);
  final Map arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('我的二维码名片'),
      ),
      body: Center(
        child: Card(
          child: Consumer<LoginUserModel>(
            builder: (context, model, _) {
              return Container(
                width: 300.0,
                height: 320.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 16.0,
                            backgroundImage: NetworkImage(model.loginUser.avatar),
                          ),
                          SizedBox(width: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(model.loginUser.userNickname),
                              Text(model.loginUser.createTime,
                                  style: TextStyle(fontSize: 10.0, color: Colors.blueGrey[200])),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 200.0,
                      height: 200.0,
                      child: QrImage(
                        data: jsonEncode({'type': 'user', 'userId': model.loginUser.id,'nickName': model.loginUser.userNickname}),
                        version: QrVersions.auto,
                        size: 200,
                        gapless: false,
                        embeddedImage: NetworkImage(model.loginUser.avatar),
                        embeddedImageStyle: QrEmbeddedImageStyle(
                          size: Size(40, 40),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('扫一扫，添加好友', style: TextStyle(fontSize: 10.0, color: Colors.blueGrey[200])),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
