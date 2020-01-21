import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/04_skill_list_fun.dart';
import 'package:fengchao/models/article_model.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:fengchao/pages/widgets/template/detail_template.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class TeamDetailComponent extends StatefulWidget {
  final Map arguments;

  TeamDetailComponent({Key key, this.arguments}) : super(key: key);

  _TeamDetailComponentState createState() => _TeamDetailComponentState();
}

class _TeamDetailComponentState extends State<TeamDetailComponent> {
  ArticleModel detail;

  @override
  void initState() {
    super.initState();
    initUserData();
  }

  initUserData() async {
    print(widget.arguments);
    await Future.delayed(Duration(milliseconds: 600), () async {
      var res = await getTeamInfoById(params: widget.arguments);
      if (null != res) {
        detail = ArticleModel.fromJson(res['data']);
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  void showMenuSelection(String value) {
    switch (value) {
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
    var res = await toFavoriteTeam(params: {'id': detail.id});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('团队详情'),
        centerTitle: true,
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
            ],
          )
        ],
        // bottom: PreferredSize(
        //   preferredSize: Size.fromHeight(60.0),
        //   child: Builder(
        //     builder: _headerBuilder,
        //   ),
        // ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: _skillDetailBuilder(context),
        ),
      ),
    );
  }

  Widget _headerBuilder(BuildContext context) {
    Widget header;
    if (detail == null) {
      header = TempEmptyHeader();
    } else {
      header = TempHeader(
        userInfo: detail.user,
      );
    }
    return header;
  }

  List<Widget> _skillDetailBuilder(BuildContext context) {
    List<Widget> child;
    if (detail == null) {
      child = <Widget>[loadWidget];
    } else {
      child = <Widget>[
        TempSkillBody(
          postInfo: detail,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                padding: EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 16.0),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
                child: Column(
                  children: _biuldWithTeamUser(),
                ),
              ),
              Container(
                decoration: ShapeDecoration(
                    color: kTitleColor,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0)),
                    )),
                padding: EdgeInsets.only(left: 16.0),
                child: Text('团队成员：'),
              ),
            ],
          ),
        )
      ];
    }
    return child;
  }

  List<Widget> _biuldWithTeamUser() {
    return detail.teamUsers.map((item){
      return ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(item.user.avatar),
        ),
        title: Text(item.user.userNickname),
        subtitle: Text(item.user.skill??'暂无设置个人技能'),
        trailing: Icon(Icons.navigate_next),
        dense: true,
        onTap: (){},
      );
    }).toList();
  }
}
