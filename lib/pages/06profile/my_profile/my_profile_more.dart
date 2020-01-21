import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/06_user_profile_fun.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_radio_dialog.dart';
import 'package:fengchao/pages/widgets/custom_toast.dart';
import 'package:fengchao/provider/login_user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const double _kPickerSheetHeight = 216.0;
const double _kPickerItemHeight = 32.0;

class MyProfileMoreComponent extends StatefulWidget {
  MyProfileMoreComponent({Key key, this.arguments}) : super(key: key);
  final Map arguments;

  @override
  _MyProfileMoreComponentState createState() => _MyProfileMoreComponentState();
}

class _MyProfileMoreComponentState extends State<MyProfileMoreComponent> {
  int _selectedIndusIndex;
  DateTime date;

  final List<String> indusNames = <String>[
    '保密',
    'IT|通信|互联网',
    '机械机电|自动化',
    '专业服务',
    '冶金冶炼|五金|采掘',
    '化工行业',
    '纺织服装|皮革鞋帽',
    '电子电器|仪器仪表',
    '快消品|办公用品',
    '房产|建筑|城建|环保',
    '金融行业',
    '制药|医疗',
    '生活服务|娱乐休闲',
    '交通工具|运输物流',
    '批发|零售|贸易',
    '广告|媒体',
    '教育|科研|培训',
    '造纸|印刷',
    '包装|工艺礼品|奢侈品',
    '营销|销售人员',
    '能源|资源',
    '农|林|牧|渔',
    '政府|非赢利机构',
    '其他',
  ];

  FixedExtentScrollController scrollController;

  String _timeToString(time) {
    var timeStr =
        "${time.year.toString()}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}";
    return timeStr;
  }

  int _radioValue = 0;

  Widget _buildBottomPicker({Widget picker, String title}) {
    return DefaultTextStyle(
      style: const TextStyle(
        color: CupertinoColors.black,
        fontSize: 16.0,
      ),
      child: Container(
        height: _kPickerSheetHeight + 50 + 1,
        color: CupertinoColors.white,
        child: Column(
          children: <Widget>[
            Container(
              height: 50.0,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(title),
                  ),
                  Container(
                    width: 60.0,
                    height: 32.0,
                    child: FlatButton(
                      padding: EdgeInsets.zero,
                      color: Colors.blue,
                      child: Text('确定'),
                      onPressed: () {
                        if (title == '选择所属行业') {
                          _doPublish({'user_industry_id': _selectedIndusIndex + 1});
                        } else {
                          _doPublish({'birthday': _timeToString(date)});
                        }
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            ),
            Divider(height: 1.0, thickness: 1.0),
            Container(
              height: _kPickerSheetHeight,
              padding: const EdgeInsets.only(top: 6.0),
              child: GestureDetector(
                // Blocks taps from propagating to the modal sheet and popping.
                onTap: () {},
                child: SafeArea(
                  top: false,
                  child: CupertinoTheme(
                    data: CupertinoTheme.of(context).copyWith(
                        textTheme: CupertinoTheme.of(context)
                            .textTheme
                            .copyWith(dateTimePickerTextStyle: TextStyle(fontSize: 16.0))),
                    child: picker,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showDemoDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {
      // The value passed to Navigator.pop() or null.
      if (value != null) {
        print('$value');
        setState(() {
          _radioValue = value as int;
        });
      }
      _doPublish({'sex': _radioValue});
    });
  }

  Future _doPublish(data) async {
    var res = await editUserInfo(params: data);
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
      } else {
        print('修改失败');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('用户设置'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Consumer<LoginUserModel>(
              builder: (context, model, _) {
                _radioValue = model.loginUser.sex;
                date = model.loginUser.birthday == null || model.loginUser.birthday == ''
                    ? DateTime.now()
                    : DateTime.parse(model.loginUser.birthday);
                _selectedIndusIndex = model.loginUser.userIndustryId - 1;
                return ListView(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  children: <Widget>[
                    ListTile(
                      dense: true,
                      title: Text('邮箱'),
                      subtitle: Text('设置您的电子邮箱'),
                      trailing: Container(
                        width: 180.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              child: Text(model.loginUser.userEmail??'未设置'),
                            ),
                            Icon(Icons.navigate_next)
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/myEmail').then((isRefresh) {
                          if (isRefresh == true) {
                            print('刷新用户头像');
                          }
                        });
                      },
                    ),
                    Divider(height: 10.0, thickness: 1.0),
                    ListTile(
                      dense: true,
                      title: Text('性别'),
                      subtitle: Text('设置您的性别'),
                      trailing: Container(
                        width: 180.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              child: Text(_radioValue == 0 ? '保密' : _radioValue == 1 ? '男士' : '女士'),
                            ),
                            Icon(Icons.navigate_next)
                          ],
                        ),
                      ),
                      onTap: () {
                        showDemoDialog<int>(
                          context: context,
                          child: Dialog(
                            child: CustomRadioDialog(
                              title: Text('选择您的性别', style: TextStyle(fontSize: 18.0)),
                              selected: _radioValue,
                              body: ['保密', '男士', '女士'],
                            ),
                          ),
                        );
                      },
                    ),
                    Divider(height: 10.0, thickness: 1.0),
                    ListTile(
                      dense: true,
                      title: Text('生日'),
                      subtitle: Text('设置您的生日'),
                      trailing: Container(
                        width: 180.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              child: Text(_timeToString(date)),
                            ),
                            Icon(Icons.navigate_next)
                          ],
                        ),
                      ),
                      onTap: () {
                        showCupertinoModalPopup<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return _buildBottomPicker(
                              title: '选择出生日期',
                              picker: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.date,
                                initialDateTime: date,
                                minimumYear: 1900,
                                use24hFormat: true,
                                onDateTimeChanged: (DateTime newDateTime) {
                                  setState(() => date = newDateTime);
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Divider(height: 10.0, thickness: 1.0),
                    ListTile(
                      dense: true,
                      title: Text('行业'),
                      subtitle: Text('设置您的行业'),
                      trailing: Container(
                        width: 180.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              child: Text(
                                indusNames[_selectedIndusIndex],
                              ),
                            ),
                            Icon(Icons.navigate_next)
                          ],
                        ),
                      ),
                      onTap: () async {
                        await showCupertinoModalPopup<void>(
                          context: context,
                          builder: (BuildContext context) {
                            scrollController = FixedExtentScrollController(initialItem: _selectedIndusIndex);
                            return _buildBottomPicker(
                              title: '选择所属行业',
                              picker: CupertinoPicker(
                                looping: true,
                                scrollController: scrollController,
                                itemExtent: _kPickerItemHeight,
                                backgroundColor: CupertinoColors.white,
                                onSelectedItemChanged: (int index) {
                                  setState(() => _selectedIndusIndex = index);
                                },
                                children: List<Widget>.generate(indusNames.length, (int index) {
                                  return Center(
                                    child: Text(indusNames[index], style: TextStyle(fontSize: 16.0)),
                                  );
                                }),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Divider(height: 10.0, thickness: 1.0),
                    ListTile(
                      dense: true,
                      title: Text('个人简介'),
                      subtitle: Text(
                        model.loginUser.introduction??'您还没有设置个人介绍',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Icon(Icons.navigate_next),
                      onTap: () {
                        Navigator.pushNamed(context, '/myIntro').then((isRefresh) {
                          if (isRefresh == true) {
                            print('刷新用户头像');
                          }
                        });
                      },
                    ),
                    Divider(height: 10.0, thickness: 1.0),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
