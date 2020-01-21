import 'dart:async';
import 'dart:convert';

import 'package:fengchao/common/api/06_user_profile_fun.dart';
import 'package:fengchao/common/config/config.dart';
import 'package:fengchao/common/utils/common_utils.dart';
import 'package:fengchao/common/utils/sp_utils.dart';
import 'package:fengchao/models/user_entity.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/provider/login_user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

/// 聊天界面示例
class ChatComponent extends StatefulWidget {
  final Map<String, dynamic> arguments;

  const ChatComponent({Key key, this.arguments}) : super(key: key);

  @override
  ChatComponentState createState() {
    return ChatComponentState();
  }
}

class ChatComponentState extends State<ChatComponent> {
  // 信息列表
  List<MessageModel> _msgList;

  // 输入框
  TextEditingController _textEditingController;
  // 滚动控制器
  ScrollController _scrollController;

  IOWebSocketChannel channel;

  User _toUser;

  int _loginUserid = SpUtil.getInt('xxUserId');
  String _token = SpUtil.getString('xxToken');

  @override
  void initState() {
    super.initState();
    _openWebSocketConnect();
    _msgList = [
      MessageModel(own: false, message: '可以开始聊天了'),
    ];
    _textEditingController = TextEditingController();
    _textEditingController.addListener(() {
      setState(() {});
    });
    _scrollController = ScrollController();

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        print(visible);
        if (visible) {
          _moveTobottom();
        }
      },
    );
  }

  Future _openWebSocketConnect() async {
    channel = IOWebSocketChannel.connect(CONFIG.WEBSOCKET_SERVER);

    Map<String, dynamic> res = await getUserInfoById(params: widget.arguments);
    if (null != res) {
      _toUser = User.fromJson(res['data']);
    }
    var data = {
      "fromuserid": _loginUserid,
      "touserid": widget.arguments['id'],
      "XX-Token": _token,
      "XX-Device-Type": "mobile"
    };
    channel.sink.add(jsonEncode(data));

    channel.stream.listen((value) {
      List msgList = jsonDecode(value)['data'];
      msgList.forEach((v) {
        _msgList.add(MessageModel.fromJson(v));
      });
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _scrollController.dispose();
    channel.sink.close(status.goingAway);
  }

  Future _moveTobottom() async {
    await Future.delayed(Duration(milliseconds: 300));
    if (_scrollController.positions.isNotEmpty) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  // 发送消息
  void _sendMsg(String msg) {
    var data = {
      "fromuserid": _loginUserid,
      "touserid": widget.arguments['id'],
      "message": msg,
      "isimg": false,
      "url": null,
    };
    channel.sink.add(jsonEncode(data));
    setState(() {
      _msgList.add(MessageModel(own: true, message: msg));
      _textEditingController.text = '';
    });
    _moveTobottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('临时聊天'),
        backgroundColor: Colors.grey[200],
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: <Widget>[
          Divider(
            height: 0.5,
          ),
          Expanded(
            child: CustomScrollView(
              reverse: false,
              controller: _scrollController,
              // physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _toUser == null ? Container() : _buildMsg(_msgList[index]);
                    },
                    childCount: _msgList.length,
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey[100],
            padding: EdgeInsets.only(
              left: 15.0,
              right: 15.0,
              top: 8.0,
              bottom: 8.0,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 5.0,
                      right: 5.0,
                      top: 5.0,
                      bottom: 5.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(
                        4.0,
                      )),
                    ),
                    child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                          top: 2.0,
                          bottom: 2.0,
                        ),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        if (_textEditingController.text.isNotEmpty) {
                          _sendMsg(_textEditingController.text);
                        }
                      },
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (_textEditingController.text.isNotEmpty) {
                      _sendMsg(_textEditingController.text);
                      _textEditingController.text = '';
                    }
                  },
                  child: Container(
                    height: 30.0,
                    width: 60.0,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      left: 15.0,
                    ),
                    decoration: BoxDecoration(
                      color: _textEditingController.text.isEmpty ? Colors.grey : Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(
                        4.0,
                      )),
                    ),
                    child: Text(
                      FlutterI18n.translate(context, 'send'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建消息视图
  Widget _buildMsg(MessageModel entity) {
    if (entity == null || entity.own == null) {
      return Container();
    }
    if (entity.own) {
      return Container(
        margin: EdgeInsets.all(
          10.0,
        ),
        child: Consumer<LoginUserModel>(
          builder: (context, model, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      model.loginUser.userNickname,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13.0,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 5.0,
                      ),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.lightGreen[300],
                        borderRadius: BorderRadius.all(Radius.circular(
                          4.0,
                        )),
                      ),
                      constraints: BoxConstraints(
                        maxWidth: 240.0,
                      ),
                      child: Text(
                        entity.message ?? '',
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    )
                  ],
                ),
                Card(
                  margin: EdgeInsets.only(
                    left: 10.0,
                  ),
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  elevation: 0.0,
                  child: Container(
                    height: 40.0,
                    width: 40.0,
                    child: Image.network(model.loginUser.avatar),
                  ),
                ),
              ],
            );
          },
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.all(
          10.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              margin: EdgeInsets.only(
                right: 10.0,
              ),
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              elevation: 0.0,
              child: Container(
                height: 40.0,
                width: 40.0,
                child: Image.network(_toUser.avatar),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _toUser.userNickname,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13.0,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 5.0,
                  ),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(
                      4.0,
                    )),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: 240.0,
                  ),
                  child: Text(
                    entity.message ?? '',
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }
  }
}

/// 信息实体
class MessageModel {
  bool own;
  String message;
  String createTime;
  int fromId;
  int toUserId;
  bool isImg;
  String url;

  MessageModel({this.own, this.message, this.fromId, this.toUserId, this.isImg, this.url, this.createTime});

  MessageModel.fromJson(Map<String, dynamic> json) {
    own = false;
    fromId = json['fromuser'];
    message = json['message'];
    toUserId = json['touser_id'];
    createTime = CommonUtils.timeToString(DateTime.fromMillisecondsSinceEpoch(json['create_time']));
    isImg = json['isimg'] == 1 ? true : false;
    url = json['url'] == null ? null : CONFIG.BASE_URL + json['url'];
  }
}
