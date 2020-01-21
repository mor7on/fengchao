import 'package:fengchao/common/api/06_user_profile_fun.dart';
import 'package:fengchao/models/mine_share.dart';
import 'package:fengchao/pages/widgets/custom_loading_widget.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyShareComponent extends StatefulWidget {
  MyShareComponent({Key key}) : super(key: key);

  _MyShareComponentState createState() => _MyShareComponentState();
}

class _MyShareComponentState extends State<MyShareComponent> {
  int page = 0;
  List<MineShare> _result;

  RefreshController _refreshController;
  // 控制结束
  bool _enableControlFinish = false;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
    initUserData();
  }

  initUserData() async {
    await Future.delayed(Duration(milliseconds: 600), () async {
      var res = await getMyShareList(params: {'page': 0});
      if (null != res) {
        _result = res;
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: _headerSliverBuilder,
        body: Builder(
          builder: _mainBodyDelegate,
        ),
      ),
    );
  }

  Widget _mainBodyDelegate(BuildContext context) {
    return SmartRefresher(
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
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        itemCount: _result == null || _result.length == 0 ? 1 : _result.length,
        itemBuilder: _sliverListDelegate,
        // physics: NeverScrollableScrollPhysics(),
      ),
      onRefresh: () async {},
      onLoading: () async {
        page += 1;
        var requestParams = {
          "page": page,
        };
        print(requestParams);
        await getMyShareList(params: requestParams).then((v) {
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
      },
    );
  }

  Widget _sliverListDelegate(BuildContext context, int index) {
    Widget child;
    if (_result == null) {
      child = loadWidget;
    } else if (_result.length == 0) {
      child = CustomEmptyWidget();
    } else {
      child = Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: UserShareCard(
          userShare: _result[index],
          lastUserShareTime: index == 0 ? null : _result[index - 1].createTime,
        ),
      );
    }
    return child;
  }

  List<Widget> _headerSliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverPersistentHeader(
        delegate: SliverCustomHeaderDelegate(
            title: '我的分享',
            collapsedHeight: 50,
            expandedHeight: 200,
            paddingTop: MediaQuery.of(context).padding.top,
            coverImgUrl: 'http://www.4u2000.com/h5/static/together.jpg'),
        pinned: true,
        floating: false,
      ),
    ];
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
    return Color.fromARGB(alpha, 255, 255, 255);
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
            color: Colors.blueGrey,
            child: Image.network(this.coverImgUrl, fit: BoxFit.cover),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: this.makeStickyHeaderTextColor(shrinkOffset, true),
                          size: 20.0,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
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
                      //     size: 20.0,
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

class UserShareCard extends StatelessWidget {
  const UserShareCard({Key key, this.userShare, this.lastUserShareTime}) : super(key: key);
  final MineShare userShare;
  final String lastUserShareTime;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        lastUserShareTime == null || userShare.createTime.substring(0, 4) != lastUserShareTime.substring(0, 4)
            ? Container(
                width: 60.0,
                height: 30.0,
                color: Colors.black,
                alignment: Alignment.center,
                child: Text(userShare.createTime.substring(0, 4),
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white)),
              )
            : Container(),
        InkWell(
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(minHeight: 30.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 60.0,
                  alignment: Alignment.center,
                  child: Text(
                    lastUserShareTime != null &&
                            userShare.createTime.substring(5, 10) == lastUserShareTime.substring(5, 10)
                        ? ''
                        : userShare.createTime.substring(5, 10),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                userShare.imageList.length == 0
                    ? Container()
                    : Container(
                        width: 60.0,
                        height: 60.0,
                        margin: EdgeInsets.only(right: 5.0),
                        child: Image.network(
                          userShare.imageList[0],
                          fit: BoxFit.cover,
                        ),
                      ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: Text(userShare.postTitle, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          userShare.postContent,
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12.0, color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/articleDetail', arguments: {'id': userShare.id});
          },
        )
      ],
    );
  }
}
