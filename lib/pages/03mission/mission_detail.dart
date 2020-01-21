import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/03_mission_list_fun.dart';
import 'package:fengchao/common/utils/common_utils.dart';
import 'package:fengchao/common/utils/sp_utils.dart';
import 'package:fengchao/models/article_model.dart';
import 'package:fengchao/models/tender_user.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_toast.dart';
import 'package:fengchao/pages/widgets/likebutton/like_button.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:fengchao/pages/widgets/template/detail_template.dart';
import 'package:fengchao/pages/widgets/tender_screen_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class MissionDetailComponent extends StatefulWidget {
  MissionDetailComponent({Key key, this.arguments}) : super(key: key);
  final Map arguments;
  @override
  _MissionDetailComponentState createState() => _MissionDetailComponentState();
}

class _MissionDetailComponentState extends State<MissionDetailComponent> {
  ArticleModel detail;
  bool isPostUser = false;

  @override
  void initState() {
    super.initState();
    initUserData();
  }

  initUserData() async {
    // BotToast.showLoading();
    await Future.delayed(Duration(milliseconds: 200), () async {
      var res = await getMissionById(params: widget.arguments);
      if (null != res) {
        detail = ArticleModel.fromJson(res['data']);
        int loginId = SpUtil.getInt('xxUserId');
        if (loginId == detail.user.id) {
          isPostUser = true;
        }
      }
    });
    if (mounted) {
      setState(() {});
    }
    // BotToast.closeAllLoading();
  }

  void showMenuSelection(String value) {
    switch (value) {
      case 'Edit':
        _navigateToEdit();
        break;
      case 'Delete':
        _toDelete();
        break;
      case 'Favorite':
        _toFavorite();
        break;
      case 'Share':
        _showShareSheet(
          context: context,
          child: CupertinoActionSheet(
            title: const Text('分享'),
            message: const Text('您要分享到哪里？'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  '微信会话',
                  style: TextStyle(fontSize: 16.0),
                ),
                onPressed: () {
                  Navigator.pop(context, 'SESSION');
                },
              ),
              CupertinoActionSheetAction(
                child: const Text(
                  '微信朋友圈',
                  style: TextStyle(fontSize: 16.0),
                ),
                onPressed: () {
                  Navigator.pop(context, 'TIMELINE');
                },
              ),
              CupertinoActionSheetAction(
                child: const Text(
                  '微信收藏',
                  style: TextStyle(fontSize: 16.0),
                ),
                onPressed: () {
                  Navigator.pop(context, 'FAVORITE');
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text(
                '取消',
                style: TextStyle(fontSize: 16.0),
              ),
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
            ),
          ),
        );
        break;
      default:
    }
  }

