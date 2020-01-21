import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;

export 'package:flutter/services.dart' show TextEditingValue, TextSelection, TextInputType;
export 'package:flutter/rendering.dart' show SelectionChangedCause;

typedef SelectionChangedCallback = void Function(TextSelection selection, SelectionChangedCause cause);

const Duration _kCursorBlinkHalfPeriod = Duration(milliseconds: 500);

const Duration _kCursorBlinkWaitForStart = Duration(milliseconds: 150);

const int _kObscureShowLatestCharCursorTicks = 3;


class CustomEditableText extends StatefulWidget {
  CustomEditableText(
      {Key key,
      @required this.controller,
      @required this.focusNode,
      this.readOnly = false,
      this.systemKeyboardActive = true,
      this.obscureText = false,
      this.autocorrect = true,
      @required this.style,
      StrutStyle strutStyle,
      @required this.cursorColor,
      @required this.backgroundCursorColor,
      this.textAlign = TextAlign.start,
      this.textDirection,
      this.locale,
      this.textScaleFactor,
      this.maxLines = 1,
      this.minLines,
      this.expands = false,
      this.forceLine = true,
      this.textWidthBasis = TextWidthBasis.parent,
      this.autofocus = false,
      bool showCursor,
      this.showSelectionHandles = false,
      this.selectionColor,
      this.selectionControls,
      TextInputType keyboardType,
      this.textInputAction,
      this.textCapitalization = TextCapitalization.none,
      this.onChanged,
      this.onEditingComplete,
      this.onSubmitted,
      this.onSelectionChanged,
      this.onSelectionHandleTapped,
      List<TextInputFormatter> inputFormatters,
      this.rendererIgnoresPointer = false,
      this.cursorWidth = 2.0,
      this.cursorRadius,
      this.cursorOpacityAnimates = false,
      this.cursorOffset,
      this.paintCursorAboveText = false,
      this.scrollPadding = const EdgeInsets.all(20.0),
      this.keyboardAppearance = Brightness.light,
      this.dragStartBehavior = DragStartBehavior.start,
      this.enableInteractiveSelection = true,
      this.scrollController,
      this.scrollPhysics,
      this.toolbarOptions = const ToolbarOptions(copy: true, cut: true, paste: true, selectAll: true)})
      : assert(controller != null),
        assert(focusNode != null),
        assert(obscureText != null),
        assert(autocorrect != null),
        assert(showSelectionHandles != null),
        assert(enableInteractiveSelection != null),
        assert(readOnly != null),
        assert(forceLine != null),
        assert(style != null),
        assert(cursorColor != null),
        assert(cursorOpacityAnimates != null),
        assert(paintCursorAboveText != null),
        assert(backgroundCursorColor != null),
        assert(textAlign != null),
        assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          'minLines can\'t be greater than maxLines',
        ),
        assert(expands != null),
        assert(
          !expands || (maxLines == null && minLines == null),
          'minLines and maxLines must be null when expands is true.',
        ),
        assert(autofocus != null),
        assert(rendererIgnoresPointer != null),
        assert(scrollPadding != null),
        assert(dragStartBehavior != null),
        assert(toolbarOptions != null),
        _strutStyle = strutStyle,
        keyboardType = keyboardType ?? (maxLines == 1 ? TextInputType.text : TextInputType.multiline),
        inputFormatters = maxLines == 1
            ? <TextInputFormatter>[
                BlacklistingTextInputFormatter.singleLineFormatter,
                ...inputFormatters ?? const Iterable<TextInputFormatter>.empty(),
              ]
            : inputFormatters,
        showCursor = showCursor ?? !readOnly,
        super(key: key);

  final TextEditingController controller;

  final FocusNode focusNode;

  final bool obscureText;

  final TextWidthBasis textWidthBasis;

  final bool readOnly;

  final bool systemKeyboardActive;

  final bool forceLine;

  final ToolbarOptions toolbarOptions;

  final bool showSelectionHandles;

  final bool showCursor;

  final bool autocorrect;

  final TextStyle style;

  StrutStyle get strutStyle {
    if (_strutStyle == null) {
      return style != null ? StrutStyle.fromTextStyle(style, forceStrutHeight: true) : StrutStyle.disabled;
    }
    return _strutStyle.inheritFromTextStyle(style);
  }

  final StrutStyle _strutStyle;

  final TextAlign textAlign;

  final TextDirection textDirection;

  final TextCapitalization textCapitalization;

  final Locale locale;

  final double textScaleFactor;

  final Color cursorColor;

  final Color backgroundCursorColor;

  final int maxLines;

  final int minLines;

  final bool expands;

  final bool autofocus;

  final Color selectionColor;

  final TextSelectionControls selectionControls;

  final TextInputType keyboardType;

  final TextInputAction textInputAction;

  final ValueChanged<String> onChanged;

  final VoidCallback onEditingComplete;

  final ValueChanged<String> onSubmitted;

  final SelectionChangedCallback onSelectionChanged;

  final VoidCallback onSelectionHandleTapped;

  final List<TextInputFormatter> inputFormatters;

  final bool rendererIgnoresPointer;

  final double cursorWidth;

  final Radius cursorRadius;

  final bool cursorOpacityAnimates;

  final Offset cursorOffset;

  final bool paintCursorAboveText;

  final Brightness keyboardAppearance;

  final EdgeInsets scrollPadding;

  final bool enableInteractiveSelection;

  static bool debugDeterministicCursor = false;

  final DragStartBehavior dragStartBehavior;

  final ScrollController scrollController;

  final ScrollPhysics scrollPhysics;

  bool get selectionEnabled => enableInteractiveSelection;

  @override
  EditableTextState createState() => EditableTextState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextEditingController>('controller', controller));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode));
    properties.add(DiagnosticsProperty<bool>('obscureText', obscureText, defaultValue: false));
    properties.add(DiagnosticsProperty<bool>('autocorrect', autocorrect, defaultValue: true));
    style?.debugFillProperties(properties);
    properties.add(EnumProperty<TextAlign>('textAlign', textAlign, defaultValue: null));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection, defaultValue: null));
    properties.add(DiagnosticsProperty<Locale>('locale', locale, defaultValue: null));
    properties.add(DoubleProperty('textScaleFactor', textScaleFactor, defaultValue: null));
    properties.add(IntProperty('maxLines', maxLines, defaultValue: 1));
    properties.add(IntProperty('minLines', minLines, defaultValue: null));
    properties.add(DiagnosticsProperty<bool>('expands', expands, defaultValue: false));
    properties.add(DiagnosticsProperty<bool>('autofocus', autofocus, defaultValue: false));
    properties.add(DiagnosticsProperty<TextInputType>('keyboardType', keyboardType, defaultValue: null));
    properties.add(DiagnosticsProperty<ScrollController>('scrollController', scrollController, defaultValue: null));
    properties.add(DiagnosticsProperty<ScrollPhysics>('scrollPhysics', scrollPhysics, defaultValue: null));
  }
}

