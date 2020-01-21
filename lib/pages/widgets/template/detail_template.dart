import 'package:fengchao/common/utils/common_utils.dart';
import 'package:fengchao/models/article_model.dart';
import 'package:fengchao/models/custom_entity_list.dart';
import 'package:fengchao/models/user_entity.dart';
import 'package:fengchao/pages/widgets/city_pickers/meta/city_list.dart';
import 'package:fengchao/pages/widgets/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

const Color kTitleColor = Color(0xFFE3F2FD);

class TempHeader extends StatelessWidget {
  const TempHeader({Key key, this.userInfo}) : super(key: key);
  final User userInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
      color: kTitleColor,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${userInfo.userNickname}', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                Text('任务(已接/已发/完成)：${userInfo.tasks}/${userInfo.publishTasks}/${userInfo.completeTasks}',
                    style: TextStyle(fontSize: 12.0)),
                // Text('rate:${userInfo['rate']}',style: TextStyle(fontSize: 12.0)),
                RatingBarIndicator(
                  itemSize: 16.0,
                  rating: userInfo.rate,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  // itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: GestureDetector(
              child: CircleAvatar(
                backgroundImage: NetworkImage(userInfo.avatar),
              ),
              onTap: (){
                Navigator.pushNamed(context, '/userInfo',arguments: {'id': userInfo.id});
              },
            ),
          )
        ],
      ),
    );
  }
}

class TempEmptyHeader extends StatelessWidget {
  const TempEmptyHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
      color: kTitleColor,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: Color(0xFFF0F0F0),
                  child: Text('User_NickName',
                      style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: Color(0xFFF0F0F0))),
                ),
                SizedBox(height: 2.0),
                Container(
                  color: Color(0xFFF0F0F0),
                  child: Text('任务(已接/已发/完成)：00/00/00', style: TextStyle(fontSize: 12.0, color: Color(0xFFF0F0F0))),
                ),
                // Text('rate:${userInfo['rate']}',style: TextStyle(fontSize: 12.0)),
                RatingBarIndicator(
                  itemSize: 16.0,
                  rating: 0,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  // itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: CircleAvatar(
              backgroundColor: Color(0xFFF0F0F0),
            ),
          )
        ],
      ),
    );
  }
}

class TempCompanyBody extends StatelessWidget {
  const TempCompanyBody({Key key, this.postInfo}) : super(key: key);
  final ArticleModel postInfo;

