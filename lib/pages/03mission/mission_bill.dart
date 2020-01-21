import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/03_mission_list_fun.dart';
import 'package:fengchao/common/utils/sp_utils.dart';
import 'package:fengchao/models/article_model.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_toast.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:fengchao/provider/mission_steps_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MissionBillComponent extends StatefulWidget {
  MissionBillComponent({Key key, this.arguments}) : super(key: key);
  final Map<String, dynamic> arguments;

  @override
  _MissionBillComponentState createState() => _MissionBillComponentState();
}

class _MissionBillComponentState extends State<MissionBillComponent> {
  Map<String, dynamic> _billInfo;
  Map<String, dynamic> _tradeInfo;
  final String _rule = '关于保证金：\n保证金在乙方确认收款后自动退回甲方账户，若乙方未确认收款，也未在五个工作日内提起申诉，保证金将在甲方付款五个工作日后退回甲方账户。';

  int _loginId = SpUtil.getInt('xxUserId');
  // int _loginId = 3;

  bool _isPostUser;
  bool _isReceivables;
  bool _buttonState = true;
  ArticleModel _missionInfo;

  @override
  void initState() {
    _missionInfo = widget.arguments['missionInfo'];
    _tradeInfo = widget.arguments['tradeInfo'];
    initUserData();
    super.initState();
  }

  void initUserData() async {
    print(widget.arguments);
    var res = await getTradeBill(params: {'trade_id': _tradeInfo['id']});
    print(res);
    if (null != res) {
      _billInfo = res['data'];
      _isPostUser = _loginId == _billInfo['payment_id'];
      _isReceivables = _loginId == _billInfo['receivables_id'];
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future _handleConfirm() async {
    if (_buttonState = false) return;
    _buttonState = false;
    var res = await toConfirmPayment(params: {'trade_id': _tradeInfo['id']});
    print(res);
    // 确定付款操作
    if (null != res) {
      if (res['data'] == true) {
        BotToast.showLoading(duration: Duration(milliseconds: 500));
        Provider.of<StepperModel>(context).initMissionSteps();
        await Future.delayed(Duration(milliseconds: 500));
        BotToast.showCustomLoading(
          duration: Duration(milliseconds: 300),
          toastBuilder: (cancelFunc) {
            return CustomToastWidget(title: '确认支付', icon: Icons.done);
          },
        );
        await Future.delayed(Duration(milliseconds: 300));
        Navigator.pop(context);
      }
    }
  }

  Future _handlePayment() async {
    Navigator.pushNamed(context, '/missionPayment', arguments: {'billInfo': _billInfo, 'trade_id': _tradeInfo['id']})
        .then((isRefresh) {
      if (isRefresh == true) {
        setState(() {
          _billInfo = null;
        });
        initUserData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('任务账单'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: _billInfo == null
            ? loadWidget
            : Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      _rule,
                      style: TextStyle(fontSize: 13.0),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Card(
                    elevation: 0.0,
                    margin: EdgeInsets.zero,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    height: 40.0,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${_missionInfo.postTitle}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.navigate_next,
                                  size: 20.0,
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, '/missionDetail', arguments: {'id': _missionInfo.id});
                            },
                          ),
                          Container(
                            child: Text(
                              '账单编号：${_billInfo['number']}',
                              style: TextStyle(fontSize: 12.0, color: Colors.grey),
                            ),
                          ),
                          Divider(),
                          Container(
                            width: double.infinity,
                            height: 40.0,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '任务佣金：',
                              style: TextStyle(fontSize: 14.0, color: Colors.grey),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${_billInfo['coin']} CNY',
                              style: TextStyle(fontSize: 24.0, color: Colors.green),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 40.0,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '任务保金：',
                                    style: TextStyle(fontSize: 14.0, color: Colors.grey),
                                  ),
                                ),
                                Text(
                                  '${_missionInfo.bail == null || _missionInfo.bail.coin == null ? "0.00" : _missionInfo.bail.coin} CNY',
                                  style: TextStyle(fontSize: 14.0, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 40.0,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '支付状态：',
                                    style: TextStyle(fontSize: 14.0, color: Colors.grey),
                                  ),
                                ),
                                Text(
                                  _billInfo['state'] == 1 ? '已支付' : '未支付',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 40.0,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '乙方实收：',
                                    style: TextStyle(fontSize: 14.0, color: Colors.grey),
                                  ),
                                ),
                                Text(
                                  _billInfo['coin'] + ' CNY',
                                  style: TextStyle(fontSize: 14.0, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Consumer<StepperModel>(
                    builder: (context,model,_){
                      if (model.tradeInfo['type'] == 3) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(0.0),
                          child: RaisedButton(
                            color: Colors.blue,
                            elevation: 0.0,
                            child: _isPostUser
                                ? Text('去付款', style: TextStyle(color: Colors.white))
                                : Text('待付款', style: TextStyle(color: Colors.white)),
                            onPressed: _isPostUser ? _handlePayment : null,
                          ),
                        );
                      }
                      if (model.tradeInfo['type'] == 4) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(0.0),
                          child: RaisedButton(
                            color: Colors.blue,
                            elevation: 0.0,
                            child: _isReceivables
                                ? Text('确认收款', style: TextStyle(color: Colors.white))
                                : Text('待确认收款', style: TextStyle(color: Colors.white)),
                            onPressed: _isReceivables ? _handleConfirm : null,
                          ),
                        );
                      }
                      if (model.tradeInfo['type'] == 5) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(0.0),
                          child: RaisedButton(
                            color: Colors.blue,
                            elevation: 0.0,
                            child: Text('已确认收款', style: TextStyle(color: Colors.white)),
                            onPressed: null,
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
