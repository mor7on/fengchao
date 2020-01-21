import 'package:fengchao/common/api/06_user_profile_fun.dart';
import 'package:fengchao/models/article_model.dart';
import 'package:fengchao/pages/05social/social_aticle_item.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_loading_widget.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FriendsDynamicComponent extends StatefulWidget {
  final Map arguments;

  FriendsDynamicComponent({Key key, this.arguments}) : super(key: key);

  _FriendsDynamicComponentState createState() => _FriendsDynamicComponentState();
}

class _FriendsDynamicComponentState extends State<FriendsDynamicComponent> {
  List<ArticleModel> detail;
  String date;
  int page;
  bool isCateUser = false;

  String timeToString(time) {
    var timeStr =
        "${time.year.toString()}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
    return timeStr;
  }

  RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
    initUserData();
  }

  initUserData() async {
    page = 0;
    date = timeToString(new DateTime.now());
    // BotToast.showLoading();
    await Future.delayed(Duration(milliseconds: 600), () async {
      var res = await getMyFriendsDynamic(params: {'date': date, 'page': page});
      if (null != res) {
        detail = [];
        res['data'].forEach((v) {
          detail.add(new ArticleModel.fromJson(v));
        });
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _onRefresh() async {
    page = 0;
    var requestParams = {'date': date, 'page': page};
    await Future.delayed(Duration(milliseconds: 600), () {
      getMyFriendsDynamic(params: requestParams).then((res) {
        if (null != res) {
          detail = [];
          res['data'].forEach((v) {
            detail.add(new ArticleModel.fromJson(v));
          });
          setState(() {});
          _refreshController.refreshCompleted();
          _refreshController.resetNoData();
        }
      });
    });
  }

  Future<void> _onLoading() async {
    page += 1;
    var requestParams = {'date': date, 'page': page};
    await getMyFriendsDynamic(params: requestParams).then((res) {
      if (null != res) {
        res['data'].forEach((v) {
          detail.add(new ArticleModel.fromJson(v));
        });
        setState(() {});
        _refreshController.loadComplete();
        if (res['data'].length < 10) {
          _refreshController.loadNoData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('好友动态'),
        centerTitle: true,
      ),
      body: SmartRefresher(
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
        onLoading: _onLoading,
        onRefresh: _onRefresh,
        controller: _refreshController,
        child: _socialDetailBuilder(context),
      ),
    );
  }

  Widget _socialDetailBuilder(BuildContext context) {
    Widget child;
    if (detail == null) {
      child = loadWidget;
    } else if (detail.length == 0) {
      child = CustomEmptyWidget();
    } else {
      child = ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        itemCount: detail.length,
        itemBuilder: (BuildContext context, int index) {
          return SocialArticleItem(items: detail[index]);
        },
      );
    }
    return child;
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
