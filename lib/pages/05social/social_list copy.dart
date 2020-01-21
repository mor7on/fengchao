//import 'dart:convert';
//import 'dart:io';

import 'dart:math' as math;

import 'package:fengchao/common/api/05_social_list_fun.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_loading_widget.dart';
import 'package:fengchao/pages/widgets/fade_in_utf8list.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Category {
  Category({this.title, this.categoryId, this.selected});
  final String title;
  final int categoryId;
  bool selected;
  @override
  String toString() => '$runtimeType("$title")';
}

List<Category> allCategories = <Category>[
  Category(
    title: '全部分类',
    categoryId: 0,
    selected: true,
  ),
  Category(
    title: '社会',
    categoryId: 1,
    selected: false,
  ),
  Category(
    title: '军事',
    categoryId: 2,
    selected: false,
  ),
  Category(
    title: '文学',
    categoryId: 3,
    selected: false,
  ),
  Category(
    title: '情感',
    categoryId: 4,
    selected: false,
  ),
  Category(
    title: '游戏',
    categoryId: 5,
    selected: false,
  ),
  Category(
    title: '娱乐',
    categoryId: 6,
    selected: false,
  ),
  Category(
    title: '体育',
    categoryId: 7,
    selected: false,
  ),
  Category(
    title: '互联网',
    categoryId: 8,
    selected: false,
  ),
  Category(
    title: '生活',
    categoryId: 9,
    selected: false,
  ),
  Category(
    title: '财经',
    categoryId: 10,
    selected: false,
  ),
  Category(
    title: '教育',
    categoryId: 11,
    selected: false,
  ),
  Category(
    title: '汽车',
    categoryId: 12,
    selected: false,
  ),
  Category(
    title: '健康',
    categoryId: 13,
    selected: false,
  ),
  Category(
    title: '传媒',
    categoryId: 14,
    selected: false,
  ),
  Category(
    title: '房产',
    categoryId: 15,
    selected: false,
  ),
  Category(
    title: '数码',
    categoryId: 16,
    selected: false,
  ),
  Category(
    title: '职场',
    categoryId: 17,
    selected: false,
  ),
  Category(
    title: '学术',
    categoryId: 18,
    selected: false,
  ),
  Category(
    title: '艺术',
    categoryId: 19,
    selected: false,
  ),
  Category(
    title: '科技',
    categoryId: 20,
    selected: false,
  ),
  Category(
    title: '综合',
    categoryId: 21,
    selected: false,
  ),
  Category(
    title: '地区',
    categoryId: 22,
    selected: false,
  ),
  Category(
    title: '电影',
    categoryId: 23,
    selected: false,
  ),
  Category(
    title: '电视',
    categoryId: 24,
    selected: false,
  ),
  Category(
    title: '动漫',
    categoryId: 25,
    selected: false,
  ),
  Category(
    title: '制造',
    categoryId: 26,
    selected: false,
  ),
];

// One BackdropPanel is visible at a time. It's stacked on top of the
// the BackdropDemo.
class BackdropPanel extends StatelessWidget {
  const BackdropPanel({
    Key key,
    this.onTap,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.title,
    this.child,
  }) : super(key: key);

  final VoidCallback onTap;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;
  final Widget title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      elevation: 2.0,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragUpdate: onVerticalDragUpdate,
            onVerticalDragEnd: onVerticalDragEnd,
            onTap: onTap,
            child: Container(
              height: 48.0,
              padding: const EdgeInsetsDirectional.only(start: 16.0),
              alignment: AlignmentDirectional.centerStart,
              child: DefaultTextStyle(
                style: theme.textTheme.subhead,
                child: Tooltip(
                  message: 'Tap to dismiss',
                  child: title,
                ),
              ),
            ),
          ),
          const Divider(height: 1.0),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// Cross fades between 'Select a Category' and 'Asset Viewer'.
class BackdropTitle extends AnimatedWidget {
  const BackdropTitle({
    Key key,
    Listenable listenable,
    this.voidCallback,
  }) : super(key: key, listenable: listenable);

  final VoidCallback voidCallback;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return DefaultTextStyle(
      style: Theme.of(context).primaryTextTheme.subhead,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      child: Row(
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.centerStart,
            children: <Widget>[
              Opacity(
                opacity: CurvedAnimation(
                  parent: ReverseAnimation(animation),
                  curve: const Interval(0.5, 1.0),
                ).value,
                child: const Text('选择分类'),
              ),
              Opacity(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0.5, 1.0),
                ).value,
                child: Text('蜂巢圈'),
              ),
            ],
          ),
          Expanded(child: Container()),
          Opacity(
            opacity: CurvedAnimation(
              parent: ReverseAnimation(animation),
              curve: const Interval(0.5, 1.0),
            ).value,
            child: IconButton(
              icon: Icon(Icons.check),
              onPressed: voidCallback,
            ),
          ),
        ],
      ),
    );
  }
}

