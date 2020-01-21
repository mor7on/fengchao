import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/05_social_list_fun.dart';
import 'package:fengchao/common/utils/common_utils.dart';
import 'package:fengchao/common/utils/sp_utils.dart';
import 'package:fengchao/models/article_model.dart';
import 'package:fengchao/pages/05social/social_aticle_item.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_loading_widget.dart';
import 'package:fengchao/pages/widgets/custom_toast.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class SocialDetailComponent extends StatefulWidget {
  final Map arguments;

  SocialDetailComponent({Key key, this.arguments}) : super(key: key);

  _SocialDetailComponentState createState() => _SocialDetailComponentState();
}

class _SocialDetailComponentState extends State<SocialDetailComponent> {
  List<ArticleModel> detail;
  Map<String,dynamic> _socialInfo;
  String date;
  int page;
  bool isCateUser = false;

  RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
    initUserData();
  }

  initUserData() async {
    page = 0;
    date = CommonUtils.timeToString(new DateTime.now());
    await Future.delayed(Duration(milliseconds: 600), () async {
      var info = await getSocialById(params: {'id': widget.arguments['id']});
      if (null != info) {
        _socialInfo = info['data'];
      }
      var res = await getSocialPostById(params: {'category_id': widget.arguments['id'], 'date': date, 'page': page});
      int loginId = SpUtil.getInt('xxUserId');
      isCateUser = loginId == widget.arguments['pid'];
      if (null != res) {
        detail = [];
        res['data'].forEach((v) {
          detail.add(new ArticleModel.fromJson(v));
        });
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
            text: _socialInfo['description'],
            transaction: "text${DateTime.now().millisecondsSinceEpoch}",
            scene: fluwx.WeChatScene.SESSION);
        _shareText(share);
      }
      if (value == 'TIMELINE') {
        var share = fluwx.WeChatShareTextModel(
            text: _socialInfo['description'],
            transaction: "text${DateTime.now().millisecondsSinceEpoch}",
            scene: fluwx.WeChatScene.TIMELINE);
        _shareText(share);
      }
      if (value == 'FAVORITE') {
        var share = fluwx.WeChatShareTextModel(
            text: _socialInfo['description'],
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
    var res = await toFavoriteSocial(params: {'id':widget.arguments['id']});
    print(res);
    if (null != res) {
      if (res['data'] == 1) {
        BotToast.showText(text: '收藏成功', textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
        _socialInfo['cate_favorites'] += 1;
      } else {
        BotToast.showText(text: '重复收藏', textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
      }
      setState(() {});
    }
  }

  Future _navigateToEdit() async {
    Navigator.pushNamed(context, '/socialEdit', arguments: {'id': widget.arguments['id']});
  }

  Future _toDelete() async {
    var res = await deleteSocial(params: {'id': widget.arguments['id']});
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

  Future<void> _onRefresh() async {
    page = 0;
    date = CommonUtils.timeToString(new DateTime.now());
    var requestParams = {'category_id': widget.arguments['id'], 'date': date, 'page': page};
    await Future.delayed(Duration(milliseconds: 600), () {
      getSocialPostById(params: requestParams).then((res) {
        if (null != res) {
          detail = [];
          res['data'].forEach((v) {
            detail.add(new ArticleModel.fromJson(v));
          });
          setState(() {});
          _refreshController.refreshCompleted();
          _refreshController.resetNoData();
        }
      });
    });
  }

  Future<void> _onLoading() async {
    page += 1;
    var requestParams = {'category_id': widget.arguments['id'], 'date': date, 'page': page};
    await getSocialPostById(params: requestParams).then((res) {
      if (null != res) {
        res['data'].forEach((v) {
          detail.add(new ArticleModel.fromJson(v));
        });
        setState(() {});
        _refreshController.loadComplete();
        if (res['data'].length < 10) {
          _refreshController.loadNoData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('圈子详情'),
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
              isCateUser
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
              isCateUser
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/socialPostPublish', arguments: {'id': widget.arguments['id']})
              .then((isRefresh) {
            if (isRefresh == true) {
              initUserData();
            }
          });
        },
        child: Icon(Icons.add, size: 30),
        backgroundColor: Colors.orange,
        shape: CircleBorder(side: BorderSide(color: Colors.white, width: 5.0)),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: BezierCircleHeader(
          dismissType: BezierDismissType.ScaleToCenter,
        ),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("上拉加载");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("加载失败，请重试");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("释放加载");
            } else {
              body = Text("- END -");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        onLoading: _onLoading,
        onRefresh: _onRefresh,
        controller: _refreshController,
        child: _socialDetailBuilder(context),
      ),
    );
  }

  Widget _socialDetailBuilder(BuildContext context) {
    Widget child;
    if (detail == null) {
      child = loadWidget;
    } else if (detail.length == 0) {
      child = CustomEmptyWidget();
    } else {
      child = ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        itemCount: detail.length,
        itemBuilder: (BuildContext context, int index) {
          return SocialArticleItem(
            items: detail[index],
            editCallBack: (ArticleModel item) {
              Navigator.pushNamed(context, '/socialPostEdit', arguments: {'detail': item}).then((isRefresh) {
                if (isRefresh == true) {
                  initUserData();
                }
              });
            },
          );
        },
      );
    }
    return child;
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
