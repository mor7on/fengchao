import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_listtile.dart';
import 'package:fengchao/provider/login_user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

class UserProfileComponent extends StatefulWidget {
  UserProfileComponent({Key key}) : super(key: key);

  _UserProfileComponentState createState() => _UserProfileComponentState();
}

class _UserProfileComponentState extends State<UserProfileComponent> {
  void onClickItem(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/myCertificate');
        break;
      case 1:
        Navigator.pushNamed(context, '/friendsDynamic', arguments: {'id': 13});
        break;
      case 2:
        Navigator.pushNamed(context, '/mySkillList');
        break;
      case 3:
        Navigator.pushNamed(context, '/myFavoriteList');
        break;
      case 4:
        Navigator.pushNamed(context, '/myShareList');
        break;
      case 5:
        Navigator.pushNamed(context, '/myNewFriends');
        break;
      case 6:
        Navigator.pushNamed(context, '/myFriendsList');
        break;
      case 7:
        final model = Provider.of<LoginUserModel>(context);
        Navigator.pushNamed(context, '/myTeamInfo', arguments: {'id': model.userTeam == null ? null : model.userTeam.id});
        break;
      case 8:
        Navigator.pushNamed(context, '/myWalletInfo');
        break;
      case 9:
        Navigator.pushNamed(context, '/myOption');
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    print('初始化UserProfileComponent----------');
    // Future.microtask(
    //   () => Provider.of<LoginUserModel>(context).init(),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: Text(
            FlutterI18n.translate(context, 'mine'),
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.recent_actors),
              onPressed: () {
                Navigator.pushNamed(context, '/myProfile').then((isRefresh) {
                  if (isRefresh == true) {
                    print('刷新页面');
                  }
                });
              },
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Color(0xFFF4F5F6),
                    ),
                  ),
                ],
              ),
            ),
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    // 顶部栏
                    new Stack(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: 140.0,
                          color: Colors.white,
                        ),
                        ClipPath(
                          clipper: new TopBarClipper(MediaQuery.of(context).size.width, 120.0),
                          child: new Container(
                            width: double.infinity,
                            height: 120.0,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        // 名字
                        Container(
                          margin: new EdgeInsets.only(top: 10.0),
                          child: new Center(
                            child: Consumer<LoginUserModel>(
                              builder: (contex, model, _) {
                                return model.loginUser == null
                                    ? Container()
                                    : Text(
                                        model.loginUser.userNickname,
                                        style: new TextStyle(fontSize: 20.0, color: Colors.white),
                                      );
                              },
                            ),
                          ),
                        ),
                        // 图标
                        Container(
                          margin: new EdgeInsets.only(top: 50.0),
                          child: new Center(
                              child: new Container(
                            width: 60.0,
                            height: 60.0,
                            child: new PreferredSize(
                              child: new Container(
                                padding: EdgeInsets.all(5.0),
                                child: new ClipOval(
                                  child: new Container(
                                    color: Colors.white,
                                    child: Consumer<LoginUserModel>(
                                      builder: (context, model, _) {
                                        return model.loginUser == null
                                            ? CircularProgressIndicator(strokeWidth: 10.0)
                                            : Image.network(model.loginUser.avatar);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              preferredSize: new Size(60.0, 60.0),
                            ),
                          )),
                        ),
                      ],
                    ),
                    // 内容
                    Consumer<LoginUserModel>(
                      builder: (context, model, _) {
                        return model == null
                            ? Container()
                            : Container(
                                width: double.infinity,
                                color: Color(0xFFF4F5F6),
                                child: Column(
                                  children: _biuldUserProfileListWidget(model.userProfileList),
                                ),
                              );
                      },
                    )
                  ]),
                ),
              ],
            ),
          ],
        ));
  }

  List<Widget> _biuldUserProfileListWidget(items) {
    List<Widget> list = new List();
    for (var i = 0; i < items.length; i++) {
      list.add(
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.all(5.0),
          margin: [1, 4, 6, 8].contains(i) ? EdgeInsets.only(bottom: 5.0) : EdgeInsets.only(bottom: 1.0),
          child: CustomListTile(
            onPressed: () {
              onClickItem(i);
            },
            itemTitle: items[i].title,
            itemIcon: items[i].icon,
            itemDescription: items[i].description,
            isShowEnterIcon: items[i].showEnterIcon,
          ),
        ),
      );
    }

    return list;
  }

}

// 顶部栏裁剪
class TopBarClipper extends CustomClipper<Path> {
  // 宽高
  double width;
  double height;

  TopBarClipper(this.width, this.height);

  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.moveTo(0.0, 0.0);
    path.lineTo(width, 0.0);
    path.lineTo(width, height / 2);
    path.lineTo(0.0, height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
