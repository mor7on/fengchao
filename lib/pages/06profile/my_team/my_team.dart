import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/06_user_profile_fun.dart';
import 'package:fengchao/common/utils/common_utils.dart';
import 'package:fengchao/common/utils/sp_utils.dart';
import 'package:fengchao/models/user_team.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:fengchao/provider/login_user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyTeamComponent extends StatefulWidget {
  MyTeamComponent({Key key, this.arguments}) : super(key: key);
  final Map<String, dynamic> arguments;

  _MyTeamComponentState createState() => _MyTeamComponentState();
}

class _MyTeamComponentState extends State<MyTeamComponent> {
  UserTeam teamInfo;
  @override
  void initState() {
    super.initState();
    initUserData();
    Future.microtask(
      () => Provider.of<LoginUserModel>(context, listen: false).fetchApplyUser(),
    );
  }

  initUserData() async {
    await Future.delayed(Duration(milliseconds: 200), () async {
      if (widget.arguments['id'] != null) {
        var res = await getTeamInfoById(params: {'id': widget.arguments['id']});
        if (null != res) {
          teamInfo = res;
        }
      }
    });
    if (mounted && widget.arguments['id'] != null) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('我的团队'),
        actions: <Widget>[
          widget.arguments['id'] == null
              ? Container()
              : Stack(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.add_alert,
                        color: Colors.black,
                      ),
                      iconSize: 20.0,
                      onPressed: () => Navigator.pushNamed(context, '/teamApplyUser', arguments: widget.arguments),
                    ),
                    Positioned(
                      top: 5.0,
                      right: 10.0,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: 16.0,
                          minHeight: 16.0,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10.0)),
                          child: Consumer<LoginUserModel>(
                            builder: (context, model, _) {
                              return Text(
                                model.applyUser.length.toString(),
                                style: TextStyle(fontSize: 10.0, color: Colors.white),
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                )
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (widget.arguments['id'] == null) {
            return Column(
              children: <Widget>[
                SizedBox(
                  height: 32.0,
                ),
                Container(
                  child: Text('您还没有创建和加入团队'),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text('加入团队'),
                      onPressed: () {
                        Navigator.pushNamed(context, '/skillList');
                      },
                    ),
                    FlatButton(
                      child: Text('创建团队'),
                      onPressed: () {
                        Navigator.pushNamed(context, '/creatTeam');
                      },
                    ),
                  ],
                ),
              ],
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _biuldWithUserTeamHeader(context),
                  UserTeamInfoCard(
                    teamInfo: teamInfo,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _biuldWithUserTeamHeader(BuildContext context) {
    final int loginId = SpUtil.getInt('xxUserId');
    return teamInfo == null
        ? loadWidget
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 70.0,
                  height: 70.0,
                  padding: EdgeInsets.all(8.0),
                  child: teamInfo.imageList == null
                      ? Container()
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(teamInfo.imageList[0], fit: BoxFit.cover)),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(teamInfo.postTitle),
                          SizedBox(width: 10.0),
                          Container(
                            width: 30.0,
                            height: 30.0,
                            child: IconButton(
                              padding: EdgeInsets.all(0.0),
                              icon: Icon(IconData(0xe724, fontFamily: 'iconfont')),
                              iconSize: 20.0,
                              onPressed: () {
                                Navigator.pushNamed(context, '/myTeamQR');
                              },
                            ),
                          ),
                        ],
                      ),
                      Text(teamInfo.createTime, style: TextStyle(fontSize: 10.0)),
                      Text('团队技能：${teamInfo.postKeywords}', style: TextStyle(fontSize: 10.0)),
                      Text('团队申请：${teamInfo.postStatus == 1 ? '开放' : '关闭'}', style: TextStyle(fontSize: 10.0)),
                    ],
                  ),
                ),
                loginId == teamInfo.userId
                    ? Container(
                        width: 47.0,
                        child: FlatButton(
                          child: Icon(Icons.arrow_forward_ios, size: 20.0),
                          onPressed: () {
                            Navigator.pushNamed(context, '/editTeam');
                          },
                        ),
                      )
                    : Container(),
              ],
            ),
          );
  }
}

class UserTeamInfoCard extends StatelessWidget {
  const UserTeamInfoCard({Key key, this.teamInfo}) : super(key: key);
  final UserTeam teamInfo;

