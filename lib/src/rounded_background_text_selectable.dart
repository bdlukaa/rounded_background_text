import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rounded_background_text/rounded_background_text.dart';

class _SelectableTextSelectionGestureDetectorBuilder
    extends TextSelectionGestureDetectorBuilder {
  _SelectableTextSelectionGestureDetectorBuilder(
      {required _RoundedBackgroundTextSelectableState state})
      : super(delegate: state);

  @override
  void onSingleTapUp(TapDragUpDetails details) {
    if (!delegate.selectionEnabled) {
      return;
    }
    super.onSingleTapUp(details);
    // _state.widget.onTap?.call();
  }
}

/// Creates a selectable [RoundedBackgroundText].
///
/// See also:
///
///   * [SelectableText], a run of selectable text with a single style.
///   * [RoundedBackgroundTextField], the editable version of this widget.
class RoundedBackgroundTextSelectable extends StatefulWidget {
  /// The text to display.
  final String text;

  /// {@macro rounded_background_text.background_color}
  final Color? backgroundColor;

  /// {@macro rounded_background_text.innerRadius}
  final double innerRadius;

  /// {@macro rounded_background_text.outerRadius}
  final double outerRadius;

  /// Defines the focus for this widget.
  ///
  /// Text is only selectable when widget is focused.
  ///
  /// The [focusNode] is a long-lived object that's typically managed by a
  /// [StatefulWidget] parent. See [FocusNode] for more information.
  ///
  /// To give the focus to this widget, provide a [focusNode] and then
  /// use the current [FocusScope] to request the focus:
  ///
  /// ```dart
  /// FocusScope.of(context).requestFocus(myFocusNode);
  /// ```
  ///
  /// This happens automatically when the widget is tapped.
  ///
  /// To be notified when the widget gains or loses the focus, add a listener
  /// to the [focusNode]:
  ///
  /// ```dart
  /// myFocusNode.addListener(() { print(myFocusNode.hasFocus); });
  /// ```
  ///
  /// If null, this widget will create its own [FocusNode] with
  /// [FocusNode.skipTraversal] parameter set to `true`, which causes the widget
  /// to be skipped over during focus traversal.
  final FocusNode? focusNode;

  /// The style to use for the text.
  ///
  /// If null, defaults [DefaultTextStyle] of context.
  final TextStyle? style;

  /// {@macro flutter.widgets.editableText.strutStyle}
  final StrutStyle? strutStyle;

  /// {@macro flutter.widgets.editableText.textAlign}
  final TextAlign? textAlign;

  /// {@macro flutter.widgets.editableText.textDirection}
  final TextDirection? textDirection;

  /// {@macro flutter.painting.textPainter.textScaler}
  final TextScaler? textScaler;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  /// {@macro flutter.widgets.editableText.maxLines}
  final int? maxLines;

  /// {@macro flutter.widgets.editableText.showCursor}
  final bool showCursor;

  /// {@macro flutter.widgets.editableText.cursorWidth}
  final double cursorWidth;

  /// {@macro flutter.widgets.editableText.cursorHeight}
  final double? cursorHeight;

  /// {@macro flutter.widgets.editableText.cursorRadius}
  final Radius? cursorRadius;

  /// The color of the cursor.
  ///
  /// The cursor indicates the current text insertion point.
  ///
  /// If null then [DefaultSelectionStyle.cursorColor] is used. If that is also
  /// null and [ThemeData.platform] is [TargetPlatform.iOS] or
  /// [TargetPlatform.macOS], then [CupertinoThemeData.primaryColor] is used.
  /// Otherwise [ColorScheme.primary] of [ThemeData.colorScheme] is used.
  final Color? cursorColor;

  /// Controls how tall the selection highlight boxes are computed to be.
  ///
  /// See [ui.BoxHeightStyle] for details on available styles.
  final ui.BoxHeightStyle selectionHeightStyle;

  /// Controls how wide the selection highlight boxes are computed to be.
  ///
  /// See [ui.BoxWidthStyle] for details on available styles.
  final ui.BoxWidthStyle selectionWidthStyle;

  /// {@macro flutter.widgets.editableText.enableInteractiveSelection}
  final bool enableInteractiveSelection;

