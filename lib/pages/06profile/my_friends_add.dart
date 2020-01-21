import 'package:fengchao/common/api/06_user_profile_fun.dart';
import 'package:fengchao/models/user_entity.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class MyFriendsAddComponent extends StatefulWidget {
  MyFriendsAddComponent({Key key}) : super(key: key);

  @override
  _MyFriendsAddComponentState createState() => _MyFriendsAddComponentState();
}

class _MyFriendsAddComponentState extends State<MyFriendsAddComponent> {
  TextEditingController _textEditingController;
  List<User> _kUsers;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _textEditingController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  void _getUserByNickName() async {
    print(_textEditingController.text);
    Map<String, dynamic> res = await getUserByNickName(params: {'name': _textEditingController.text});
    print(res);
    if (null != res) {
      _kUsers = [];
      for (var item in res['data']) {
        _kUsers.add(User.fromJson(item));
      }
      _textEditingController.text = '';
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('添加好友'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: TextFormField(
                    controller: _textEditingController,
                    keyboardType: TextInputType.text,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: '用户昵称',
                      hintText: '用户昵称(不能为空)',
                      isDense: true,
                      alignLabelWithHint: true,
                    ),
                    maxLines: 1,
                    style: TextStyle(fontSize: 14.0, height: 1.5, textBaseline: TextBaseline.alphabetic),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                InkWell(
                  onTap: () {
                    if (_textEditingController.text.isNotEmpty) {
                      _getUserByNickName();
                    }
                  },
                  child: Container(
                    height: 30.0,
                    width: 60.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _textEditingController.text.isEmpty ? Colors.grey : Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(
                        4.0,
                      )),
                    ),
                    child: Icon(Icons.search),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: _kUsers == null
                  ? Container()
                  : ListView.builder(
                    padding: EdgeInsets.all(16.0),
                      itemCount: _kUsers.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(_kUsers[index].avatar),
                          ),
                          title: Text(_kUsers[index].userNickname),
                          subtitle: Text(
                            _kUsers[index].signature,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Icon(Icons.navigate_next),
                          dense: true,
                          onTap: () {
                            Navigator.pushNamed(context, '/userInfo',arguments: {'id': _kUsers[index].id});
                          },
                        );
                      },
                    ),
            ),
        ],
      ),
    );
  }
}
