import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rounded_background_text/rounded_background_text.dart';

/// Creates a selectable [RoundedBackgroundText].
///
/// See also:
///
///   * [SelectableText], a run of selectable text with a single style.
///   * [RoundedBackgroundTextField], the editable version of this widget.
class RoundedBackgroundTextSelectable extends StatefulWidget {
  final String text;

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
    extends State<RoundedBackgroundTextSelectable> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.text);
  }

  @override
  void didUpdateWidget(covariant RoundedBackgroundTextSelectable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      controller.text = widget.text;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RoundedBackgroundTextField(
      controller: controller,
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
      onSelectionChanged: widget.onSelectionChanged,
      contextMenuBuilder: widget.contextMenuBuilder,
      magnifierConfiguration:
          widget.magnifierConfiguration ?? TextMagnifierConfiguration.disabled,
    );
  }
}
