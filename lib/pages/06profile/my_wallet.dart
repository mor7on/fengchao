import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/06_user_profile_fun.dart';
import 'package:fengchao/common/utils/common_utils.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:fengchao/provider/login_user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MyWalletComponent extends StatefulWidget {
  MyWalletComponent({Key key}) : super(key: key);

  _MyWalletComponentState createState() => _MyWalletComponentState();
}

class _MyWalletComponentState extends State<MyWalletComponent> {
  Map<String,dynamic> _wallet;
  double _income;

  @override
  void initState() {
    super.initState();
    initUserData();
  }

  initUserData() async {
    await Future.delayed(Duration(milliseconds: 600), () async {
      DateTime timeNow = DateTime.now();
      String end = CommonUtils.timeToString(timeNow);
      DateTime startTime = DateTime(timeNow.year, timeNow.month, 1);
      String start = CommonUtils.timeToString(startTime);

      var val = await getMyIncome(params: {'startTime': start,'endTime': end});
      print(val);
      if (null != val) {
        _income = val['data'];
      }
      var res = await getMyBalance();
      print(res);
      if (null != res) {
        _wallet = res['data'];
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('我的钱包'),
      ),
      body: _wallet == null
          ? loadWidget
          : Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 120.0,
                          margin: EdgeInsets.symmetric(vertical: 16.0),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            // borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0),bottomRight: Radius.circular(20.0)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '本月收入：',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Container(
                                      width: 120.0,
                                      height: 50.0,
                                      alignment: Alignment.center,
                                      child: Text(_income.toStringAsFixed(2), style: TextStyle(fontSize: 20.0, color: Colors.white)),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 8.0),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '账户余额：',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Container(
                                      width: 120.0,
                                      height: 50.0,
                                      alignment: Alignment.center,
                                      child:
                                          Text(_wallet['all'], style: TextStyle(fontSize: 20.0, color: Colors.white)),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  CustomImageButton(
                                    title: '我的账单',
                                    icon: Image.asset('assets/images/check.png'),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/myBill');
                                    },
                                  ),
                                  CustomImageButton(
                                    title: '交易密码',
                                    icon: Image.asset('assets/images/lock.png'),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/setPassword');
                                    },
                                  ),
                                  CustomImageButton(
                                    title: '修改密码',
                                    icon: Image.asset('assets/images/unlock.png'),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/editPassword');
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  CustomImageButton(
                                    title: '绑定微信',
                                    icon: Image.asset('assets/images/wechat.png'),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/expectService');
                                    },
                                  ),
                                  CustomImageButton(
                                    title: '绑定支付宝',
                                    icon: Image.asset('assets/images/zhifubao.png'),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/expectService');
                                    },
                                  ),
                                  CustomImageButton(
                                    title: '绑定银行卡',
                                    icon: Image.asset('assets/images/bankcard.png'),
                                    onPressed: () {
                                      final model = Provider.of<LoginUserModel>(context);
                                      print(model.certificateState);
                                      print(model.userpassState);
                                      if (model.certificateState == 2) {
                                        if (model.userpassState == 1) {
                                          Navigator.pushNamed(context, '/queryBankCard');
                                        } else {
                                          BotToast.showText(
                                              text: '请先设置交易密码',
                                              textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
                                        }
                                      } else {
                                        BotToast.showText(
                                            text: '请先进行实名认证',
                                            textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            children: <Widget>[
                              CustomImageButton(
                                icon: Image.asset('assets/images/financial_fill.png'),
                                title: '充值|提现',
                                onPressed: () {
                                  Navigator.pushNamed(context, '/myBalance');
                                },
                              ),
                              Expanded(
                                child: Container(
                                  height: 100.0,
                                  margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey[50],
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0),bottomRight: Radius.circular(20.0)),
                                  ),
                                  child: Container(),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 100.0,
                                  margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey[50],
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0),bottomRight: Radius.circular(20.0)),
                                  ),
                                  child: Container(),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class CustomImageButton extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback onPressed;

  const CustomImageButton({
    Key key,
    this.icon,
    this.title,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 100.0,
          margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.blueGrey[50],
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0),bottomRight: Radius.circular(20.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(width: 50.0, height: 50.0, child: icon),
              Text(
                title,
                style: TextStyle(fontSize: 12.0),
              )
            ],
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(4.0),
              splashColor: Colors.blueGrey.withOpacity(0.2),
              highlightColor: Colors.blueGrey.withOpacity(0.1),
              onTap: onPressed,
            ),
          ),
        ),
      ],
    ));
  }
}

class SliverCustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double collapsedHeight;
  final double expandedHeight;
  final double paddingTop;
  final String title;
  final Widget child;
  String statusBarMode = 'dark';

  SliverCustomHeaderDelegate({
    this.collapsedHeight,
    this.expandedHeight,
    this.paddingTop,
    this.child,
    this.title,
  });

  @override
  double get minExtent => this.collapsedHeight + this.paddingTop;

  @override
  double get maxExtent => this.expandedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  void updateStatusBarBrightness(shrinkOffset) {
    if (shrinkOffset > 50 && this.statusBarMode == 'light') {
      this.statusBarMode = 'dark';
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ));
    } else if (shrinkOffset <= 50 && this.statusBarMode == 'dark') {
      this.statusBarMode = 'light';
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ));
    }
  }

  Color makeStickyHeaderBgColor(shrinkOffset) {
    final int alpha = (shrinkOffset / (this.maxExtent - this.minExtent) * 255).clamp(0, 255).toInt();
    return Color.fromARGB(alpha, 255, 255, 255);
  }

  Color makeStickyHeaderTextColor(shrinkOffset, isIcon) {
    if (shrinkOffset <= 50) {
      return isIcon ? Colors.white : Colors.transparent;
    } else {
      final int alpha = (shrinkOffset / (this.maxExtent - this.minExtent) * 255).clamp(0, 255).toInt();
      return Color.fromARGB(alpha, 0, 0, 0);
    }
  }

  Color makeStickyHeaderBottomTextColor(shrinkOffset, isIcon) {
    if (shrinkOffset <= 20) {
      return isIcon ? Colors.white : Colors.white;
    } else {
      final int alpha = ((1 - shrinkOffset / (this.maxExtent - this.minExtent)) * 255).clamp(0, 255).toInt();
      return Color.fromARGB(alpha, 255, 255, 255);
    }
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    this.updateStatusBarBrightness(shrinkOffset);
    return Container(
      height: this.maxExtent,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            color: Colors.blueGrey[300],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20.0,
            child: child,
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              color: this.makeStickyHeaderBgColor(shrinkOffset),
              child: SafeArea(
                bottom: false,
                child: Container(
                  height: this.collapsedHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: this.makeStickyHeaderTextColor(shrinkOffset, true),
                          size: 20.0,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        this.title,
                        style: TextStyle(
                          fontSize: Theme.of(context).textTheme.subhead.fontSize,
                          fontWeight: FontWeight.w500,
                          color: this.makeStickyHeaderTextColor(shrinkOffset, false),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.share,
                          color: this.makeStickyHeaderTextColor(shrinkOffset, true),
                          size: 20.0,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
