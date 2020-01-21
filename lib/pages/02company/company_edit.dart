import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/02_company_list_fun.dart';
import 'package:fengchao/common/api/http_request.dart';
import 'package:fengchao/models/article_model.dart';
import 'package:fengchao/models/custom_entity.dart';
import 'package:fengchao/models/custom_entity_list.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_toast.dart';
import 'package:fengchao/pages/widgets/muti_image_upload.dart';
import 'package:flutter/material.dart';

class CompanyEditComponent extends StatelessWidget {
  const CompanyEditComponent({Key key, this.arguments}) : super(key: key);
  final Map<String,dynamic> arguments;

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
          title: Text('企业信息修改'),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: CompanyForm(detail: arguments['detail']),
          ),
        ),
      ),
    );
  }
}

class CompanyForm extends StatefulWidget {
  CompanyForm({Key key, this.detail}) : super(key: key);
  final ArticleModel detail;

  _CompanyFormState createState() => _CompanyFormState();
}

class _CompanyFormState extends State<CompanyForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int industryId;
  String industryText;
  List _imageUrls = [];
  bool _autovalidate = false;
  bool _buttonState = true;

  String _title, _content, _comAdress, _postAdress;

  @override
  void initState() {
    super.initState();
    industryId = widget.detail.postIndustry;
    industryText = publishIndust[industryId].label;
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
    if (value.isEmpty) return '企业名称不能为空';
    return null;
  }

  String _validateContent(String value) {
    if (value.isEmpty) return '企业简介不能为空';
    return null;
  }

  String _validateAdress(String value) {
    if (value.isEmpty) return '企业地址不能为空';
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
    var res = await editCompany(params: {
      'id': widget.detail.id,
      'post_title': _title,
      'post_content': _content,
      'thumbnail': _imageUrls.length > 0 ? _imageUrls[0] : null,
      'comp_address': _comAdress,
      'post_address': _postAdress,
      'post_industry': industryId,
      'more': jsonEncode({'photos': _imageUrls}),
    });
    if (null != res) {
      if (res['data'] == true) {
        BotToast.showCustomLoading(
          duration: Duration(milliseconds: 2000),
          toastBuilder: (cancelFunc) {
            return CustomToastWidget(title: '编辑成功', icon: Icons.done);
          },
        );
        await Future.delayed(Duration(milliseconds: 2000));
        Navigator.of(context).pop(true);
      } else {
        print('编辑失败');
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
                  labelText: '企业名称',
                  hintText: '您的企业名称(不能为空)',
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
            SizedBox(
              height: 3.0,
            ),
            Stack(
              children: <Widget>[
                Container(
                    width: double.infinity,
                    height: 54.0,
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Text('所属行业：',
                              style: TextStyle(fontSize: 14.0, height: 1.5, textBaseline: TextBaseline.alphabetic)),
                        ),
                        Expanded(
                          child: Text(industryText,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: industryText == '选择所属行业...' ? Colors.grey[600] : Colors.black)),
                        ),
                        Icon(Icons.chevron_right, color: Colors.grey[600]),
                      ],
                    )),
                Positioned.fill(
                    child: InkWell(
                  borderRadius: BorderRadius.circular(5.0),
                  onTap: () async {
                    Navigator.pushNamed(context, '/popIndustry', arguments: {'id': industryId}).then((res) {
                      CustomEntity tempResult = res;
                      if (tempResult == null || industryId == tempResult.value) {
                        return;
                      } else {
                        setState(() {
                          industryText = tempResult.label;
                          industryId = tempResult.value;
                        });
                      }
                    });
                  },
                ))
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
              child: TextFormField(
                initialValue: widget.detail.postContent,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: '企业简要说明（例如：企业的成立时间，生产什么产品...）',
                  helperText: '请简要描述您的企业',
                  labelText: '企业简介',
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
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
              child: TextFormField(
                initialValue: widget.detail.compAddress,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: '企业地址',
                  hintText: '您的企业地址(不能为空)',
                  isDense: true,
                  alignLabelWithHint: true,
                ),
                maxLines: 1,
                style: TextStyle(fontSize: 14.0, height: 1.5, textBaseline: TextBaseline.alphabetic),
                validator: _validateAdress,
                onSaved: (val) {
                  _comAdress = val;
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
                    child: Text('产品图片：', style: TextStyle(fontSize: 14.0)),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: MutiImageUploadComponent(
                      onChanged: onUploadImages,
                      imageList: _imageUrls,
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