List<IntSize> _createSizes(int count) {
  math.Random rnd = new math.Random();
  return new List.generate(count, (i) => new IntSize(180, rnd.nextInt(10) * 10 + 150));
}

class SocialListComponent extends StatefulWidget {
  SocialListComponent({Key key}) : super(key: key);

  _SocialListComponentState createState() => _SocialListComponentState();
}

class _SocialListComponentState extends State<SocialListComponent> with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'BackdropSocialList');
  AnimationController _controller;
  List<int> _categoryIds = [0];
  String date;
  int page = 0;
  List _result;
  String socialTags = '全部分类';
  int _kItemCount;
  List<IntSize> _sizes;

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
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      value: 1.0,
      vsync: this,
    );
    _refreshController = RefreshController(initialRefresh: false);
    initUserData();
  }

  initUserData() async {
    _result = null;
    date = timeToString(new DateTime.now());
    await Future.delayed(Duration(milliseconds: 600), () async {
      var res = await getSocialList(
          params: {"date": date, "page": page, "keywords": socialTags == '全部分类' ? null : socialTags});
      if (null != res) {
        _result = res;
        _kItemCount = _result.length;
        _sizes = _createSizes(_kItemCount).toList();
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  void _changeCategory(Category category) {
    if (category.categoryId == 0) {
      _categoryIds = [0];
    } else {
      if (_categoryIds[0] == 0) {
        _categoryIds = [category.categoryId];
      } else {
        if (_categoryIds.contains(category.categoryId)) {
          _categoryIds.remove(category.categoryId);
          if (_categoryIds.isEmpty) {
            _categoryIds = [0];
          }
        } else {
          _categoryIds.add(category.categoryId);
        }
      }
    }
    // setState(() {});
  }

  void _onConfirmSelcted() {
    socialTags = _categoryIds.map((i) => allCategories[i].title).toList().join(',');
    print(socialTags);
    setState(() {
      _controller.fling(velocity: 2.0);
    });
    initUserData();
  }

  bool get _backdropPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed || status == AnimationStatus.forward;
  }

  void _toggleBackdropPanelVisibility() {
    _controller.fling(velocity: _backdropPanelVisible ? -2.0 : 2.0);
  }

  double get _backdropHeight {
    final RenderBox renderBox = _backdropKey.currentContext.findRenderObject();
    return renderBox.size.height;
  }

  // By design: the panel can only be opened with a swipe. To close the panel
  // the user must either tap its heading or the backdrop's menu icon.

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_controller.isAnimating || _controller.status == AnimationStatus.completed) return;

    _controller.value -= details.primaryDelta / (_backdropHeight ?? details.primaryDelta);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating || _controller.status == AnimationStatus.completed) return;

    final double flingVelocity = details.velocity.pixelsPerSecond.dy / _backdropHeight;
    if (flingVelocity < 0.0)
      _controller.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _controller.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _controller.fling(velocity: _controller.value < 0.5 ? -2.0 : 2.0);
  }

  void _onLoading() async {
    page += 1;
    var requestParams = {"date": date, "page": page, "keywords": socialTags == '全部分类' ? '' : socialTags};
    print(requestParams);
    await getSocialList(params: requestParams).then((v) {
      if (null != v) {
        List list = _result;
        list.addAll(v);
        setState(() {
          _result = list;
          _sizes.addAll(_createSizes(v.length).toList());
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

  void _onRefresh() async {
    date = timeToString(new DateTime.now());
    page = 0;
    var requestParams = {"date": date, "page": page, "keywords": socialTags == '全部分类' ? null : socialTags};
    await Future.delayed(Duration(milliseconds: 1200), () {
      getSocialList(params: requestParams).then((v) {
        if (null != v) {
          if (v.length > 0) {
            setState(() {
              _result = v;
              _sizes = _createSizes(v.length).toList();
            });
          } else {
            setState(() {
              _result = [];
              _sizes = [];
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

  // Stacks a BackdropPanel, which displays the selected category, on top
  // of the backdrop. The categories are displayed with ListTiles. Just one
  // can be selected at a time. This is a LayoutWidgetBuild function because
  // we need to know how big the BackdropPanel will be to set up its
  // animation.
  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const double panelTitleHeight = 48.0;
    final Size panelSize = constraints.biggest;
    final double panelTop = panelSize.height - panelTitleHeight;

    final Animation<RelativeRect> panelAnimation = _controller.drive(
      RelativeRectTween(
        begin: RelativeRect.fromLTRB(
          0.0,
          panelTop - MediaQuery.of(context).padding.bottom,
          0.0,
          panelTop - panelSize.height,
        ),
        end: const RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
      ),
    );

    final ThemeData theme = Theme.of(context);
    final List<Widget> backdropItems = allCategories.map<Widget>((Category category) {
      // final bool selected = _categoryIds.contains(category.categoryId);
      return Material(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        color: category.selected ? Colors.white.withOpacity(0.25) : Colors.transparent,
        child: CheckboxListTile(
          value: category.selected,
          title: Text(category.title, style: TextStyle(fontSize: 14.0)),
          // selected: category.selected,
          onChanged: (bool s) {
            if (category.categoryId == 0) {
              for (var i = 0; i < allCategories.length; i++) {
                allCategories[i].selected = false;
              }
            } else {
              allCategories[0].selected = false;
            }

            category.selected = s;
            _changeCategory(category);
            setState(() {});
          },
        ),
      );
    }).toList();

    return Container(
      key: _backdropKey,
      color: theme.primaryColor,
      child: Stack(
        children: <Widget>[
          ListTileTheme(
            dense: true,
            iconColor: theme.primaryIconTheme.color,
            textColor: theme.primaryTextTheme.title.color.withOpacity(0.6),
            selectedColor: theme.primaryTextTheme.title.color,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 50.0),
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: backdropItems,
                ),
              ),
            ),
          ),
          PositionedTransition(
            rect: panelAnimation,
            child: BackdropPanel(
              onTap: _toggleBackdropPanelVisibility,
              onVerticalDragUpdate: _handleDragUpdate,
              onVerticalDragEnd: _handleDragEnd,
              title: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(right: 16.0),
                  child: Text(socialTags, overflow: TextOverflow.ellipsis, maxLines: 1)),
              child: SmartRefresher(
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
                child: _result == null
                    ? loadWidget
                    : _result.length != 0
                        ? StaggeredGridView.countBuilder(
                            padding: EdgeInsets.all(4.0),
                            crossAxisCount: 2,
                            // addAutomaticKeepAlives: true,
                            // primary: true,
                            // shrinkWrap: true,
                            itemCount: _result.length,
                            itemBuilder: (BuildContext context, int index) =>
                                new _Tile(index, _sizes[index], _result, initUserData),
                            staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                            mainAxisSpacing: 4.0,
                            crossAxisSpacing: 4.0,
                          )
                        : CustomEmptyWidget(),
                onRefresh: _onRefresh,
                onLoading: _onLoading,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          leading: IconButton(
            icon: new Icon(Icons.arrow_back_ios, size: 20.0),
            onPressed: () {
              if (!_backdropPanelVisible) {
                _controller.fling(velocity: 2.0);
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          title: BackdropTitle(
            listenable: _controller.view,
            voidCallback: _onConfirmSelcted,
          ),
          actions: <Widget>[
            IconButton(
              onPressed: _toggleBackdropPanelVisibility,
              icon: AnimatedIcon(
                icon: AnimatedIcons.close_menu,
                semanticLabel: 'close',
                progress: _controller.view,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.pushNamed(context, '/socialPublish').then((isRefresh) {
              if (isRefresh == true) {
                initUserData();
              }
            });
          },
          child: Icon(Icons.add, size: 30),
          backgroundColor: Colors.orange,
          shape: CircleBorder(side: BorderSide(color: Colors.white, width: 5.0)),
        ),
        body: LayoutBuilder(
          builder: _buildStack,
        ));
  }
}

class IntSize {
  const IntSize(this.width, this.height);

  final int width;
  final int height;
}

class _Tile extends StatelessWidget {
  const _Tile(this.index, this.size, this.listInfo, this.callRefresh);

  final IntSize size;
  final int index;
  final List listInfo;
  final VoidCallback callRefresh;

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Stack(
            children: <Widget>[
              //new Center(child: new CircularProgressIndicator()),
              new Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
                  child: FadeInImage.memoryNetwork(
                    width: MediaQuery.of(context).size.width / 2 - 14.0,
                    height: size.height.toDouble(),
                    fit: BoxFit.cover,
                    placeholder: kTransparentImage,
                    image: listInfo[index]['imageUrl'],
                  ),
                ),
              ),
              Positioned(
                left: 0.0,
                bottom: 0.0,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2 - 14.0,
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  color: Colors.blueGrey.withOpacity(0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        '${listInfo[index]['post_title']}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.blueGrey[50]),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(4.0),
                    splashColor: Colors.blueGrey.withOpacity(0.2),
                    highlightColor: Colors.blueGrey.withOpacity(0.1),
                    onTap: () {
                      Navigator.pushNamed(context, '/socialDetail',
                              arguments: {'id': listInfo[index]['id'], 'pid': listInfo[index]['user_id']})
                          .then((isRefresh) {
                        if (isRefresh == true) {
                          callRefresh();
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          new Padding(
            padding: const EdgeInsets.all(4.0),
            child: new Row(
              children: <Widget>[
                Container(
                  width: 30.0,
                  height: 30.0,
                  padding: EdgeInsets.all(5.0),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/head_knoyo.jpg'),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                new Text(
                  '收藏 879人',
                  style: const TextStyle(color: Colors.grey, fontSize: 12.0),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
