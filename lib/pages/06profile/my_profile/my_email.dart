import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/06_user_profile_fun.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_toast.dart';
import 'package:fengchao/provider/login_user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyEmailComponent extends StatefulWidget {
  MyEmailComponent({Key key, this.arguments}) : super(key: key);
  final Map arguments;

  @override
  _MyEmailComponentState createState() => _MyEmailComponentState();
}

class _MyEmailComponentState extends State<MyEmailComponent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  bool _buttonState = true;
  String _email;

  String _validateEmail(String value) {
    RegExp rexEmail =
        RegExp(r'^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$');
    if (!rexEmail.hasMatch(value)) return '###@example.com - 正确电子信箱格式';
    if (value.length > 30) return '地址长度超限';
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
      'user_email': _email,
    });
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
          title: Text('更改电子信箱'),
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
                      initialValue: model.loginUser.userEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '电子信箱',
                        hintText: '######@example.com',
                      ),
                      maxLines: 1,
                      maxLength: 30,
                      style: TextStyle(fontSize: 14.0, height: 1.5, textBaseline: TextBaseline.alphabetic),
                      validator: _validateEmail,
                      onSaved: (val) {
                        _email = val;
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