  /// {@macro flutter.widgets.editableText.selectionControls}
  final TextSelectionControls? selectionControls;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@macro flutter.widgets.editableText.selectionEnabled}
  bool get selectionEnabled => enableInteractiveSelection;

  /// {@macro flutter.widgets.editableText.scrollPhysics}
  final ScrollPhysics? scrollPhysics;

  /// {@macro flutter.widgets.editableText.scrollBehavior}
  final ScrollBehavior? scrollBehavior;

  /// {@macro dart.ui.textHeightBehavior}
  final TextHeightBehavior? textHeightBehavior;

  /// {@macro flutter.painting.textPainter.textWidthBasis}
  final TextWidthBasis? textWidthBasis;

  /// {@macro flutter.widgets.editableText.onSelectionChanged}
  final SelectionChangedCallback? onSelectionChanged;

  /// {@macro flutter.widgets.EditableText.contextMenuBuilder}
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  static Widget _defaultContextMenuBuilder(
    BuildContext context,
    EditableTextState editableTextState,
  ) {
    return AdaptiveTextSelectionToolbar.editableText(
        editableTextState: editableTextState);
  }

  /// The configuration for the magnifier used when the text is selected.
  ///
  /// By default, builds a [CupertinoTextMagnifier] on iOS and [TextMagnifier]
  /// on Android, and builds nothing on all other platforms. To suppress the
  /// magnifier, consider passing [TextMagnifierConfiguration.disabled].
  ///
  /// {@macro flutter.widgets.magnifier.intro}
  final TextMagnifierConfiguration? magnifierConfiguration;

  /// Creates a selectable [RoundedBackgroundText].
  const RoundedBackgroundTextSelectable({
    super.key,
    required this.text,
    this.backgroundColor,
    this.innerRadius = kDefaultInnerRadius,
    this.outerRadius = kDefaultOuterRadius,
    this.focusNode,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.textScaler,
    this.autofocus = false,
    this.maxLines,
    this.showCursor = false,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.dragStartBehavior = DragStartBehavior.start,
    this.scrollPhysics,
    this.scrollBehavior,
    this.textHeightBehavior,
    this.textWidthBasis,
    this.onSelectionChanged,
    this.contextMenuBuilder = _defaultContextMenuBuilder,
    this.magnifierConfiguration,
  });

  @override
  State<RoundedBackgroundTextSelectable> createState() =>
      _RoundedBackgroundTextSelectableState();
}