  void _showShareSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String value) {
      if (value == 'SESSION') {
        var share = fluwx.WeChatShareTextModel(
            text: detail.postContent,
            transaction: "text${DateTime.now().millisecondsSinceEpoch}",
            scene: fluwx.WeChatScene.SESSION);
        _shareText(share);
      }
      if (value == 'TIMELINE') {
        var share = fluwx.WeChatShareTextModel(
            text: detail.postContent,
            transaction: "text${DateTime.now().millisecondsSinceEpoch}",
            scene: fluwx.WeChatScene.TIMELINE);
        _shareText(share);
      }
      if (value == 'FAVORITE') {
        var share = fluwx.WeChatShareTextModel(
            text: detail.postContent,
            transaction: "text${DateTime.now().millisecondsSinceEpoch}",
            scene: fluwx.WeChatScene.FAVORITE);
        _shareText(share);
      }
    });
  }

  void _shareText(fluwx.WeChatShareModel model) {
    fluwx.shareToWeChat(model).then((data) {
      print(data);
    });
  }

  Future _toFavorite() async {
    var res = await toFavoriteMission(params: {'id': detail.id});
    print(res);
    if (null != res) {
      if (res['data'] == 1) {
        BotToast.showText(text: '收藏成功', textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
        detail.postFavorites += 1;
      } else {
        BotToast.showText(text: '重复收藏', textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
      }
      setState(() {});
    }
  }

  Future _navigateToEdit() async {
    Navigator.pushNamed(context, '/missionEdit', arguments: {'detail': detail}).then((isRefresh) {
      if (isRefresh == true) {
        initUserData();
      }
    });
  }

  Future _toDelete() async {
    var res = await deleteMission(params: {'id': detail.id});
    if (null != res) {
      if (res['data'] == true) {
        BotToast.showCustomLoading(
          duration: Duration(milliseconds: 2000),
          toastBuilder: (cancelFunc) {
            return CustomToastWidget(title: '删除成功', icon: Icons.done);
          },
        );
        await Future.delayed(Duration(milliseconds: 2000));
        Navigator.of(context).pop(true);
      } else {
        print('删除失败');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('重建任务详情页面');
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(FlutterI18n.translate(context, "missionDetail")),
        actions: <Widget>[
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.more_vert),
            offset: Offset(20.0, 100.0),
            color: Colors.black54,
            onSelected: showMenuSelection,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Favorite',
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.favorite, color: Colors.white, size: 20.0),
                  title: Text('收藏', style: TextStyle(color: Colors.white)),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Share',
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.share, color: Colors.white, size: 20.0),
                  title: Text('分享', style: TextStyle(color: Colors.white)),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Send',
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.send, color: Colors.white, size: 20.0),
                  title: Text('推送', style: TextStyle(color: Colors.white)),
                ),
              ),
              isPostUser
                  ? const PopupMenuItem<String>(
                      value: 'Edit',
                      child: ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.edit, color: Colors.white, size: 20.0),
                        title: Text('编辑', style: TextStyle(color: Colors.white)),
                      ),
                    )
                  : null,
              isPostUser
                  ? const PopupMenuItem<String>(
                      value: 'Delete',
                      child: ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.delete, color: Colors.white, size: 20.0),
                        title: Text('删除', style: TextStyle(color: Colors.white)),
                      ),
                    )
                  : null,
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Builder(
            builder: (BuildContext context) {
              if (detail != null) {
                return TempHeader(
                  userInfo: detail.user,
                );
              } else {
                return TempEmptyHeader();
              }
            },
          ),
        ),
      ),
      body: Builder(
        builder: (BuildContext context) {
          if (detail != null) {
            return Stack(
              children: <Widget>[
                LayoutBuilder(
                  builder: (c, b) => TempMissionBody(postInfo: detail),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ExpandBottomSheet(postInfo: detail),
                )
                // Align(child: ExpandBottomSheet(postInfo: snapshot.data), alignment: Alignment.bottomRight),
              ],
            );
          } else {
            return loadWidget;
          }
        },
      ),
    );
  }
}

class ExpandBottomSheet extends StatefulWidget {
  ExpandBottomSheet({Key key, this.postInfo}) : super(key: key);
  final ArticleModel postInfo;
  // 明标0；暗标1
  // final int type;
  // 用户任务状态，0未报名，1已报名，2同意，3不同意
  // final int userState;

  _ExpandBottomSheetState createState() => _ExpandBottomSheetState();
}

class _ExpandBottomSheetState extends State<ExpandBottomSheet> {
  // 明标0；暗标1
  int missionType;
  // owner0；visitor1
  int visitorType;
  // 用户任务状态，null未报名，userState['user_state'] = 0已报名，1已同意，2不同意
  int userState = -1;
  // 报名用户列表
  List<TenderUser> tenderUser;
  // 显示报名用户列表
  bool showUserList = false;
  //  当前用户ID
  int userId = SpUtil.getInt('xxUserId');

  LikeButtonController _myLikeButtonController;

  @override
  void initState() {
    super.initState();
    _myLikeButtonController = LikeButtonController();
    missionType = widget.postInfo.type;
    visitorType = widget.postInfo.user.id == userId ? 0 : 1;
    initUserData();
  }

  void initUserData() async {
    await Future.delayed(Duration(milliseconds: 200), () async {
      List<TenderUser> res = await getMissionTenderUserList(params: {'id': widget.postInfo.id});
      if (null != res) {
        print(res);
        List<int> tenderUserIds = [];

        for (var i = 0; i < res.length; i++) {
          tenderUserIds.add(res[i].userId);
        }
        tenderUser = res;
        if (visitorType == 1) {
          userState = tenderUserIds.contains(userId) ? res.firstWhere((item) => item.userId == userId).userState : null;
        }
      }
    });

    if (mounted) {
      setState(() {});
    }
  }

  void _refreshTenderUser() async {
    await Future.delayed(Duration(milliseconds: 200), () async {
      List<TenderUser> res = await getMissionTenderUserList(params: {'id': widget.postInfo.id});
      if (null != res) {
        print(res);
        tenderUser = res;
      }
    });
    setState(() {});
  }

