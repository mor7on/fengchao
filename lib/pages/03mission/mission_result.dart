import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/03_mission_list_fun.dart';
import 'package:fengchao/common/config/config.dart';
import 'package:fengchao/common/utils/sp_utils.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/photo_view_screen.dart';
import 'package:fengchao/provider/mission_steps_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:provider/provider.dart';

class MissionResultComponent extends StatefulWidget {
  MissionResultComponent({Key key, this.arguments}) : super(key: key);
  final Map arguments;

  @override
  _MissionResultComponentState createState() => _MissionResultComponentState();
}

class _MissionResultComponentState extends State<MissionResultComponent> {
  int _itemCount;

  bool _loop;

  bool _autoplay;

  int _autoplayDely;

  double _padding;

  bool _outer;

  double _radius;

  double _viewportFraction;

  SwiperLayout _layout;

  int _currentIndex;

  double _scale;

  Axis _scrollDirection;

  Curve _curve;

  double _fade;

  bool _autoplayDisableOnInteraction;

  CustomLayoutOption customLayoutOption;

  SwiperController _controller;

  bool _showPostUser;

  Map<String, dynamic> more;

  int activeIndex = 0;

  @override
  void initState() {
    more = widget.arguments['more'] == null ? null : jsonDecode(widget.arguments['more']);
    customLayoutOption = new CustomLayoutOption(startIndex: -1, stateCount: 3)
        .addRotate([-25.0 / 180, 0.0, 25.0 / 180]).addTranslate(
            [new Offset(-350.0, 0.0), new Offset(0.0, 0.0), new Offset(350.0, 0.0)]);
    _fade = 1.0;
    _currentIndex = 0;
    _curve = Curves.ease;
    _scale = 0.8;
    _controller = new SwiperController();
    _layout = SwiperLayout.CUSTOM;
    _radius = 10.0;
    _padding = 0.0;
    _loop = true;
    _itemCount = more['photos'].length;
    _autoplay = false;
    _autoplayDely = 3000;
    _viewportFraction = 0.8;
    _outer = false;
    _scrollDirection = Axis.horizontal;
    _autoplayDisableOnInteraction = false;
    _showPostUser = SpUtil.getInt('xxUserId') == widget.arguments['pu_id'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('查看成果'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 80.0,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(50.0))),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildColumn(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildColumn() {
    return <Widget>[
      buildSwiper(),
      SizedBox(height: 20.0),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0, bottom: 8.0),
              child: Text(
                activeIndex == 0
                    ? widget.arguments['content']
                    : '您是否对乙方工作感到满意？\n满意请点击确认成果，不满意请点击退回。\n确认后将进入付款流程，无法进行更改。\n退回后将退回上一步，乙方须重新提交成果。',
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            Container(
              width: double.infinity,
              height: 30.0,
              color: Colors.blueGrey[50],
            ),
            Positioned(
              left: 90.0,
              child: ClipPath(
                clipper: TapBarClipper(90, 30, activeIndex == 1),
                child: Container(
                  width: 90.0,
                  height: 30.0,
                  color: activeIndex == 1 ? Colors.white : Colors.blueGrey[50],
                  alignment: Alignment.center,
                  child: FlatButton(
                    padding: EdgeInsets.zero,
                    child: Text(
                      '用户须知',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    onPressed: () {
                      setState(() {
                        activeIndex = 1;
                      });
                    },
                  ),
                ),
              ),
            ),
            ClipPath(
              clipper: TapBarClipper(90, 30, activeIndex == 0),
              child: Container(
                width: 90.0,
                height: 30.0,
                color: activeIndex == 0 ? Colors.white : Colors.blueGrey[50],
                alignment: Alignment.center,
                child: FlatButton(
                  padding: EdgeInsets.zero,
                  child: Text(
                    '留言信息',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onPressed: () {
                    setState(() {
                      activeIndex = 0;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      widget.arguments['isShow'] == true
          ? ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('退回成果'),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/missionResultToBack',arguments: widget.arguments);
                  },
                ),
                FlatButton(
                  child: Text('确认成果'),
                  onPressed: _handleSubmit,
                ),
              ],
            )
          : Container()
    ];
  }

  Future _handleSubmit() async {
    // 1，发起确认成果请求
      BotToast.showLoading(backgroundColor: Colors.transparent);
      var result = await toAgreeResultById(
        params: {
          'trade_id': widget.arguments['trade_id'],
          'content': '成果满意',
        },
      );
      BotToast.closeAllLoading();
      if (null != result) {
        // TODO 2，弹窗，转到支付页面或者稍后付款
        Provider.of<StepperModel>(context).initMissionSteps();
        showDemoDialog<String>(
          context: context,
          child: CupertinoAlertDialog(
            title: Text(
              '任务已经完成，是否现在付款？',
              style: TextStyle(fontSize: 16.0),
            ),
            content: Text(
              '选择稍后付款可以稍后在任务执行页面点击去付款按钮进入付款页面。',
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('稍后付款'),
                onPressed: () {
                  Navigator.pop(context, 'cancle');
                },
              ),
              CupertinoDialogAction(
                child: const Text('现在付款'),
                onPressed: () {
                  Navigator.pop(context, 'confirm');
                },
              ),
            ],
          ),
        );
      }
  }

  void showDemoDialog<T>({BuildContext context, Widget child}) {
    showCupertinoDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((T value) async {
      // The value passed to Navigator.pop() or null.
      if (value == 'confirm') {
        // TODO 跳转到支付页面

      }
      Navigator.pop(context);
    });
  }

  Widget buildSwiper() {
    Widget item;
    print(more['photos'].length);

    if (more != null && more['photos'].length > 0) {
      item = Container(
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: new Swiper(
          onTap: (int index) {
            List imageList = more['photos'];
            Navigator.of(context).push(
              new FadeRoute(
                page: PhotoViewScreen(
                  images: imageList, //传入图片list
                  index: index, //传入当前点击的图片的index
                  // heroTag: 'picture$index', //传入当前点击的图片的hero tag （可选）
                ),
              ),
            );
          },
          customLayoutOption: customLayoutOption,
          fade: _fade,
          index: _currentIndex,
          onIndexChanged: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          curve: _curve,
          scale: _scale,
          itemWidth: 200.0,
          controller: _controller,
          layout: _layout,
          outer: _outer,
          itemHeight: 200 / 0.618,
          viewportFraction: _viewportFraction,
          autoplayDelay: _autoplayDely,
          loop: _loop,
          autoplay: _autoplay,
          itemBuilder: _buildItem,
          itemCount: _itemCount,
          scrollDirection: _scrollDirection,
          indicatorLayout: PageIndicatorLayout.COLOR,
          autoplayDisableOnInteraction: _autoplayDisableOnInteraction,
          pagination: new SwiperPagination(
              builder: const DotSwiperPaginationBuilder(size: 5.0, activeSize: 8.0, space: 10.0, color: Colors.grey)),
        ),
      );
    } else {
      item = Container();
    }
    return item;
  }

  Widget _buildItem(BuildContext context, int index) {
    return ClipRRect(
      borderRadius: new BorderRadius.all(new Radius.circular(_radius)),
      child: new Image.network(
        CONFIG.BASE_URL + more['photos'][index % more['photos'].length],
        fit: BoxFit.cover,
      ),
    );
  }
}

// 顶部栏裁剪
class TapBarClipper extends CustomClipper<Path> {
  // 宽高
  double width;
  double height;
  bool isActive;

  TapBarClipper(this.width, this.height, this.isActive);

  @override
  Path getClip(Size size) {
    double clip = isActive ? 10.0 : 0.0;
    Path path = new Path();
    path.moveTo(0.0, 0.0);
    path.lineTo(width - clip, 0.0);
    path.lineTo(width, height);
    path.lineTo(0.0, height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
          // 设置过度时间
          transitionDuration: Duration(milliseconds: 500),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
