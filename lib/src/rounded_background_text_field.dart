import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'rounded_background_text.dart';

/// A wrapper around [RoundedBackgroundText] and [TextField]
class RoundedBackgroundTextField extends StatefulWidget {
  const RoundedBackgroundTextField({
    Key? key,
    required this.controller,
    this.style,
    this.backgroundColor,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.textScaleFactor,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines,
    this.cursorWidth = 2.0,
    this.cursorColor,
    this.cursorHeight,
    this.cursorRadius,
    this.keyboardType,
    this.hint,
    this.innerRadius = kDefaultInnerFactor,
    this.outerRadius = kDefaultOuterFactor,
    this.autofocus = false,
    this.focusNode,
    this.keyboardAppearance = Brightness.light,
    this.enableInteractiveSelection = true,
    this.selectionControls,
  }) : super(key: key);

  final TextEditingController controller;

  /// The final text style
  ///
  /// The font size will be reduced if there isn't enough space for the text
  final TextStyle? style;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// {@macro flutter.widgets.editableText.textDirection}
  final TextDirection? textDirection;

  /// {@macro flutter.widgets.editableText.textCapitalization}
  final TextCapitalization textCapitalization;

  /// {@macro flutter.widgets.editableText.textScaleFactor}
  final double? textScaleFactor;

  /// {@macro rounded_background_text.background_color}
  final Color? backgroundColor;

  final int? maxLines;

  /// {@macro flutter.widgets.editableText.cursorWidth}
  final double cursorWidth;

  /// {@macro flutter.widgets.editableText.cursorHeight}
  final double? cursorHeight;

  /// {@macro flutter.widgets.editableText.cursorRadius}
  final Radius? cursorRadius;

  /// The color of the cursor.
  ///
  /// The cursor indicates the current location of text insertion point in
  /// the field.
  ///
  /// If this is null it will default to the ambient
  /// [TextSelectionThemeData.cursorColor]. If that is null, and the
  /// [ThemeData.platform] is [TargetPlatform.iOS] or [TargetPlatform.macOS]
  /// it will use [CupertinoThemeData.primaryColor]. Otherwise it will use
  /// the value of [ColorScheme.primary] of [ThemeData.colorScheme].
  final Color? cursorColor;

  /// {@macro flutter.widgets.editableText.keyboardType}
  final TextInputType? keyboardType;

  /// The text hint
  final String? hint;

  /// {@macro rounded_background_text.innerRadius}
  final double innerRadius;

  /// {@macro rounded_background_text.outerRadius}
  final double outerRadius;

  /// Defines the keyboard focus for this widget.
  ///
  /// The [focusNode] is a long-lived object that's typically managed by a
  /// [StatefulWidget] parent. See [FocusNode] for more information.
  ///
  /// To give the keyboard focus to this widget, provide a [focusNode] and then
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
  /// focusNode.addListener(() { print(myFocusNode.hasFocus); });
  /// ```
  ///
  /// If null, this widget will create its own [FocusNode].
  ///
  /// ## Keyboard
  ///
  /// Requesting the focus will typically cause the keyboard to be shown
  /// if it's not showing already.
  ///
  /// On Android, the user can hide the keyboard - without changing the focus -
  /// with the system back button. They can restore the keyboard's visibility
  /// by tapping on a text field.  The user might hide the keyboard and
  /// switch to a physical keyboard, or they might just need to get it
  /// out of the way for a moment, to expose something it's
  /// obscuring. In this case requesting the focus again will not
  /// cause the focus to change, and will not make the keyboard visible.
  ///
  /// This widget builds an [EditableText] and will ensure that the keyboard is
  /// showing when it is tapped by calling [EditableTextState.requestKeyboard()].
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  /// The appearance of the keyboard.
  ///
  /// This setting is only honored on iOS devices.
  ///
  /// Defaults to [Brightness.light].
  final Brightness keyboardAppearance;

  /// {@macro flutter.widgets.editableText.enableInteractiveSelection}
  final bool enableInteractiveSelection;

  /// {@macro flutter.widgets.editableText.selectionControls}
  final TextSelectionControls? selectionControls;

  /// {@macro flutter.widgets.editableText.selectionEnabled}
  bool get selectionEnabled => enableInteractiveSelection;

  @override
  _RoundedBackgroundTextFieldState createState() =>
      _RoundedBackgroundTextFieldState();
}

