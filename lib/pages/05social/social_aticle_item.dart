import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/05_social_list_fun.dart';
import 'package:fengchao/common/utils/common_utils.dart';
import 'package:fengchao/common/utils/sp_utils.dart';
import 'package:fengchao/models/article_model.dart';
import 'package:fengchao/models/user_entity.dart';
import 'package:fengchao/pages/widgets/muti_box_widget.dart';
import 'package:fengchao/pages/widgets/reply_screen_dialog.dart';
import 'package:fengchao/provider/login_user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class SocialArticleItem extends StatefulWidget {
  final ArticleModel items;
  final Function editCallBack;

  SocialArticleItem({Key key, this.items, this.editCallBack}) : super(key: key);

  @override
  _SocialArticleItemState createState() => _SocialArticleItemState();
}

class _SocialArticleItemState extends State<SocialArticleItem> {
  bool showMore = false;
  int _loginId = SpUtil.getInt('xxUserId');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.fromLTRB(10.0, 2, 10.0, 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
            boxShadow: showMore
                ? [
                    BoxShadow(
                      offset: Offset(1, 1),
                      blurRadius: 1.0,
                      color: Colors.black38,
                    )
                  ]
                : [],
          ),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: GestureDetector(
                      child: CircleAvatar(backgroundImage: NetworkImage(widget.items.user.avatar)),
                      onTap: () {
                        Navigator.pushNamed(context, '/userInfo', arguments: {'id': widget.items.user.id});
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            widget.items.user.userNickname,
                            style: TextStyle(color: Color(0xFF000000), fontSize: 14.0),
                          ),
                        ),
                        Container(
                          child: Text('发布时间：${widget.items.createTime}',
                              style: TextStyle(color: Color(0xFF999999), fontSize: 10.0)),
                        ),
                        SizedBox(
                          height: 6.0,
                        ),
                        Container(
                          child: Text(
                            '标题：${widget.items.postTitle}',
                            style: TextStyle(fontSize: 12.0, color: Colors.grey),
                          ),
                        ),
                        Container(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                child: Text(
                                  widget.items.postContent,
                                  maxLines: showMore ? null : 3,
                                  overflow: showMore ? TextOverflow.visible : TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 12.0),
                                ),
                              ),
                              Positioned.fill(
                                  child: InkWell(
                                borderRadius: BorderRadius.circular(2.0),
                                onTap: () {
                                  setState(() {
                                    showMore = !showMore;
                                  });
                                },
                              ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        MultiImageBoxBuilder(
                          imageList: showMore ? widget.items.imageList : [],
                        ),
                        CommentBox(
                          comments: widget.items.leaves,
                          thumbs: widget.items.thumbs,
                          articleId: widget.items.id,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Divider(),
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Stack(
                        children: <Widget>[
                          Center(
                              child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 2.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.flag, color: Color(0xFF999999)),
                                  SizedBox(
                                    width: 4.0,
                                  ),
                                  Text('(${widget.items.postFavorites})',
                                      style: TextStyle(fontSize: 12.0, color: Color(0xFFCCCCCC))),
                                ],
                              ),
                              SizedBox(
                                height: 2.0,
                              ),
                            ],
                          )),
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(2.0),
                                onTap: () {
                                  _doArticleFavorate(widget.items);
                                },
                              ),
                            ),
                          )
                        ],
                      )),
                  Expanded(
                      flex: 1,
                      child: Stack(
                        children: <Widget>[
                          Center(
                              child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 2.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.share, color: Color(0xFF999999)),
                                  SizedBox(
                                    width: 4.0,
                                  ),
                                  Text('(0)', style: TextStyle(fontSize: 12.0, color: Color(0xFFCCCCCC))),
                                ],
                              ),
                              SizedBox(
                                height: 2.0,
                              ),
                            ],
                          )),
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(2.0),
                                onTap: () {
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
                                },
                              ),
                            ),
                          )
                        ],
                      )),
                  Expanded(
                      flex: 1,
                      child: Stack(
                        children: <Widget>[
                          Center(
                              child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 2.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.bubble_chart, color: Color(0xFF999999)),
                                  SizedBox(
                                    width: 4.0,
                                  ),
                                  Text('(${widget.items.commentCount})',
                                      style: TextStyle(fontSize: 12.0, color: Color(0xFFCCCCCC))),
                                ],
                              ),
                              SizedBox(
                                height: 2.0,
                              ),
                            ],
                          )),
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(2.0),
                                onTap: () {
                                  Navigator.pushNamed(context, '/articleComments', arguments: {'id': widget.items.id});
                                },
                              ),
                            ),
                          )
                        ],
                      )),
                ],
              )
            ],
          ),
        ),
        _loginId == widget.items.user.id
            ? Positioned(
                top: 8.0,
                right: 10.0,
                child: GestureDetector(
                  child: ClipPath(
                    clipper: EditPostCliper(32.0, 12.0),
                    child: Container(
                      width: 32.0,
                      height: 12.0,
                      alignment: Alignment.centerRight,
                      color: Colors.lightGreen,
                      child: Text(
                        'EDIT',
                        style: TextStyle(fontSize: 10.0, color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () {
                    widget.editCallBack(widget.items);
                  },
                ),
              )
            : Container(),
      ],
    );
  }

  void _showShareSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String value) {
      if (value == 'SESSION') {
        var share = fluwx.WeChatShareTextModel(
            text: widget.items.postContent,
            transaction: "text${DateTime.now().millisecondsSinceEpoch}",
            scene: fluwx.WeChatScene.SESSION);
        _shareText(share);
      }
      if (value == 'TIMELINE') {
        var share = fluwx.WeChatShareTextModel(
            text: widget.items.postContent,
            transaction: "text${DateTime.now().millisecondsSinceEpoch}",
            scene: fluwx.WeChatScene.TIMELINE);
        _shareText(share);
      }
      if (value == 'FAVORITE') {
        var share = fluwx.WeChatShareTextModel(
            text: widget.items.postContent,
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

  void _doArticleFavorate(ArticleModel post) async {
    var res = await doArticleFavorate(params: {'id': post.id});
    print(res);
    if (null != res) {
      if (res['data'] == 1) {
        BotToast.showText(text: '收藏成功', textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
        widget.items.postFavorites += 1;
      } else {
        BotToast.showText(text: '重复收藏', textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
      }
      setState(() {});
    }
  }
}

class EditPostCliper extends CustomClipper<Path> {
  // 宽高
  double width;
  double height;

  EditPostCliper(this.width, this.height);

  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.moveTo(5.0, 0.0);
    path.lineTo(width, 0.0);
    path.lineTo(width, height);
    path.lineTo(5.0, height);
    path.lineTo(0.0, height / 2);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class CommentBox extends StatefulWidget {
  CommentBox({Key key, this.comments, this.thumbs, this.articleId}) : super(key: key);
  final List<Comment> comments;
  final List<Thumbs> thumbs;
  final int articleId;

  @override
  _CommentBoxState createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> scaleAnimation;
  bool isZan = false;
  int loginId = SpUtil.getInt('xxUserId');

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    scaleAnimation =
        Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Curves.bounceOut));
  }

  @override
  void dispose() {
    super.dispose();
    animationController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ScaleTransition(
                scale: scaleAnimation,
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Colors.grey,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              width: 50.0,
                              height: 30.0,
                              child: FlatButton(
                                padding: EdgeInsets.zero,
                                child: Text(
                                  '点赞',
                                  style: TextStyle(fontSize: 14.0, color: isZan ? Colors.red : Colors.white),
                                ),
                                onPressed: () {
                                  if (isZan) {
                                    return;
                                  } else {
                                    _doArticleThumb();
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                              child: Text('|'),
                            ),
                            Container(
                              width: 50.0,
                              height: 30.0,
                              child: FlatButton(
                                padding: EdgeInsets.zero,
                                child: Text(
                                  '留言',
                                  style: TextStyle(fontSize: 14.0, color: Colors.white),
                                ),
                                onPressed: () {
                                  _toReplyAll();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 10.0,
                        height: 20.0,
                        decoration: ShapeDecoration(
                          color: Colors.grey,
                          shape: BeveledRectangleBorder(
                            borderRadius:
                                BorderRadius.only(topRight: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 30.0,
                height: 24.0,
                color: Colors.grey[100],
                child: FlatButton(
                  padding: EdgeInsets.zero,
                  child: Icon(Icons.more_horiz),
                  onPressed: () {
                    setState(() {
                      isZan = _hasDoZan();
                    });
                    if (animationController.isCompleted) {
                      //反向开始
                      animationController.reverse();
                    } else {
                      //正向动画开始
                      animationController.forward();
                    }
                  },
                ),
              )
            ],
          ),
          Divider(),
          Container(
            width: double.infinity,
            color: Colors.grey[100],
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 5.0,
              children: _biuldWithThumb(),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Container(
            child: Column(
              children: _biuldWithComments(),
            ),
          ),
        ],
      ),
    );
  }

  int _parentId;
  int _discussId;
  User _discussUser;
  User _user;
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
      "post_id": widget.articleId,
      "content": val,
      "discuss_id": _discussId,
      "parent_id": _parentId,
    };
    var res = await toArticleReply(params: data);
    print(res);
    if (null != res) {
      widget.comments.add(
        Comment(
          id: res['data'],
          userId: _user.id,
          postId: widget.articleId,
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

  void _doArticleThumb() async {
    var res = await doArticleThumb(params: {'id': widget.articleId});
    print(res);
    if (null != res) {
      if (res['data'] == true) {
        widget.thumbs.add(
          Thumbs(
            userId: loginId,
            postId: widget.articleId,
            createTime: null,
            user: Provider.of<LoginUserModel>(context).loginUser,
          ),
        );
      }
    }
    isZan = true;
    setState(() {});
  }

  bool _hasDoZan() {
    if (widget.thumbs.length == 0) {
      return false;
    } else {
      for (var item in widget.thumbs) {
        if (item.userId == loginId) {
          return true;
        }
      }
    }
    return false;
  }

  List<Widget> _biuldWithThumb() {
    List<Widget> children = [];
    children.add(Icon(
      Icons.favorite,
      color: Colors.grey,
      size: 20.0,
    ));
    for (var i = 0; i < (widget.thumbs.length >= 6 ? 6 : widget.thumbs.length); i++) {
      children.add(Text(
        widget.thumbs[i].user.userNickname + ',',
        style: TextStyle(fontSize: 12.0, color: Colors.grey),
      ));
    }

    return children;
  }

  List<Widget> _biuldWithComments() {
    List<Widget> children;
    if (widget.comments.length > 0) {
      children = widget.comments.map((item) {
        return item.discussUser == null
            ? Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      child: Text(
                        item.user.userNickname + '：',
                        style: TextStyle(fontSize: 12.0, color: Colors.blue),
                      ),
                      onTap: () {
                        _toReplyUser({'parentId': item.parentId == 0 ? item.id : item.parentId, 'toUser': item.user});
                      },
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 12.0),
                      child: Text.rich(TextSpan(children: <TextSpan>[
                        TextSpan(
                          text: item.content,
                          style: TextStyle(fontSize: 12.0),
                        ),
                        TextSpan(
                          text: CommonUtils.dateToPretty(item.createTime),
                          style: TextStyle(fontSize: 10.0, color: Colors.grey),
                        ),
                      ])),
                    )
                  ],
                ),
              )
            : Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          child: Text(
                            item.user.userNickname,
                            style: TextStyle(fontSize: 12.0, color: Colors.blue),
                          ),
                          onTap: () {
                            _toReplyUser(
                                {'parentId': item.parentId == 0 ? item.id : item.parentId, 'toUser': item.user});
                          },
                        ),
                        Text(
                          ' 回复 ',
                          style: TextStyle(fontSize: 12.0),
                        ),
                        GestureDetector(
                          child: Text(
                            item.discussUser.userNickname + '：',
                            style: TextStyle(fontSize: 12.0, color: Colors.blue),
                          ),
                          onTap: () {
                            _toReplyUser(
                                {'parentId': item.parentId == 0 ? item.id : item.parentId, 'toUser': item.discussUser});
                          },
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 12.0),
                      child: Text.rich(TextSpan(children: <TextSpan>[
                        TextSpan(
                          text: item.content,
                          style: TextStyle(fontSize: 12.0),
                        ),
                        TextSpan(
                          text: CommonUtils.dateToPretty(item.createTime),
                          style: TextStyle(fontSize: 10.0, color: Colors.grey),
                        ),
                      ])),
                    )
                  ],
                ),
              );
      }).toList();
    } else {
      children = [];
    }

    return children;
  }
}
