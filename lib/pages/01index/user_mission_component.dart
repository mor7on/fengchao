import 'package:fengchao/common/api/03_mission_list_fun.dart';
import 'package:fengchao/common/utils/common_utils.dart';
import 'package:fengchao/models/article_model.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_media_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserMissionComponent extends StatefulWidget {
  UserMissionComponent({Key key}) : super(key: key);

  _UserMissionComponentState createState() => _UserMissionComponentState();
}

class _UserMissionComponentState extends State<UserMissionComponent> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(FlutterI18n.translate(context, "missionTitle")),
      ),
      body: UserMissionTabComponent(type: 0),
    );
  }
}

class UserMissionTabComponent extends StatefulWidget {
  final int type;
  UserMissionTabComponent({Key key, this.type}) : super(key: key);

  _UserMissionTabComponentState createState() => _UserMissionTabComponentState();
}

class _UserMissionTabComponentState extends State<UserMissionTabComponent> {
  String date;
  int page = 0;
  List<ArticleModel> _result;

  RefreshController _refreshController;
  // 控制结束
  bool _enableControlFinish = false;

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    initUserData();
    super.initState();
  }

  initUserData() async {
    await Future.delayed(Duration(milliseconds: 200), () async {
      var res = await getMissionByState(
          params: {'page': 0, 'date': CommonUtils.timeToString(new DateTime.now())}, state: widget.type);
      if (null != res) {
        _result = [];
        res['data'].forEach((v) {
          _result.add(new ArticleModel.fromJson(v));
        });
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    print('重建UserMissionComponent---------');
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

  void _onRefresh() async {
    date = CommonUtils.timeToString(new DateTime.now());
    page = 0;
    var requestParams = {
      "date": date,
      "page": page,
    };
    await Future.delayed(Duration(milliseconds: 600), () {
      getMissionByState(params: requestParams, state: widget.type).then((res) {
        if (null != res) {
          _result = [];
          if (res['data'].length > 0) {
            res['data'].forEach((v) {
              _result.add(new ArticleModel.fromJson(v));
            });
          }
          setState(() {});
          if (!_enableControlFinish) {
            _refreshController.refreshCompleted();
            _refreshController.resetNoData();
          }
        }
      });
    });
  }

  void _onLoading() async {
    page += 1;
    var requestParams = {
      "date": date,
      "page": page,
    };
    print(requestParams);
    await getMissionByState(params: requestParams, state: widget.type).then((res) {
      if (null != res) {
        res['data'].forEach((v) {
          _result.add(new ArticleModel.fromJson(v));
        });
        setState(() {});
        if (!_enableControlFinish) {
          _refreshController.loadComplete();
          if (res['data'].length < 10) {
            _refreshController.loadNoData();
          }
        }
      }
    });
  }

  Widget _biuldWithContent(context, idx) {
    return _result == null
        ? Container(
            width: double.infinity,
            height: 500.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 50.0,
                  height: 50.0,
                  child: SpinKitCircle(
                    color: Colors.blue,
                    size: 25.0,
                  ),
                ),
                Container(
                  child: Text(FlutterI18n.translate(context, 'loading'),
                      style: TextStyle(fontSize: 12.0, color: Color(0xFF999999))),
                )
              ],
            ),
          )
        : _result.length > 0
            ? CustomMediaCard(
                item: _result[idx],
                navigatorName: '/missionDetail',
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
                    Text('暂无数据', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, color: Colors.black12)),
                    Expanded(flex: 1, child: SizedBox()),
                  ],
                )),
              );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
