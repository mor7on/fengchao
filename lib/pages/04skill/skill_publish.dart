import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/04_skill_list_fun.dart';
import 'package:fengchao/common/api/http_request.dart';
import 'package:fengchao/models/category_model.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_toast.dart';
import 'package:fengchao/pages/widgets/muti_image_upload.dart';
import 'package:flutter/material.dart';

class SkillPublishComponent extends StatelessWidget {
  const SkillPublishComponent({Key key}) : super(key: key);

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
          title: Text('个人技能发布'),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: SkillForm(),
          ),
        ),
      ),
    );
  }
}

class SkillForm extends StatefulWidget {
  SkillForm({Key key}) : super(key: key);

  _SkillFormState createState() => _SkillFormState();
}

class _SkillFormState extends State<SkillForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _tagsController = TextEditingController();
  List<int> _cateIds;
  String _skillTags;
  List _imageUrls = [];
  bool _autovalidate = false;
  bool _buttonState = true;

  String _title, _content, _postAdress;

  @override
  void initState() {
    super.initState();
    // _skillTags = '';
    _cateIds = [];
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
    if (value.isEmpty) return '标题不能为空';
    return null;
  }

  String _validateContent(String value) {
    if (value.isEmpty) return '内容不能为空';
    return null;
  }

  String _validateKeywords(String value) {
    if (value.isEmpty) return '关键词不能为空';
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
    var res = await addSkill(params: {
      'post_title': _title,
      'post_content': _content,
      'post_address': _postAdress,
      'post_keywords': _skillTags,
      'more': jsonEncode({'photos': _imageUrls}),
    });
    print(res);
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
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: '标题',
                  hintText: '您的标题(不能为空)',
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
              child: Stack(
                children: <Widget>[
                  TextFormField(
                    controller: _tagsController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: '关键词',
                      hintText: '请输入关键词，用逗号隔开...',
                      isDense: true,
                      alignLabelWithHint: true,
                    ),
                    maxLines: 1,
                    style: TextStyle(fontSize: 14.0, height: 1.5, textBaseline: TextBaseline.alphabetic),
                    validator: _validateKeywords,
                    onSaved: (val) {
                      _skillTags = val;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      child: IconButton(
                        icon: Icon(Icons.navigate_next),
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          await Navigator.pushNamed(context, '/popKeywords', arguments: {'ids': _cateIds}).then((res) {
                            List<Category> tempResult = res;
                            if (tempResult == null) {
                              return;
                            } else {
                              _cateIds = [];
                              List<String> skillList = [];
                              for (var i = 0; i < tempResult.length; i++) {
                                _cateIds.add(tempResult[i].categoryId);
                                skillList.add(tempResult[i].title);
                              }
                              _tagsController.text = skillList.join(',');
                              setState(() {});
                            }
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: '个人简要说明（例如：个人拥有什么技能，做过哪些相关工作...）',
                  helperText: '请简要描述您的技能',
                  labelText: '个人简介',
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
                    child: Text('图片描述：', style: TextStyle(fontSize: 14.0)),
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
