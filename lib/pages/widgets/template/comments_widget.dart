import 'dart:ffi';

import 'package:fengchao/common/utils/common_utils.dart';
import 'package:fengchao/models/article_model.dart';
import 'package:flutter/material.dart';

import 'detail_template.dart';

class CommentsWidget extends StatelessWidget {
  CommentsWidget({Key key, this.comments, this.onReplyAll, this.onReplyUser}) : super(key: key);
  final List<Comment> comments;
  final VoidCallback onReplyAll;
  final ValueChanged<Map<String, dynamic>> onReplyUser;

  @override
  Widget build(BuildContext context) {
    print('重建了companyDetail留言');
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 8.0),
            padding: EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 15.0),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
            child: Column(
              children: _biuldWithComments(context),
            ),
          ),
          Container(
            decoration: ShapeDecoration(
                color: kTitleColor,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0)),
                )),
            padding: EdgeInsets.only(left: 16.0),
            child: Text('留言评论：'),
          ),
        ],
      ),
    );
  }

  List<Widget> _biuldWithComments(context) {
    List<Widget> children;
    children = comments.map((item) {
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
                      onReplyUser({'parentId': item.parentId == 0 ? item.id : item.parentId, 'toUser': item.user});
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
                          onReplyUser({'parentId': item.parentId == 0 ? item.id : item.parentId, 'toUser': item.user});
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
                          onReplyUser({'parentId': item.parentId == 0 ? item.id : item.parentId, 'toUser': item.discussUser});
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
    if (comments.length >= 5) {
      children.removeRange(5, children.length);
      children.add(Container(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              width: 80.0,
              height: 30.0,
              child: FlatButton(
                padding: EdgeInsets.zero,
                child: Text(
                  '留言(Reply)',
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                ),
                onPressed: onReplyAll,
              ),
            ),
            Container(
              width: 80.0,
              height: 30.0,
              child: FlatButton(
                padding: EdgeInsets.zero,
                child: Text(
                  '更多(More...)',
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/companyComments', arguments: {'id': comments[0].companyId});
                },
              ),
            ),
          ],
        ),
      ));
    }
    if (comments.length > 0 && comments.length < 5) {
      children.add(Container(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              width: 80.0,
              height: 30.0,
              child: FlatButton(
                padding: EdgeInsets.zero,
                child: Text(
                  '留言(Reply)',
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                ),
                onPressed: onReplyAll,
              ),
            ),
          ],
        ),
      ));
    }
    if (comments.length == 0) {
      children.add(Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Icon(
              Icons.cloud_off,
              size: 50.0,
              color: Colors.grey,
            ),
            Text('暂无评论'),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: 80.0,
                  height: 30.0,
                  child: FlatButton(
                    padding: EdgeInsets.zero,
                    child: Text(
                      '留言(Reply)',
                      style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                    ),
                    onPressed: onReplyAll,
                  ),
                ),
              ],
            )
          ],
        ),
      ));
    }

    return children;
  }
}
