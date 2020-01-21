import 'package:fengchao/pages/widgets/custom_bottom_bar_item.dart';
import 'package:flutter/material.dart';
import 'dart:collection' show Queue;
import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart' show Vector3;

enum CustomBottomBarType {
  fixed,

  shifting,
}

class CustomBottomBar extends StatefulWidget {
  CustomBottomBar({
    Key key,
    @required this.items,
    this.onTap,
    this.currentIndex = 0,
    this.elevation = 8.0,
    CustomBottomBarType type,
    Color fixedColor,
    this.backgroundColor,
    this.iconSize = 24.0,
    Color selectedItemColor,
    this.unselectedItemColor,
    this.selectedIconTheme = const IconThemeData(),
    this.unselectedIconTheme = const IconThemeData(),
    this.selectedFontSize = 14.0,
    this.unselectedFontSize = 12.0,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.showSelectedLabels = true,
    bool showUnselectedLabels,
  })  : assert(items != null),
        assert(items.length >= 2),
        assert(
          items.every((CustomBottomBarItem item) => item.title != null) == true,
          'Every item must have a non-null title',
        ),
        assert(0 <= currentIndex && currentIndex < items.length),
        assert(elevation != null && elevation >= 0.0),
        assert(iconSize != null && iconSize >= 0.0),
        assert(selectedItemColor == null || fixedColor == null,
            'Either selectedItemColor or fixedColor can be specified, but not both'),
        assert(selectedFontSize != null && selectedFontSize >= 0.0),
        assert(unselectedFontSize != null && unselectedFontSize >= 0.0),
        assert(showSelectedLabels != null),
        type = _type(type, items),
        selectedItemColor = selectedItemColor ?? fixedColor,
        showUnselectedLabels = showUnselectedLabels ?? _defaultShowUnselected(_type(type, items)),
        super(key: key);

  final List<CustomBottomBarItem> items;

  final ValueChanged<int> onTap;

  final int currentIndex;

  final double elevation;

  final CustomBottomBarType type;

  Color get fixedColor => selectedItemColor;

  final Color backgroundColor;

  final double iconSize;

  final Color selectedItemColor;

  final Color unselectedItemColor;

  final IconThemeData selectedIconTheme;

  final IconThemeData unselectedIconTheme;

  final TextStyle selectedLabelStyle;

  final TextStyle unselectedLabelStyle;

  final double selectedFontSize;

  final double unselectedFontSize;

  final bool showUnselectedLabels;

  final bool showSelectedLabels;

  static CustomBottomBarType _type(
    CustomBottomBarType type,
    List<CustomBottomBarItem> items,
  ) {
    if (type != null) {
      return type;
    }
    return items.length <= 3 ? CustomBottomBarType.fixed : CustomBottomBarType.shifting;
  }

