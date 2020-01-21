import 'package:fengchao/common/api/01_index_component_fun.dart';
import 'package:fengchao/common/config/config.dart';
import 'package:fengchao/models/chat_box.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_loading_widget.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class UserChatBoxComponent extends StatefulWidget {
  UserChatBoxComponent({Key key}) : super(key: key);

  @override
  _UserChatBoxComponentState createState() => _UserChatBoxComponentState();
}

class _UserChatBoxComponentState extends State<UserChatBoxComponent> {
  List<List<ChatBox>> _chatBoxList;

  @override
  void initState() {
    super.initState();
    _initUserData();
  }

  void _initUserData() async {
    Map<String, dynamic> res = await getChatBoxInfo();
    if (null != res) {
      _chatBoxList = [];
      List<ChatBox> list = [];
      for (var item in res['data']) {
        if (_chatBoxList.length == 0) {
          list.add(ChatBox.fromJson(item));
          _chatBoxList.add(list);
        }else {
          list = [];
          for (var chat in _chatBoxList) {
            if (chat[0].fromuser.id == item['fromuser']['id']) {
              chat.add(ChatBox.fromJson(item));
              list.add(ChatBox.fromJson(item));
            }
          }
          if (list.length == 0) {
            list.add(ChatBox.fromJson(item));
            _chatBoxList.add(list);
          }
        }
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('聊天信息'),
      ),
      body: _chatBoxList == null
          ? loadWidget
          : _chatBoxList.length == 0
              ? CustomEmptyWidget()
              : ListView.builder(
                  itemCount: _chatBoxList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            onTap: (){
                              Navigator.pushNamed(context, '/chat',arguments: {'id':_chatBoxList[index][0].fromuser.id});
                            },
                            dense: true,
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(_chatBoxList[index][0].fromuser.avatar),
                            ),
                            title: Text(_chatBoxList[index][0].fromuser.userNickname),
                            subtitle: Text('${_chatBoxList[index].length}条未读信息'),
                          ),
                          Divider(),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
