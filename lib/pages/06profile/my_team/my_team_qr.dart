import 'dart:convert';

import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/provider/login_user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyTeamQRComponent extends StatelessWidget {
  const MyTeamQRComponent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('我的团队二维码'),
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
                            backgroundImage: NetworkImage(model.userTeam.imageList[0]),
                          ),
                          SizedBox(width: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(model.userTeam.postTitle),
                              Text(model.userTeam.createTime,
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
                        data: jsonEncode(
                            {'type': 'team', 'teamId': model.userTeam.id, 'teamName': model.userTeam.postTitle}),
                        version: QrVersions.auto,
                        size: 200,
                        gapless: false,
                        embeddedImage: NetworkImage(model.userTeam.imageList[0]),
                        embeddedImageStyle: QrEmbeddedImageStyle(
                          size: Size(50, 50),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('扫一扫，加入团队更轻松', style: TextStyle(fontSize: 10.0, color: Colors.blueGrey[200])),
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
