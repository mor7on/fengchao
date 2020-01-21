//import 'dart:convert';
//import 'dart:io';
import 'dart:math' as math;

import 'package:fengchao/common/api/02_company_list_fun.dart';
import 'package:fengchao/models/article_model.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_loading_widget.dart';
import 'package:fengchao/pages/widgets/custom_media_card.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' hide RefreshIndicator;

class Category {
  const Category({this.title, this.categoryId});
  final String title;
  final int categoryId;
  @override
  String toString() => '$runtimeType("$title")';
}

const List<Category> allCategories = <Category>[
  Category(
    title: '全部行业',
    categoryId: 0,
  ),
  Category(
    title: '保密',
    categoryId: 1,
  ),
  Category(
    title: 'IT|通信|互联网',
    categoryId: 2,
  ),
  Category(
    title: '机械机电|自动化',
    categoryId: 3,
  ),
  Category(
    title: '专业服务',
    categoryId: 4,
  ),
  Category(
    title: '冶金冶炼|五金|采掘',
    categoryId: 5,
  ),
  Category(
    title: '化工行业',
    categoryId: 6,
  ),
  Category(
    title: '纺织服装|皮革鞋帽',
    categoryId: 7,
  ),
  Category(
    title: '电子电器|仪器仪表',
    categoryId: 8,
  ),
  Category(
    title: '快消品|办公用品',
    categoryId: 9,
  ),
  Category(
    title: '房产|建筑|城建|环保',
    categoryId: 10,
  ),
  Category(
    title: '金融行业',
    categoryId: 11,
  ),
  Category(
    title: '制药|医疗',
    categoryId: 12,
  ),
  Category(
    title: '生活服务|娱乐休闲',
    categoryId: 13,
  ),
  Category(
    title: '交通工具|运输物流',
    categoryId: 14,
  ),
  Category(
    title: '批发|零售|贸易',
    categoryId: 15,
  ),
  Category(
    title: '广告|媒体',
    categoryId: 16,
  ),
  Category(
    title: '教育|科研|培训',
    categoryId: 17,
  ),
  Category(
    title: '造纸|印刷',
    categoryId: 18,
  ),
  Category(
    title: '包装|工艺礼品|奢侈品',
    categoryId: 19,
  ),
  Category(
    title: '营销|销售人员',
    categoryId: 20,
  ),
  Category(
    title: '能源|资源',
    categoryId: 21,
  ),
  Category(
    title: '农|林|牧|渔',
    categoryId: 22,
  ),
  Category(
    title: '政府|非赢利机构',
    categoryId: 23,
  ),
  Category(
    title: '其他',
    categoryId: 24,
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
  }) : super(key: key, listenable: listenable);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return DefaultTextStyle(
      style: Theme.of(context).primaryTextTheme.subhead,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: CurvedAnimation(
              parent: ReverseAnimation(animation),
              curve: const Interval(0.5, 1.0),
            ).value,
            child: const Text('选择行业'),
          ),
          Opacity(
            opacity: CurvedAnimation(
              parent: animation,
              curve: const Interval(0.5, 1.0),
            ).value,
            child: const Text('小企大厅'),
          ),
        ],
      ),
    );
  }
}

// This widget is essentially the backdrop itself.
class CompanyListComponent extends StatefulWidget {
  CompanyListComponent({Key key}) : super(key: key);

  _CompanyListComponentState createState() => _CompanyListComponentState();
}

class _CompanyListComponentState extends State<CompanyListComponent> with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'BackdropCompanyList');
  AnimationController _controller;
  Category _category = allCategories[0];
  String date;
  int page = 0;
  List<ArticleModel> _result;

  String industryText = '全部行业';

  String timeToString(time) {
    var timeStr =
        "${time.year.toString()}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
    return timeStr;
  }

  RefreshController _refreshController;

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

  Future initUserData() async {
    _result = null;
    _refreshController.resetNoData();
    date = timeToString(new DateTime.now());
    await Future.delayed(Duration(milliseconds: 600), () async {
      var res = await getCompanyList(params: {'page': 0, 'date': date, "industry_id": _category.categoryId});
      print(res);
      if (null != res) {
        _result = [];
        res['data'].forEach((v) {
          _result.add(ArticleModel.fromMap(v));
        });
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
    if (_category.categoryId == category.categoryId) {
      return;
    } else {
      setState(() {
        _category = category;
        _controller.fling(velocity: 2.0);
      });
      initUserData();
    }
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
    var requestParams = {"date": date, "page": page, "industry_id": _category.categoryId};
    print(requestParams);
    await getCompanyList(params: requestParams).then((val) {
      if (null != val) {
        val['data'].forEach((v) {
          _result.add(ArticleModel.fromJson(v));
        });
        setState(() {});
        _refreshController.loadComplete();
        if (val['data'].length < 10) {
          _refreshController.loadNoData();
        }
      }
    });
  }

  void _onRefresh() async {
    date = timeToString(new DateTime.now());
    page = 0;
    var requestParams = {"date": date, "page": page, "industry_id": _category.categoryId};
    await Future.delayed(Duration(milliseconds: 1200), () {
      getCompanyList(params: requestParams).then((val) {
        if (null != val) {
          _result = [];
          List v = val['data'];
          if (v.length > 0) {
            v.forEach((item) {
              _result.add(ArticleModel.fromJson(item));
            });
          }
          setState(() {});
          _refreshController.refreshCompleted();
          _refreshController.resetNoData();
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
      final bool selected = category == _category;
      return Material(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        color: selected ? Colors.white.withOpacity(0.25) : Colors.transparent,
        child: ListTile(
          title: Text(category.title, style: TextStyle(fontSize: 14.0)),
          selected: selected,
          onTap: () {
            _changeCategory(category);
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
              title: Text(_category.title),
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
                child: ListView.builder(
                  key: PageStorageKey<Category>(_category),
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: _result == null || _result.length == 0 ? 1 : _result.length,
                  itemBuilder: _sliverListDelegate,
                  // physics: NeverScrollableScrollPhysics(),
                ),
                onRefresh: _onRefresh,
                onLoading: _onLoading,
              ),
            ),
          ),
        ],
      ),
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
        child: CustomMediaCard(
          item: _result[index],
          navigatorName: '/companyDetail',
          voidCallback: initUserData,
        ),
      );
    }
    return child;
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
          await Navigator.pushNamed(context, '/companyPublish').then((isRefresh) {
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
      ),
    );
  }
}
