import 'package:fengchao/common/api/06_user_profile_fun.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:fengchao/provider/login_user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyBalanceComponent extends StatefulWidget {
  MyBalanceComponent({Key key}) : super(key: key);

  @override
  _MyBalanceComponentState createState() => _MyBalanceComponentState();
}

class _MyBalanceComponentState extends State<MyBalanceComponent> {
  @override
  void initState() {
    super.initState();
    initUserData();
  }

  void initUserData() async {
    Future.microtask(
      () => Provider.of<LoginUserModel>(context, listen: false).fetchMyBlance(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('账户余额'),
      ),
      body: Consumer<LoginUserModel>(
        builder: (context, model, _) {
          return model.myblance == null
              ? loadWidget
              : Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 50.0),
                      child: Container(
                        width: 50.0,
                        height: 50.0,
                        child: Image.asset('assets/images/financial_fill.png'),
                      ),
                    ),
                    Container(
                      height: 40.0,
                      alignment: Alignment.center,
                      child: Text('[账户余额]'),
                    ),
                    Container(
                      height: 40.0,
                      alignment: Alignment.center,
                      child: Text(
                        model.myblance.all.toStringAsFixed(2) + ' CNY',
                        style: TextStyle(fontSize: 30.0, color: Colors.green),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text('冻结保证金：'),
                          ),
                          Container(
                            child: Text(model.myblance.bail.toStringAsFixed(2) + 'CNY'),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text('可提现金额：'),
                          ),
                          Container(
                            child: Text(
                                (model.myblance.all - model.myblance.bail).toStringAsFixed(2) + 'CNY'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                      child: FlatButton(
                        color: Colors.grey[100],
                        child: Text('充值'),
                        onPressed: () {
                          Navigator.pushNamed(context, '/myRechage');
                        },
                      ),
                    ),
                    Container(
                      child: FlatButton(
                        color: Colors.green,
                        textColor: Colors.white,
                        child: Text('提现'),
                        onPressed: () {
                          Navigator.pushNamed(context, '/myWithdraw');
                        },
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