class _RoundedBackgroundTextFieldState
    extends State<RoundedBackgroundTextField> {
  double finalScale = 1.0;

  FocusNode? _focusNode;
  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    // final text = widget.controller;
    // if (!text.text.contains('\n')) {
    //   widget.controller.text += '\n';
    // }
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (mounted) {
        scale();
      }
    });
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChange);
    super.dispose();
  }

  Size getSize() {
    RenderBox box = context.findRenderObject() as RenderBox;
    return box.size;
  }

  double scale() {
    final size = getSize();

    final painter = TextPainter(
      text: TextSpan(
          text: widget.controller.text,
          style: widget.style?.copyWith(
            height: calculateHeight(
              (widget.style?.fontSize ?? 16) * finalScale,
            ),
          )),
      textDirection: TextDirection.ltr,
      maxLines: widget.maxLines,
      textAlign: widget.textAlign,
      // textWidthBasis: widget.textWidthBasis ?? TextWidthBasis.parent,
      // textScaleFactor: widget.textScaleFactor,
      // strutStyle: widget.strutStyle,
      // locale: widget.locale,
      // textHeightBehavior: widget.textHeightBehavior,
      // ellipsis: widget.ellipsis,
    )..layout(maxWidth: size.width);

    final scale = (size.height / painter.size.height).clamp(0.0, 1.0);
    // debugPrint('${size.height}/${painter.size.height} - $scale');

    if (finalScale != scale && mounted) {
      setState(() => finalScale = scale);
    }

    return finalScale;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final TextSelectionThemeData selectionTheme =
        TextSelectionTheme.of(context);
    final defaultTextStyle = DefaultTextStyle.of(context);

    final fontSize =
        (widget.style?.fontSize ?? defaultTextStyle.style.fontSize ?? 16) *
            finalScale;

    TextSelectionControls? textSelectionControls = widget.selectionControls;
    final bool paintCursorAboveText;
    final bool cursorOpacityAnimates;
    Offset? cursorOffset;
    Color? cursorColor = widget.cursorColor;
    final Color selectionColor;
    Color? autocorrectionTextRectColor;
    Radius? cursorRadius = widget.cursorRadius;

    switch (theme.platform) {
      case TargetPlatform.iOS:
        final CupertinoThemeData cupertinoTheme = CupertinoTheme.of(context);
        textSelectionControls ??= cupertinoTextSelectionControls;
        paintCursorAboveText = true;
        cursorOpacityAnimates = true;
        cursorColor ??=
            selectionTheme.cursorColor ?? cupertinoTheme.primaryColor;
        selectionColor = selectionTheme.selectionColor ??
            cupertinoTheme.primaryColor.withOpacity(0.40);
        cursorRadius ??= const Radius.circular(2.0);
        cursorOffset = Offset(
            iOSHorizontalOffset / MediaQuery.of(context).devicePixelRatio, 0);
        autocorrectionTextRectColor = selectionColor;
        break;

      case TargetPlatform.macOS:
        final CupertinoThemeData cupertinoTheme = CupertinoTheme.of(context);
        textSelectionControls ??= cupertinoDesktopTextSelectionControls;
        paintCursorAboveText = true;
        cursorOpacityAnimates = true;
        cursorColor ??=
            selectionTheme.cursorColor ?? cupertinoTheme.primaryColor;
        selectionColor = selectionTheme.selectionColor ??
            cupertinoTheme.primaryColor.withOpacity(0.40);
        cursorRadius ??= const Radius.circular(2.0);
        cursorOffset = Offset(
            iOSHorizontalOffset / MediaQuery.of(context).devicePixelRatio, 0);
        break;

      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        textSelectionControls ??= materialTextSelectionControls;
        paintCursorAboveText = false;
        cursorOpacityAnimates = false;
        cursorColor ??= selectionTheme.cursorColor ?? theme.colorScheme.primary;
        selectionColor = selectionTheme.selectionColor ??
            theme.colorScheme.primary.withOpacity(0.40);
        break;

      case TargetPlatform.linux:
      case TargetPlatform.windows:
        textSelectionControls ??= desktopTextSelectionControls;
        paintCursorAboveText = false;
        cursorOpacityAnimates = false;
        cursorColor ??= selectionTheme.cursorColor ?? theme.colorScheme.primary;
        selectionColor = selectionTheme.selectionColor ??
            theme.colorScheme.primary.withOpacity(0.40);
        break;
    }

    return Center(
      child: Stack(
        alignment: Alignment.topCenter,
        // clipBehavior: Clip.none,
        children: [
          const Positioned.fill(child: SizedBox.expand()),
          if (widget.controller.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 2.0, left: 1.0),
              child: RoundedBackgroundText(
                widget.controller.text,
                style: widget.style?.copyWith(fontSize: fontSize),
                textAlign: widget.textAlign,
                backgroundColor: widget.backgroundColor,
                innerRadius: widget.innerRadius,
                outerRadius: widget.outerRadius,
              ),
            ),
          Positioned.fill(
            child: EditableText(
              autofocus: widget.autofocus,
              controller: widget.controller,
              focusNode: _effectiveFocusNode,
              // The text field can't be scrollable because
              // [RoundedBackgroundText] can't follow the scroll
              scrollPhysics: const NeverScrollableScrollPhysics(),
              scrollBehavior: const ScrollBehavior(),

              style: (widget.style ?? const TextStyle()).copyWith(
                color: Colors.transparent,
                // color: Colors.black,
                fontSize: fontSize,
                height: calculateHeight(fontSize),
              ),
              textAlign: widget.textAlign,
              maxLines: widget.maxLines,
              keyboardType: widget.keyboardType,
              backgroundCursorColor: CupertinoColors.inactiveGray,
              cursorColor: widget.cursorColor ??
                  widget.style?.color ??
                  foregroundColor(widget.backgroundColor) ??
                  selectionTheme.cursorColor ??
                  Colors.black,
              cursorWidth: widget.cursorWidth,
              cursorHeight: widget.cursorHeight,
              cursorRadius: widget.cursorRadius,
              paintCursorAboveText: paintCursorAboveText,
              cursorOpacityAnimates: cursorOpacityAnimates,
              cursorOffset: cursorOffset,
              autocorrectionTextRectColor: autocorrectionTextRectColor,
              scrollPadding: EdgeInsets.zero,
              textCapitalization: widget.textCapitalization,
              keyboardAppearance: widget.keyboardAppearance,
              textScaleFactor: widget.textScaleFactor,
              enableInteractiveSelection: widget.enableInteractiveSelection,
              selectionColor: selectionColor,
              selectionControls:
                  widget.selectionEnabled ? textSelectionControls : null,
            ),
          ),
        ],
      ),
    );
  }
}
