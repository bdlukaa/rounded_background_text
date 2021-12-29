import 'package:flutter/material.dart';
import 'rounded_background_text.dart';

/// A text with rounded background that is embedded inline within text.
///
/// See also:
///
///  * [TextSpan], a node that represents text in an [InlineSpan] tree.
///  * [RoundedBackgroundText], which renders rounded background texts
class RoundedBackgroundTextSpan extends WidgetSpan {
  /// Creates a text with rounded background with the given values
  RoundedBackgroundTextSpan({
    required String text,
    TextStyle? style,
    Color? backgroundColor,
    double textScaleFactor = 1.0,
    Locale? locale,
    TextBaseline? baseline,
  }) : super(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: RoundedBackgroundText(
              text,
              style: style,
              backgroundColor: backgroundColor,
              textScaleFactor: textScaleFactor,
              locale: locale,
            ),
          ),
          baseline: baseline,
        );
}
