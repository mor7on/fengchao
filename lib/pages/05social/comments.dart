import 'package:fengchao/common/api/05_social_list_fun.dart';
import 'package:fengchao/common/utils/common_utils.dart';
import 'package:fengchao/models/article_model.dart';
import 'package:fengchao/models/user_entity.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_loading_widget.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:fengchao/pages/widgets/reply_screen_dialog.dart';
import 'package:fengchao/provider/login_user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ArticleComments extends StatefulWidget {
  ArticleComments({Key key, this.arguments}) : super(key: key);
  final Map arguments;

  @override
  _ArticleCommentsState createState() => _ArticleCommentsState();
}

class _ArticleCommentsState extends State<ArticleComments> {
  RefreshController _refreshController;
  List<Comment> _aComments;
  String date;
  int page = 0;
  int _parentId;
  int _discussId;
  User _discussUser;
  User _user;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
    initUserData();
  }

  @override
  void dispose() {
    _refreshController?.dispose();
    super.dispose();
  }

  void initUserData() async {
    date = CommonUtils.timeToString(DateTime.now());
    var res = await getArticleComments(params: {'date': date, 'post_id': widget.arguments['id'], 'page': page});
    if (null != res) {
      _aComments = [];
      for (var item in res['data']) {
        _aComments.add(Comment.fromJson(item));
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('全部回复'),
      ),
      body: Stack(
        children: <Widget>[
          _aComments == null ? loadWidget : _buildSmartRefresher(),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomSheet(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50.0,
      decoration:
          BoxDecoration(color: Colors.grey[100], border: BorderDirectional(top: BorderSide(color: Colors.grey[300]))),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.text_fields),
          ),
          GestureDetector(
            child: Container(
              width: 160.0,
              height: 30.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(18.0)),
              child: Text(
                '我来说两句',
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
            ),
            onTap: _toReplyAll,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: GestureDetector(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.navigate_before),
                    Text('返回'),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSmartRefresher() {
    if (_aComments.length == 0) {
      return CustomEmptyWidget();
    }
    return SmartRefresher(
      enablePullDown: false,
      enablePullUp: true,
      header: BezierCircleHeader(
        dismissType: BezierDismissType.ScaleToCenter,
      ),
      footer: CustomFooter(
        height: 100.0,
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
            height: 50.0,
            // padding: EdgeInsets.only(bottom: 50.0),
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
        itemCount: _aComments.length,
        itemBuilder: (context, index) {
          List<Comment> children = [];
          final Comment comment = _aComments[index];

          if (comment.parentId == 0) {
            for (var item in _aComments) {
              if (comment.id == item.parentId) {
                children.add(item);
              }
            }
            return CommentTile(
              comment: comment,
              children: children,
              onItemTap: _toReplyUser,
            );
          } else {
            return Container();
          }
        },
      ),
      onRefresh: _onRefresh,
      onLoading: _onLoading,
    );
  }

  void _onLoading() async {
    page += 1;
    var requestParams = {'date': date, 'company_id': widget.arguments['id'], 'page': page};
    print(requestParams);
    await getArticleComments(params: requestParams).then((v) {
      if (null != v) {
        for (var item in v['data']) {
          _aComments.add(Comment.fromJson(item));
        }
        setState(() {});
        _refreshController.loadComplete();
        if (v['data'].length < 20) {
          _refreshController.loadNoData();
        }
      }
    });
  }

  void _onRefresh() async {
    date = CommonUtils.timeToString(DateTime.now());
    page = 0;
    var requestParams = {'date': date, 'post_id': widget.arguments['id'], 'page': page};
    await Future.delayed(Duration(milliseconds: 1200), () {
      getArticleComments(params: requestParams).then((v) {
        if (null != v) {
          // if (v.length > 0) {
          //   setState(() {
          //     _result = v;
          //   });
          // } else {
          //   setState(() {
          //     _result = [];
          //   });
          // }
          _refreshController.refreshCompleted();
          _refreshController.resetNoData();
        }
      });
    });
  }

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
      _aComments.add(
        Comment(
          id: res['data'],
          userId: _user.id,
          postId: widget.arguments['id'],
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

class CommentTile extends StatelessWidget {
  const CommentTile({
    Key key,
    this.comment,
    this.children,
    this.onItemTap,
  }) : super(key: key);

  final Comment comment;
  final List<Comment> children;
  final ValueChanged<Map<String, dynamic>> onItemTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(comment.user.avatar),
            radius: 16.0,
          ),
        ),
        Expanded(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  child: Text(
                    comment.user.userNickname + '：',
                    style: TextStyle(color: Colors.grey, fontSize: 14.0),
                  ),
                  onTap: () {
                    onItemTap({'parentId': comment.id, 'toUser': comment.user});
                  },
                ),
                Text(
                  comment.createTime,
                  style: TextStyle(color: Colors.grey, fontSize: 12.0),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    comment.content,
                    style: TextStyle(color: Colors.black, fontSize: 14.0),
                  ),
                ),
                children.length == 0
                    ? Container()
                    : Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 8.0),
                        decoration: BoxDecoration(
                            border: BorderDirectional(
                          start: BorderSide(
                            width: 5.0,
                            color: Colors.grey[200],
                          ),
                        )),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: children.map((item) {
                            return Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Text(
                                          item.user.userNickname,
                                          style: TextStyle(color: Colors.grey, fontSize: 12.0),
                                        ),
                                        onTap: () {
                                          onItemTap({'parentId': comment.id, 'toUser': item.user});
                                        },
                                      ),
                                      Text(
                                        ' 回复 ',
                                        style: TextStyle(color: Colors.grey, fontSize: 12.0),
                                      ),
                                      GestureDetector(
                                        child: Text(
                                          item.discussUser == null ? '' : item.discussUser.userNickname + '：',
                                          style: TextStyle(color: Colors.grey, fontSize: 12.0),
                                        ),
                                        onTap: () {
                                          onItemTap({'parentId': comment.id, 'toUser': item.discussUser});
                                        },
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2.0),
                                    child: Text(
                                      item.content,
                                      style: TextStyle(color: Colors.black, fontSize: 14.0),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