  static bool _defaultShowUnselected(CustomBottomBarType type) {
    switch (type) {
      case CustomBottomBarType.shifting:
        return false;
      case CustomBottomBarType.fixed:
        return true;
    }
    assert(false);
    return false;
  }

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _BottomNavigationTile extends StatelessWidget {
  const _BottomNavigationTile(
    this.type,
    this.item,
    this.animation,
    this.iconSize, {
    this.onTap,
    this.colorTween,
    this.flex,
    this.selected = false,
    @required this.selectedLabelStyle,
    @required this.unselectedLabelStyle,
    @required this.selectedIconTheme,
    @required this.unselectedIconTheme,
    this.showSelectedLabels,
    this.showUnselectedLabels,
    this.indexLabel,
  })  : assert(type != null),
        assert(item != null),
        assert(animation != null),
        assert(selected != null),
        assert(selectedLabelStyle != null),
        assert(unselectedLabelStyle != null);

  final CustomBottomBarType type;
  final CustomBottomBarItem item;
  final Animation<double> animation;
  final double iconSize;
  final VoidCallback onTap;
  final ColorTween colorTween;
  final double flex;
  final bool selected;
  final IconThemeData selectedIconTheme;
  final IconThemeData unselectedIconTheme;
  final TextStyle selectedLabelStyle;
  final TextStyle unselectedLabelStyle;
  final String indexLabel;
  final bool showSelectedLabels;
  final bool showUnselectedLabels;

  @override
  Widget build(BuildContext context) {
    int size;

    final double selectedFontSize = selectedLabelStyle.fontSize;

    final double selectedIconSize = selectedIconTheme?.size ?? iconSize;
    final double unselectedIconSize = unselectedIconTheme?.size ?? iconSize;

    final double selectedIconDiff = math.max(selectedIconSize - unselectedIconSize, 0);

    final double unselectedIconDiff = math.max(unselectedIconSize - selectedIconSize, 0);

    double bottomPadding;
    double topPadding;
    if (showSelectedLabels && !showUnselectedLabels) {
      bottomPadding = Tween<double>(
        begin: selectedIconDiff / 2.0,
        end: selectedFontSize / 2.0 - unselectedIconDiff / 2.0,
      ).evaluate(animation);
      topPadding = Tween<double>(
        begin: selectedFontSize + selectedIconDiff / 2.0,
        end: selectedFontSize / 2.0 - unselectedIconDiff / 2.0,
      ).evaluate(animation);
    } else if (!showSelectedLabels && !showUnselectedLabels) {
      bottomPadding = Tween<double>(
        begin: selectedIconDiff / 2.0,
        end: unselectedIconDiff / 2.0,
      ).evaluate(animation);
      topPadding = Tween<double>(
        begin: selectedFontSize + selectedIconDiff / 2.0,
        end: selectedFontSize + unselectedIconDiff / 2.0,
      ).evaluate(animation);
    } else {
      bottomPadding = Tween<double>(
        begin: selectedFontSize / 2.0 + selectedIconDiff / 2.0,
        end: selectedFontSize / 2.0 + unselectedIconDiff / 2.0,
      ).evaluate(animation);
      topPadding = Tween<double>(
        begin: selectedFontSize / 2.0 + selectedIconDiff / 2.0,
        end: selectedFontSize / 2.0 + unselectedIconDiff / 2.0,
      ).evaluate(animation);
    }

    switch (type) {
      case CustomBottomBarType.fixed:
        size = 1;
        break;
      case CustomBottomBarType.shifting:
        size = (flex * 1000.0).round();
        break;
    }

    return Expanded(
      flex: size,
      child: Semantics(
        container: true,
        selected: selected,
        child: Focus(
          child: Stack(
            children: <Widget>[
              InkResponse(
                onTap: onTap,
                child: Padding(
                  padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _Label(
                        colorTween: colorTween,
                        animation: animation,
                        item: item,
                        selectedLabelStyle: selectedLabelStyle,
                        unselectedLabelStyle: unselectedLabelStyle,
                        showSelectedLabels: showSelectedLabels,
                        showUnselectedLabels: showUnselectedLabels,
                      ),
                    ],
                  ),
                ),
              ),
              Semantics(
                label: indexLabel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _Label extends StatelessWidget {
  const _Label({
    Key key,
    @required this.colorTween,
    @required this.animation,
    @required this.item,
    @required this.selectedLabelStyle,
    @required this.unselectedLabelStyle,
    @required this.showSelectedLabels,
    @required this.showUnselectedLabels,
  })  : assert(colorTween != null),
        assert(animation != null),
        assert(item != null),
        assert(selectedLabelStyle != null),
        assert(unselectedLabelStyle != null),
        assert(showSelectedLabels != null),
        assert(showUnselectedLabels != null),
        super(key: key);

  final ColorTween colorTween;
  final Animation<double> animation;
  final CustomBottomBarItem item;
  final TextStyle selectedLabelStyle;
  final TextStyle unselectedLabelStyle;
  final bool showSelectedLabels;
  final bool showUnselectedLabels;

  @override
  Widget build(BuildContext context) {
    final double selectedFontSize = selectedLabelStyle.fontSize;
    final double unselectedFontSize = unselectedLabelStyle.fontSize;

    final TextStyle customStyle = TextStyle.lerp(
      unselectedLabelStyle,
      selectedLabelStyle,
      animation.value,
    );
    Widget text = DefaultTextStyle.merge(
      style: customStyle.copyWith(
        fontSize: selectedFontSize,
        color: colorTween.evaluate(animation),
      ),
      child: Transform(
        transform: Matrix4.diagonal3(
          Vector3.all(
            Tween<double>(
              begin: unselectedFontSize / selectedFontSize,
              end: 1.0,
            ).evaluate(animation),
          ),
        ),
        alignment: Alignment.bottomCenter,
        child: item.title,
      ),
    );

    if (!showUnselectedLabels && !showSelectedLabels) {
      text = Opacity(
        alwaysIncludeSemantics: true,
        opacity: 0.0,
        child: text,
      );
    } else if (!showUnselectedLabels) {
      text = FadeTransition(
        alwaysIncludeSemantics: true,
        opacity: animation,
        child: text,
      );
    } else if (!showSelectedLabels) {
      text = FadeTransition(
        alwaysIncludeSemantics: true,
        opacity: Tween<double>(begin: 1.0, end: 0.0).animate(animation),
        child: text,
      );
    }

    return Align(
      alignment: Alignment.bottomCenter,
      heightFactor: 1.0,
      child: Container(child: text),
    );
  }
}

class _CustomBottomBarState extends State<CustomBottomBar> with TickerProviderStateMixin {
  List<AnimationController> _controllers = <AnimationController>[];
  List<CurvedAnimation> _animations;

  final Queue<_Circle> _circles = Queue<_Circle>();

  Color _backgroundColor;

  static final Animatable<double> _flexTween = Tween<double>(begin: 1.0, end: 1.5);

  void _resetState() {
    for (AnimationController controller in _controllers) controller.dispose();
    for (_Circle circle in _circles) circle.dispose();
    _circles.clear();

    _controllers = List<AnimationController>.generate(widget.items.length, (int index) {
      return AnimationController(
        duration: kThemeAnimationDuration,
        vsync: this,
      )..addListener(_rebuild);
    });
    _animations = List<CurvedAnimation>.generate(widget.items.length, (int index) {
      return CurvedAnimation(
        parent: _controllers[index],
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.fastOutSlowIn.flipped,
      );
    });
    _controllers[widget.currentIndex].value = 1.0;
    _backgroundColor = widget.items[widget.currentIndex].backgroundColor;
  }

  @override
  void initState() {
    super.initState();
    _resetState();
  }

  void _rebuild() {
    setState(() {});
  }

  @override
  void dispose() {
    for (AnimationController controller in _controllers) controller.dispose();
    for (_Circle circle in _circles) circle.dispose();
    super.dispose();
  }

  double _evaluateFlex(Animation<double> animation) => _flexTween.evaluate(animation);

  void _pushCircle(int index) {
    if (widget.items[index].backgroundColor != null) {
      _circles.add(
        _Circle(
          state: this,
          index: index,
          color: widget.items[index].backgroundColor,
          vsync: this,
        )..controller.addStatusListener(
            (AnimationStatus status) {
              switch (status) {
                case AnimationStatus.completed:
                  setState(() {
                    final _Circle circle = _circles.removeFirst();
                    _backgroundColor = circle.color;
                    circle.dispose();
                  });
                  break;
                case AnimationStatus.dismissed:
                case AnimationStatus.forward:
                case AnimationStatus.reverse:
                  break;
              }
            },
          ),
      );
    }
  }

  @override
  void didUpdateWidget(CustomBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.items.length != oldWidget.items.length) {
      _resetState();
      return;
    }

    if (widget.currentIndex != oldWidget.currentIndex) {
      switch (widget.type) {
        case CustomBottomBarType.fixed:
          break;
        case CustomBottomBarType.shifting:
          _pushCircle(widget.currentIndex);
          break;
      }
      _controllers[oldWidget.currentIndex].reverse();
      _controllers[widget.currentIndex].forward();
    } else {
      if (_backgroundColor != widget.items[widget.currentIndex].backgroundColor)
        _backgroundColor = widget.items[widget.currentIndex].backgroundColor;
    }
  }

  static TextStyle _effectiveTextStyle(TextStyle textStyle, double fontSize) {
    textStyle ??= const TextStyle();

    return textStyle.fontSize == null ? textStyle.copyWith(fontSize: fontSize) : textStyle;
  }

  List<Widget> _createTiles() {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    assert(localizations != null);

    final ThemeData themeData = Theme.of(context);

    final TextStyle effectiveSelectedLabelStyle =
        _effectiveTextStyle(widget.selectedLabelStyle, widget.selectedFontSize);
    final TextStyle effectiveUnselectedLabelStyle =
        _effectiveTextStyle(widget.unselectedLabelStyle, widget.unselectedFontSize);

    Color themeColor;
    switch (themeData.brightness) {
      case Brightness.light:
        themeColor = themeData.primaryColor;
        break;
      case Brightness.dark:
        themeColor = themeData.accentColor;
        break;
    }

    ColorTween colorTween;
    switch (widget.type) {
      case CustomBottomBarType.fixed:
        colorTween = ColorTween(
          begin: widget.unselectedItemColor ?? themeData.textTheme.caption.color,
          end: widget.selectedItemColor ?? widget.fixedColor ?? themeColor,
        );
        break;
      case CustomBottomBarType.shifting:
        colorTween = ColorTween(
          begin: widget.unselectedItemColor ?? Colors.white,
          end: widget.selectedItemColor ?? Colors.white,
        );
        break;
    }

    final List<Widget> tiles = <Widget>[];
    for (int i = 0; i < widget.items.length; i++) {
      tiles.add(_BottomNavigationTile(
        widget.type,
        widget.items[i],
        _animations[i],
        widget.iconSize,
        selectedIconTheme: widget.selectedIconTheme,
        unselectedIconTheme: widget.unselectedIconTheme,
        selectedLabelStyle: effectiveSelectedLabelStyle,
        unselectedLabelStyle: effectiveUnselectedLabelStyle,
        onTap: () {
          if (widget.onTap != null) widget.onTap(i);
        },
        colorTween: colorTween,
        flex: _evaluateFlex(_animations[i]),
        selected: i == widget.currentIndex,
        showSelectedLabels: widget.showSelectedLabels,
        showUnselectedLabels: widget.showUnselectedLabels,
        indexLabel: localizations.tabLabel(tabIndex: i + 1, tabCount: widget.items.length),
      ));
    }
    return tiles;
  }

  Widget _createContainer(List<Widget> tiles) {
    return DefaultTextStyle.merge(
      overflow: TextOverflow.ellipsis,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: tiles,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasMediaQuery(context));

    final double additionalBottomPadding =
        math.max(MediaQuery.of(context).padding.bottom - widget.selectedFontSize / 2.0, 0.0);
    Color backgroundColor;
    switch (widget.type) {
      case CustomBottomBarType.fixed:
        backgroundColor = widget.backgroundColor;
        break;
      case CustomBottomBarType.shifting:
        backgroundColor = _backgroundColor;
        break;
    }
    return Semantics(
      explicitChildNodes: true,
      child: Material(
        elevation: widget.elevation,
        color: backgroundColor,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: kBottomNavigationBarHeight + additionalBottomPadding),
          child: CustomPaint(
            painter: _RadialPainter(
              circles: _circles.toList(),
              textDirection: Directionality.of(context),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: Padding(
                padding: EdgeInsets.only(bottom: additionalBottomPadding),
                child: MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  child: _createContainer(_createTiles()),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Circle {
  _Circle({
    @required this.state,
    @required this.index,
    @required this.color,
    @required TickerProvider vsync,
  })  : assert(state != null),
        assert(index != null),
        assert(color != null) {
    controller = AnimationController(
      duration: kThemeAnimationDuration,
      vsync: vsync,
    );
    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    );
    controller.forward();
  }

  final _CustomBottomBarState state;
  final int index;
  final Color color;
  AnimationController controller;
  CurvedAnimation animation;

  double get horizontalLeadingOffset {
    double weightSum(Iterable<Animation<double>> animations) {
      return animations.map<double>(state._evaluateFlex).fold<double>(0.0, (double sum, double value) => sum + value);
    }

    final double allWeights = weightSum(state._animations);

    final double leadingWeights = weightSum(state._animations.sublist(0, index));

    return (leadingWeights + state._evaluateFlex(state._animations[index]) / 2.0) / allWeights;
  }

  void dispose() {
    controller.dispose();
  }
}

class _RadialPainter extends CustomPainter {
  _RadialPainter({
    @required this.circles,
    @required this.textDirection,
  })  : assert(circles != null),
        assert(textDirection != null);

  final List<_Circle> circles;
  final TextDirection textDirection;

  static double _maxRadius(Offset center, Size size) {
    final double maxX = math.max(center.dx, size.width - center.dx);
    final double maxY = math.max(center.dy, size.height - center.dy);
    return math.sqrt(maxX * maxX + maxY * maxY);
  }

  @override
  bool shouldRepaint(_RadialPainter oldPainter) {
    if (textDirection != oldPainter.textDirection) return true;
    if (circles == oldPainter.circles) return false;
    if (circles.length != oldPainter.circles.length) return true;
    for (int i = 0; i < circles.length; i += 1) if (circles[i] != oldPainter.circles[i]) return true;
    return false;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (_Circle circle in circles) {
      final Paint paint = Paint()..color = circle.color;
      final Rect rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
      canvas.clipRect(rect);
      double leftFraction;
      switch (textDirection) {
        case TextDirection.rtl:
          leftFraction = 1.0 - circle.horizontalLeadingOffset;
          break;
        case TextDirection.ltr:
          leftFraction = circle.horizontalLeadingOffset;
          break;
      }
      final Offset center = Offset(leftFraction * size.width, size.height / 2.0);
      final Tween<double> radiusTween = Tween<double>(
        begin: 0.0,
        end: _maxRadius(center, size),
      );
      canvas.drawCircle(
        center,
        radiusTween.transform(circle.animation.value),
        paint,
      );
    }
  }
}
