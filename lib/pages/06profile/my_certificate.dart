import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/06_user_profile_fun.dart';
import 'package:fengchao/common/utils/encrypt_helper.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/muti_image_upload.dart';
import 'package:fengchao/provider/login_user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MyCertificateComponent extends StatefulWidget {
  MyCertificateComponent({Key key}) : super(key: key);

  @override
  _MyCertificateComponentState createState() => _MyCertificateComponentState();
}

class _MyCertificateComponentState extends State<MyCertificateComponent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _trueName;
  String _kIDCard;
  bool _autovalidate = false;
  bool _isReSubmit = false;
  List _imageUrls = [];
  bool _buttonState = true;
  EncryptHelper _encryptHelper = EncryptHelper();

  @override
  void initState() {
    super.initState();
    _encryptHelper.init();
  }

  String _validateTrueName(String value) {
    if (value.isEmpty) return '真实姓名不能为空';
    return null;
  }

  String _validateIDCard(String value) {
    if (value.isEmpty) return '身份证号不能为空';
    return null;
  }

  void onUploadImages(urls) {
    _imageUrls = urls;
    print(_imageUrls);
    setState(() {});
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      BotToast.showText(text: "输入有误，请重新输入", textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
    } else {
      form.save();
      // _buttonState = false;
      _doPublish();
    }
  }

  void _doPublish() async {
    Map<String, dynamic> params = {
      'name': _encryptHelper.encode(_trueName),
      'number': _encryptHelper.encode(_kIDCard),
      'positive': _imageUrls[0],
      'negative': _imageUrls[1],
    };
    Map res = await publishIDCard(params: params);
    if (null != res) {
      if(res['data'] == true){
        BotToast.showText(text: "提交成功，等待审核...", textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
        Provider.of<LoginUserModel>(context).fetchUserCertificate();
        Future.delayed(Duration(milliseconds: 1200));
        Navigator.pop(context);
      }else {
        BotToast.showText(text: "提交失败，请重新提交！", textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LoginUserModel>(context).certificateState;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text('实名认证'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Builder(
                  builder: (context) {
                    if (model == 0) {
                      return _isReSubmit ? _buildForm() : _buildWithAlreadySubmit();
                    } else if (model == 1) {
                      return _isReSubmit ? _buildForm() : _buildWithNotPass();
                    } else if (model == 2) {
                      return _biuldWithAlreadyPass();
                    } else {
                      return _buildForm();
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Column _biuldWithAlreadyPass() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Text(
            '您提交的实名信息已通过审核；\n在享受网络服务的同时，请遵守国家相关法律法规，祝您有一个愉快的开始',
            style: TextStyle(fontSize: 14.0),
          ),
        ),
        SizedBox(
          height: 16.0,
        ),
      ],
    );
  }

  Column _buildWithNotPass() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Text(
            '您提交的实名信息经核实，未通过审核，有可能是信息输入有误或身份证照片不清晰；\n若需重新提交信息，请点击下方按钮。',
            style: TextStyle(fontSize: 14.0),
          ),
        ),
        SizedBox(
          height: 16.0,
        ),
        Container(
          width: double.infinity,
          alignment: Alignment.centerRight,
          child: FlatButton(
            color: Colors.green[200],
            child: Text('重新提交'),
            onPressed: () {
              setState(() {
               _isReSubmit = true; 
              });
            },
          ),
        ),
      ],
    );
  }

  Column _buildWithAlreadySubmit() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Text(
            '您提交的实名信息正在认证中，我们将在3天内核实信息，请你耐心等待；\n若需重新提交信息，请点击下方按钮。',
            style: TextStyle(fontSize: 14.0),
          ),
        ),
        SizedBox(
          height: 16.0,
        ),
        Container(
          width: double.infinity,
          alignment: Alignment.centerRight,
          child: FlatButton(
            color: Colors.green[200],
            child: Text('重新提交'),
            onPressed: () {
              setState(() {
               _isReSubmit = true; 
              });
            },
          ),
        ),
      ],
    );
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      autovalidate: _autovalidate,
      child: Column(
        children: <Widget>[
          Container(
            child: TextFormField(
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: '真实姓名',
                hintText: '真实姓名(不能为空)',
                isDense: true,
                alignLabelWithHint: true,
              ),
              maxLines: 1,
              style: TextStyle(fontSize: 14.0, height: 1.5, textBaseline: TextBaseline.alphabetic),
              validator: _validateTrueName,
              onSaved: (val) {
                _trueName = val;
              },
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            child: TextFormField(
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: '身份证号',
                hintText: '身份证号(不能为空)',
                isDense: true,
                alignLabelWithHint: true,
              ),
              maxLines: 1,
              maxLength: 18,
              style: TextStyle(fontSize: 14.0, height: 1.5, textBaseline: TextBaseline.alphabetic),
              validator: _validateIDCard,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter(RegExp(r'^(\d+)([A-Za-z0-9])?$')),
                // Fit the validating format.
              ],
              onSaved: (val) {
                _kIDCard = val;
              },
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text('身份证照片（正反面）：', style: TextStyle(fontSize: 14.0))),
                      Text('${_imageUrls.length}/2')
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10.0),
                  child: MutiImageUploadComponent(
                    onChanged: onUploadImages,
                    total: 2,
                    type: 1, //上传avatar
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Text(
              '根据《中华人民共和国网络安全法》，在享受网络相关服务之前必须进行实名认证，用户在账户实名认证后将享受更高等级的安全防护。我们将通过敏感数据加密存储、监控多层防御等技术手段确保用户个人信息得到有效的保护，守卫您的信息安全。',
              style: TextStyle(fontSize: 14.0),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            width: double.infinity,
            height: 60.0,
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            child: FlatButton(
              color: Colors.blue,
              child: Text('提交', style: TextStyle(color: Colors.white)),
              onPressed: _buttonState ? _handleSubmitted : null,
            ),
          )
        ],
      ),
    );
  }
}
