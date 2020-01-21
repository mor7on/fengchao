import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/03_mission_list_fun.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_expand_scroll_view.dart';
import 'package:fengchao/pages/widgets/custom_toast.dart';
import 'package:fengchao/pages/widgets/muti_image_upload.dart';
import 'package:fengchao/provider/mission_steps_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_baidu_map/flutter_baidu_map.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class PostResultComponent extends StatelessWidget {
  const PostResultComponent({Key key, this.arguments}) : super(key: key);
  final Map arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('提交成果'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: CustomExpandScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: PostResultFormList(taskInfo: arguments),
          ),
        ),
      ),
    );
  }
}

class PostResultFormList extends StatefulWidget {
  PostResultFormList({Key key, this.taskInfo}) : super(key: key);
  final Map taskInfo;

  _PostResultFormListState createState() => _PostResultFormListState();
}

class _PostResultFormListState extends State<PostResultFormList> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String content, email, more;
  BaiduLocation location;
  bool _autovalidate = false;
  List _imageUrls = [];

  @override
  void initState() {
    super.initState();
    initUserlocation();
  }

  void initUserlocation() async {
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
    bool hasPermission = permission == PermissionStatus.granted;
    if (!hasPermission) {
      Map<PermissionGroup, PermissionStatus> map =
          await PermissionHandler().requestPermissions([PermissionGroup.location]);
      if (map.values.toList()[0] != PermissionStatus.granted) {
        return;
      }
    }
    location = await FlutterBaiduMap.getCurrentLocation();
    print(location.province + location.city + location.district + location.street);
    print(location.locationDescribe);
  }

  String _validateContent(String value) {
    if (value.isEmpty) return '内容不能为空';
    return null;
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      BotToast.showText(text: "输入有误，请重新输入", textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
    } else {
      form.save();
      _doPublish();
    }
  }

  Future _doPublish() async {
    more = jsonEncode({'photos': _imageUrls});
    Map<String, dynamic> postParams = {"trade_id": widget.taskInfo['id'], "content": content, "more": more};
    Map<String, dynamic> res = await toPostResultById(params: postParams);
    print(res);
    if (null != res) {
      if (res['data'] == true) {
        BotToast.showCustomLoading(
          duration: Duration(milliseconds: 1000),
          toastBuilder: (cancelFunc) {
            return CustomToastWidget(title: '发布成功', icon: Icons.done);
          },
        );
        Provider.of<StepperModel>(context).initMissionSteps();
        await Future.delayed(Duration(milliseconds: 1000));
        Navigator.of(context).pop(true);
      }
    }
  }

  void _onUploadImages(urls) {
    _imageUrls = urls;
    print(_imageUrls);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidate: _autovalidate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 8.0,
          ),
          Container(
            // padding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
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
                    onChanged: _onUploadImages,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          // Container(
          //   padding: const EdgeInsets.all(0.0),
          //   child: Text('提交成果描述(不能为空)：', style: TextStyle(fontSize: 14.0)),
          // ),
          // SizedBox(
          //   height: 8.0,
          // ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: '提交成果的简要说明（例如：已经完成了什么工作内容...）',
                helperText: '请简要描述您的成果，可适当配以图片说明。',
                labelText: '提交成果描述',
                isDense: true,
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              style: TextStyle(fontSize: 14.0, height: 1.5, textBaseline: TextBaseline.alphabetic),
              validator: _validateContent,
              onSaved: (val) {
                content = val;
              },
            ),
          ),
          const SizedBox(height: 24.0),
          Container(
            padding: const EdgeInsets.all(0.0),
            child: RaisedButton(
              color: Colors.blue,
              elevation: 0.0,
              child: const Text('提交', style: TextStyle(color: Colors.white)),
              onPressed: _handleSubmitted,
            ),
          ),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Text(
              '请认真填写，提高任务完成的成功率',
              style: TextStyle(fontSize: 10.0, color: Colors.blueGrey[300]),
            ),
          ),
        ],
      ),
    );
  }
}
