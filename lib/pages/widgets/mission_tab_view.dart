import 'package:fengchao/common/api/03_mission_list_fun.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'loading_widget.dart';

class UserMissionTabComponent extends StatefulWidget {
  final int type;

  /// 控制器
  final MissionTabController missionTabController;

  UserMissionTabComponent({Key key, this.type, this.missionTabController}) : super(key: key);

  _UserMissionTabComponentState createState() => _UserMissionTabComponentState();
}

class _UserMissionTabComponentState extends State<UserMissionTabComponent> {
  String date;
  int page = 0;
  List _result;
  List<String> _tradeState = ['已报名待确认', '待提交成果', '待确认成果', '待甲方付款', '待确认收款', '已完成'];
  int _missionType = 0;

  String timeToString(time) {
    var timeStr =
        "${time.year.toString()}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
    return timeStr;
  }

  RefreshController _refreshController;
  // 控制结束
  bool _enableControlFinish = false;

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    initUserData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 绑定控制器
    if (widget.missionTabController != null) widget.missionTabController._bindMissionTabState(this);
  }

  initUserData() async {
    _result = null;
    await Future.delayed(Duration(milliseconds: 600), () async {
      date = timeToString(DateTime.now());
      var res = await getMissionByState(params: {'page': 0, 'date': date, 'type': _missionType}, state: widget.type);
      print(res);
      if (null != res) {
        _result = res['data'];
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  void _changeMissionState(int state) {
    _missionType = state;
    initUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: BezierCircleHeader(
        dismissType: BezierDismissType.ScaleToCenter,
      ),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text("上拉加载");
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text("加载失败，请重试");
          } else if (mode == LoadStatus.canLoading) {
            body = Text("释放加载");
          } else {
            body = Text("- END -");
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        itemCount: _result == null || _result.length == 0 ? 1 : _result.length,
        itemBuilder: _biuldWithContent,
        // physics: NeverScrollableScrollPhysics(),
      ),
      onRefresh: _onRefresh,
      onLoading: _onLoading,
    );
  }

  void _onLoading() async {
    page += 1;
    var requestParams = {
      "date": date,
      "page": page,
      'type': _missionType,
    };
    print(requestParams);
    await getMissionByState(params: requestParams, state: widget.type).then((v) {
      if (null != v) {
        List list = _result;
        list.addAll(v['data']);
        setState(() {
          _result = list;
        });
        if (!_enableControlFinish) {
          _refreshController.loadComplete();
          if (v['data'].length < 10) {
            _refreshController.loadNoData();
          }
        }
      }
    });
  }

  void _onRefresh() async {
    date = timeToString(new DateTime.now());
    page = 0;
    var requestParams = {
      "date": date,
      "page": page,
      'type': _missionType,
    };
    await Future.delayed(Duration(milliseconds: 600), () {
      getMissionByState(params: requestParams, state: widget.type).then((v) {
        if (null != v) {
          if (v['data'].length > 0) {
            setState(() {
              _result = v['data'];
            });
          } else {
            setState(() {
              _result = [];
            });
          }
          if (!_enableControlFinish) {
            _refreshController.refreshCompleted();
            _refreshController.resetNoData();
          }
        }
      });
    });
  }

  Widget _biuldWithContent(context, idx) {
    return _result == null
        ? loadWidget
        : _result.length > 0
            ? Card(
                child: ListTile(
                  contentPadding: EdgeInsets.all(8.0),
                  leading: Icon(
                    _result[idx]['trade'] == null || _result[idx]['trade']['type'] == 0
                        ? Icons.person_pin
                        : Icons.rotate_right,
                    color: _result[idx]['trade'] == null || _result[idx]['trade']['type'] == 0
                        ? Colors.grey
                        : Colors.green,
                    size: 40.0,
                  ),
                  title: Text(_result[idx]['post_title']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(_result[idx]['create_time']),
                      SizedBox(height: 8.0),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.amber),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0),
                              bottomRight: Radius.circular(5.0),
                            )),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              '任务状态：',
                              style: TextStyle(fontSize: 10.0, color: Colors.amber),
                            ),
                            Container(
                              child: Text(
                                _result[idx]['trade'] == null ? '暂无人报名' : _tradeState[_result[idx]['trade']['type']],
                                style: TextStyle(fontSize: 10.0, color: Colors.amber),
                              ),
                              // decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(5.0)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.navigate_next),
                  dense: true,
                  onTap: () {
                    Navigator.pushNamed(context, '/missionDetail', arguments: {'id': _result[idx]['id']});
                  },
                ),
              )
            : Container(
                width: double.infinity,
                height: 400.0,
                alignment: Alignment.center,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Expanded(flex: 1, child: SizedBox()),
                      Icon(Icons.cloud_off, size: 128.0, color: Colors.black12),
                      Text(
                        '暂无数据',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, color: Colors.black12),
                      ),
                      Expanded(flex: 1, child: SizedBox()),
                    ],
                  ),
                ),
              );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}

class MissionTabController {
  void changeMissionState(state) {
    if (this._missionTabState != null) {
      this._missionTabState._changeMissionState(state);
    }
  }

  // 状态
  _UserMissionTabComponentState _missionTabState;

  // 绑定状态
  void _bindMissionTabState(_UserMissionTabComponentState state) {
    this._missionTabState = state;
  }
}
