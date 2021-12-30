import 'package:flutter/material.dart';

import 'rounded_background_text.dart';

/// A wrapper around [RoundedBackgroundText] and [TextField]
class RoundedBackgroundTextField extends StatefulWidget {
  const RoundedBackgroundTextField({
    Key? key,
    required this.controller,
    this.style,
    this.textAlign = TextAlign.start,
    this.backgroundColor,
    this.maxLines,
    this.cursorWidth = 2.0,
    this.cursorColor,
    this.cursorHeight,
    this.cursorRadius,
    this.keyboardType,
    this.hint,
    this.innerRadius = kDefaultInnerFactor,
    this.outerRadius = kDefaultOuterFactor,
  }) : super(key: key);

  final TextEditingController controller;

  /// The final text style
  ///
  /// The font size will be reduced if there isn't enough space for the text
  final TextStyle? style;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

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

  @override
  _RoundedBackgroundTextFieldState createState() =>
      _RoundedBackgroundTextFieldState();
}

class _RoundedBackgroundTextFieldState
    extends State<RoundedBackgroundTextField> {
  double finalScale = 1.0;

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
    final defaultTextStyle = DefaultTextStyle.of(context);

    final fontSize =
        (widget.style?.fontSize ?? defaultTextStyle.style.fontSize ?? 16) *
            finalScale;

    return Center(
      child: Stack(
        alignment: Alignment.topCenter,
        // clipBehavior: Clip.none,
        children: [
          const Positioned.fill(child: SizedBox.expand()),
          if (widget.controller.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 3.0),
              child: RoundedBackgroundText(
                widget.controller.text,
                style: widget.style?.copyWith(fontSize: fontSize),
                textAlign: widget.textAlign,
                backgroundColor: widget.backgroundColor,
                innerRadius: widget.innerRadius,
                outerRadius: widget.outerRadius,
              ),
            ),
          Positioned(
            top: 3.0,
            left: 0,
            right: 0,
            bottom: 0.0,
            child: TextField(
              autofocus: true,
              controller: widget.controller,

              /// The text field can't be scrollable because
              /// [RoundedBackgroundText] can't follow the scroll
              scrollPhysics: const NeverScrollableScrollPhysics(),
              style: widget.style?.copyWith(
                color: Colors.transparent,
                // color: Colors.black,
                fontSize: fontSize,
                height: calculateHeight(fontSize),
              ),
              textAlign: widget.textAlign,
              maxLines: widget.maxLines,
              keyboardType: widget.keyboardType,
              cursorColor: widget.cursorColor ??
                  widget.style?.color ??
                  foregroundColor(widget.backgroundColor),
              cursorWidth: widget.cursorWidth,
              cursorHeight: widget.cursorHeight,
              cursorRadius: widget.cursorRadius,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: widget.hint,
              ),
              textCapitalization: TextCapitalization.sentences,
              keyboardAppearance: Brightness.dark,
            ),
          ),
        ],
      ),
    );
  }
}