class EditableTextState extends State<CustomEditableText>
    with AutomaticKeepAliveClientMixin<CustomEditableText>, WidgetsBindingObserver, TickerProviderStateMixin<CustomEditableText>
    implements TextInputClient, TextSelectionDelegate {
  Timer _cursorTimer;
  bool _targetCursorVisibility = false;
  final ValueNotifier<bool> _cursorVisibilityNotifier = ValueNotifier<bool>(true);
  final GlobalKey _editableKey = GlobalKey();

  TextInputConnection _textInputConnection;
  TextSelectionOverlay _selectionOverlay;

  ScrollController _scrollController;

  AnimationController _cursorBlinkOpacityController;

  final LayerLink _toolbarLayerLink = LayerLink();
  final LayerLink _startHandleLayerLink = LayerLink();
  final LayerLink _endHandleLayerLink = LayerLink();

  bool _didAutoFocus = false;
  FocusAttachment _focusAttachment;

  static const Duration _fadeDuration = Duration(milliseconds: 250);

  static const Duration _floatingCursorResetTime = Duration(milliseconds: 125);

  AnimationController _floatingCursorResetController;

  @override
  bool get wantKeepAlive => widget.focusNode.hasFocus;

  Color get _cursorColor => widget.cursorColor.withOpacity(_cursorBlinkOpacityController.value);

  @override
  bool get cutEnabled => widget.toolbarOptions.cut && !widget.readOnly;

  @override
  bool get copyEnabled => widget.toolbarOptions.copy;

  @override
  bool get pasteEnabled => widget.toolbarOptions.paste && !widget.readOnly;

  @override
  bool get selectAllEnabled => widget.toolbarOptions.selectAll;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_didChangeTextEditingValue);
    _focusAttachment = widget.focusNode.attach(context);
    widget.focusNode.addListener(_handleFocusChanged);
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(() {
      _selectionOverlay?.updateForScroll();
    });
    _cursorBlinkOpacityController = AnimationController(vsync: this, duration: _fadeDuration);
    _cursorBlinkOpacityController.addListener(_onCursorColorTick);
    _floatingCursorResetController = AnimationController(vsync: this);
    _floatingCursorResetController.addListener(_onFloatingCursorResetTick);
    _cursorVisibilityNotifier.value = widget.showCursor;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didAutoFocus && widget.autofocus) {
      FocusScope.of(context).autofocus(widget.focusNode);
      _didAutoFocus = true;
    }
  }

  @override
  void didUpdateWidget(CustomEditableText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_didChangeTextEditingValue);
      widget.controller.addListener(_didChangeTextEditingValue);
      _updateRemoteEditingValueIfNeeded();
    }
    if (widget.controller.selection != oldWidget.controller.selection) {
      _selectionOverlay?.update(_value);
    }
    _selectionOverlay?.handlesVisible = widget.showSelectionHandles;
    if (widget.focusNode != oldWidget.focusNode) {
      if (oldWidget.keyboardType != widget.keyboardType) {
        _closeInputConnectionIfNeeded();
      }
      oldWidget.focusNode.removeListener(_handleFocusChanged);
      _focusAttachment?.detach();
      _focusAttachment = widget.focusNode.attach(context);
      widget.focusNode.addListener(_handleFocusChanged);
      updateKeepAlive();
    }
    if (widget.readOnly) {
      _closeInputConnectionIfNeeded();
    } else {
      if (oldWidget.readOnly && _hasFocus) _openInputConnection();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeTextEditingValue);
    _cursorBlinkOpacityController.removeListener(_onCursorColorTick);
    _floatingCursorResetController.removeListener(_onFloatingCursorResetTick);
    _closeInputConnectionIfNeeded();
    assert(!_hasInputConnection);
    _stopCursorTimer();
    assert(_cursorTimer == null);
    _selectionOverlay?.dispose();
    _selectionOverlay = null;
    _focusAttachment.detach();
    widget.focusNode.removeListener(_handleFocusChanged);
    super.dispose();
  }

  TextEditingValue _lastKnownRemoteTextEditingValue;

  @override
  void updateEditingValue(TextEditingValue value) {
    if (widget.readOnly) {
      return;
    }
    if (value.text != _value.text) {
      hideToolbar();
      _showCaretOnScreen();
      if (widget.obscureText && value.text.length == _value.text.length + 1) {
        _obscureShowCharTicksPending = _kObscureShowLatestCharCursorTicks;
        _obscureLatestCharIndex = _value.selection.baseOffset;
      }
    }
    _lastKnownRemoteTextEditingValue = value;
    _formatAndSetValue(value);

    _stopCursorTimer(resetCharTicks: false);
    _startCursorTimer();
  }

  @override
  void performAction(TextInputAction action) {
    switch (action) {
      case TextInputAction.newline:
        if (!_isMultiline) _finalizeEditing(true);
        break;
      case TextInputAction.done:
      case TextInputAction.go:
      case TextInputAction.send:
      case TextInputAction.search:
        _finalizeEditing(true);
        break;
      default:
        _finalizeEditing(false);
        break;
    }
  }

  Rect _startCaretRect;

  TextPosition _lastTextPosition;

  Offset _pointOffsetOrigin;

  Offset _lastBoundedOffset;

  Offset get _floatingCursorOffset => Offset(0, renderEditable.preferredLineHeight / 2);

  @override
  void updateFloatingCursor(RawFloatingCursorPoint point) {
    switch (point.state) {
      case FloatingCursorDragState.Start:
        if (_floatingCursorResetController.isAnimating) {
          _floatingCursorResetController.stop();
          _onFloatingCursorResetTick();
        }
        final TextPosition currentTextPosition = TextPosition(offset: renderEditable.selection.baseOffset);
        _startCaretRect = renderEditable.getLocalRectForCaret(currentTextPosition);
        renderEditable.setFloatingCursor(
            point.state, _startCaretRect.center - _floatingCursorOffset, currentTextPosition);
        break;
      case FloatingCursorDragState.Update:
        if (_pointOffsetOrigin != null) {
          final Offset centeredPoint = point.offset - _pointOffsetOrigin;
          final Offset rawCursorOffset = _startCaretRect.center + centeredPoint - _floatingCursorOffset;
          _lastBoundedOffset = renderEditable.calculateBoundedFloatingCursorOffset(rawCursorOffset);
          _lastTextPosition = renderEditable
              .getPositionForPoint(renderEditable.localToGlobal(_lastBoundedOffset + _floatingCursorOffset));
          renderEditable.setFloatingCursor(point.state, _lastBoundedOffset, _lastTextPosition);
        } else {
          _pointOffsetOrigin = point.offset;
        }
        break;
      case FloatingCursorDragState.End:
        if (_lastTextPosition != null && _lastBoundedOffset != null) {
          _floatingCursorResetController.value = 0.0;
          _floatingCursorResetController.animateTo(1.0, duration: _floatingCursorResetTime, curve: Curves.decelerate);
        }
        break;
    }
  }

  void _onFloatingCursorResetTick() {
    final Offset finalPosition =
        renderEditable.getLocalRectForCaret(_lastTextPosition).centerLeft - _floatingCursorOffset;
    if (_floatingCursorResetController.isCompleted) {
      renderEditable.setFloatingCursor(FloatingCursorDragState.End, finalPosition, _lastTextPosition);
      if (_lastTextPosition.offset != renderEditable.selection.baseOffset)
        _handleSelectionChanged(TextSelection.collapsed(offset: _lastTextPosition.offset), renderEditable,
            SelectionChangedCause.forcePress);
      _startCaretRect = null;
      _lastTextPosition = null;
      _pointOffsetOrigin = null;
      _lastBoundedOffset = null;
    } else {
      final double lerpValue = _floatingCursorResetController.value;
      final double lerpX = ui.lerpDouble(_lastBoundedOffset.dx, finalPosition.dx, lerpValue);
      final double lerpY = ui.lerpDouble(_lastBoundedOffset.dy, finalPosition.dy, lerpValue);

      renderEditable.setFloatingCursor(FloatingCursorDragState.Update, Offset(lerpX, lerpY), _lastTextPosition,
          resetLerpValue: lerpValue);
    }
  }

  void _finalizeEditing(bool shouldUnfocus) {
    if (widget.onEditingComplete != null) {
      widget.onEditingComplete();
    } else {
      widget.controller.clearComposing();
      if (shouldUnfocus) widget.focusNode.unfocus();
    }

    if (widget.onSubmitted != null) widget.onSubmitted(_value.text);
  }

  void _updateRemoteEditingValueIfNeeded() {
    if (!_hasInputConnection) return;
    final TextEditingValue localValue = _value;
    if (localValue == _lastKnownRemoteTextEditingValue) return;
    _lastKnownRemoteTextEditingValue = localValue;
    _textInputConnection.setEditingState(localValue);
  }

  TextEditingValue get _value => widget.controller.value;
  set _value(TextEditingValue value) {
    widget.controller.value = value;
  }

  bool get _hasFocus => widget.focusNode.hasFocus;
  bool get _isMultiline => widget.maxLines != 1;

  double _getScrollOffsetForCaret(Rect caretRect) {
    double caretStart;
    double caretEnd;
    if (_isMultiline) {
      final double lineHeight = renderEditable.preferredLineHeight;
      final double caretOffset = (lineHeight - caretRect.height) / 2;
      caretStart = caretRect.top - caretOffset;
      caretEnd = caretRect.bottom + caretOffset;
    } else {
      caretStart = caretRect.left;
      caretEnd = caretRect.right;
    }

    double scrollOffset = _scrollController.offset;
    final double viewportExtent = _scrollController.position.viewportDimension;
    if (caretStart < 0.0) {
      scrollOffset += caretStart;
    } else if (caretEnd >= viewportExtent) {
      scrollOffset += caretEnd - viewportExtent;
    }
    return scrollOffset;
  }

  Rect _getCaretRectAtScrollOffset(Rect caretRect, double scrollOffset) {
    final double offsetDiff = _scrollController.offset - scrollOffset;
    return _isMultiline ? caretRect.translate(0.0, offsetDiff) : caretRect.translate(offsetDiff, 0.0);
  }

  bool get _hasInputConnection => _textInputConnection != null && _textInputConnection.attached;

  void _openInputConnection() {
    if (widget.readOnly) {
      return;
    }
    if (!_hasInputConnection) {
      final TextEditingValue localValue = _value;
      _lastKnownRemoteTextEditingValue = localValue;
      _textInputConnection = TextInput.attach(
        this,
        TextInputConfiguration(
          inputType: widget.keyboardType,
          obscureText: widget.obscureText,
          autocorrect: widget.autocorrect,
          inputAction: widget.textInputAction ??
              (widget.keyboardType == TextInputType.multiline ? TextInputAction.newline : TextInputAction.done),
          textCapitalization: widget.textCapitalization,
          keyboardAppearance: widget.keyboardAppearance,
        ),
      )..setEditingState(localValue);
    }
    if (widget.systemKeyboardActive) {
      _textInputConnection.show();
    }
  }

  void _closeInputConnectionIfNeeded() {
    if (_hasInputConnection) {
      _textInputConnection.close();
      _textInputConnection = null;
      _lastKnownRemoteTextEditingValue = null;
    }
  }

  void _openOrCloseInputConnectionIfNeeded() {
    if (_hasFocus && widget.focusNode.consumeKeyboardToken()) {
      _openInputConnection();
    } else if (!_hasFocus) {
      _closeInputConnectionIfNeeded();
      widget.controller.clearComposing();
    }
  }

  void requestKeyboard() {
    if (_hasFocus) {
      _openInputConnection();
    } else {
      widget.focusNode.requestFocus();
    }
  }

  void _updateOrDisposeSelectionOverlayIfNeeded() {
    if (_selectionOverlay != null) {
      if (_hasFocus) {
        _selectionOverlay.update(_value);
      } else {
        _selectionOverlay.dispose();
        _selectionOverlay = null;
      }
    }
  }

  void _handleSelectionChanged(TextSelection selection, RenderEditable renderObject, SelectionChangedCause cause) {
    widget.controller.selection = selection;

    requestKeyboard();

    _selectionOverlay?.hide();
    _selectionOverlay = null;

    if (widget.selectionControls != null) {
      _selectionOverlay = TextSelectionOverlay(
        context: context,
        value: _value,
        debugRequiredFor: widget,
        toolbarLayerLink: _toolbarLayerLink,
        startHandleLayerLink: _startHandleLayerLink,
        endHandleLayerLink: _endHandleLayerLink,
        renderObject: renderObject,
        selectionControls: widget.selectionControls,
        selectionDelegate: this,
        dragStartBehavior: widget.dragStartBehavior,
        onSelectionHandleTapped: widget.onSelectionHandleTapped,
      );
      _selectionOverlay.handlesVisible = widget.showSelectionHandles;
      _selectionOverlay.showHandles();
      if (widget.onSelectionChanged != null) widget.onSelectionChanged(selection, cause);
    }
  }

  bool _textChangedSinceLastCaretUpdate = false;
  Rect _currentCaretRect;

  void _handleCaretChanged(Rect caretRect) {
    _currentCaretRect = caretRect;

    if (_textChangedSinceLastCaretUpdate) {
      _textChangedSinceLastCaretUpdate = false;
      _showCaretOnScreen();
    }
  }

  static const Duration _caretAnimationDuration = Duration(milliseconds: 100);
  static const Curve _caretAnimationCurve = Curves.fastOutSlowIn;

  bool _showCaretOnScreenScheduled = false;

  void _showCaretOnScreen() {
    if (_showCaretOnScreenScheduled) {
      return;
    }
    _showCaretOnScreenScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((Duration _) {
      _showCaretOnScreenScheduled = false;
      if (_currentCaretRect == null || !_scrollController.hasClients) {
        return;
      }
      final double scrollOffsetForCaret = _getScrollOffsetForCaret(_currentCaretRect);
      _scrollController.animateTo(
        scrollOffsetForCaret,
        duration: _caretAnimationDuration,
        curve: _caretAnimationCurve,
      );
      final Rect newCaretRect = _getCaretRectAtScrollOffset(_currentCaretRect, scrollOffsetForCaret);

      double bottomSpacing = widget.scrollPadding.bottom;
      if (_selectionOverlay?.selectionControls != null) {
        final double handleHeight =
            _selectionOverlay.selectionControls.getHandleSize(renderEditable.preferredLineHeight).height;
        final double interactiveHandleHeight = math.max(
          handleHeight,
          kMinInteractiveDimension,
        );
        final Offset anchor = _selectionOverlay.selectionControls.getHandleAnchor(
          TextSelectionHandleType.collapsed,
          renderEditable.preferredLineHeight,
        );
        final double handleCenter = handleHeight / 2 - anchor.dy;
        bottomSpacing = math.max(
          handleCenter + interactiveHandleHeight / 2,
          bottomSpacing,
        );
      }
      final Rect inflatedRect = Rect.fromLTRB(
        newCaretRect.left - widget.scrollPadding.left,
        newCaretRect.top - widget.scrollPadding.top,
        newCaretRect.right + widget.scrollPadding.right,
        newCaretRect.bottom + bottomSpacing,
      );
      _editableKey.currentContext.findRenderObject().showOnScreen(
            rect: inflatedRect,
            duration: _caretAnimationDuration,
            curve: _caretAnimationCurve,
          );
    });
  }

  double _lastBottomViewInset;

  @override
  void didChangeMetrics() {
    if (_lastBottomViewInset < WidgetsBinding.instance.window.viewInsets.bottom) {
      _showCaretOnScreen();
    }
    _lastBottomViewInset = WidgetsBinding.instance.window.viewInsets.bottom;
  }

  void _formatAndSetValue(TextEditingValue value) {
    final bool textChanged = _value?.text != value?.text;
    if (textChanged && widget.inputFormatters != null && widget.inputFormatters.isNotEmpty) {
      for (TextInputFormatter formatter in widget.inputFormatters) value = formatter.formatEditUpdate(_value, value);
      _value = value;
      _updateRemoteEditingValueIfNeeded();
    } else {
      _value = value;
    }
    if (textChanged && widget.onChanged != null) widget.onChanged(value.text);
  }

  void _onCursorColorTick() {
    renderEditable.cursorColor = widget.cursorColor.withOpacity(_cursorBlinkOpacityController.value);
    _cursorVisibilityNotifier.value = widget.showCursor && _cursorBlinkOpacityController.value > 0;
  }

  @visibleForTesting
  bool get cursorCurrentlyVisible => _cursorBlinkOpacityController.value > 0;

  @visibleForTesting
  Duration get cursorBlinkInterval => _kCursorBlinkHalfPeriod;

  @visibleForTesting
  TextSelectionOverlay get selectionOverlay => _selectionOverlay;

  int _obscureShowCharTicksPending = 0;
  int _obscureLatestCharIndex;

  void _cursorTick(Timer timer) {
    _targetCursorVisibility = !_targetCursorVisibility;
    final double targetOpacity = _targetCursorVisibility ? 1.0 : 0.0;
    if (widget.cursorOpacityAnimates) {
      _cursorBlinkOpacityController.animateTo(targetOpacity, curve: Curves.easeOut);
    } else {
      _cursorBlinkOpacityController.value = targetOpacity;
    }

    if (_obscureShowCharTicksPending > 0) {
      setState(() {
        _obscureShowCharTicksPending--;
      });
    }
  }

  void _cursorWaitForStart(Timer timer) {
    assert(_kCursorBlinkHalfPeriod > _fadeDuration);
    _cursorTimer?.cancel();
    _cursorTimer = Timer.periodic(_kCursorBlinkHalfPeriod, _cursorTick);
  }

  void _startCursorTimer() {
    _targetCursorVisibility = true;
    _cursorBlinkOpacityController.value = 1.0;
    if (CustomEditableText.debugDeterministicCursor) return;
    if (widget.cursorOpacityAnimates) {
      _cursorTimer = Timer.periodic(_kCursorBlinkWaitForStart, _cursorWaitForStart);
    } else {
      _cursorTimer = Timer.periodic(_kCursorBlinkHalfPeriod, _cursorTick);
    }
  }

  void _stopCursorTimer({bool resetCharTicks = true}) {
    _cursorTimer?.cancel();
    _cursorTimer = null;
    _targetCursorVisibility = false;
    _cursorBlinkOpacityController.value = 0.0;
    if (CustomEditableText.debugDeterministicCursor) return;
    if (resetCharTicks) _obscureShowCharTicksPending = 0;
    if (widget.cursorOpacityAnimates) {
      _cursorBlinkOpacityController.stop();
      _cursorBlinkOpacityController.value = 0.0;
    }
  }

  void _startOrStopCursorTimerIfNeeded() {
    if (_cursorTimer == null && _hasFocus && _value.selection.isCollapsed)
      _startCursorTimer();
    else if (_cursorTimer != null && (!_hasFocus || !_value.selection.isCollapsed)) _stopCursorTimer();
  }

  void _didChangeTextEditingValue() {
    _updateRemoteEditingValueIfNeeded();
    _startOrStopCursorTimerIfNeeded();
    _updateOrDisposeSelectionOverlayIfNeeded();
    _textChangedSinceLastCaretUpdate = true;

    setState(() {/* We use widget.controller.value in build(). */});
  }

  void _handleFocusChanged() {
    _openOrCloseInputConnectionIfNeeded();
    _startOrStopCursorTimerIfNeeded();
    _updateOrDisposeSelectionOverlayIfNeeded();
    if (_hasFocus) {
      WidgetsBinding.instance.addObserver(this);
      _lastBottomViewInset = WidgetsBinding.instance.window.viewInsets.bottom;
      _showCaretOnScreen();
      if (!_value.selection.isValid) {
        _handleSelectionChanged(TextSelection.collapsed(offset: _value.text.length), renderEditable, null);
      }
    } else {
      WidgetsBinding.instance.removeObserver(this);

      _value = TextEditingValue(text: _value.text);
    }
    updateKeepAlive();
  }

  TextDirection get _textDirection {
    final TextDirection result = widget.textDirection ?? Directionality.of(context);
    assert(result != null, '$runtimeType created without a textDirection and with no ambient Directionality.');
    return result;
  }

  RenderEditable get renderEditable => _editableKey.currentContext.findRenderObject();

  @override
  TextEditingValue get textEditingValue => _value;

  double get _devicePixelRatio => MediaQuery.of(context).devicePixelRatio ?? 1.0;

  @override
  set textEditingValue(TextEditingValue value) {
    _selectionOverlay?.update(value);
    _formatAndSetValue(value);
  }

  @override
  void bringIntoView(TextPosition position) {
    _scrollController.jumpTo(_getScrollOffsetForCaret(renderEditable.getLocalRectForCaret(position)));
  }

  bool showToolbar() {
    if (_selectionOverlay == null || _selectionOverlay.toolbarIsVisible) {
      return false;
    }

    _selectionOverlay.showToolbar();
    return true;
  }

  @override
  void hideToolbar() {
    _selectionOverlay?.hide();
  }

  void toggleToolbar() {
    assert(_selectionOverlay != null);
    if (_selectionOverlay.toolbarIsVisible) {
      hideToolbar();
    } else {
      showToolbar();
    }
  }

  VoidCallback _semanticsOnCopy(TextSelectionControls controls) {
    return widget.selectionEnabled && copyEnabled && _hasFocus && controls?.canCopy(this) == true
        ? () => controls.handleCopy(this)
        : null;
  }

  VoidCallback _semanticsOnCut(TextSelectionControls controls) {
    return widget.selectionEnabled && cutEnabled && _hasFocus && controls?.canCut(this) == true
        ? () => controls.handleCut(this)
        : null;
  }

  VoidCallback _semanticsOnPaste(TextSelectionControls controls) {
    return widget.selectionEnabled && pasteEnabled && _hasFocus && controls?.canPaste(this) == true
        ? () => controls.handlePaste(this)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    _focusAttachment.reparent();
    super.build(context);

    final TextSelectionControls controls = widget.selectionControls;
    return Scrollable(
      excludeFromSemantics: true,
      axisDirection: _isMultiline ? AxisDirection.down : AxisDirection.right,
      controller: _scrollController,
      physics: widget.scrollPhysics,
      dragStartBehavior: widget.dragStartBehavior,
      viewportBuilder: (BuildContext context, ViewportOffset offset) {
        return CompositedTransformTarget(
          link: _toolbarLayerLink,
          child: Semantics(
            onCopy: _semanticsOnCopy(controls),
            onCut: _semanticsOnCut(controls),
            onPaste: _semanticsOnPaste(controls),
            child: _Editable(
              key: _editableKey,
              startHandleLayerLink: _startHandleLayerLink,
              endHandleLayerLink: _endHandleLayerLink,
              textSpan: buildTextSpan(),
              value: _value,
              cursorColor: _cursorColor,
              backgroundCursorColor: widget.backgroundCursorColor,
              showCursor: CustomEditableText.debugDeterministicCursor
                  ? ValueNotifier<bool>(widget.showCursor)
                  : _cursorVisibilityNotifier,
              forceLine: widget.forceLine,
              readOnly: widget.readOnly,
              hasFocus: _hasFocus,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              expands: widget.expands,
              strutStyle: widget.strutStyle,
              selectionColor: widget.selectionColor,
              textScaleFactor: widget.textScaleFactor ?? MediaQuery.textScaleFactorOf(context),
              textAlign: widget.textAlign,
              textDirection: _textDirection,
              locale: widget.locale,
              textWidthBasis: widget.textWidthBasis,
              obscureText: widget.obscureText,
              autocorrect: widget.autocorrect,
              offset: offset,
              onSelectionChanged: _handleSelectionChanged,
              onCaretChanged: _handleCaretChanged,
              rendererIgnoresPointer: widget.rendererIgnoresPointer,
              cursorWidth: widget.cursorWidth,
              cursorRadius: widget.cursorRadius,
              cursorOffset: widget.cursorOffset,
              paintCursorAboveText: widget.paintCursorAboveText,
              enableInteractiveSelection: widget.enableInteractiveSelection,
              textSelectionDelegate: this,
              devicePixelRatio: _devicePixelRatio,
            ),
          ),
        );
      },
    );
  }

  TextSpan buildTextSpan() {
    if (widget.obscureText) {
      String text = _value.text;
      text = RenderEditable.obscuringCharacter * text.length;
      final int o = _obscureShowCharTicksPending > 0 ? _obscureLatestCharIndex : null;
      if (o != null && o >= 0 && o < text.length) text = text.replaceRange(o, o + 1, _value.text.substring(o, o + 1));
      return TextSpan(style: widget.style, text: text);
    }

    return widget.controller.buildTextSpan(
      style: widget.style,
      withComposing: !widget.readOnly,
    );
  }

}