  void showDemoDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {
      // The value passed to Navigator.pop() or null.
      if (value == 'confirm') {
        // userState = null;
        // // _myLikeButtonController.callLoad();
        // setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Stack(
        overflow: Overflow.visible,
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          showUserList
              ? MissionUserList(
                  missionInfo: widget.postInfo,
                  userList: tenderUser,
                  type: visitorType,
                  missionType: missionType,
                  refresh: _refreshTenderUser,
                )
              : Container(),
          Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 50.0,
                color: Colors.red[900],
              ),
              Expanded(
                child: Container(
                  height: 50.0,
                  color: Colors.blueGrey,
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: visitorType == 1 ? _biuldVisitorWidget(context) : _buildOwnerWidget(context),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            child: LikeButton(
              width: 80.0,
              likeBttonController: _myLikeButtonController,
              duration: Duration(milliseconds: 1000),
              icon: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 2.0, color: Colors.white),
                  image: DecorationImage(image: AssetImage('assets/images/avatar.png'), fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerWidget(c) {
    return Row(
      children: <Widget>[
        Expanded(
          child: FlatButton(
            color: Colors.amber,
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
            ),
            child: Text('查看报名列表'),
            onPressed: () {
              showUserList = !showUserList;
              setState(() {});
            },
          ),
        )
      ],
    );
  }

  Widget _biuldVisitorWidget(context) {
    if (userState == -1) {
      return Container();
    } else if (userState == null) {
      return _beforeTenderBiuld(context);
    } else if (userState == 0) {
      return _afterTenderBiuld(context);
    } else if (userState == 1) {
      return _alreadyTenderBiuld(context);
    } else {
      return _refusedTenderBiuld(context);
    }
  }

  Widget _beforeTenderBiuld(context) {
    final bool isLock = CommonUtils.toCompareExpiredTime(widget.postInfo.expiredTime);
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            child: FlatButton(
              child: Text('状态：未报名'),
              onPressed: null,
            ),
          ),
        ),
        FlatButton(
          color: Colors.amber,
          child: isLock ? Icon(Icons.lock) : Text('报名'),
          shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
          ),
          onPressed: isLock ? null : missionType == 0 ? _showBMDialog : _showTBDialog,
        )
      ],
    );
  }

  Future _todoBMfun() async {
    var res = await todoBMfunById(params: {'id': widget.postInfo.id});
    if (null != res) {
      if (res['data'] == true) {
        _myLikeButtonController.callLoad();
        BotToast.showText(text: '报名成功', textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
        userState = 0;
        setState(() {});
      } else {
        print('报名失败');
      }
    }
  }

  void _toCancleTender() async {
    var res = await toCancleTenderById(params: {'task_id': widget.postInfo.id});
    if (null != res) {
      if (res['data'] == true) {
        _myLikeButtonController.reset();
        BotToast.showText(text: '取消报名', textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
        userState = null;
        setState(() {});
      } else {
        print('取消报名失败');
      }
    }
  }

  Future _todoTBfun(double charge) async {
    // TODO投标接口
    BotToast.showLoading(duration: Duration(milliseconds: 300));
    var res = await todoTBfunById(params: {'task_id': widget.postInfo.id, 'coin': charge.toStringAsFixed(2)});
    await Future.delayed(Duration(milliseconds: 300));
    userState = 0;
    _myLikeButtonController.callLoad();
    setState(() {});
  }

  void _showTBDialog() {
    // 调出投标输入框
    Navigator.push(
      context,
      PageRouteBuilder<double>(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) => TenderScreenDialog(),
      ),
    ).then((val) {
      if (val != null) {
        _todoTBfun(val);
      }
    });
  }

  void _showBMDialog() {
    showDialog(
        context: context,
        builder: (BuildContext content) {
          return AlertDialog(
            content: Text('是否确定报名任务：${widget.postInfo.postTitle}？'),
            actions: <Widget>[
              FlatButton(
                child: const Text('取消'),
                onPressed: () {
                  Navigator.pop(context, 'cancle');
                },
              ),
              FlatButton(
                child: const Text('确认'),
                onPressed: () {
                  Navigator.pop(context, 'confirm');
                  _todoBMfun();
                },
              ),
            ],
          );
        });
  }

  Widget _afterTenderBiuld(context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            child: FlatButton(
              textColor: Colors.white,
              child: Text('状态：已报名'),
              onPressed: () {
                showUserList = !showUserList;
                setState(() {});
              },
            ),
          ),
        ),
        FlatButton(
          color: Colors.blueGrey[200],
          child: Text('取消'),
          shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
          ),
          onPressed: () {
            showDemoDialog<String>(
              context: context,
              child: AlertDialog(
                content: Text(
                  '您确定要取消报名吗？',
                ),
                actions: <Widget>[
                  FlatButton(
                    child: const Text('取消'),
                    onPressed: () {
                      Navigator.pop(context, 'cancle');
                    },
                  ),
                  FlatButton(
                    child: const Text('确认'),
                    onPressed: () {
                      Navigator.pop(context, 'confirm');
                      _toCancleTender();
                    },
                  ),
                ],
              ),
            );
          },
        )
      ],
    );
  }

  Widget _alreadyTenderBiuld(context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            child: FlatButton(
              textColor: Colors.amber,
              child: Text('状态：已中标'),
              onPressed: () {
                showUserList = !showUserList;
                setState(() {});
              },
            ),
          ),
        ),
        FlatButton(
          color: Colors.amber,
          shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
          ),
          child: Icon(Icons.navigate_next),
          onPressed: () {
            Navigator.pushNamed(context, '/missionOperations', arguments: {
              'task_id': widget.postInfo.id,
              'user_id': userId,
              'pu_id': widget.postInfo.user.id,
              'missionInfo': widget.postInfo,
            });
          },
        )
      ],
    );
  }

  Widget _refusedTenderBiuld(context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: FlatButton(
            disabledColor: Colors.blueGrey[300],
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
            ),
            child: Text('状态：未中标'),
            onPressed: null,
          ),
        ),
      ],
    );
  }
}

