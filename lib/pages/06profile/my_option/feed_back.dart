import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/06_user_profile_fun.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_toast.dart';
import 'package:fengchao/pages/widgets/muti_image_upload.dart';
import 'package:flutter/material.dart';

class FeedBackComponent extends StatelessWidget {
  const FeedBackComponent({Key key}) : super(key: key);

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
          title: Text('投诉及建议'),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: FeedBackFormList(),
          ),
        ),
      ),
    );
  }
}

class FeedBackFormList extends StatefulWidget {
  FeedBackFormList({Key key}) : super(key: key);

  _FeedBackFormListState createState() => _FeedBackFormListState();
}

class _FeedBackFormListState extends State<FeedBackFormList> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List _imageUrls = [];
  String content, email, more;

  void _submitFeedbackForm() {
    _formKey.currentState.save();
    more = jsonEncode({'photos': _imageUrls});
    Map<String, dynamic> postParams = {"content": content, "email": email, "model": 'HUAWEI-COR-AL10', "more": more};
    postFeedback(params: postParams).then((res) async {
      if (null != res) {
        if (res['data'] == true) {
          BotToast.showCustomLoading(
              duration: Duration(milliseconds: 1000),
              toastBuilder: (cancelFunc) {
                return CustomToastWidget(title: '发布成功', icon: Icons.done, cancelFunc: cancelFunc);
              });
          await Future.delayed(Duration(milliseconds: 1000));
          Navigator.of(context).pop();
        } else {
          BotToast.showText(text: "提交失败，请重新提交！", textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
        }
      }
    });
  }

  void _onUpload(urls) {
    _imageUrls = urls;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 8.0,
          ),
          Container(padding: const EdgeInsets.all(8.0), child: Text('问题描述(不能为空)：', style: TextStyle(fontSize: 14.0))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '请告诉我们您的问题或者建议（例如：需要增加您关注的某些内容或者app卡顿等等...）',
                helperText: '请简要描述您的问题，可适当配以图片说明。',
                labelText: '问题描述：',
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              style: TextStyle(fontSize: 14.0, height: 1.5, textBaseline: TextBaseline.alphabetic),
              onSaved: (val) {
                content = val;
              },
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Text('图片：(选填，提供截图，总大小10m以下)', style: TextStyle(fontSize: 14.0)),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(6.0, 10.0, 6.0, 10.0),
                  child: MutiImageUploadComponent(
                    onChanged: _onUpload,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Container(
              padding: const EdgeInsets.all(8.0),
              child: Text('QQ|Email(选填，方便我们联系你)：', style: TextStyle(fontSize: 14.0))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'QQ|Email',
                hintText: '选填，方便我们联系你',
              ),
              maxLines: 1,
              style: TextStyle(fontSize: 14.0, height: 1.5, textBaseline: TextBaseline.alphabetic),
              onSaved: (val) {
                email = val;
              },
            ),
          ),
          const SizedBox(height: 24.0),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              color: Colors.blue,
              elevation: 0.0,
              child: const Text('提交', style: TextStyle(color: Colors.white)),
              onPressed: _submitFeedbackForm,
            ),
          ),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '您的投诉及建议是我们前进的动力！',
              style: TextStyle(fontSize: 10.0, color: Colors.blueGrey[300]),
            ),
          ),
        ],
      ),
    );
  }
}
