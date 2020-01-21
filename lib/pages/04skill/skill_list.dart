//import 'dart:convert';
//import 'dart:io';
import 'dart:math' as math;

import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/04_skill_list_fun.dart';
import 'package:fengchao/common/utils/common_utils.dart';
import 'package:fengchao/models/article_model.dart';
import 'package:fengchao/models/category_model.dart';
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
    this.title,
  }) : super(key: key, listenable: listenable);

  final VoidCallback voidCallback;
  final VoidCallback confirmCallback;
  final String title;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return DefaultTextStyle(
      style: Theme.of(context).primaryTextTheme.subhead,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      child: Row(
        children: <Widget>[
          GestureDetector(
            child: Container(
              width: 60.0,
              child: Row(
                children: <Widget>[
                  Text(title),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
            onTap: voidCallback,
          ),
          Stack(
            alignment: AlignmentDirectional.centerStart,
            children: <Widget>[
              Opacity(
                opacity: CurvedAnimation(
                  parent: ReverseAnimation(animation),
                  curve: const Interval(0.5, 1.0),
                ).value,
                child: Text('选择分类'),
              ),
              Opacity(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0.5, 1.0),
                ).value,
                child: Text('蜂巢'),
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

class SkillListComponent extends StatefulWidget {
  SkillListComponent({Key key}) : super(key: key);

  _SkillListComponentState createState() => _SkillListComponentState();
}

class _SkillListComponentState extends State<SkillListComponent> with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'BackdropSkillList');
  AnimationController _controller;
  List<int> _categoryIds = [0];
  String date;
  int page = 0;
  List<ArticleModel> _result;
  List<Category> _allCategories;
  String skillTags = '全部分类';

  RefreshController _refreshController;
  // 控制结束
  bool _enableControlFinish = false;

  int currentIndex = 0;

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
    date = CommonUtils.timeToString(new DateTime.now());
    _result = null;
    _refreshController.resetNoData();
    await Future.delayed(Duration(milliseconds: 600), () async {
      var res = await getSkillList(
          params: {'page': 0, 'date': date, "keywords": skillTags == '全部分类' ? '' : skillTags}, cateIdx: currentIndex);
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
    skillTags = _categoryIds.map((i) => _allCategories[i].title).toList().join(',');
    print(skillTags);
    setState(() {
      _controller.fling(velocity: 2.0);
    });
    initUserData();
  }

  Future _showCustomPicker() async {
    BotToast.showCustomLoading(
        clickClose: true,
        allowClick: false,
        toastBuilder: (cancle) => Center(
              child: Card(
                color: Colors.black54,
                child: Container(
                  width: 200.0,
                  height: 160.0,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.person_outline, size: 60.0, color: Colors.white),
                                  Text(
                                    '个人',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(4.0),
                                  splashColor: Colors.white.withOpacity(0.2),
                                  highlightColor: Colors.white.withOpacity(0.1),
                                  onTap: () {
                                    if (currentIndex != 0) {
                                      currentIndex = 0;
                                      initUserData();
                                    }
                                    cancle();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 2.0, height: 60.0, child: Container(color: Colors.white)),
                      Expanded(
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.people_outline, size: 60.0, color: Colors.white),
                                  Text(
                                    '团队',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(4.0),
                                  splashColor: Colors.white.withOpacity(0.2),
                                  highlightColor: Colors.white.withOpacity(0.1),
                                  onTap: () {
                                    if (currentIndex != 1) {
                                      currentIndex = 1;
                                      initUserData();
                                    }
                                    cancle();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
    // setState(() {
    //   _controller.fling(velocity: 2.0);
    // });
    // initUserData();
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
    var requestParams = {"date": date, "page": page, "keywords": skillTags == '全部分类' ? '' : skillTags};
    print(requestParams);
    await getSkillList(params: requestParams, cateIdx: currentIndex).then((res) {
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
    var requestParams = {"date": date, "page": page, "keywords": skillTags == '全部分类' ? '' : skillTags};
    await Future.delayed(Duration(milliseconds: 1200), () {
      getSkillList(params: requestParams, cateIdx: currentIndex).then((res) {
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
      // final bool marked = _categoryIds.contains(category.categoryId);
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
                  child: Text(skillTags, overflow: TextOverflow.ellipsis, maxLines: 1)),
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
      child = Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: CustomMediaCard(
          item: _result[index],
          navigatorName: currentIndex == 0 ? '/skillDetail' : '/teamDetail',
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
            title: currentIndex == 0 ? '个人' : '团队',
            listenable: _controller.view,
            voidCallback: _showCustomPicker,
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
          onPressed: () async {
            await Navigator.pushNamed(context, '/skillPublish').then((isRefresh) {
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
