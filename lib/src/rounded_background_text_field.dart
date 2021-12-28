import 'package:flutter/material.dart';

import 'rounded_background_text.dart';

/// A wrapper around [RoundedBackgroundText] and [TextField]
class HighlightTextField extends StatefulWidget {
  const HighlightTextField({
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
  }) : super(key: key);

  final TextEditingController controller;
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

  @override
  _HighlightTextFieldState createState() => _HighlightTextFieldState();
}

class _HighlightTextFieldState extends State<HighlightTextField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = DefaultTextStyle.of(context);

    return Center(
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          const Positioned.fill(child: SizedBox.expand()),
          if (widget.controller.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 3.0),
              child: RoundedBackgroundText(
                widget.controller.text,
                style: widget.style,
                textAlign: widget.textAlign,
                backgroundColor: widget.backgroundColor,
              ),
            ),
          Positioned(
            top: 3.0,
            left: 0,
            right: 0,
            child: TextField(
              autofocus: true,
              controller: widget.controller,
              style: widget.style?.copyWith(
                color: Colors.transparent,
                // color: Colors.black,
                height: calculateHeight(
                  widget.style?.fontSize ??
                      defaultTextStyle.style.fontSize ??
                      16,
                ),
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
