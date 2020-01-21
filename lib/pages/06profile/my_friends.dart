import 'package:fengchao/common/api/06_user_profile_fun.dart';
import 'package:fengchao/models/friend_group.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';

class MyFriendsComponent extends StatefulWidget {
  MyFriendsComponent({Key key}) : super(key: key);

  _MyFriendsComponentState createState() => _MyFriendsComponentState();
}

class _MyFriendsComponentState extends State<MyFriendsComponent> {
  List<FriendGroup> friends;

  @override
  void initState() {
    super.initState();
    initUserData();
  }

  Future initUserData() async {
    var res = await getMyFriendsList();
    if (null != res) {
      friends = res;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('我的好友'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_add),
            iconSize: 20.0,
            onPressed: () {
              Navigator.pushNamed(context, '/myFriendsAdd');
            },
          )
        ],
      ),
      body: friends == null
          ? Container()
          : friends.length > 0
              ? ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  itemCount: friends.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: ExpansionTile(
                        initiallyExpanded: friends[index].name == '我的好友' ? true : false,
                        title: Text(friends[index].name, style: TextStyle(fontSize: 14.0)),
                        children: friends[index].friendList.isEmpty
                            ? [
                                Container(
                                  width: double.infinity,
                                  height: 60.0,
                                  child: Center(
                                    child: Text('该组暂无好友', style: TextStyle(fontSize: 12.0)),
                                  ),
                                )
                              ]
                            : friends[index].friendList.map((v) {
                                return Dismissible(
                                  key: ObjectKey(v),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (DismissDirection direction) {},
                                  confirmDismiss: (DismissDirection dismissDirection) {
                                    print('确认删除？');
                                    return Future.value(false);
                                  },
                                  background: Container(
                                    color: Colors.blueGrey[200],
                                    child: const ListTile(
                                      trailing: Icon(Icons.delete, color: Colors.white, size: 36.0),
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 20.0,
                                      backgroundImage: NetworkImage(v.avatar),
                                    ),
                                    title: Text(v.userNickname),
                                    subtitle: Text(v.signature, overflow: TextOverflow.ellipsis, maxLines: 1),
                                    dense: true,
                                    trailing: Icon(Icons.navigate_next),
                                    onTap: () {
                                      Navigator.pushNamed(context, '/userInfo', arguments: {'id': v.id});
                                    },
                                  ),
                                );
                              }).toList(),
                      ),
                    );
                  },
                )
              : CustomEmptyWidget(),
    );
  }
}
