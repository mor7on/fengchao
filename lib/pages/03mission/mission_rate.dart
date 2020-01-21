import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/03_mission_list_fun.dart';
import 'package:fengchao/common/api/06_user_profile_fun.dart';
import 'package:fengchao/models/user_entity.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:fengchao/pages/widgets/muti_image_upload.dart';
import 'package:fengchao/provider/mission_steps_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class MissionRateComponent extends StatefulWidget {
  MissionRateComponent({Key key, this.arguments}) : super(key: key);
  final Map<String, dynamic> arguments;

  @override
  _MissionRateComponentState createState() => _MissionRateComponentState();
}

class _MissionRateComponentState extends State<MissionRateComponent> {
  TextEditingController _contentController = TextEditingController();
  List<String> _imageUrls = [];
  User _rateUser;
  double _rate = 3.5;

  @override
  void initState() {
    super.initState();
    initUserData();
  }

  Future<Null> initUserData() async {
    var res = await getUserInfoById(params: {'id': widget.arguments['user_id']});
    if (null != res) {
      _rateUser = User.fromJson(res['data']);
    }
    if (mounted) {
      setState(() {});
    }
  }

  void onUploadImages(urls) {
    _imageUrls = urls;
    print(_imageUrls);
  }

  Future<Null> _handleSubmitted() async {
    BotToast.showLoading(backgroundColor: Colors.transparent);
    String content = _contentController.text.trim();
    var res = await toPostUserRate(
      params: {
        'trade_id': widget.arguments['trade_id'],
        'content': content,
        'target_id': widget.arguments['user_id'],
        'rate': _rate,
        // 'more': jsonEncode({'photos': _imageUrls})
      },
    );
    BotToast.closeAllLoading();
    print(res);
    if (null != res) {
      if (res['data'] == true) {
        Provider.of<StepperModel>(context).initMissionSteps();
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text('用户评价'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: _rateUser == null ? loadWidget : _buildWithColumn(),
        ),
      ),
    );
  }

  Column _buildWithColumn() {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            children: <Widget>[
              Container(
                height: 40.0,
                child: Text(
                  '您对用户${_rateUser.userNickname}感到满意吗？',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              RatingBar(
                initialRating: 3.4,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  _rate = rating;
                },
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    child: OutlineButton(
                      child: Text('不满意'),
                      shape: StadiumBorder(),
                      onPressed: () {
                        _contentController.text = '不满意';
                      },
                    ),
                  ),
                  Container(
                    child: OutlineButton(
                      child: Text('非常满意'),
                      shape: StadiumBorder(),
                      onPressed: () {
                        _contentController.text = '非常满意';
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.zero,
                child: TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: '简要描述评价内容（例如：服务态度、工作成果等是否满意...）',
                    labelText: '评价留言',
                    filled: true,
                    fillColor: Color(0xFFF0F0F0),
                    isDense: true,
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                  maxLength: 200,
                  style: TextStyle(fontSize: 14.0, height: 1.5, textBaseline: TextBaseline.alphabetic),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 16.0,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 30.0,
                child: Text('上传图片：', style: TextStyle(fontSize: 14.0)),
              ),
              Container(
                padding: EdgeInsets.only(top: 10.0),
                child: MutiImageUploadComponent(
                  onChanged: onUploadImages,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 3.0,
        ),
        Container(
          width: double.infinity,
          height: 60.0,
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
          child: FlatButton(
            color: Colors.blue,
            disabledColor: Colors.grey[300],
            disabledTextColor: Colors.grey[700],
            child: Text('提交', style: TextStyle(color: Colors.white)),
            onPressed: _handleSubmitted,
          ),
        )
      ],
    );
  }
}