  @override
  Widget build(BuildContext context) {
    return teamInfo == null
        ? Container()
        : Container(
            padding: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('${teamInfo.postTitle}', style: TextStyle(fontSize: 16.0)),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.visibility, size: 12.0, color: Colors.blueGrey),
                            Text('${teamInfo.postHits}次浏览', style: TextStyle(fontSize: 12.0, color: Colors.blueGrey)),
                            SizedBox(
                              width: 8.0,
                            ),
                            Icon(Icons.center_focus_strong, size: 12.0, color: Colors.blueGrey),
                            Text('${teamInfo.postFavorites}人收藏',
                                style: TextStyle(fontSize: 12.0, color: Colors.blueGrey)),
                            SizedBox(
                              width: 8.0,
                            ),
                            Icon(Icons.launch, size: 12.0, color: Colors.blueGrey),
                            Text(CommonUtils.dateToPretty(teamInfo.createTime),
                                style: TextStyle(fontSize: 12.0, color: Colors.blueGrey)),
                            SizedBox(
                              width: 8.0,
                            ),
                            Icon(Icons.error_outline, size: 12.0, color: Colors.blueGrey),
                            Text('举报', style: TextStyle(fontSize: 12.0, color: Colors.blueGrey)),
                            SizedBox(
                              width: 8.0,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 4.0),
                  padding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('${teamInfo.postContent}',
                            style: TextStyle(fontSize: 14.0, color: Colors.blueGrey[300])),
                      ),
                      Container(
                        child: Text(
                            '发布地址：${teamInfo.postAddress != null && teamInfo.postAddress != '' ? teamInfo.postAddress : '未输入或见以上内容'}',
                            style: TextStyle(fontSize: 12.0, color: Colors.blueGrey[100])),
                      ),
                      Container(
                        child: Text('团队技能：${teamInfo.postKeywords}',
                            style: TextStyle(fontSize: 12.0, color: Colors.blueGrey[100])),
                      )
                    ],
                  ),
                ),
                teamInfo.teamUsers.isEmpty
                    ? Container()
                    : Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 4.0),
                        padding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
                        child: Column(
                          children: teamInfo.teamUsers.asMap().keys.map((index) {
                            return ListTile(
                              dense: true,
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(teamInfo.teamUsers[index].user.avatar),
                              ),
                              title: Text(teamInfo.teamUsers[index].user.userNickname),
                              subtitle: Text(
                                teamInfo.teamUsers[index].user.signature == '' ||
                                        teamInfo.teamUsers[index].user.signature == null
                                    ? '这个家伙很懒，什么都没有留下'
                                    : teamInfo.teamUsers[index].user.signature,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Container(
                                child: _biuldActionButton(context, index),
                              ),
                            );
                          }).toList(),
                        ),
                      )
              ],
            ),
          );
  }

  Widget _biuldActionButton(context, index) {
    final int loginId = SpUtil.getInt('xxUserId');
    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle = theme.textTheme.subhead.copyWith(color: theme.textTheme.caption.color);
    if (index == 0) {
      if (loginId == teamInfo.userId) {
        return FlatButton(
          child: Text('解散'),
          onPressed: () {
            showDemoDialog<Map<String, dynamic>>(
              context: context,
              child: AlertDialog(
                content: Text(
                  '您确定要解散团队吗？',
                  style: dialogTextStyle,
                ),
                actions: <Widget>[
                  FlatButton(
                    child: const Text('取消'),
                    onPressed: () {
                      Navigator.pop(context, {'action': 'cancle'});
                    },
                  ),
                  FlatButton(
                    child: const Text('确定'),
                    onPressed: () {
                      Navigator.pop(context, {'action': 'disband', 'index': index});
                    },
                  ),
                ],
              ),
            );
          },
        );
      } else {
        return Container();
      }
    } else {
      if (loginId == teamInfo.userId) {
        return FlatButton(
          child: Text('解约'),
          onPressed: () {
            //TODO解约接口
            showDemoDialog<Map<String, dynamic>>(
              context: context,
              child: AlertDialog(
                content: Text(
                  '您确定要和${teamInfo.teamUsers[index].user.userNickname}解约吗？',
                  style: dialogTextStyle,
                ),
                actions: <Widget>[
                  FlatButton(
                    child: const Text('取消'),
                    onPressed: () {
                      Navigator.pop(context, {'action': 'cancle'});
                    },
                  ),
                  FlatButton(
                    child: const Text('确定'),
                    onPressed: () {
                      Navigator.pop(context, {'action': 'break', 'index': index});
                    },
                  ),
                ],
              ),
            );
          },
        );
      } else if (loginId == teamInfo.teamUsers[index].userId) {
        return FlatButton(
          child: Text('退组'),
          onPressed: () {
            //TODO退组接口
            showDemoDialog<Map<String, dynamic>>(
              context: context,
              child: AlertDialog(
                content: Text(
                  '您确定要退出团队${teamInfo.postTitle}吗？',
                  style: dialogTextStyle,
                ),
                actions: <Widget>[
                  FlatButton(
                    child: const Text('取消'),
                    onPressed: () {
                      Navigator.pop(context, {'action': 'cancle'});
                    },
                  ),
                  FlatButton(
                    child: const Text('确定'),
                    onPressed: () {
                      Navigator.pop(context, {'action': 'quit', 'index': index});
                    },
                  ),
                ],
              ),
            );
          },
        );
      } else {
        return Container();
      }
    }
  }

  void showDemoDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) async {
      // The value passed to Navigator.pop() or null.
      if (null != value) {
        Map<String, dynamic> action = value as Map;
        if (action['action'] == 'disband') {
          Provider.of<LoginUserModel>(context).fetchDisbandTeam();
          await Future.delayed(Duration(milliseconds: 300));
          Navigator.pop(context);
        }
        if (action['action'] == 'break') {
          var res = await dismissTeamUser(
              params: {'team_id': teamInfo.id, 'user_id': teamInfo.teamUsers[action['index']].userId});
          if (res['code'] == 1) {
            if (res['data'] == true) {
              teamInfo.teamUsers.removeAt(action['index']);
              BotToast.showText(
                  text: "已将${teamInfo.teamUsers[action['index']].user.userNickname}开除出团队",
                  textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
            }
          } else {
            print(res);
          }
        }
        if (action['action'] == 'quit') {
          var res = await quitUserTeam(params: {'team_id': teamInfo.id});
          if (res['code'] == 1) {
            Provider.of<LoginUserModel>(context).fetchDisbandTeam();
            BotToast.showText(
                text: "已退出团队${teamInfo.postTitle}", textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
            await Future.delayed(Duration(milliseconds: 300));
            Navigator.pop(context);
          } else {
            print(res);
          }
        }
      }
    });
  }
}
