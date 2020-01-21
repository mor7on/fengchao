import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/03_mission_list_fun.dart';
import 'package:fengchao/common/api/http_request.dart';
import 'package:fengchao/models/category_model.dart';
import 'package:fengchao/pages/widgets/city_pickers/city_pickers.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_toast.dart';
import 'package:fengchao/pages/widgets/muti_image_upload.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const double _kPickerSheetHeight = 216.0;

class MissionPublishComponent extends StatelessWidget {
  const MissionPublishComponent({Key key}) : super(key: key);

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
          title: Text('任务信息发布'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.notifications),
              iconSize: 20.0,
              onPressed: () {
                BotToast.showSimpleNotification(title: '未认证用户！', subTitle: '未认证用户无法发布任务！是否现在完成认证？');
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: MissionForm(),
          ),
        ),
      ),
    );
  }
}

class MissionForm extends StatefulWidget {
  MissionForm({Key key}) : super(key: key);

  _MissionFormState createState() => _MissionFormState();
}

class _MissionFormState extends State<MissionForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _keywordsController = TextEditingController();
  // FocusNode focusNode = new FocusNode();
  DateTime date = DateTime.now();
  Result _targetCity;
  List<Category> _selectKeywords;
  List<int> _keywordsIds;
  int _missionType;
  List _imageUrls = [];
  bool _autovalidate = false;
  bool _buttonState = true;

  String _title, _content, _keywords, _postAddress, _expiredTime, _deposit, _postSalary;

  @override
  void initState() {
    super.initState();
    _missionType = 0;
    _keywords = '任务关键词...';
    _keywordsIds = [];
    _targetCity = new Result(cityName: '全国', cityId: '0');
    _initUserLocation();
  }

  Future _initUserLocation() async {
    _postAddress = await DioApi.getUserLocation();
  }

  String _timeToString(time) {
    var timeStr =
        "${time.year.toString()}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} 23:59:59";
    return timeStr;
  }

  void onUploadImages(urls) {
    _imageUrls = urls;
    print(_imageUrls);
  }

  String _validateTitle(String value) {
    if (value.isEmpty) return '任务标题不能为空';
    return null;
  }

  String _validateContent(String value) {
    if (value.isEmpty) return '任务描述不能为空';
    return null;
  }

  String _validatePostSalary(String value) {
    if (_missionType == 0 && value.isEmpty) return '任务佣金不能为空';
    if (value.isNotEmpty) {
      double money = double.tryParse(value);
      if (money == null) {
        return '输入错误';
      }
      if (money < 10.0) return '佣金不能小于10元';
    }
    return null;
  }

  String _validateDeposit(String value) {
    if (_missionType == 1 && value.isEmpty) return '任务保证金不能为空';
    if (value.isNotEmpty) {
      double money = double.tryParse(value);
      if (money == null) {
        return '输入错误';
      }
      if (money < 10.0) return '保证金不能小于10元';
    }
    return null;
  }

  String _validateKeywords(String value) {
    if (value.isEmpty) return '关键词不能为空';
    return null;
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      BotToast.showText(text: "输入有误，请重新输入", textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
    } else {
      form.save();
      _buttonState = false;
      _doPublish();
    }
  }

  Future _doPublish() async {
    print(_deposit);
    Map res = await addMission(params: {
      'post_title': _title,
      'post_content': _content,
      'area_id': _targetCity.cityId == '0' ? null : _targetCity.cityId,
      'post_keywords': _keywords,
      'post_address': _postAddress,
      'expired_time': _expiredTime, // 过期时间
      'deposit': _deposit.isEmpty ? null : double.parse(_deposit).toStringAsFixed(2), // 保证金
      'post_salary': _missionType == 0 ? double.parse(_postSalary).toStringAsFixed(2) : null, // 任务佣金
      'type': _missionType, // 任务类型  明标0，暗标1
      'more': jsonEncode({'photos': _imageUrls}),
    });
    print(res);

    /// {code: 1, msg: 添加成功, data: {msg: 添加成功, type: 2}}
    /// {code: 1, msg: null, data: {msg: 内容有误, type: 0}}
    /// type: 1余额不足,2发布成功...,3未认证用户！
    if (null != res) {
      if (res['data']['type'] == '2') {
        BotToast.showCustomLoading(
          duration: Duration(milliseconds: 2000),
          toastBuilder: (cancelFunc) {
            return CustomToastWidget(title: '发布成功', icon: Icons.done);
          },
        );
        await Future.delayed(Duration(milliseconds: 2000));
        Navigator.of(context).pop(true);
      } else if (res['data']['type'] == '1') {
        BotToast.showSimpleNotification(title: '余额不足！', subTitle: '由于您账户余额不足，无法使用保证金');
      } else if (res['data']['type'] == '3') {
        BotToast.showSimpleNotification(title: '未认证用户！', subTitle: '未认证用户无法发布任务！请先完成实名认证');
      } else {
        BotToast.showSimpleNotification(title: '内容有误！', subTitle: '任务过期时间小于当前时间');
      }
    }
    setState(() {
      _buttonState = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .copyWith(inputDecorationTheme: InputDecorationTheme(hintStyle: TextStyle(fontSize: 14.0, height: 1.5))),
      child: Form(
        key: _formKey,
        autovalidate: _autovalidate,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
              color: Colors.blue[50],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 120.0,
                    child: RadioListTile(
                      value: 0,
                      groupValue: _missionType,
                      title: Text('明标'),
                      dense: true,
                      onChanged: (val) {
                        setState(() {
                          _missionType = val;
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 120.0,
                    child: RadioListTile(
                      value: 1,
                      groupValue: _missionType,
                      title: Text('暗标'),
                      dense: true,
                      onChanged: (val) {
                        setState(() {
                          _missionType = val;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Container(
            //     padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
            //     child: Text('任务标题(不能为空)：', style: TextStyle(fontSize: 14.0))),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: '任务标题',
                  hintText: '任务标题(不能为空)',
                  isDense: true,
                  alignLabelWithHint: true,
                ),
                maxLines: 1,
                style: TextStyle(fontSize: 14.0, height: 1.5, textBaseline: TextBaseline.alphabetic),
                validator: _validateTitle,
                onSaved: (val) {
                  _title = val;
                },
              ),
            ),
            // SizedBox(
            //   height: 3.0,
            // ),
            _missionType == 0
                ? Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: '任务佣金',
                        hintText: '输入本任务的佣金',
                        isDense: true,
                        prefix: Text('¥ ', style: TextStyle(fontSize: 20.0)),
                        suffix: Text('CNY', style: TextStyle(fontSize: 20.0, color: Colors.blueAccent)),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 1,
                      style: TextStyle(fontSize: 14.0, height: 1.5, textBaseline: TextBaseline.alphabetic),
                      validator: _validatePostSalary,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter(RegExp(r'^(([1-9]{1}\d*)|(0{1}))([\.]?)(\d{1,2})?$')), //只输入数字
                      ],
                      onSaved: (val) {
                        _postSalary = val;
                      },
                      // onTap: () async {
                      //   // 触摸收起键盘
                      //   FocusScope.of(context).requestFocus(FocusNode());
                      //   await Future.delayed(Duration(milliseconds: 300));
                      //   FocusScope.of(context).requestFocus(focusNode);
                      // },
                    ),
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
              child: TextFormField(
                // focusNode: focusNode,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: '保证金',
                  hintText: '添加保证金须保证账户有足够余额',
                  isDense: true,
                  prefix: Text('¥ ', style: TextStyle(fontSize: 20.0)),
                  suffix: Text('CNY', style: TextStyle(fontSize: 20.0, color: Colors.blueAccent)),
                  alignLabelWithHint: true,
                ),
                maxLines: 1,
                style: TextStyle(fontSize: 14.0, height: 1.5, textBaseline: TextBaseline.alphabetic),
                validator: _validateDeposit,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter(RegExp(r'^(([1-9]{1}\d*)|(0{1}))([\.]?)(\d{1,2})?$')), //只输入数字
                ],
                onSaved: (val) {
                  _deposit = val;
                },
                // onTap: () async {
                //   // 触摸收起键盘
                //   FocusScope.of(context).requestFocus(FocusNode());
                //   await Future.delayed(Duration(milliseconds: 300));
                //   FocusScope.of(context).requestFocus(focusNode);
                // },
              ),
            ),
            // SizedBox(
            //   height: 3.0,
            // ),
            // Container(
            //     padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
            //     child: Text('关键词(不能为空)：', style: TextStyle(fontSize: 14.0))),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
              child: Stack(
                children: <Widget>[
                  TextFormField(
                    controller: _keywordsController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: '关键词',
                      hintText: '请输入关键词，用逗号隔开...',
                      isDense: true,
                      alignLabelWithHint: true,
                    ),
                    maxLines: 1,
                    style: TextStyle(fontSize: 14.0, height: 1.5, textBaseline: TextBaseline.alphabetic),
                    validator: _validateKeywords,
                    onSaved: (val) {
                      _keywords = val;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      child: IconButton(
                        icon: Icon(Icons.navigate_next),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pushNamed(context, '/popKeywords', arguments: {'ids': _keywordsIds}).then((res) {
                            List<Category> tempResult = res;
                            // print(tempResult[0].toString());
                            if (tempResult == null || tempResult.length == 0) {
                              return;
                            } else {
                              _selectKeywords = tempResult;
                              List<String> keyordsList = [];
                              for (var i = 0; i < tempResult.length; i++) {
                                keyordsList.add(tempResult[i].title);
                              }
                              _keywordsController.text = keyordsList.join(',');
                              setState(() {});
                            }
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            // SizedBox(
            //   height: 3.0,
            // ),
            // Container(
            //   padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
            //   child: Text('任务描述(不能为空)：', style: TextStyle(fontSize: 14.0)),
            // ),
            Container(
              color: Colors.blue[50],
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                title: Text(
                  '过期时间',
                  style: TextStyle(fontSize: 14.0),
                ),
                subtitle: Text('任务过期后将无法继续报名'),
                trailing: Container(
                  width: 140.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        child: Text(_expiredTime == null ? '' : _expiredTime.split(' ')[0]),
                      ),
                      Container(
                        width: 50.0,
                        child: Icon(Icons.navigate_next),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  showCupertinoModalPopup<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return _buildBottomPicker(
                        title: '选择过期时间',
                        picker: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: date,
                          minimumYear: 1900,
                          use24hFormat: true,
                          onDateTimeChanged: (DateTime newDateTime) {
                            date = newDateTime;
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Divider(
              height: 1.0,
              thickness: 1.0,
              color: Colors.grey,
              indent: 20.0,
              endIndent: 20.0,
            ),
            Container(
              color: Colors.blue[50],
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                title: Text(
                  '区域限制',
                  style: TextStyle(fontSize: 14.0),
                ),
                subtitle: Text('限制任务接取人区域'),
                trailing: Container(
                  width: 150.0,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 100.0,
                        child: Text(
                          _targetCity?.cityName ?? '全国',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Container(
                        width: 50.0,
                        child: Icon(Icons.navigate_next),
                      )
                    ],
                  ),
                ),
                onTap: _showCityPicker,
              ),
            ),
            Divider(
              height: 1.0,
              thickness: 1.0,
              color: Colors.grey,
              indent: 20.0,
              endIndent: 20.0,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: '任务简要说明（例如：需要什么样的技术人员，做什么样的工作...）',
                  helperText: '请简要描述任务要求',
                  labelText: '任务描述',
                  isDense: true,
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                maxLength: 2000,
                style: TextStyle(fontSize: 14.0, height: 1.5, textBaseline: TextBaseline.alphabetic),
                validator: _validateContent,
                onSaved: (val) {
                  _content = val;
                },
              ),
            ),
            SizedBox(
              height: 3.0,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    child: Text('产品图片：', style: TextStyle(fontSize: 14.0)),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: MutiImageUploadComponent(
                      onChanged: onUploadImages,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 3.0,
            ),
            Container(
              width: double.infinity,
              height: 60.0,
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              child: FlatButton(
                color: Colors.blue,
                disabledColor: Colors.grey[300],
                disabledTextColor: Colors.grey[700],
                child: Text('提交', style: TextStyle(color: Colors.white)),
                onPressed: _buttonState ? _handleSubmitted : null,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _showCityPicker() async {
    Result result = await CityPickers.showCitiesSelector(context: context, title: '城市选择', hotCities: [
      HotCity(name: '全国', id: 100000),
      HotCity(name: '北京市', id: 110000),
      HotCity(name: '天津市', id: 120000),
      HotCity(name: '河北省', id: 130000),
      HotCity(name: '山西省', id: 140000),
      HotCity(name: '内蒙古自治区', id: 150000),
      HotCity(name: '辽宁省', id: 210000),
      HotCity(name: '吉林省', id: 220000),
      HotCity(name: '黑龙江省', id: 230000),
      HotCity(name: '上海市', id: 310000),
      HotCity(name: '江苏省', id: 320000),
      HotCity(name: '浙江省', id: 330000),
      HotCity(name: '安徽省', id: 340000),
      HotCity(name: '福建省', id: 350000),
      HotCity(name: '江西省', id: 360000),
      HotCity(name: '山东省', id: 370000),
      HotCity(name: '河南省', id: 410000),
      HotCity(name: '湖北省', id: 420000),
      HotCity(name: '湖南省', id: 430000),
      HotCity(name: '广东省', id: 440000),
      HotCity(name: '广西壮族自治区', id: 450000),
      HotCity(name: '海南省', id: 460000),
      HotCity(name: '重庆市', id: 500000),
      HotCity(name: '四川省', id: 510000),
      HotCity(name: '贵州省', id: 520000),
      HotCity(name: '云南省', id: 530000),
      HotCity(name: '西藏自治区', id: 540000),
      HotCity(name: '陕西省', id: 610000),
      HotCity(name: '甘肃省', id: 620000),
      HotCity(name: '青海省', id: 630000),
      HotCity(name: '宁夏回族自治区', id: 640000),
      HotCity(name: '新疆维吾尔自治区', id: 650000),
      HotCity(name: '台湾省', id: 710000),
      HotCity(name: '香港特别行政区', id: 810000),
      HotCity(name: '澳门特别行政区', id: 820000),
      HotCity(name: '广州市', id: 440100),
      HotCity(name: '深圳市', id: 440300)
    ]);
    print(result);
    setState(() {
      _targetCity = result;
    });
  }

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
                        setState(() {
                          _expiredTime = _timeToString(date);
                        });
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
}
