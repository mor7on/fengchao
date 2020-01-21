import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/06_user_profile_fun.dart';
import 'package:fengchao/models/new_friend.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_loading_widget.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class MyNewFriendsComponent extends StatefulWidget {
  MyNewFriendsComponent({Key key}) : super(key: key);

  @override
  _MyNewFriendsComponentState createState() => _MyNewFriendsComponentState();
}

class _MyNewFriendsComponentState extends State<MyNewFriendsComponent> {
  List<NewFriends> _userList;
  @override
  void initState() {
    super.initState();
    initUserData();
  }

//   {
// "code": 1,
// "msg": null,
// "data":[
// {
// "id": 26,
// "user_id": 139,
// "friend":{"id": 3, "user_status": 1, "user_nickname": "大大", "avatar": "public/upload/avatar/191029/small_157235877985226.png",…},
// "state": 0,
// "create_time": "2019-10-03 22:42:46",
// "user":{
  // "id": 139,
  // "user_status": 1,
  // "user_nickname": "user_ehtd5917",
  // "avatar": "",
  // "signature": "",
  // "tasks": 5,
  // "complete_tasks": 3,
  // "rate": 3.5,
  // "publish_tasks": 0,
  // "user_set":{"id": 14, "user_id": 139, "content": "{\"showlocation\":true,\"autoupdate\":true}", "update_time": null,…},
  // "card":{"id": 16, "create_time": "2019-11-08 14:47:15", "user_id": 139, "state": 0,…}
  // },
// "message": "好的，哦厚古薄今紧急集合计"
// }
// ]
// }

  initUserData() async {
    await Future.delayed(Duration(milliseconds: 600), () async {
      Map<String, dynamic> res = await getAskForNewFriend();
      if (null != res) {
        _userList = [];
        for (var item in res['data']) {
          _userList.add(NewFriends.fromJson(item));
        }
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  void _toRefuseFriendApply(index, id) async {
    Map<String, dynamic> res = await toPassFriendApply(params: {'user_id': id, 'type': 2}); // type 1 同意，2 删除
    print(res);
    if (null != res) {
      if (res['data'] == true) {
        BotToast.showText(
            text: '已拒绝好友申请！',
            textStyle: TextStyle(fontSize: 14.0, color: Colors.white),
            duration: Duration(milliseconds: 1000));
        await Future.delayed(Duration(milliseconds: 1000));
        _userList.removeAt(index);
        setState(() {});
      } else {
        print('拒绝好友失败');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('好友申请'),
      ),
      body: Builder(
        builder: (context) {
          if (_userList == null) {
            return loadWidget;
          } else if (_userList.length > 0) {
            return _buildListView();
          } else {
            return CustomEmptyWidget();
          }
        },
      ),
    );
  }

  ListView _buildListView() {
    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: _userList.length,
      itemBuilder: (context, index) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              dense: true,
              leading: CircleAvatar(
                backgroundImage: NetworkImage(_userList[index].user.avatar),
              ),
              title: Text(_userList[index].user.userNickname),
              subtitle: Text(_userList[index].message),
              trailing: Container(
                width: 50.0,
                height: 30.0,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 50.0,
                      child: FlatButton(
                        padding: EdgeInsets.zero,
                        color: Colors.green[100],
                        child: Text('删除'),
                        onPressed: () {
                          _toRefuseFriendApply(index, _userList[index].user.id);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/userInfo', arguments: {
                  'id': _userList[index].user.id,
                  'from': _userList[index].message,
                });
              },
            ),
            Divider(color: Colors.black),
          ],
        );
      },
    );
  }
}
