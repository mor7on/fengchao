import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/06_user_profile_fun.dart';
import 'package:fengchao/common/utils/encrypt_helper.dart';
import 'package:fengchao/models/bank_card.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const double _kPickerSheetHeight = 216.0;
const double _kPickerItemHeight = 32.0;

class BindBankCardComponent extends StatefulWidget {
  BindBankCardComponent({Key key, this.arguments}) : super(key: key);
  final Map arguments;

  @override
  _BindBankCardComponentState createState() => _BindBankCardComponentState();
}

class _BindBankCardComponentState extends State<BindBankCardComponent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FixedExtentScrollController scrollController;
  int _selectedIndex;
  bool _autovalidate = false;
  bool _buttonState = true;
  String _cardOfName;
  String _cardNumber;
  String _cardOfBank;
  EncryptHelper _encryptHelper = EncryptHelper();

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    scrollController = FixedExtentScrollController(initialItem: _selectedIndex);
    _encryptHelper.init();
  }

  @override
  void dispose() {
    scrollController?.dispose();
    super.dispose();
  }

  String _validateName(String value) {
    if (value.isEmpty) return '收款人姓名不能为空';
    return null;
  }

  String _validateNumber(String value) {
    if (value.isEmpty) return '收款人卡号不能为空';
    return null;
  }

  void _handleSubmitted() {
    if (_buttonState == false) return;
    _buttonState = false;
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      _buttonState = true;
    } else {
      form.save();
      _doPublish();
    }
  }

  Future _doPublish() async {
    BotToast.showLoading(duration: Duration(milliseconds: 600));
    var res = await toBindBankCards(params: {
      'name': _encryptHelper.encode(_cardOfName),
      'bankcard': _encryptHelper.encode(_cardNumber),
      'bankcard_type': _cardOfBank,
    });
    print(res);
    await Future.delayed(Duration(milliseconds: 600));
    if (null != res) {
      if (res['data'] == true) {
        BotToast.showCustomLoading(
          duration: Duration(milliseconds: 300),
          toastBuilder: (cancelFunc) {
            return CustomToastWidget(title: '绑定成功', icon: Icons.done);
          },
        );
        await Future.delayed(Duration(milliseconds: 300));
        Navigator.of(context).pop(true);
      } else {
        _buttonState = true;
        BotToast.showText(text: res['msg'], textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
      }
    }
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
                          _cardOfBank = bankList[_selectedIndex].name;
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
          title: Text('绑定银行卡'),
        ),
        body: Form(
          key: _formKey,
          autovalidate: _autovalidate,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            children: <Widget>[
              Container(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: '收款人姓名',
                    hintText: '收款人姓名(不能为空)',
                    isDense: true,
                    alignLabelWithHint: true,
                  ),
                  maxLines: 1,
                  maxLength: 16,
                  style: TextStyle(fontSize: 14.0, height: 1.5, textBaseline: TextBaseline.alphabetic),
                  validator: _validateName,
                  onSaved: (val) {
                    _cardOfName = val;
                  },
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: '收款人卡号',
                    hintText: '收款人卡号(不能为空)',
                    isDense: true,
                    alignLabelWithHint: true,
                  ),
                  maxLines: 1,
                  maxLength: 16,
                  style: TextStyle(fontSize: 14.0, height: 1.5, textBaseline: TextBaseline.alphabetic),
                  validator: _validateNumber,
                  onSaved: (val) {
                    _cardNumber = val;
                  },
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                child: InkWell(
                  onTap: () async {
                    await showCupertinoModalPopup<void>(
                      context: context,
                      builder: (BuildContext context) {
                        scrollController = FixedExtentScrollController(initialItem: _selectedIndex);
                        return _buildBottomPicker(
                          title: '选择收款人银行',
                          picker: CupertinoPicker(
                            looping: true,
                            scrollController: scrollController,
                            itemExtent: _kPickerItemHeight,
                            backgroundColor: CupertinoColors.white,
                            onSelectedItemChanged: (int index) {
                              _selectedIndex = index;
                            },
                            children: List<Widget>.generate(bankList.length, (int index) {
                              return Center(
                                child: Text(bankList[index].name, style: TextStyle(fontSize: 16.0)),
                              );
                            }),
                          ),
                        );
                      },
                    );
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      // contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                      labelText: '收款人银行',
                      alignLabelWithHint: true,
                      isDense: true,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          _cardOfBank == null ? '选择收款人银行' : _cardOfBank,
                          style: TextStyle(fontSize: 14.0),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color:
                              Theme.of(context).brightness == Brightness.light ? Colors.grey.shade700 : Colors.white70,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  '提示：绑定的银行卡为提现时资金转入的银行卡，若因绑定错误导致提现失败或者造成资金损失，皆由您个人承担。',
                  style: TextStyle(fontSize: 14.0),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                width: double.infinity,
                height: 60.0,
                padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                child: FlatButton(
                  color: Colors.blue,
                  child: Text('提交', style: TextStyle(color: Colors.white)),
                  onPressed: _handleSubmitted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
