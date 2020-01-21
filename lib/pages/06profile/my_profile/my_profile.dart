import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/provider/login_user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyProfileComponent extends StatefulWidget {
  MyProfileComponent({Key key}) : super(key: key);

  @override
  _MyProfileComponentState createState() => _MyProfileComponentState();
}

class _MyProfileComponentState extends State<MyProfileComponent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('用户设置'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Consumer<LoginUserModel>(
              builder: (context, model, _) {
                return ListView(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  children: <Widget>[
                    ListTile(
                      dense: true,
                      title: Text('头像'),
                      subtitle: Text('设置您的头像'),
                      trailing: Container(
                        width: 100.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: NetworkImage(model.loginUser.avatar),
                            ),
                            Icon(Icons.navigate_next)
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/myAvatar').then((isRefresh) {
                          if (isRefresh == true) {
                            print('刷新用户头像');
                          }
                        });
                      },
                    ),
                    Divider(height: 10.0, thickness: 1.0),
                    ListTile(
                      dense: true,
                      title: Text('昵称'),
                      subtitle: Text('设置您的昵称'),
                      trailing: Container(
                        width: 160.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              child: Text(model.loginUser.userNickname),
                            ),
                            Icon(Icons.navigate_next)
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/myNickname').then((isRefresh) {
                          if (isRefresh == true) {
                            print('刷新用户头像');
                          }
                        });
                      },
                    ),
                    Divider(height: 10.0, thickness: 1.0),
                    ListTile(
                      dense: true,
                      title: Text('技能'),
                      subtitle: Text('设置您的技能'),
                      trailing: Container(
                        width: 160.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              child: Text(model.loginUser.skill??'未设置个人技能',maxLines: 1,overflow: TextOverflow.ellipsis,),
                            ),
                            Icon(Icons.navigate_next)
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/mySkillTags').then((isRefresh) {
                          if (isRefresh == true) {
                            print('刷新用户头像');
                          }
                        });
                      },
                    ),
                    Divider(height: 10.0, thickness: 1.0),
                    ListTile(
                      dense: true,
                      title: Text('签名'),
                      subtitle: Text(
                        model.loginUser.signature??'您还没有设置个人签名',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Icon(Icons.navigate_next),
                      onTap: () {
                        Navigator.pushNamed(context, '/mySignature').then((isRefresh) {
                          if (isRefresh == true) {
                            print('刷新用户头像');
                          }
                        });
                      },
                    ),
                    Divider(height: 10.0, thickness: 1.0),
                    ListTile(
                      dense: true,
                      title: Text('二维码名片'),
                      subtitle: Text('您的二维码名片'),
                      trailing: Container(
                        width: 100.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[Icon(IconData(0xe724, fontFamily: 'iconfont')), Icon(Icons.navigate_next)],
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/myQrcode');
                      },
                    ),
                    Divider(height: 10.0, thickness: 1.0),
                    ListTile(
                      dense: true,
                      title: Text('更多'),
                      subtitle: Text('更多用户设置'),
                      trailing: Icon(Icons.navigate_next),
                      onTap: () {
                        Navigator.pushNamed(context, '/myProfileMore');
                      },
                    ),
                    Divider(height: 10.0, thickness: 1.0),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
