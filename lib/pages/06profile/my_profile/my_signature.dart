import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/06_user_profile_fun.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_toast.dart';
import 'package:fengchao/provider/login_user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MySignatureComponent extends StatefulWidget {
  MySignatureComponent({Key key, this.arguments}) : super(key: key);
  final Map arguments;

  @override
  _MySignatureComponentState createState() => _MySignatureComponentState();
}

class _MySignatureComponentState extends State<MySignatureComponent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  bool _buttonState = true;
  String _signature;

  String _validateSignature(String value) {
    if (value.length > 20) return '签名不能超过20个字符';
    return null;
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
    } else {
      form.save();
      setState(() {
        _buttonState = false;
      });
      _doPublish();
    }
  }

  Future _doPublish() async {
    var res = await editUserInfo(params: {
      'signature': _signature,
    });
    print(res);
    if (null != res) {
      if (res['data'] == true) {
        BotToast.showCustomLoading(
          duration: Duration(milliseconds: 1000),
          toastBuilder: (cancelFunc) {
            return CustomToastWidget(title: '修改成功', icon: Icons.done);
          },
        );
        await Future.delayed(Duration(milliseconds: 1000));
        Navigator.of(context).pop(true);
      } else {
        print('修改失败');
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
          title: Text('更改个性签名'),
          actions: <Widget>[
            Center(
              child: Container(
                width: 60.0,
                height: 40.0,
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                child: FlatButton(
                  padding: EdgeInsets.zero,
                  color: Colors.blueGrey,
                  disabledColor: Colors.blueGrey[100],
                  child: Text('确定', style: TextStyle(color: Colors.white, fontSize: 14.0)),
                  onPressed: _buttonState ? _handleSubmitted : null,
                ),
              ),
            )
          ],
        ),
        body: Form(
          key: _formKey,
          autovalidate: _autovalidate,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 8.0),
                child: Consumer<LoginUserModel>(
                  builder: (context, model, _) {
                    return TextFormField(
                      initialValue: model.loginUser.signature,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '一句话签名',
                        hintText: '您的个性签名',
                      ),
                      maxLines: 2,
                      maxLength: 20,
                      style: TextStyle(fontSize: 14.0, height: 1.5, textBaseline: TextBaseline.alphabetic),
                      validator: _validateSignature,
                      onSaved: (val) {
                        _signature = val;
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