class _Editable extends LeafRenderObjectWidget {
  const _Editable({
    Key key,
    this.textSpan,
    this.value,
    this.startHandleLayerLink,
    this.endHandleLayerLink,
    this.cursorColor,
    this.backgroundCursorColor,
    this.showCursor,
    this.forceLine,
    this.readOnly,
    this.textWidthBasis,
    this.hasFocus,
    this.maxLines,
    this.minLines,
    this.expands,
    this.strutStyle,
    this.selectionColor,
    this.textScaleFactor,
    this.textAlign,
    @required this.textDirection,
    this.locale,
    this.obscureText,
    this.autocorrect,
    this.offset,
    this.onSelectionChanged,
    this.onCaretChanged,
    this.rendererIgnoresPointer = false,
    this.cursorWidth,
    this.cursorRadius,
    this.cursorOffset,
    this.enableInteractiveSelection = true,
    this.textSelectionDelegate,
    this.paintCursorAboveText,
    this.devicePixelRatio,
  })  : assert(textDirection != null),
        assert(rendererIgnoresPointer != null),
        super(key: key);

  final TextSpan textSpan;
  final TextEditingValue value;
  final Color cursorColor;
  final LayerLink startHandleLayerLink;
  final LayerLink endHandleLayerLink;
  final Color backgroundCursorColor;
  final ValueNotifier<bool> showCursor;
  final bool forceLine;
  final bool readOnly;
  final bool hasFocus;
  final int maxLines;
  final int minLines;
  final bool expands;
  final StrutStyle strutStyle;
  final Color selectionColor;
  final double textScaleFactor;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final Locale locale;
  final bool obscureText;
  final TextWidthBasis textWidthBasis;
  final bool autocorrect;
  final ViewportOffset offset;
  final SelectionChangedHandler onSelectionChanged;
  final CaretChangedHandler onCaretChanged;
  final bool rendererIgnoresPointer;
  final double cursorWidth;
  final Radius cursorRadius;
  final Offset cursorOffset;
  final bool enableInteractiveSelection;
  final TextSelectionDelegate textSelectionDelegate;
  final double devicePixelRatio;
  final bool paintCursorAboveText;

