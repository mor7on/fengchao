import 'package:fengchao/common/api/06_user_profile_fun.dart';
import 'package:fengchao/common/config/config.dart';
import 'package:fengchao/models/bill.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class MyBillComponent extends StatefulWidget {
  MyBillComponent({Key key}) : super(key: key);

  @override
  _MyBillComponentState createState() => _MyBillComponentState();
}

class _MyBillComponentState extends State<MyBillComponent> {
  DateTime _fromDate;
  DateTime _toDate = DateTime.now();
  List<Bill> _myBill;

  List<String> _userList = ['支出', '支出', '支出', '支出', '支出', '支出'];

  @override
  void initState() {
    super.initState();
    _fromDate = DateTime(_toDate.year, _toDate.month, 1);
    initUserData();
  }

  // <text v-if="value.type == 1">充值</text>
  // <text v-if="value.type == 2">收入</text>
  // <text v-if="value.type == 3">支出</text>
  // <text v-if="value.type == 4">提现</text>

  void initUserData() async {
    String start = timeToString(_fromDate);
    String end = timeToString(_toDate);
    var res = await getMyBillList(params: {'starttime': start, 'endtime': end});
    print(res);
    if (null != res) {
      _myBill = [];
      for (var item in res['data']) {
        _myBill.add(Bill.fromJson(item));
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  String timeToString(time) {
    var timeStr =
        "${time.year.toString()}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
    return timeStr;
  }

  String timeToShort(String time) {
    var short = time.substring(5, 10).replaceAll(RegExp(r'-'), '/');
    return short;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('我的账单'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 16.0,
          ),
          Row(
            children: <Widget>[
              _DateTimePicker(
                labelText: '从：',
                selectedDate: _fromDate,
                selectDate: (DateTime date) {
                  setState(() {
                    _fromDate = date;
                  });
                },
              ),
              _DateTimePicker(
                labelText: '至：',
                selectedDate: _toDate,
                selectDate: (DateTime date) {
                  setState(() {
                    _toDate = date;
                  });
                },
              ),
              Container(
                child: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          Expanded(
            child: _myBill == null
                ? loadWidget
                : ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    itemCount: _myBill.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            dense: true,
                            leading: Text(timeToShort(_myBill[index].createTime)),
                            title: Text(_myBill[index].operation),
                            trailing: Builder(
                              builder: (context) {
                                String prefix;
                                Color textColor;
                                if (_myBill[index].type == 1 || _myBill[index].type == 2) {
                                  prefix = '+';
                                  textColor = Colors.green;
                                } else {
                                  prefix = '-';
                                  textColor = Colors.black;
                                }
                                return Text(
                                  prefix + _myBill[index].coin,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: textColor,
                                  ),
                                );
                              },
                            ),
                          ),
                          Divider(),
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

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectedTime,
    this.selectDate,
    this.selectTime,
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) selectTime(picked);
  }

  String _timeToString(time) {
    var timeStr =
        "${time.year.toString()}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}";
    return timeStr;
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.body1;
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: _InputDropdown(
          labelText: labelText,
          valueText: _timeToString(selectedDate),
          valueStyle: valueStyle,
          onPressed: () {
            _selectDate(context);
          },
        ),
      ),
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown({
    Key key,
    this.child,
    this.labelText,
    this.valueText,
    this.valueStyle,
    this.onPressed,
  }) : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          border: InputBorder.none,
          fillColor: Colors.grey[200],
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
          alignLabelWithHint: true,
          prefixText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: valueStyle),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade700 : Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}
