import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'rounded_background_text.dart';

/// A text with rounded background that is embedded inline within text.
///
/// See also:
///
///  * [TextSpan], a node that represents text in an [InlineSpan] tree.
///  * [RoundedBackgroundText], which renders rounded background texts
class RoundedBackgroundTextSpan extends WidgetSpan {
  final String text;

  /// Creates a text with rounded background with the given values
  RoundedBackgroundTextSpan({
    required this.text,
    TextStyle? style,
    Color? backgroundColor,
    double textScaleFactor = 1.0,
    Locale? locale,
    TextBaseline? baseline,
    double? innerRadius,
    double? outerRadius,
    TextAlign? textAlign,
  }) : super(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: RoundedBackgroundText(
              text,
              style: style,
              backgroundColor: backgroundColor,
              textScaleFactor: textScaleFactor,
              locale: locale,
              innerRadius: innerRadius ?? kDefaultInnerRadius,
              outerRadius: outerRadius ?? kDefaultOuterRadius,
              textAlign: textAlign,
              maxLines: 1,
            ),
          ),
          baseline: baseline,
        );

  TextSpan get _textSpan => TextSpan(text: text);

  @override
  InlineSpan? getSpanForPositionVisitor(
      TextPosition position, Accumulator offset) {
    return _textSpan.getSpanForPositionVisitor(position, offset);
  }

  @override
  void computeToPlainText(
    StringBuffer buffer, {
    bool includeSemanticsLabels = true,
    bool includePlaceholders = true,
  }) {
    _textSpan.computeToPlainText(
      buffer,
      includeSemanticsLabels: includeSemanticsLabels,
      includePlaceholders: includePlaceholders,
    );
  }

  @override
  void computeSemanticsInformation(
    List<InlineSpanSemanticsInformation> collector, {
    ui.Locale? inheritedLocale,
    bool inheritedSpellOut = false,
  }) {
    return _textSpan.computeSemanticsInformation(
      collector,
      inheritedLocale: inheritedLocale,
      inheritedSpellOut: inheritedSpellOut,
    );
  }

  @override
  int? codeUnitAtVisitor(int index, Accumulator offset) {
    return _textSpan.codeUnitAtVisitor(index, offset);
  }
}
