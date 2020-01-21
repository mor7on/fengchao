import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/utils/global_dialog.dart';
import 'package:fengchao/models/home_red_dot.dart';
import 'package:fengchao/provider/login_user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'index_component.dart';
import 'user_mission_component.dart';
import 'user_profile_component.dart';
import 'user_share_component.dart';

class HomeComponent extends StatefulWidget {
  HomeComponent({Key key}) : super(key: key);

  @override
  _HomeComponentState createState() => _HomeComponentState();
}

class _HomeComponentState extends State<HomeComponent> with TickerProviderStateMixin, WidgetsBindingObserver {
  // 页面控制
  TabController _tabController;
  PageController _pageController;
  Animation<Color> fadeScreenAnimation;
  AnimationController _screenController;
  // HomeRedDot homeRedDot;
  int _lastClickTime = 0;

  bool _bottomBarState = true;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _pageController = new PageController();

    _screenController = AnimationController(vsync: this, duration: Duration(seconds: 2));
    fadeScreenAnimation =
        ColorTween(begin: Color.fromRGBO(247, 64, 106, 1.0), end: Colors.transparent).animate(_screenController);
    _screenController.forward();
    WidgetsBinding.instance.addObserver(this);

    Future.microtask(
      () {
        print('初始化Provider');
        Provider.of<HomeRedDot>(context, listen: false).startTimer();
        Provider.of<LoginUserModel>(context, listen: false).init();
      },
    );
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        print('处于这种状态的应用程序应该假设它们可能在任何时候暂停。');
        Provider.of<HomeRedDot>(context, listen: false).stopTimer();
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
        print('resumed');
        Provider.of<HomeRedDot>(context, listen: false).startTimer();
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        print('paused');
        break;
      case AppLifecycleState.suspending: // 申请将暂时暂停
        print('申请将暂时暂停');
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _screenController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 底部栏切换
  void _onBottomNavigationBarTap(int index) {
    _pageController.jumpToPage(index);
    setState(() {
      _tabController.index = index;
    });
  }

  // 双击退出
  Future<bool> _doubleExit() {
    int nowTime = new DateTime.now().microsecondsSinceEpoch;
    if (_lastClickTime != 0 && nowTime - _lastClickTime > 1500) {
      return new Future.value(true);
    } else {
      _lastClickTime = new DateTime.now().microsecondsSinceEpoch;
      BotToast.showText(text: "连续按两次返回键返回桌面", textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
      new Future.delayed(const Duration(milliseconds: 1500), () {
        _lastClickTime = 0;
      });
      return new Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('重建HomeComponent---------------');
    GlobalDialog.ctx = context;
    return WillPopScope(
      onWillPop: _doubleExit,
      child: Stack(
        children: <Widget>[
          Scaffold(
            bottomNavigationBar: Visibility(
              visible: _bottomBarState,
              maintainState: true,
              child: Builder(builder: (BuildContext context) {
                return BottomNavigationBar(
                  onTap: _onBottomNavigationBarTap,
                  currentIndex: _tabController.index,
                  type: BottomNavigationBarType.fixed,
                  showUnselectedLabels: true,
                  fixedColor: Colors.amber,
                  // backgroundColor: Colors.teal,
                  // unselectedItemColor: Colors.white,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        backgroundColor: Colors.deepPurple,
                        icon: Icon(Icons.widgets),
                        title: Text(
                          FlutterI18n.translate(context, "home"),
                          style: TextStyle(fontSize: 12.0),
                        )),
                    BottomNavigationBarItem(
                        backgroundColor: Colors.blueGrey,
                        icon: Icon(Icons.map),
                        title: Text(
                          FlutterI18n.translate(context, "mission"),
                          style: TextStyle(fontSize: 12.0),
                        )),
                    BottomNavigationBarItem(
                        backgroundColor: Colors.teal,
                        icon: Icon(Icons.center_focus_strong),
                        title: Text(
                          FlutterI18n.translate(context, "share"),
                          style: TextStyle(fontSize: 12.0),
                        )),
                    BottomNavigationBarItem(
                        backgroundColor: Colors.indigo,
                        icon: Icon(Icons.account_circle),
                        title: Text(
                          FlutterI18n.translate(context, "mine"),
                          style: TextStyle(fontSize: 12.0),
                        )),
                  ],
                );
              }),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(_bottomBarState ? Icons.arrow_downward : Icons.arrow_upward),
              mini: true,
              backgroundColor: Colors.teal,
              onPressed: () {
                setState(() {
                  _bottomBarState = !_bottomBarState;
                });
              },
            ),
            body: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) => _tabController.animateTo(index),
              children: <Widget>[
                IndexComponent(),
                UserMissionComponent(),
                UserShareComponent(),
                UserProfileComponent(),
              ],
            ),
          ),
          FadeBox(
            animation: fadeScreenAnimation,
          )
        ],
      ),
    );
  }
}

class FadeBox extends AnimatedWidget {
  FadeBox({Key key, Animation<Color> animation}) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final Animation<Color> animation = listenable;
    return Hero(
      tag: "fade",
      child: new Container(
        width: animation.isCompleted ? 0.0 : screenSize.width,
        height: animation.isCompleted ? 0.0 : screenSize.height,
        decoration: new BoxDecoration(
          color: animation.value,
        ),
      ),
    );
  }
}
