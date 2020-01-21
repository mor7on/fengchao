import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/06_user_profile_fun.dart';
import 'package:fengchao/models/user_entity.dart';
import 'package:fengchao/models/user_team.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_toast.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class UserInfoComponent extends StatefulWidget {
  UserInfoComponent({Key key, this.arguments}) : super(key: key);

  final Map<String, dynamic> arguments;

  @override
  _UserInfoComponentState createState() => _UserInfoComponentState();
}

class _UserInfoComponentState extends State<UserInfoComponent> {
  TextEditingController _textEditingController;
  User _user;
  UserTeam _userTeam;

  @override
  void initState() {
    super.initState();
    initUserData();
    _textEditingController = TextEditingController();
    _textEditingController.addListener(() {
      setState(() {});
    });
  }

  void initUserData() async {
    Map<String, dynamic> res = await getUserInfoById(params: widget.arguments);
    Map<String, dynamic> team = await getTeamByUserId(params: {'user_id': widget.arguments['id']});
    print(team);
    if (null != res) {
      _user = User.fromJson(res['data']);
    }
    if (null != team) {
      if (team['data'] != null) {
        _userTeam = UserTeam.fromJson(team['data']);
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _toAskForNewFriends() async {
    Map<String, dynamic> res =
        await toApplyForFriend(params: {'friend_id': _user.id, 'message': _textEditingController.text});
    print(res);
    // {code: 1, msg: null, data: false}
    if (null != res) {
      if (res['data'] == true) {
        BotToast.showText(
            text: '已发出好友申请！',
            textStyle: TextStyle(fontSize: 14.0, color: Colors.white),
            duration: Duration(milliseconds: 1000));
        await Future.delayed(Duration(milliseconds: 1000));
        Navigator.pop(context);
      } else {
        print('好友申请失败');
      }
    }
  }

  void _toPassFriendApply() async {
    Map<String, dynamic> res = await toPassFriendApply(params: {'user_id': _user.id, 'type': 1}); // type 1 同意，2 删除
    print(res);
    if (null != res) {
      if (res['data'] == true) {
        BotToast.showCustomLoading(
          duration: Duration(milliseconds: 1000),
          toastBuilder: (cancelFunc) {
            return CustomToastWidget(title: '已加为好友', icon: Icons.done);
          },
        );
        await Future.delayed(Duration(milliseconds: 1000));
        Navigator.pop(context);
      }else {
        print('添加好友失败');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text('用户信息'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(8.0),
                child: Builder(
                  builder: (context) {
                    if (_user == null) {
                      return loadWidget;
                    } else {
                      return _buildWithUserInfo(context);
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWithUserInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    child: Image.network(
                      _user.avatar,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_user.userNickname),
                  Text(
                    '任务(已接/已发/完成)：${_user.tasks}/${_user.publishTasks}/${_user.completeTasks}',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                  RatingBarIndicator(
                    itemSize: 16.0,
                    rating: 3.7,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    // itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                  ),
                  Text(
                    '技能：${_user.skill??'暂无技能描述'}',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '个人简介',
                style: TextStyle(fontSize: 14.0),
              ),
              Container(
                child: Text(
                  _user.introduction??'暂无个人简介',
                  style: TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Container(
          width: double.infinity,
          // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
          child: ListTile(
            title: Text(
              'Ta的动态',
              style: TextStyle(fontSize: 15.0),
            ),
            trailing: Container(
              width: 160.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(''),
                  Icon(Icons.navigate_next),
                ],
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/userShareList', arguments: {'id': _user.id});
            },
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Container(
          width: double.infinity,
          // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
          child: ListTile(
            title: Text(
              'Ta的团队',
              style: TextStyle(fontSize: 15.0),
            ),
            trailing: Container(
              width: 160.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(_userTeam == null ? '暂无团队' : _userTeam.postTitle),
                  Icon(Icons.navigate_next),
                ],
              ),
            ),
            // dense: true,
            onTap: () {},
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        _biuldSubmitContent()
      ],
    );
  }

  Widget _biuldSubmitContent() {
    if (_user.isfriend == 1) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: RaisedButton(
          elevation: 0.0,
          color: Colors.blue[300],
          onPressed: () {
            Navigator.pushNamed(context, '/chat',arguments: {'id':_user.id});
          },
          child: Text('和他(她)聊天'),
        ),
      );
    }
    if (widget.arguments['from'] == null) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
              child: TextFormField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: '申请好友留言（例如：我是你朋友，或者我想要接你的任务...）',
                  labelText: '输入留言信息',
                  isDense: true,
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                maxLength: 500,
                style: TextStyle(fontSize: 14.0, height: 1.5, textBaseline: TextBaseline.alphabetic),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: RaisedButton(
                elevation: 0.0,
                textColor: _textEditingController.text.isEmpty ? Colors.black : Colors.white,
                color: _textEditingController.text.isEmpty ? Colors.grey.withOpacity(0.5) : Colors.green,
                onPressed: () {
                  if (_textEditingController.text.isNotEmpty) {
                    _toAskForNewFriends();
                  }
                },
                child: Text('申请好友'),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 8.0,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.amber[50], borderRadius: BorderRadius.circular(5.0)),
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '留言信息',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  Container(
                    child: Text(
                      widget.arguments['from'],
                      style: TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Container(
              width: double.infinity,
              child: RaisedButton(
                elevation: 0.0,
                color: Colors.blue[300],
                onPressed: () {
                  _toPassFriendApply();
                },
                child: Text('通过验证'),
              ),
            ),
          ],
        ),
      );
    }
  }
}
