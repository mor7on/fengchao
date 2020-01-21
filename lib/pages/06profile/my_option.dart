import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/utils/sp_utils.dart';
import 'package:fengchao/models/home_red_dot.dart';
import 'package:fengchao/models/user_profile_model.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_listtile.dart';
import 'package:fengchao/pages/widgets/custom_radio_dialog.dart';
import 'package:fengchao/provider/app_state_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

enum Option {
  zh_CN,
  zh_TW,
  en_US,
}

class MyOptionComponent extends StatefulWidget {
  MyOptionComponent({Key key}) : super(key: key);

  _MyOptionComponentState createState() => _MyOptionComponentState();
}

class _MyOptionComponentState extends State<MyOptionComponent> {
  int _radioValue = 0;
  final List<String> language = ['简体中文', '繁體中文', 'ENGLISH'];

  final List<UserProfileModel> userOptionList = [
    UserProfileModel(title: "aboutUs", icon: 0xe722, description: "", showEnterIcon: true),
    UserProfileModel(title: "feedBack", icon: 0xe6f9, description: "", showEnterIcon: true),
    UserProfileModel(title: "invitationCode", icon: 0xe74d, description: "", showEnterIcon: true),
    UserProfileModel(title: "changeTheme", icon: 0xe740, description: "", showEnterIcon: true),
    UserProfileModel(title: "language", icon: 0xe6e1, description: "", showEnterIcon: true),
    UserProfileModel(title: "systemUpdate", icon: 0xe63e, description: "", showEnterIcon: true),
    UserProfileModel(title: "systemExit", icon: 0xe6f6, description: "", showEnterIcon: true),
  ];

  @override
  void initState() {
    super.initState();
    initUserData();
  }

  void initUserData() {
    String curlang = SpUtil.getString('xxLocale') ?? 'zh_CN';
    if (curlang == 'zh_CN') {
      _radioValue = 0;
    } else if (curlang == 'zh_TW') {
      _radioValue = 1;
    } else {
      _radioValue = 2;
    }
    userOptionList[4].description = language[_radioValue];
    if (mounted) {
      setState(() {});
    }
  }

  void onClickItem(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/aboutUs');
        break;
      case 1:
        Navigator.pushNamed(context, '/feedBack');
        break;
      case 2:
        print('invitationCode');
        break;
      case 3:
        Navigator.pushNamed(context, '/themeData');
        break;
      case 4:
        _openLanguageDialog();
        break;
      case 5:
        Navigator.pushNamed(context, '/appUpdate');
        break;
      case 6:
        _openExitDialog();
        break;
    }
  }

  Future _openLanguageDialog() async {
    showDemoDialog<int>(
      context: context,
      child: Dialog(
        child: CustomRadioDialog(
          title: Text('选择默认语言', style: TextStyle(fontSize: 18.0)),
          selected: _radioValue,
          body: language,
        ),
      ),
    );
  }

  Future _openExitDialog() async {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              '是否要退出系统？',
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('取消'),
                onPressed: () {
                  Navigator.pop(context, "cancel");
                },
              ),
              FlatButton(
                child: const Text('确定'),
                onPressed: () {
                  Navigator.pop(context, "confirm");
                },
              ),
            ],
          );
        }).then<void>((String value) async {
      // The value passed to Navigator.pop() or null.
      if (value != null) {
        if (value == "confirm") {
          SpUtil.clear();
          Provider.of<HomeRedDot>(context).stopTimer();
          BotToast.showLoading(duration: Duration(milliseconds: 300));
          Future.delayed(Duration(milliseconds: 300));
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => route == null);
        }
      }
    });
  }

  void showDemoDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) async {
      // The value passed to Navigator.pop() or null.
      if (value != null) {
        Locale kLocale;
        switch (value.toString()) {
          case '0':
            kLocale = Locale('zh', 'CN');
            break;
          case '1':
            kLocale = Locale('zh', 'TW');
            break;
          case '2':
            kLocale = Locale('en', 'US');
            break;
          default:
        }
        userOptionList[4].description = language[value as int];
        await FlutterI18n.refresh(context, kLocale);
        Provider.of<AppStateModel>(context).refreshLocale(kLocale);
        SpUtil.putString('xxLocale', kLocale.toString());
        setState(() {
          _radioValue = value as int;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('系统设置'),
        expandedHeight: 100.0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: _biuldUserOption(userOptionList),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _biuldUserOption(items) {
    List<Widget> list = new List();
    for (var i = 0; i < items.length; i++) {
      list.add(Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.all(5.0),
          margin: [2, 4].contains(i) ? EdgeInsets.only(bottom: 5.0) : EdgeInsets.only(bottom: 1.0),
          child: CustomListTile(
            onPressed: () {
              onClickItem(i);
            },
            itemTitle: items[i].title,
            itemIcon: items[i].icon,
            itemDescription: items[i].description,
            isShowEnterIcon: items[i].showEnterIcon,
          )));
    }

    return list;
  }
}