  @override
  Widget build(BuildContext context) {
    print('重建了companyDetail详情');
    
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 4.0),
            padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${postInfo.postTitle}', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.visibility, size: 12.0, color: Colors.blueGrey),
                      Text('${postInfo.postHits}次浏览', style: TextStyle(fontSize: 12.0, color: Colors.blueGrey)),
                      SizedBox(
                        width: 8.0,
                      ),
                      Icon(Icons.center_focus_strong, size: 12.0, color: Colors.blueGrey),
                      Text('${postInfo.postFavorites}人收藏', style: TextStyle(fontSize: 12.0, color: Colors.blueGrey)),
                      SizedBox(
                        width: 8.0,
                      ),
                      Icon(Icons.launch, size: 12.0, color: Colors.blueGrey),
                      Text(CommonUtils.dateToPretty(postInfo.createTime),
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
          Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                padding: EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 5.0),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('${postInfo.postContent}',
                          style: TextStyle(fontSize: 14.0, color: Colors.blueGrey[300])),
                    ),
                    Container(
                      child: Text(
                          '公司地址：${postInfo.compAddress != null && postInfo.compAddress != '' ? postInfo.compAddress : '未输入或见以上内容'}',
                          style: TextStyle(fontSize: 12.0, color: Colors.blueGrey[100])),
                    ),
                    Container(
                      child: Text('所属行业：${postInfo.postKeywords}',
                          style: TextStyle(fontSize: 12.0, color: Colors.blueGrey[100])),
                    )
                  ],
                ),
              ),
              Container(
                decoration: ShapeDecoration(
                    color: kTitleColor,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0)),
                    )),
                padding: EdgeInsets.only(left: 16.0),
                child: Text('企业简介：'),
              ),
            ],
          ),
          Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                padding: EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 16.0),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
                child: ImagePreview(
                  imageList: postInfo.imageList,
                ),
              ),
              Container(
                decoration: ShapeDecoration(
                    color: kTitleColor,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0)),
                    )),
                padding: EdgeInsets.only(left: 16.0),
                child: Text('企业附图：'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TempMissionBody extends StatelessWidget {
  const TempMissionBody({Key key, this.postInfo}) : super(key: key);
  final ArticleModel postInfo;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 50.0),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 4.0),
            padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${postInfo.postTitle}', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.visibility, size: 12.0, color: Colors.blueGrey),
                      Text('${postInfo.postHits}次浏览', style: TextStyle(fontSize: 12.0, color: Colors.blueGrey)),
                      SizedBox(
                        width: 8.0,
                      ),
                      Icon(Icons.center_focus_strong, size: 12.0, color: Colors.blueGrey),
                      Text('${postInfo.postFavorites}人收藏',
                          style: TextStyle(fontSize: 12.0, color: Colors.blueGrey)),
                      SizedBox(
                        width: 8.0,
                      ),
                      Icon(Icons.launch, size: 12.0, color: Colors.blueGrey),
                      Text(CommonUtils.dateToPretty(postInfo.createTime),
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
                ),
              ],
            ),
          ),
          Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                padding: EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 15.0),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      alignment: Alignment.centerRight,
                      child: Text(
                        postInfo.areaId == null ? '全国' : cityList['${postInfo.areaId}']['name'],
                        style: TextStyle(fontSize: 20.0, color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: ShapeDecoration(
                    color: kTitleColor,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0)),
                    )),
                padding: EdgeInsets.only(left: 16.0),
                child: Text('区域限制：'),
              ),
            ],
          ),
          Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                padding: EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 15.0),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${postInfo.bail == null || postInfo.bail.coin == null ? "0.00" : postInfo.bail.coin} CNY',
                        style: TextStyle(fontSize: 30.0, color: Colors.green),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: ShapeDecoration(
                    color: kTitleColor,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0)),
                    )),
                padding: EdgeInsets.only(left: 16.0),
                child: Text('任务保金：'),
              ),
            ],
          ),
          Stack(
            children: <Widget>[
              postInfo.type == 0
                  ? Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      padding: EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 15.0),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${postInfo.postSalary} CNY',
                              style: TextStyle(fontSize: 30.0, color: Colors.green),
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      padding: EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 15.0),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            alignment: Alignment.centerRight,
                            child: Text(
                              '通过竞标确定',
                              style: TextStyle(fontSize: 24.0, color: Colors.green),
                            ),
                          )
                        ],
                      ),
                    ),
              Container(
                decoration: ShapeDecoration(
                    color: kTitleColor,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0)),
                    )),
                padding: EdgeInsets.only(left: 16.0),
                child: Text('任务佣金：'),
              ),
            ],
          ),
          Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 5.0),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('${postInfo.postContent}',
                          style: TextStyle(fontSize: 14.0, color: Colors.blueGrey[300])),
                    ),
                    Container(
                      child: Text(
                          '地址信息：${postInfo.postAddress != null && postInfo.postAddress != '' ? postInfo.postAddress : '用户已隐藏地址信息'}',
                          style: TextStyle(fontSize: 12.0, color: Colors.blueGrey[100])),
                    ),
                    Container(
                      child: Text('任务标签：${postInfo.postKeywords}',
                          style: TextStyle(fontSize: 12.0, color: Colors.blueGrey[100])),
                    )
                  ],
                ),
              ),
              Container(
                decoration: ShapeDecoration(
                    color: kTitleColor,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0)),
                    )),
                padding: EdgeInsets.only(left: 16.0),
                child: Text('任务描述：'),
              ),
            ],
          ),
          Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                padding: EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 5.0),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
                child: ImagePreview(
                  imageList: postInfo.imageList,
                ),
              ),
              Container(
                decoration: ShapeDecoration(
                    color: kTitleColor,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0)),
                    )),
                padding: EdgeInsets.only(left: 16.0),
                child: Text('任务附图：'),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class TempSkillBody extends StatelessWidget {
  const TempSkillBody({Key key, this.postInfo}) : super(key: key);
  final ArticleModel postInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 4.0),
            padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${postInfo.postTitle}', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.visibility, size: 12.0, color: Colors.blueGrey),
                      Text('${postInfo.postHits}次浏览', style: TextStyle(fontSize: 12.0, color: Colors.blueGrey)),
                      SizedBox(
                        width: 8.0,
                      ),
                      Icon(Icons.center_focus_strong, size: 12.0, color: Colors.blueGrey),
                      Text('${postInfo.postFavorites}人收藏',
                          style: TextStyle(fontSize: 12.0, color: Colors.blueGrey)),
                      SizedBox(
                        width: 8.0,
                      ),
                      Icon(Icons.launch, size: 12.0, color: Colors.blueGrey),
                      Text(CommonUtils.dateToPretty(postInfo.createTime),
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
          Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                padding: EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 15.0),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('${postInfo.postContent}',
                          style: TextStyle(fontSize: 14.0, color: Colors.blueGrey[300])),
                    ),
                    Container(
                      child: Text(
                          '发布地址：${postInfo.postAddress != null && postInfo.postAddress != '' ? postInfo.postAddress : '未输入或见以上内容'}',
                          style: TextStyle(fontSize: 12.0, color: Colors.blueGrey[100])),
                    ),
                    Container(
                      child: Text('所属行业：${postInfo.postKeywords}',
                          style: TextStyle(fontSize: 12.0, color: Colors.blueGrey[100])),
                    )
                  ],
                ),
              ),
              Container(
                decoration: ShapeDecoration(
                    color: kTitleColor,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0)),
                    )),
                padding: EdgeInsets.only(left: 16.0),
                child: Text('技能描述：'),
              ),
            ],
          ),
          Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                padding: EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 16.0),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
                child: ImagePreview(
                  imageList: postInfo.imageList,
                ),
              ),
              Container(
                decoration: ShapeDecoration(
                    color: kTitleColor,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0)),
                    )),
                padding: EdgeInsets.only(left: 16.0),
                child: Text('技能附图：'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddFavoriteButton extends StatefulWidget {
  AddFavoriteButton({Key key, this.isLike, this.postLike, this.commentCount}) : super(key: key);
  final bool isLike;
  final int postLike;
  final int commentCount;

  _AddFavoriteButtonState createState() => _AddFavoriteButtonState();
}

class _AddFavoriteButtonState extends State<AddFavoriteButton> {
  bool isDoLike;
  int postLike;

  @override
  void initState() {
    super.initState();
    isDoLike = widget.isLike;
    postLike = widget.postLike;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
        child: ButtonBar(
          children: <Widget>[
            Container(
              width: 60.0,
              height: 30.0,
              child: FlatButton(
                padding: EdgeInsets.zero,
                child: Text('点赞($postLike)', style: TextStyle(fontSize: 14.0)),
                onPressed: () {},
              ),
            ),
            Container(
              width: 60.0,
              height: 30.0,
              child: FlatButton(
                padding: EdgeInsets.zero,
                child: Text('评论(${widget.commentCount})', style: TextStyle(fontSize: 14.0)),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TempArticleBody extends StatelessWidget {
  const TempArticleBody({Key key, this.postInfo}) : super(key: key);
  final ArticleModel postInfo;

  @override
  Widget build(BuildContext context) {
    
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 4.0),
            padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${postInfo.postTitle}', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.visibility, size: 12.0, color: Colors.blueGrey),
                      Text('${postInfo.postHits??0}次浏览', style: TextStyle(fontSize: 12.0, color: Colors.blueGrey)),
                      SizedBox(
                        width: 8.0,
                      ),
                      Icon(Icons.center_focus_strong, size: 12.0, color: Colors.blueGrey),
                      Text('${postInfo.postFavorites}人收藏', style: TextStyle(fontSize: 12.0, color: Colors.blueGrey)),
                      SizedBox(
                        width: 8.0,
                      ),
                      Icon(Icons.launch, size: 12.0, color: Colors.blueGrey),
                      Text(CommonUtils.dateToPretty(postInfo.createTime),
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
          Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                padding: EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 5.0),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('${postInfo.postContent}',
                          style: TextStyle(fontSize: 14.0, color: Colors.blueGrey[300])),
                    ),
                    Container(
                      child: Text(
                          '发布地址：${postInfo.postAddress != null && postInfo.postAddress != '' ? postInfo.postAddress : '作者隐藏了地址信息'}',
                          style: TextStyle(fontSize: 12.0, color: Colors.blueGrey[100])),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: ShapeDecoration(
                    color: kTitleColor,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0)),
                    )),
                padding: EdgeInsets.only(left: 16.0),
                child: Text('文章内容：'),
              ),
            ],
          ),
          Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                padding: EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 16.0),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
                child: ImagePreview(
                  imageList: postInfo.imageList,
                ),
              ),
              Container(
                decoration: ShapeDecoration(
                    color: kTitleColor,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0)),
                    )),
                padding: EdgeInsets.only(left: 16.0),
                child: Text('文章附图：'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}