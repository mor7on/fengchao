import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/05_social_list_fun.dart';
import 'package:fengchao/common/api/http_request.dart';
import 'package:fengchao/models/article_model.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_toast.dart';
import 'package:fengchao/pages/widgets/muti_image_upload.dart';
import 'package:flutter/material.dart';

class SocialPostEditComponent extends StatelessWidget {
  final Map arguments;
  const SocialPostEditComponent({Key key, this.arguments}) : super(key: key);

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
          title: Text('编辑文章'),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: SkillForm(
              detail: arguments['detail'],
            ),
          ),
        ),
      ),
    );
  }
}

class SkillForm extends StatefulWidget {
  final ArticleModel detail;
  SkillForm({Key key, this.detail}) : super(key: key);

  _SkillFormState createState() => _SkillFormState();
}

class _SkillFormState extends State<SkillForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List _imageUrls;
  bool _autovalidate = false;
  bool _buttonState = true;

  String _title, _content, _postAdress;

  @override
  void initState() {
    super.initState();
    _imageUrls = widget.detail.imageList;
    _initUserLocation();
  }

  Future _initUserLocation() async {
    _postAdress = await DioApi.getUserLocation();
  }

  void onUploadImages(urls) {
    _imageUrls = urls;
    print(_imageUrls);
  }

  String _validateTitle(String value) {
    if (value.isEmpty) return '文章标题不能为空';
    if (value.length > 16) return '文章标题不能超过16个字符';
    return null;
  }

  String _validateContent(String value) {
    if (value.isEmpty) return '文章内容不能为空';
    return null;
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      BotToast.showText(text: "输入有误，请重新输入", textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
    } else {
      form.save();
      _buttonState = false;
      _doPublish();
    }
  }

  Future _doPublish() async {
    var res = await editSocialPost(params: {
      'id': widget.detail.id,
      'post_title': _title,
      'post_content': _content,
      'post_address': _postAdress,
      'category_id': widget.detail.categoryId,
      'more': jsonEncode({'photos': _imageUrls}),
    });
    if (null != res) {
      if (res['data'] == true) {
        BotToast.showCustomLoading(
          duration: Duration(milliseconds: 2000),
          toastBuilder: (cancelFunc) {
            return CustomToastWidget(title: '发布成功', icon: Icons.done);
          },
        );
        await Future.delayed(Duration(milliseconds: 2000));
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .copyWith(inputDecorationTheme: InputDecorationTheme(hintStyle: TextStyle(fontSize: 14.0, height: 1.5))),
      child: Form(
        key: _formKey,
        autovalidate: _autovalidate,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
              child: TextFormField(
                initialValue: widget.detail.postTitle,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: '文章标题',
                  hintText: '文章标题(不能为空)',
                  isDense: true,
                  alignLabelWithHint: true,
                ),
                maxLines: 1,
                style: TextStyle(fontSize: 14.0, height: 1.5, textBaseline: TextBaseline.alphabetic),
                validator: _validateTitle,
                onSaved: (val) {
                  _title = val;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
              child: TextFormField(
                initialValue: widget.detail.postContent,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: '文章内容（例如：主要讨论什么内容...）',
                  labelText: '文章内容',
                  isDense: true,
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                maxLength: 2000,
                style: TextStyle(fontSize: 14.0, height: 1.5, textBaseline: TextBaseline.alphabetic),
                validator: _validateContent,
                onSaved: (val) {
                  _content = val;
                },
              ),
            ),
            SizedBox(
              height: 3.0,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    child: Text('文章附图：', style: TextStyle(fontSize: 14.0)),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: MutiImageUploadComponent(
                      onChanged: onUploadImages,
                      imageList: widget.detail.imageList,
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
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              child: FlatButton(
                color: Colors.blue,
                child: Text('提交', style: TextStyle(color: Colors.white)),
                onPressed: _buttonState ? _handleSubmitted : null,
              ),
            )
          ],
        ),
      ),
    );
  }
}