class _RoundedBackgroundTextSelectableState
    extends State<RoundedBackgroundTextSelectable>
    implements TextSelectionGestureDetectorBuilderDelegate {
  EditableTextState? get _editableText => editableTextKey.currentState;
  late final TextEditingController _controller;

  FocusNode? _focusNode;
  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode(skipTraversal: true));

  bool _showSelectionHandles = false;

  late _SelectableTextSelectionGestureDetectorBuilder
      _selectionGestureDetectorBuilder;

  // API for TextSelectionGestureDetectorBuilderDelegate.
  @override
  late bool forcePressEnabled;

  @override
  late final GlobalKey<EditableTextState> editableTextKey;

  final GlobalKey<RoundedBackgroundTextFieldState> fieldKey =
      GlobalKey<RoundedBackgroundTextFieldState>();

  @override
  bool get selectionEnabled => widget.selectionEnabled;
  // End of API for TextSelectionGestureDetectorBuilderDelegate.

  @override
  void initState() {
    super.initState();
    _selectionGestureDetectorBuilder =
        _SelectableTextSelectionGestureDetectorBuilder(state: this);
    _controller = TextEditingController(text: widget.text);
    _controller.addListener(_onControllerChanged);
    _effectiveFocusNode.addListener(_handleFocusChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      editableTextKey = fieldKey.currentState!.fieldKey;
    });
  }

  @override
  void didUpdateWidget(covariant RoundedBackgroundTextSelectable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _controller.text = widget.text;
    }

    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _focusNode)?.removeListener(_handleFocusChanged);
      (widget.focusNode ?? _focusNode)?.addListener(_handleFocusChanged);
    }
    if (_effectiveFocusNode.hasFocus && _controller.selection.isCollapsed) {
      _showSelectionHandles = false;
    } else {
      _showSelectionHandles = true;
    }
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_handleFocusChanged);
    _focusNode?.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    final bool showSelectionHandles =
        !_effectiveFocusNode.hasFocus || !_controller.selection.isCollapsed;
    if (showSelectionHandles == _showSelectionHandles) {
      return;
    }
    setState(() {
      _showSelectionHandles = showSelectionHandles;
    });
  }

  void _handleFocusChanged() {
    if (!_effectiveFocusNode.hasFocus &&
        SchedulerBinding.instance.lifecycleState == AppLifecycleState.resumed) {
      // We should only clear the selection when this SelectableText loses
      // focus while the application is currently running. It is possible
      // that the application is not currently running, for example on desktop
      // platforms, clicking on a different window switches the focus to
      // the new window causing the Flutter application to go inactive. In this
      // case we want to retain the selection so it remains when we return to
      // the Flutter application.
      _controller.value = TextEditingValue(text: _controller.value.text);
    }
  }

  void _handleSelectionChanged(
      TextSelection selection, SelectionChangedCause? cause) {
    final bool willShowSelectionHandles = _shouldShowSelectionHandles(cause);
    if (willShowSelectionHandles != _showSelectionHandles) {
      setState(() {
        _showSelectionHandles = willShowSelectionHandles;
      });
    }

    widget.onSelectionChanged?.call(selection, cause);

    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        if (cause == SelectionChangedCause.longPress) {
          _editableText?.bringIntoView(selection.base);
        }
        return;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      // Do nothing.
    }
  }

  /// Toggle the toolbar when a selection handle is tapped.
  void _handleSelectionHandleTapped() {
    if (_controller.selection.isCollapsed) {
      _editableText!.toggleToolbar();
    }
  }

  bool _shouldShowSelectionHandles(SelectionChangedCause? cause) {
    // When the text field is activated by something that doesn't trigger the
    // selection overlay, we shouldn't show the handles either.
    if (!_selectionGestureDetectorBuilder.shouldShowSelectionToolbar) {
      return false;
    }

    if (_controller.selection.isCollapsed) {
      return false;
    }

    if (cause == SelectionChangedCause.keyboard) {
      return false;
    }

    if (cause == SelectionChangedCause.longPress) {
      return true;
    }

    if (_controller.text.isNotEmpty) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        forcePressEnabled = true;
      case TargetPlatform.macOS:
        forcePressEnabled = false;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        forcePressEnabled = false;
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        forcePressEnabled = false;
    }

    return Semantics(
      onLongPress: () {
        _effectiveFocusNode.requestFocus();
      },
      child: _selectionGestureDetectorBuilder.buildGestureDetector(
        behavior: HitTestBehavior.translucent,
        child: RoundedBackgroundTextField(
          key: fieldKey,
          readOnly: true,
          controller: _controller,
          backgroundColor: widget.backgroundColor,
          focusNode: widget.focusNode,
          style: widget.style,
          strutStyle: widget.strutStyle,
          textAlign: widget.textAlign ?? TextAlign.start,
          textDirection: widget.textDirection,
          textScaler: widget.textScaler,
          autofocus: widget.autofocus,
          maxLines: widget.maxLines,
          showCursor: widget.showCursor,
          cursorWidth: widget.cursorWidth,
          cursorHeight: widget.cursorHeight,
          cursorRadius: widget.cursorRadius,
          cursorColor: widget.cursorColor,
          selectionHeightStyle: widget.selectionHeightStyle,
          selectionWidthStyle: widget.selectionWidthStyle,
          enableInteractiveSelection: widget.enableInteractiveSelection,
          selectionControls: widget.selectionControls,
          dragStartBehavior: widget.dragStartBehavior,
          scrollPhysics: widget.scrollPhysics,
          scrollBehavior: widget.scrollBehavior,
          textHeightBehavior: widget.textHeightBehavior,
          textWidthBasis: widget.textWidthBasis ?? TextWidthBasis.parent,
          onSelectionChanged: _handleSelectionChanged,
          onSelectionHandleTapped: _handleSelectionHandleTapped,
          contextMenuBuilder: widget.contextMenuBuilder,
          magnifierConfiguration: widget.magnifierConfiguration ??
              TextMagnifierConfiguration.disabled,
        ),
      ),
    );
  }
}
