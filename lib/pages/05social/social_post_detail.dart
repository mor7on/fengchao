import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/05_social_list_fun.dart';
import 'package:fengchao/common/utils/common_utils.dart';
import 'package:fengchao/common/utils/sp_utils.dart';
import 'package:fengchao/models/article_model.dart';
import 'package:fengchao/models/user_entity.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_toast.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:fengchao/pages/widgets/reply_screen_dialog.dart';
import 'package:fengchao/pages/widgets/template/comments_widget.dart';
import 'package:fengchao/pages/widgets/template/detail_template.dart';
import 'package:fengchao/provider/login_user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class ArticleDetailComponent extends StatefulWidget {
  final Map arguments;

  ArticleDetailComponent({Key key, this.arguments}) : super(key: key);

  _ArticleDetailComponentState createState() => _ArticleDetailComponentState();
}

class _ArticleDetailComponentState extends State<ArticleDetailComponent> {
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
      var res = await getArticleById(params: widget.arguments);
      if (null != res) {
        detail = ArticleModel.fromJson(res['data']);
        _comments = detail.leaves;
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
    var res = await doArticleFavorate(params: {'id': detail.id});
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
    Navigator.pushNamed(context, '/socialPostEdit', arguments: {'detail': detail}).then((isRefresh) {
      if (isRefresh == true) {
        initUserData();
      }
    });
    // await Navigator.pushNamed(context, '/companyEdit',arguments: detail).then((isRefresh){
    //   if (isRefresh) {
    //     initUserData();
    //   }
    // });
  }

  Future _toDelete() async {
    var res = await delArticleById(params: {'id': detail.id});
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
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('文章详情'),
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
              primary: true,
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: _companyDetailBuilder(context),
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

  List<Widget> _companyDetailBuilder(BuildContext context) {
    List<Widget> child;
    if (detail == null) {
      child = <Widget>[loadWidget];
    } else {
      child = <Widget>[
        TempArticleBody(
          postInfo: detail,
        ),
        CommentsWidget(
          comments: _comments,
          onReplyAll: _toReplyAll,
          onReplyUser: _toReplyUser,
        ),
      ];
    }
    return child;
  }

  int _parentId;
  int _discussId;
  User _discussUser;
  User _user;
  List<Comment> _comments;
  void _toReplyUser(Map<String, dynamic> item) {
    _parentId = item['parentId'];
    _discussUser = item['toUser'];
    _discussId = _discussUser.id;
    _user = Provider.of<LoginUserModel>(context).loginUser;
    _showReplyDialog();
  }

  void _toReplyAll() {
    _parentId = 0;
    _discussId = null;
    _user = Provider.of<LoginUserModel>(context).loginUser;
    _discussUser = null;
    _showReplyDialog();
  }

  void _showReplyDialog() {
    Navigator.push(
      context,
      PageRouteBuilder<String>(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) => ReplyScreenDialog(),
      ),
    ).then((val) {
      print(val);
      if (null != val) {
        _toPublishReply(val);
      }
    });
  }

  void _toPublishReply(val) async {
    Map<String, dynamic> data = {
      "post_id": widget.arguments['id'],
      "content": val,
      "discuss_id": _discussId,
      "parent_id": _parentId,
    };
    var res = await toArticleReply(params: data);
    print(res);
    if (null != res) {
      _comments.add(
        Comment(
          id: res['data'],
          userId: _user.id,
          content: val,
          createTime: CommonUtils.timeToString(DateTime.now()),
          discussId: _discussId,
          user: _user,
          parentId: _parentId,
          discussUser: _discussUser,
        ),
      );
      setState(() {});
    }
  }
}
