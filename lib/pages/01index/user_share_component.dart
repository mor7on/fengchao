import 'package:fengchao/common/api/05_social_list_fun.dart';
import 'package:fengchao/pages/widgets/custom_loading_widget.dart';
import 'package:fengchao/pages/widgets/uni_media_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserShareComponent extends StatefulWidget {
  UserShareComponent({Key key}) : super(key: key);

  _UserShareComponentState createState() => _UserShareComponentState();
}

class _UserShareComponentState extends State<UserShareComponent> {
  String date;
  int page = 0;
  List _result;
  bool isTapDown = false;

  String timeToString(time) {
    var timeStr =
        "${time.year.toString()}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
    return timeStr;
  }

  // 滚动控制器
  RefreshController _refreshController;
  // 控制结束
  bool _enableControlFinish = false;

  @override
  initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
    // _scrollController = ScrollController();
    initUserData();
  }

  initUserData() async {
    await Future.delayed(Duration(milliseconds: 200), () async {
      var res = await getUserSocialList(params: {'page': 0, 'date': timeToString(new DateTime.now())});
      if (null != res) {
        _result = res;
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    print('重建UserShareComponent---------');
    return Scaffold(
      body: NestedScrollView(
        // physics: ClampingScrollPhysics(),
        headerSliverBuilder: _headerSliverBuilder,
        body: SmartRefresher(
          enablePullDown: false,
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
          onLoading: _refreshOnLoad,
          onRefresh: _refreshOnRefresh,
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 8.0),
            itemCount: _result == null || _result.length == 0 ? 1 : _result.length,
            itemBuilder: _sliverListDelegate,
            // physics: NeverScrollableScrollPhysics(),
          ),
        ),
      ),
    );
  }

  List<Widget> _headerSliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverPersistentHeader(
        delegate: SliverCustomHeaderDelegate(
            title: '蜂巢圈',
            collapsedHeight: 50,
            expandedHeight: 200,
            paddingTop: MediaQuery.of(context).padding.top,
            coverImgUrl: 'http://www.4u2000.com/h5/static/myshare.png'),
        pinned: true,
        floating: false,
      ),
    ];
  }

  Widget _sliverListDelegate(BuildContext context, int idx) {
    Widget child;
    if (_result == null) {
      child = Container(
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
      );
    } else if (_result.length == 0) {
      child = CustomEmptyWidget();
    } else {
      child = UniMediaListItem(
        title: '${_result[idx]['title']}',
        content: '${_result[idx]['content']}',
        imageUrl: _result[idx]['imageUrl'],
        isFavorite: true,
        onTapItem: () {
          Navigator.pushNamed(context, '/socialDetail', arguments: {'id': _result[idx]['id']});
        },
        onTapCancle: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('确定取消关注${_result[idx]['title']}'),
                actions: <Widget>[
                  FlatButton(
                    child: const Text('取消'),
                    onPressed: () {
                      Navigator.pop(context, 'cancle');
                    },
                  ),
                  FlatButton(
                    child: const Text('确认'),
                    onPressed: () {
                      Navigator.pop(context, 'confirm');
                      _cacleUserFollow(idx, _result[idx]['id']);
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    }
    return child;
  }

  void _cacleUserFollow(index, id) async {
    var res = await toCancleUserFollow(params: {'id': id});
    if (null != res) {
      if (res['data'] == true) {
        _result.removeAt(index);
        setState(() {});
      }
    }
  }

  Future<void> _refreshOnLoad() async {
    page += 1;
    var requestParams = {
      "date": date,
      "page": page,
    };
    await getUserSocialList(params: requestParams).then((v) {
      if (null != v) {
        List list = _result;
        list.addAll(v);
        setState(() {
          _result = list;
        });
        if (!_enableControlFinish) {
          _refreshController.loadComplete();
          if (v.length < 10) {
            _refreshController.loadNoData();
          }
        }
      }
    });
  }

  Future<void> _refreshOnRefresh() async {
    date = timeToString(new DateTime.now());
    page = 0;
    var requestParams = {
      "date": date,
      "page": page,
    };
    await Future.delayed(Duration(milliseconds: 300), () async {
      await getUserSocialList(params: requestParams).then((v) {
        if (null != v) {
          if (v.length > 0) {
            _result = v;
          } else {
            _result = [];
          }
          if (!_enableControlFinish) {
            _refreshController.refreshCompleted();
            _refreshController.resetNoData();
          }
        }
      });
      setState(() {
        // isTapDown = false;
      });
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}

class SliverCustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double collapsedHeight;
  final double expandedHeight;
  final double paddingTop;
  final String coverImgUrl;
  final String title;
  String statusBarMode = 'dark';

  SliverCustomHeaderDelegate({
    this.collapsedHeight,
    this.expandedHeight,
    this.paddingTop,
    this.coverImgUrl,
    this.title,
  });

  @override
  double get minExtent => this.collapsedHeight + this.paddingTop;

  @override
  double get maxExtent => this.expandedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  void updateStatusBarBrightness(shrinkOffset) {
    if (shrinkOffset > 50 && this.statusBarMode == 'light') {
      this.statusBarMode = 'dark';
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ));
    } else if (shrinkOffset <= 50 && this.statusBarMode == 'dark') {
      this.statusBarMode = 'light';
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ));
    }
  }

  Color makeStickyHeaderBgColor(shrinkOffset) {
    final int alpha = (shrinkOffset / (this.maxExtent - this.minExtent) * 255).clamp(0, 255).toInt();
    return Colors.amber.withAlpha(alpha);
  }

  Color makeStickyHeaderTextColor(shrinkOffset, isIcon) {
    if (shrinkOffset <= 50) {
      return isIcon ? Colors.white : Colors.transparent;
    } else {
      final int alpha = (shrinkOffset / (this.maxExtent - this.minExtent) * 255).clamp(0, 255).toInt();
      return Color.fromARGB(alpha, 0, 0, 0);
    }
  }

  Color makeStickyHeaderBottomTextColor(shrinkOffset, isIcon) {
    if (shrinkOffset <= 20) {
      return isIcon ? Colors.white : Colors.white;
    } else {
      final int alpha = ((1 - shrinkOffset / (this.maxExtent - this.minExtent)) * 255).clamp(0, 255).toInt();
      return Color.fromARGB(alpha, 255, 255, 255);
    }
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    this.updateStatusBarBrightness(shrinkOffset);
    return Container(
      height: this.maxExtent,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            child: Image.network(this.coverImgUrl, fit: BoxFit.cover),
          ),
          // Positioned(
          //   left: 0,
          //   top: 0,
          //   right: 0,
          //   bottom: 0,
          //   child: Container(
          //     decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         begin: Alignment.topCenter,
          //         end: Alignment.bottomCenter,
          //         colors: [
          //           Colors.amber,
          //           Color(0x00FFFFFF),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          Positioned(
            left: 16.0,
            bottom: 16.0,
            child: Container(
              child: Text(
                this.title,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.subhead.fontSize,
                  fontWeight: FontWeight.w500,
                  color: this.makeStickyHeaderBottomTextColor(shrinkOffset, false),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              color: this.makeStickyHeaderBgColor(shrinkOffset),
              child: SafeArea(
                bottom: false,
                child: Container(
                  height: this.collapsedHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // IconButton(
                      //   icon: Icon(
                      //     Icons.arrow_back_ios,
                      //     color: this.makeStickyHeaderTextColor(shrinkOffset, true),
                      //   ),
                      //   onPressed: () => Navigator.pop(context),
                      // ),
                      Text(
                        this.title,
                        style: TextStyle(
                          fontSize: Theme.of(context).textTheme.subhead.fontSize,
                          fontWeight: FontWeight.w500,
                          color: this.makeStickyHeaderTextColor(shrinkOffset, false),
                        ),
                      ),
                      // IconButton(
                      //   icon: Icon(
                      //     Icons.share,
                      //     color: this.makeStickyHeaderTextColor(shrinkOffset, true),
                      //   ),
                      //   onPressed: () {},
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
