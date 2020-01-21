import 'package:fengchao/pages/widgets/likebutton/model.dart';
import 'package:flutter/material.dart';
import 'dot_painter.dart';
import 'circle_painter.dart';

typedef LikeCallback = void Function(bool isLike);

class LikeButton extends StatefulWidget {
  final double width;
  final Widget icon;
  final Duration duration;
  final DotColor dotColor;
  final Color circleStartColor;
  final Color circleEndColor;
  final LikeCallback onIconClicked;

  /// 控制器
  final LikeButtonController likeBttonController;

  const LikeButton({
    Key key,
    @required this.width,
    @required this.icon,
    this.duration = const Duration(milliseconds: 5000),
    this.dotColor = const DotColor(
      dotPrimaryColor: const Color(0xFFFFC107),
      dotSecondaryColor: const Color(0xFFFF9800),
      dotThirdColor: const Color(0xFFFFFFFF),
      dotLastColor: const Color(0xFFF44336),
    ),
    this.circleStartColor = const Color(0xFFFF5722),
    this.circleEndColor = const Color(0xFFFFC107),
    this.onIconClicked,
    this.likeBttonController,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> outerCircle;
  Animation<double> innerCircle;
  Animation<double> scale;
  Animation<double> dots;

  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(duration: widget.duration, vsync: this)
      ..addListener(() {
        setState(() {});
      });
    _initAllAmimations();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 绑定控制器
    if (widget.likeBttonController != null) widget.likeBttonController._bindLikeButtonState(this);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        CustomPaint(
          size: Size(widget.width, widget.width),
          painter: DotPainter(
            currentProgress: dots.value,
            color1: widget.dotColor.dotPrimaryColor,
            color2: widget.dotColor.dotSecondaryColor,
            color3: widget.dotColor.dotThirdColorReal,
            color4: widget.dotColor.dotLastColorReal,
          ),
        ),
        CustomPaint(
          size: Size(widget.width * 0.35, widget.width * 0.35),
          painter: CirclePainter(
              innerCircleRadiusProgress: innerCircle.value,
              outerCircleRadiusProgress: outerCircle.value,
              startColor: widget.circleStartColor,
              endColor: widget.circleEndColor),
        ),
        Container(
          width: widget.width,
          height: widget.width,
          alignment: Alignment.center,
          child: Transform.scale(
            scale: isLiked ? scale.value : 1.0,
            child: GestureDetector(
              child: widget.icon,
              onTap: (widget.onIconClicked == null) ? null : _onTap,
            ),
          ),
        ),
      ],
    );
  }

  void _onTap() {
    if (_controller.isAnimating) return;
    isLiked = !isLiked;
    if (isLiked) {
      _controller.forward();
    } else {
      _controller.reset();
      setState(() {});
    }
    if (widget.onIconClicked != null) widget.onIconClicked(isLiked);
  }

  void _reset() {
    if (_controller.isAnimating) return;
    isLiked = false;
    _controller.reset();
    setState(() {});
  }

  void _initAllAmimations() {
    outerCircle = new Tween<double>(
      begin: 0.1,
      end: 1.0,
    ).animate(
      new CurvedAnimation(
        parent: _controller,
        curve: new Interval(
          0.0,
          0.3,
          curve: Curves.ease,
        ),
      ),
    );
    innerCircle = new Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(
      new CurvedAnimation(
        parent: _controller,
        curve: new Interval(
          0.2,
          0.5,
          curve: Curves.ease,
        ),
      ),
    );
    scale = new Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(
      new CurvedAnimation(
        parent: _controller,
        curve: new Interval(
          0.35,
          0.7,
          curve: OvershootCurve(),
        ),
      ),
    );
    dots = new Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      new CurvedAnimation(
        parent: _controller,
        curve: new Interval(
          0.1,
          1.0,
          curve: Curves.decelerate,
        ),
      ),
    );
  }
}

class LikeButtonController {
  /// 触发刷新
  void callLoad() {
    if (this._likeButtonState != null) {
      this._likeButtonState._onTap();
    }
  }

  /// 动画复位
  void reset() {
    if (this._likeButtonState != null) {
      this._likeButtonState._reset();
    }
  }

  // 状态
  _LikeButtonState _likeButtonState;

  // 绑定状态
  void _bindLikeButtonState(_LikeButtonState state) {
    this._likeButtonState = state;
  }
}