  @override
  RenderEditable createRenderObject(BuildContext context) {
    return RenderEditable(
      text: textSpan,
      cursorColor: cursorColor,
      startHandleLayerLink: startHandleLayerLink,
      endHandleLayerLink: endHandleLayerLink,
      backgroundCursorColor: backgroundCursorColor,
      showCursor: showCursor,
      forceLine: forceLine,
      readOnly: readOnly,
      hasFocus: hasFocus,
      maxLines: maxLines,
      minLines: minLines,
      expands: expands,
      strutStyle: strutStyle,
      selectionColor: selectionColor,
      textScaleFactor: textScaleFactor,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale ?? Localizations.localeOf(context, nullOk: true),
      selection: value.selection,
      offset: offset,
      onSelectionChanged: onSelectionChanged,
      onCaretChanged: onCaretChanged,
      ignorePointer: rendererIgnoresPointer,
      obscureText: obscureText,
      textWidthBasis: textWidthBasis,
      cursorWidth: cursorWidth,
      cursorRadius: cursorRadius,
      cursorOffset: cursorOffset,
      paintCursorAboveText: paintCursorAboveText,
      enableInteractiveSelection: enableInteractiveSelection,
      textSelectionDelegate: textSelectionDelegate,
      devicePixelRatio: devicePixelRatio,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderEditable renderObject) {
    renderObject
      ..text = textSpan
      ..cursorColor = cursorColor
      ..startHandleLayerLink = startHandleLayerLink
      ..endHandleLayerLink = endHandleLayerLink
      ..showCursor = showCursor
      ..forceLine = forceLine
      ..readOnly = readOnly
      ..hasFocus = hasFocus
      ..maxLines = maxLines
      ..minLines = minLines
      ..expands = expands
      ..strutStyle = strutStyle
      ..selectionColor = selectionColor
      ..textScaleFactor = textScaleFactor
      ..textAlign = textAlign
      ..textDirection = textDirection
      ..locale = locale ?? Localizations.localeOf(context, nullOk: true)
      ..selection = value.selection
      ..offset = offset
      ..onSelectionChanged = onSelectionChanged
      ..onCaretChanged = onCaretChanged
      ..ignorePointer = rendererIgnoresPointer
      ..textWidthBasis = textWidthBasis
      ..obscureText = obscureText
      ..cursorWidth = cursorWidth
      ..cursorRadius = cursorRadius
      ..cursorOffset = cursorOffset
      ..textSelectionDelegate = textSelectionDelegate
      ..devicePixelRatio = devicePixelRatio
      ..paintCursorAboveText = paintCursorAboveText;
  }
}
