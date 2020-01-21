import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class MyWithdrawFinish extends StatelessWidget {
  final Map<String, dynamic> arguments;
  const MyWithdrawFinish({Key key, this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('提现完成'),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 100.0,
                      height: 100.0,
                      padding: EdgeInsets.all(8.0),
                      child: Image.asset('assets/images/timer.png'),
                    ),
                    Text('正在处理中...'),
                    Text('预计3天内到账',style: TextStyle(fontSize: 12.0,color: Colors.grey),),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text('提现金额'), Text('¥${arguments['coin']}',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),)],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text('手续费'), Text('¥${arguments['service']}',style: TextStyle(fontSize: 12.0,color: Colors.grey),)],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text('银行卡'), Text('${arguments['bankCard'] + arguments['trueName']}',style: TextStyle(fontSize: 12.0,color: Colors.grey),)],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 50.0),
              child: Container(
                child: RaisedButton(
                  elevation: 0.0,
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('完成'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
