import 'dart:math' as math;

import 'package:fengchao/common/api/03_mission_list_fun.dart';
import 'package:fengchao/common/utils/common_utils.dart';
import 'package:fengchao/models/article_model.dart';
import 'package:fengchao/models/category_model.dart';
import 'package:fengchao/pages/widgets/city_pickers/city_pickers.dart';
import 'package:fengchao/pages/widgets/city_pickers/meta/city_list.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_loading_widget.dart';
import 'package:fengchao/pages/widgets/custom_media_card.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
    this.confirmCallback,
    this.cityName,
  }) : super(key: key, listenable: listenable);

  final VoidCallback voidCallback;
  final VoidCallback confirmCallback;
  final String cityName;

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
                child: const Text('选择类型'),
              ),
              Opacity(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0.5, 1.0),
                ).value,
                child: Container(
                    child: Row(
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              constraints: BoxConstraints(maxWidth: 80.0),
                              child: Text(
                                cityName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                      onTap: voidCallback,
                    ),
                    Text('任务大厅'),
                  ],
                )),
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
              onPressed: confirmCallback,
            ),
          ),
        ],
      ),
    );
  }
}

class MissionListComponent extends StatefulWidget {
  MissionListComponent({Key key}) : super(key: key);

  _MissionListComponentState createState() => _MissionListComponentState();
}

class _MissionListComponentState extends State<MissionListComponent> with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'BackdropMissionList');
  AnimationController _controller;
  List<int> _categoryIds = [0];
  String date;
  int page = 0;
  int areaId = 0;
  List<ArticleModel> _result;
  List<Category> _allCategories;

  String missionTags = '全部分类';

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
    initCategories();
    initUserData();
  }

  void initCategories() {
    _allCategories = allCategories;
    for (var i = 0; i < _allCategories.length; i++) {
      _allCategories[i].selected = false;
    }
    _allCategories[0].selected = true;
  }

  initUserData() async {
    _result = null;
    _refreshController.resetNoData();
    date = CommonUtils.timeToString(new DateTime.now());
    // BotToast.showLoading();
    await Future.delayed(Duration(milliseconds: 600), () async {
      var res = await getMissionList(
          params: {'page': 0, 'date': date, "area_id": areaId, "keywords": missionTags == '全部分类' ? null : missionTags});
      if (null != res) {
        _result = [];
        res['data'].forEach((v) {
          _result.add(new ArticleModel.fromJson(v));
        });
      }
      // BotToast.closeAllLoading();
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
  }

  void _onConfirmSelcted() {
    missionTags = _categoryIds.map((i) => _allCategories[i].title).toList().join(',');
    print(missionTags);
    setState(() {
      _controller.fling(velocity: 2.0);
    });
    initUserData();
  }

  Future _showCityPicker() async {
    Result result = await CityPickers.showCitiesSelector(context: context, title: '城市选择', hotCities: [
      HotCity(name: '全国', id: 0),
      HotCity(name: '北京市', id: 110000),
      HotCity(name: '天津市', id: 120000),
      HotCity(name: '河北省', id: 130000),
      HotCity(name: '山西省', id: 140000),
      HotCity(name: '内蒙古自治区', id: 150000),
      HotCity(name: '辽宁省', id: 210000),
      HotCity(name: '吉林省', id: 220000),
      HotCity(name: '黑龙江省', id: 230000),
      HotCity(name: '上海市', id: 310000),
      HotCity(name: '江苏省', id: 320000),
      HotCity(name: '浙江省', id: 330000),
      HotCity(name: '安徽省', id: 340000),
      HotCity(name: '福建省', id: 350000),
      HotCity(name: '江西省', id: 360000),
      HotCity(name: '山东省', id: 370000),
      HotCity(name: '河南省', id: 410000),
      HotCity(name: '湖北省', id: 420000),
      HotCity(name: '湖南省', id: 430000),
      HotCity(name: '广东省', id: 440000),
      HotCity(name: '广西壮族自治区', id: 450000),
      HotCity(name: '海南省', id: 460000),
      HotCity(name: '重庆市', id: 500000),
      HotCity(name: '四川省', id: 510000),
      HotCity(name: '贵州省', id: 520000),
      HotCity(name: '云南省', id: 530000),
      HotCity(name: '西藏自治区', id: 540000),
      HotCity(name: '陕西省', id: 610000),
      HotCity(name: '甘肃省', id: 620000),
      HotCity(name: '青海省', id: 630000),
      HotCity(name: '宁夏回族自治区', id: 640000),
      HotCity(name: '新疆维吾尔自治区', id: 650000),
      HotCity(name: '台湾省', id: 710000),
      HotCity(name: '香港特别行政区', id: 810000),
      HotCity(name: '澳门特别行政区', id: 820000),
      HotCity(name: '广州市', id: 440100),
      HotCity(name: '深圳市', id: 440300)
    ]);
    print(result);
    setState(() {
      areaId = int.parse(result.cityId);
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
    var requestParams = {
      "date": date,
      "page": page,
      "area_id": areaId,
      "keywords": missionTags == '全部分类' ? '' : missionTags
    };
    print(requestParams);
    await getMissionList(params: requestParams).then((res) {
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

  void _onRefresh() async {
    date = CommonUtils.timeToString(new DateTime.now());
    page = 0;
    var requestParams = {
      "date": date,
      "page": page,
      "area_id": areaId,
      "keywords": missionTags == '全部分类' ? '' : missionTags
    };
    await Future.delayed(Duration(milliseconds: 1200), () {
      getMissionList(params: requestParams).then((res) {
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
    final List<Widget> backdropItems = _allCategories.map<Widget>((Category category) {
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
            print(category.categoryId);
            if (category.categoryId == 0) {
              for (var i = 0; i < _allCategories.length; i++) {
                _allCategories[i].selected = false;
              }
            } else {
              _allCategories[0].selected = false;
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
                  child: Text(missionTags, overflow: TextOverflow.ellipsis, maxLines: 1)),
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
      final bool isLock = CommonUtils.toCompareExpiredTime(_result[index].expiredTime);
      child = Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Stack(
          children: <Widget>[
            CustomMediaCard(
              item: _result[index],
              navigatorName: '/missionDetail',
              voidCallback: initUserData,
            ),
            isLock
                ? Positioned(
                    top: 10.0,
                    right: 10.0,
                    child: Container(
                      width: 30.0,
                      height: 30.0,
                      decoration: BoxDecoration(color: Colors.red[200], borderRadius: BorderRadius.circular(20.0)),
                      child: Icon(
                        Icons.lock,
                        size: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Container()
          ],
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
            cityName: cityList['$areaId']['name'],
            listenable: _controller.view,
            voidCallback: _showCityPicker,
            confirmCallback: _onConfirmSelcted,
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
          onPressed: () {
            Navigator.pushNamed(context, '/missionPublish').then((isRefresh) {
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
