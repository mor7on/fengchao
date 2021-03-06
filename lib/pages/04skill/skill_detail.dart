import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/04_skill_list_fun.dart';
import 'package:fengchao/common/utils/sp_utils.dart';
import 'package:fengchao/models/article_model.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_toast.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:fengchao/pages/widgets/template/detail_template.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class SkillDetailComponent extends StatefulWidget {
  final Map arguments;

  SkillDetailComponent({Key key, this.arguments}) : super(key: key);

  _SkillDetailComponentState createState() => _SkillDetailComponentState();
}

class _SkillDetailComponentState extends State<SkillDetailComponent> {
  ArticleModel detail;
  bool isPostUser = false;

  @override
  void initState() {
    super.initState();
    initUserData();
  }

  initUserData() async {
    // BotToast.showLoading();
    await Future.delayed(Duration(milliseconds: 600), () async {
      var res = await getSkillById(params: widget.arguments);
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
    var res = await toFavoriteSkill(params: {'id': detail.id});
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
    Navigator.pushNamed(context, '/skillEdit', arguments: {'id': detail.id});
  }

  Future _toDelete() async {
    var res = await deleteSkill(params: {'id': detail.id});
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('内容详情'),
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
            builder: _headerBuilder,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: _skillDetailBuilder(context),
              ),
            ),
          ),
        ],
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
      ];
    }
    return child;
  }
}