class MissionUserList extends StatelessWidget {
  final List<TenderUser> userList;
  final int type; // 0,发起人，1，报名人
  final int missionType; //0明标，1暗标
  final ArticleModel missionInfo;
  final VoidCallback refresh;
  MissionUserList({Key key, this.userList, this.type, this.missionType, this.missionInfo, this.refresh})
      : super(key: key);

  void showDemoDialog<T>({BuildContext context, Widget child, TenderUser user}) {
    showCupertinoDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((T value) async {
      // The value passed to Navigator.pop() or null.
      if (value == 'agree') {
        print('同意');
        var res = await toAgreeUserWinMissionById(params: {'user_id': user.userId, 'task_id': user.taskId});
        // {code: 1, msg: null, data: true}
        print(res);
        if (null != res) {
          if (res['data'] == true) {
            refresh();
          }
        }
      }
      if (value == 'refuse') {
        print('拒绝');
        var res = await toRefuseUserWinMissionById(params: {'user_id': user.userId, 'task_id': user.taskId});
        // {code: 1, msg: null, data: true}
        print(res);
        if (null != res) {
          if (res['data'] == true) {
            await Future.delayed(Duration(milliseconds: 1000));
            refresh();
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black38,
        ),
        Container(
          width: double.infinity,
          height: 360.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _biuldWithUserList(context, userList),
          ),
        ),
      ],
    );
  }

  List<Widget> _biuldWithUserList(BuildContext context, List<TenderUser> userList) {
    List<Widget> childList = [];
    Offset tapOffset;
    if (userList.length > 0) {
      if (type == 0) {
        childList.addAll([
          Container(
            alignment: Alignment.centerLeft,
            width: double.infinity,
            height: 40.0,
            child: Text('已报名 ${userList.length}人', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          Container(
            width: double.infinity,
            height: 30.0,
            child: Text('长按投标人员头像可查看人员信息或发起临时会话', style: TextStyle(fontSize: 12.0, color: Colors.blueGrey[300])),
          )
        ]);

        List<Widget> list = userList.map((user) {
          return Card(
            elevation: 0.0,
            shape: Border(bottom: BorderSide()),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onLongPressStart: (LongPressStartDetails detail) {
                      tapOffset = detail.globalPosition;
                    },
                    onLongPress: () {
                      showPopMenu(context, tapOffset, user.userId);
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 40.0,
                          height: 40.0,
                          padding: EdgeInsets.all(5.0),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(user.avatar),
                          ),
                        ),
                        SizedBox(width: 5.0),
                        Container(
                          height: 40.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('${user.userNickname}', style: TextStyle(fontSize: 14.0)),
                              Text(
                                missionType == 0 ? '任务佣金：¥${missionInfo.postSalary}' : '投标金额：¥${user.coin}',
                                style: TextStyle(fontSize: 12.0, color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                user.userState == 0
                    ? Container(
                        child: Row(
                        children: <Widget>[
                          Container(
                            width: 60.0,
                            child: FlatButton(
                              padding: EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text('同意'),
                              onPressed: () {
                                showDemoDialog<String>(
                                  user: user,
                                  context: context,
                                  child: CupertinoAlertDialog(
                                    title: Text(
                                      '您确定同意\n${user.userNickname}\n中标吗？',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    content: Text(
                                      '明标任务可以同意多人接取任务，暗标只能同意一人接取任务，请谨慎选择任务接取人。',
                                    ),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        child: const Text('取消'),
                                        onPressed: () {
                                          Navigator.pop(context, 'cancle');
                                        },
                                      ),
                                      CupertinoDialogAction(
                                        child: const Text('确认'),
                                        onPressed: () {
                                          Navigator.pop(context, 'agree');
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            width: 60.0,
                            child: FlatButton(
                              padding: EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text('拒绝'),
                              onPressed: () {
                                showDemoDialog<String>(
                                  user: user,
                                  context: context,
                                  child: CupertinoAlertDialog(
                                    title: Text(
                                      '您确定拒绝\n${user.userNickname}\n中标吗？',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    content: Text(
                                      '拒绝后，该用户将无法再次接取本次任务，请谨慎选择。',
                                    ),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        child: const Text('取消'),
                                        onPressed: () {
                                          Navigator.pop(context, 'cancle');
                                        },
                                      ),
                                      CupertinoDialogAction(
                                        child: const Text('确认'),
                                        onPressed: () {
                                          Navigator.pop(context, 'refuse');
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ))
                    : user.userState == 1
                        ? FlatButton(
                            child: Icon(Icons.navigate_next),
                            onPressed: () {
                              Navigator.pushNamed(context, '/missionOperations', arguments: {
                                'task_id': user.taskId,
                                'user_id': user.userId,
                                'pu_id': missionInfo.user.id,
                                'missionInfo': missionInfo,
                              });
                            },
                          )
                        : FlatButton(child: Text('已拒绝'), onPressed: null),
              ],
            ),
          );
        }).toList();
        childList.add(
          Container(
            height: 220.0,
            child: Scrollbar(
              child: ListView(
                children: list,
              ),
            ),
          ),
        );
      } else {
        childList.addAll([
          Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              height: 40.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('已报名 ${userList.length}人', style: TextStyle(fontWeight: FontWeight.w600)),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                      decoration: BoxDecoration(border: Border.all(color: Colors.amber)),
                      child: Text(
                        '与发布者沟通',
                        style: TextStyle(fontSize: 10.0, color: Colors.amber),
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/chat', arguments: {'id': missionInfo.user.id});
                    },
                  )
                ],
              )),
        ]);
        List<Widget> list = userList.map((user) {
          return Container(
            width: 40.0,
            height: 40.0,
            padding: EdgeInsets.all(5.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/head_knoyo.jpg'),
            ),
          );
        }).toList();
        childList.add(
          Wrap(
            spacing: 5.0,
            children: list,
          ),
        );
      }
    } else {
      childList.addAll([
        Container(
          alignment: Alignment.centerLeft,
          width: double.infinity,
          height: 40.0,
          child: Text('已报名 ${userList.length}人', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ]);
    }
    return childList;
  }

  CancelFunc showPopMenu(BuildContext context, Offset target, int userId) {
    return BotToast.showAttachedWidget(
      target: target,
      // targetContext: context,
      verticalOffset: 0.0,
      horizontalOffset: 0.0,
      allowClick: true,
      attachedBuilder: (cancel) => Card(
        color: Colors.amber,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FlatButton.icon(
                padding: EdgeInsets.all(5),
                onPressed: () {
                  Navigator.pushNamed(context, '/userInfo', arguments: {'id': userId});
                },
                label: Text("资料"),
                icon: Icon(Icons.account_box, color: Colors.redAccent[100]),
              ),
              FlatButton.icon(
                padding: EdgeInsets.all(5),
                onPressed: () {
                  Navigator.pushNamed(context, '/chat', arguments: {'id': userId});
                },
                label: Text("会话"),
                icon: Icon(Icons.forum, color: Colors.redAccent[100]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
