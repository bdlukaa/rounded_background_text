import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../rounded_background_text.dart';

const Color kDefaultRoundedTextBackgroundColor = Colors.blue;
const double kDefaultInnerFactor = 8.0;
const double kDefaultOuterFactor = 10.0;

/// Gets the foreground color based on [backgroundColor]
Color? foregroundColor(Color? backgroundColor) {
  return backgroundColor == null || backgroundColor.alpha == 0
      ? null
      : backgroundColor.computeLuminance() >= 0.5
          ? Colors.black
          : Colors.white;
}

/// Calculates the line height based on [fontSize]
double calculateHeight(double fontSize) {
  // fontSize * x = fontSize + 14
  // x = (fontSize + 14) / fontSize
  return (fontSize + 14) / fontSize;
}

List<List<LineMetricsHelper>> generateLineInfosForPainter(
  TextPainter painter, [
  double maxWidth = double.infinity,
]) {
  painter.layout(maxWidth: maxWidth);
  final metrics = painter.computeLineMetrics();

  final helpers = metrics.map((lineMetric) {
    return LineMetricsHelper(lineMetric, metrics.length);
  });

  final List<List<LineMetricsHelper>> lineInfos = [[]];

  for (final line in helpers) {
    if (line.isEmpty) {
      lineInfos.add([]);
    } else {
      lineInfos.last.add(line);
    }
  }

  return lineInfos;
}

const singleLinePadding = EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0);
const firstLinePadding = EdgeInsets.only(
  left: 8.0,
  right: 8.0,
  top: 8.0,
  bottom: 0,
);
const innerLinePadding = EdgeInsets.only(
  left: 8.0,
  right: 8.0,
  top: 0.0,
  bottom: 4.0,
);
const lastLinePadding = EdgeInsets.only(
  left: 8.0,
  right: 8.0,
  top: 0.0,
  bottom: 4.0,
);

/// Creates a paragraph with rounded background text
///
/// See also:
///
///  * [RichText], which this widget uses to render text
///  * [TextPainter], which is used to calculate the line metrics
///  * [TextStyle], used to customize the text look and feel
class RoundedBackgroundText extends StatelessWidget {
  /// Creates a rounded background text with a single style.
  RoundedBackgroundText(
    String text, {
    Key? key,
    TextStyle? style,
    this.textDirection,
    this.textAlign,
    this.backgroundColor,
    this.textWidthBasis,
    this.ellipsis,
    this.locale,
    this.strutStyle,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.textHeightBehavior,
    this.innerRadius = kDefaultInnerFactor,
    this.outerRadius = kDefaultOuterFactor,
  })  : text = TextSpan(text: text, style: style),
        super(key: key);

  /// Creates a rounded background text based on an [InlineSpan], that can have
  /// multiple styles
  const RoundedBackgroundText.rich({
    Key? key,
    required this.text,
    this.textDirection,
    this.backgroundColor,
    this.textAlign,
    this.textWidthBasis,
    this.ellipsis,
    this.locale,
    this.strutStyle,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.textHeightBehavior,
    this.innerRadius = kDefaultInnerFactor,
    this.outerRadius = kDefaultOuterFactor,
  })  : assert(innerRadius >= 0.0 && innerRadius <= 20.0),
        assert(outerRadius >= 0.0 && outerRadius <= 20.0),
        super(key: key);

  /// Creates a selectable [RoundedBackgroundText]
  ///
  /// See also:
  ///
  ///   * [SelectableText], a run of selectable text with a single style.
  ///   * [RoundedBackgroundTextField], the editable version of this widget.
  static Widget selectable(
    String text, {
    Key? key,
    FocusNode? focusNode,
    bool autofocus = false,
    ToolbarOptions toolbarOptions = const ToolbarOptions(
      selectAll: true,
      copy: true,
    ),
    TextSelectionControls? selectionControls,
    TextStyle? style,
    TextDirection? textDirection,
    Color? backgroundColor,
    TextAlign textAlign = TextAlign.start,
    TextWidthBasis? textWidthBasis,
    double textScaleFactor = 1.0,
    double innerRadius = kDefaultInnerFactor,
    double outerRadius = kDefaultOuterFactor,
    MouseCursor? mouseCursor,
    double cursorWidth = 2.0,
    Color? cursorColor,
    double? cursorHeight,
    Radius? cursorRadius,
    SelectionChangedCallback? onSelectionChanged,
    bool enableInteractiveSelection = true,
  }) {
    final controller = TextEditingController();
    controller.text = text;
    return RoundedBackgroundTextField(
      key: key,
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      toolbarOptions: toolbarOptions,
      style: style,
      readOnly: true,
      textDirection: textDirection,
      backgroundColor: backgroundColor,
      textAlign: textAlign,
      textScaleFactor: textScaleFactor,
      innerRadius: innerRadius,
      outerRadius: outerRadius,
      mouseCursor: mouseCursor,
      autocorrect: false,
      cursorColor: cursorColor,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorWidth: cursorWidth,
      selectionControls: selectionControls,
      onSelectionChanged: onSelectionChanged,
      enableInteractiveSelection: enableInteractiveSelection,
    );
  }

  /// Creates a selectable [RoundedBackgroundText] that can have multiple styles
  ///
  /// See also:
  ///
  ///   * [SelectableText], a run of selectable text with a single style.
  ///   * [RoundedBackgroundTextField], the editable version of this widget.
  static Widget selectableRich(
    TextSpan textSpan, {
    Key? key,
    FocusNode? focusNode,
    bool autofocus = false,
    ToolbarOptions toolbarOptions = const ToolbarOptions(
      selectAll: true,
      copy: true,
    ),
    TextSelectionControls? selectionControls,
    TextStyle? style,
    TextDirection? textDirection,
    Color? backgroundColor,
    TextAlign textAlign = TextAlign.start,
    TextWidthBasis? textWidthBasis,
    double textScaleFactor = 1.0,
    double innerRadius = kDefaultInnerFactor,
    double outerRadius = kDefaultOuterFactor,
    MouseCursor? mouseCursor,
    double cursorWidth = 2.0,
    Color? cursorColor,
    double? cursorHeight,
    Radius? cursorRadius,
    SelectionChangedCallback? onSelectionChanged,
    bool enableInteractiveSelection = true,
  }) {
    final controller = _TextSpanEditingController(textSpan: textSpan);
    return RoundedBackgroundTextField(
      key: key,
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      toolbarOptions: toolbarOptions,
      style: style,
      readOnly: true,
      textDirection: textDirection,
      backgroundColor: backgroundColor,
      textAlign: textAlign,
      textScaleFactor: textScaleFactor,
      innerRadius: innerRadius,
      outerRadius: outerRadius,
      mouseCursor: mouseCursor,
      autocorrect: false,
      cursorColor: cursorColor,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorWidth: cursorWidth,
      selectionControls: selectionControls,
      onSelectionChanged: onSelectionChanged,
      enableInteractiveSelection: enableInteractiveSelection,
    );
  }

  /// The text to display in this widget.
  final InlineSpan text;

  /// The directionality of the text.
  final TextDirection? textDirection;

  /// {@template rounded_background_text.background_color}
  /// The text background color.
  ///
  /// If null, [kDefaultRoundedTextBackgroundColor] will be used.
  /// {@end-template}
  final Color? backgroundColor;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// {@macro flutter.painting.textPainter.textWidthBasis}
  final TextWidthBasis? textWidthBasis;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be truncated.
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  final int? maxLines;

  /// {@macro flutter.dart:ui.textHeightBehavior}
  final TextHeightBehavior? textHeightBehavior;

  /// The string used to ellipsize overflowing text.
  final String? ellipsis;

  /// Used to select a font when the same Unicode character can
  /// be rendered differently, depending on the locale.
  ///
  /// It's rarely necessary to set this property. By default its value
  /// is inherited from the enclosing app with `Localizations.localeOf(context)`.
  ///
  /// See [RenderParagraph.locale] for more information.
  final Locale? locale;

  /// {@macro flutter.painting.textPainter.strutStyle}
  final StrutStyle? strutStyle;

  /// The number of font pixels for each logical pixel.
  ///
  /// For example, if the text scale factor is 1.5, text will be 50% larger than
  /// the specified font size.
  final double textScaleFactor;

  /// {@template rounded_background_text.innerRadius}
  /// The radius of the inner corners.
  ///
  /// Defaults to [this.innerFactor]
  /// {@end-template}
  final double innerRadius;

  /// {@template rounded_background_text.outerRadius}
  /// The radius of the inner corners.
  ///
  /// Defaults to [this.outerFactor]
  /// {@end-template}
  final double outerRadius;

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = DefaultTextStyle.of(context);
    final style = text.style ?? defaultTextStyle.style;
    return _RoundedBackgroundText(
      text: TextSpan(
        children: [text],
        style: TextStyle(
          color: foregroundColor(backgroundColor),
          leadingDistribution: TextLeadingDistribution.proportional,
          height: calculateHeight(style.fontSize ?? 16),
          fontSize: style.fontSize ?? 16.0,
        ).merge(style),
      ),
      textDirection:
          textDirection ?? Directionality.maybeOf(context) ?? TextDirection.ltr,
      textAlign: textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start,
      backgroundColor: backgroundColor ?? Colors.transparent,
      textWidthBasis: textWidthBasis ?? defaultTextStyle.textWidthBasis,
      maxLines: maxLines ?? defaultTextStyle.maxLines,
      textHeightBehavior:
          textHeightBehavior ?? defaultTextStyle.textHeightBehavior,
      ellipsis: ellipsis,
      locale: locale,
      strutStyle: strutStyle,
      textScaleFactor: textScaleFactor,
      innerFactor: innerRadius,
      outerFactor: outerRadius,
    );
  }
}

class _TextSpanEditingController extends TextEditingController {
  _TextSpanEditingController({required TextSpan textSpan})
      : _textSpan = textSpan,
        super(text: textSpan.toPlainText(includeSemanticsLabels: false));

  final TextSpan _textSpan;

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    // This does not care about composing.
    return TextSpan(
      style: style,
      children: <TextSpan>[_textSpan],
    );
  }

  @override
  set text(String? newText) {
    // This should never be reached.
    throw UnimplementedError();
  }
}

class _RoundedBackgroundText extends StatefulWidget {
  const _RoundedBackgroundText({
    Key? key,
    required this.text,
    required this.textDirection,
    this.backgroundColor = kDefaultRoundedTextBackgroundColor,
    this.maxLines,
    this.textAlign = TextAlign.center,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textScaleFactor = 1,
    this.strutStyle,
    this.locale,
    this.textHeightBehavior,
    this.ellipsis,
    this.innerFactor = kDefaultInnerFactor,
    this.outerFactor = kDefaultOuterFactor,
  }) : super(key: key);

  final InlineSpan text;
  final TextDirection textDirection;

  final Color backgroundColor;
  final int? maxLines;
  final TextAlign textAlign;
  final TextWidthBasis? textWidthBasis;
  final double textScaleFactor;
  final StrutStyle? strutStyle;
  final Locale? locale;
  final TextHeightBehavior? textHeightBehavior;
  final String? ellipsis;

  final double innerFactor;
  final double outerFactor;

  @override
  __RoundedBackgroundTextState createState() => __RoundedBackgroundTextState();
}

class __RoundedBackgroundTextState extends State<_RoundedBackgroundText> {
  final parentKey = GlobalKey();

  List<List<LineMetricsHelper>> lineInfos = [];

  Size requiredSize = Size.zero;
  double lastMaxWidth = 0;

  @override
  void initState() {
    super.initState();
    generate();
  }

  @override
  void didUpdateWidget(_RoundedBackgroundText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.textAlign != widget.textAlign ||
        oldWidget.textDirection != widget.textDirection ||
        oldWidget.textWidthBasis != widget.textWidthBasis) {
      generate();
    }
  }

  late TextPainter painter;

  void generate() {
    // debugPrint('generating on $lastMaxWidth w');
    painter = TextPainter(
      text: widget.text,
      textDirection: widget.textDirection,
      maxLines: widget.maxLines,
      textAlign: widget.textAlign,
      textWidthBasis: widget.textWidthBasis ?? TextWidthBasis.parent,
      textScaleFactor: widget.textScaleFactor,
      strutStyle: widget.strutStyle,
      locale: widget.locale,
      textHeightBehavior: widget.textHeightBehavior,
      ellipsis: widget.ellipsis,
    );

    lineInfos = generateLineInfosForPainter(painter, lastMaxWidth);
    requiredSize = painter.size;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      final maxWidth = size.maxWidth;
      if (lastMaxWidth != maxWidth) {
        lastMaxWidth = maxWidth;
        generate();
      }
      return SizedBox(
        width: requiredSize.width == 0 || requiredSize.width.isInfinite
            ? maxWidth
            : requiredSize.width,
        child: CustomPaint(
          isComplex: true,
          willChange: true,
          size: Size(
            size.maxWidth,
            size.maxHeight.isInfinite ? requiredSize.height : size.maxHeight,
          ),
          painter: _HighlightPainter(
            lineInfos: lineInfos,
            backgroundColor: widget.backgroundColor,
            text: painter,
            innerFactor: widget.innerFactor,
            outerFactor: widget.outerFactor,
          ),
        ),
      );
    });
  }
}

class _HighlightPainter extends CustomPainter {
  final List<List<LineMetricsHelper>> lineInfos;
  final Color backgroundColor;
  final TextPainter text;

  final double innerFactor;
  final double outerFactor;

  const _HighlightPainter({
    required this.lineInfos,
    required this.backgroundColor,
    required this.text,
    this.innerFactor = kDefaultInnerFactor,
    this.outerFactor = kDefaultOuterFactor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final lineInfo in lineInfos) {
      paintBackground(canvas, lineInfo);
    }

    text.paint(canvas, Offset.zero);
  }

  void paintBackground(Canvas canvas, List<LineMetricsHelper> lineInfos) {
    if (lineInfos.isEmpty) return;
    if (lineInfos.length == 1) {
      final info = lineInfos.first;
      if (!info.isEmpty) {
        canvas.drawRRect(
          RRect.fromLTRBR(
            info.x,
            info.y,
            info.fullWidth,
            info.fullHeight,
            Radius.circular(outerFactor),
          ),
          Paint()..color = backgroundColor,
        );
      }
      return;
    }

    final path = Path();
    final firstInfo = lineInfos.elementAt(0);
    final lastInfo = lineInfos.elementAt(lineInfos.length - 1);

    path.moveTo(firstInfo.x + outerFactor, firstInfo.y);

    LineMetricsHelper lastUsedInfo = firstInfo;
    int currentIndex = -1;

    for (final info in lineInfos) {
      currentIndex++;

      LineMetricsHelper? nextElement() {
        try {
          return lineInfos.elementAt(currentIndex + 1);
        } catch (e) {
          return null;
        }
      }

      final next = nextElement();

      if (next != null) {
        final difference = () {
          final width = (info.width - next.width);
          if (width.isNegative) return -width;
          return width;
        }()
            .toInt();
        final differenceBigger = difference > outerFactor + 1;
        // print('$differenceBigger $difference/$outerFactor');
        if (!differenceBigger) {
          next.overridenX = info.x;
          next.overridenWidth = info.fullWidth;
        }
      }

      void drawTopLeftCorner(LineMetricsHelper info) {
        final outerFactor = lastUsedInfo == info
            ? this.outerFactor
            : (lastUsedInfo.x - info.x).clamp(0, this.outerFactor);
        final controlPoint = Offset(
          info.x,
          info.y,
        );
        final endPoint = Offset(info.x, info.y + outerFactor);

        path.lineTo(info.x + outerFactor, info.y);
        path.quadraticBezierTo(
          controlPoint.dx,
          controlPoint.dy,
          endPoint.dx,
          endPoint.dy,
        );
      }

      void drawBottomLeftCorner(LineMetricsHelper info) {
        path.lineTo(info.x, info.fullHeight - outerFactor);

        final iControlPoint = Offset(
          info.x,
          info.fullHeight,
        );
        final iEndPoint = Offset(info.x + outerFactor, info.fullHeight);

        path.quadraticBezierTo(
          iControlPoint.dx,
          iControlPoint.dy,
          iEndPoint.dx,
          iEndPoint.dy,
        );
      }

      void drawInnerCorner(LineMetricsHelper info, [bool toLeft = true]) {
        if (toLeft) {
          final formattedHeight = info.fullHeight - innerLinePadding.bottom;

          final innerFactor = (info.x - next!.x).clamp(0, this.innerFactor);
          path.lineTo(info.x, info.fullHeight - innerFactor);
          final iControlPoint = Offset(
            info.x,
            formattedHeight,
          );
          final iEndPoint = Offset(
            info.x - innerFactor,
            formattedHeight,
          );

          path.quadraticBezierTo(
            iControlPoint.dx,
            iControlPoint.dy,
            iEndPoint.dx,
            iEndPoint.dy,
          );
        } else {
          final formattedY = next!.y + innerLinePadding.bottom;

          final innerFactor = (next.x - info.x).clamp(0, this.innerFactor);
          path.lineTo(next.x - innerFactor, formattedY);
          final iControlPoint = Offset(
            next.x,
            formattedY,
          );
          final iEndPoint = Offset(
            next.x,
            formattedY + innerFactor,
          );

          path.quadraticBezierTo(
            iControlPoint.dx,
            iControlPoint.dy,
            iEndPoint.dx,
            iEndPoint.dy,
          );
        }
      }

      if (next != null) {
        if (info == firstInfo || info.x < lastUsedInfo.x) {
          drawTopLeftCorner(info);
        }
        if (info.x > next.x) {
          // If the current one is less than the next, draw the inner corner
          drawInnerCorner(info);
          // drawBottomLeftCorner(info);
        }
        // If the next one is more to the right, draw the bottom left
        if (info.x < next.x) {
          // Draw bottom right corner
          drawBottomLeftCorner(info);

          // Otherwise draw the inverse inner corner
          drawInnerCorner(info, false);
        }
      } else {
        // If it's in the last one, draw the top and bottom corners
        drawTopLeftCorner(info);
        drawBottomLeftCorner(info);
      }

      lastUsedInfo = info;
    }

    // Draw the last line only to the half of it
    path.lineTo(lastInfo.fullWidth / 2, lastInfo.fullHeight);

    final reversedInfo = lineInfos.reversed;
    currentIndex = -1;
    lastUsedInfo = reversedInfo.first;

    // !Goes horizontal and up
    for (final info in reversedInfo) {
      currentIndex++;
      LineMetricsHelper? nextElement() {
        try {
          return reversedInfo.elementAt(currentIndex + 1);
        } catch (e) {
          return null;
        }
      }

      final next = nextElement();

      void drawTopRightCorner(
        LineMetricsHelper info, [
        double? factor,
      ]) {
        factor ??= outerFactor;
        final controlPoint = Offset(
          info.fullWidth,
          info.y,
        );
        final endPoint = Offset(info.fullWidth - factor, info.y);

        path.lineTo(info.fullWidth, info.y + factor);
        path.quadraticBezierTo(
          controlPoint.dx,
          controlPoint.dy,
          endPoint.dx,
          endPoint.dy,
        );
      }

      void drawBottomRightCorner(LineMetricsHelper info) {
        path.lineTo(info.fullWidth - outerFactor, info.fullHeight);

        final iControlPoint = Offset(
          info.fullWidth,
          info.fullHeight,
        );
        final iEndPoint = Offset(
          info.fullWidth,
          info.fullHeight - outerFactor,
        );

        path.quadraticBezierTo(
          iControlPoint.dx,
          iControlPoint.dy,
          iEndPoint.dx,
          iEndPoint.dy,
        );
      }

      void drawInnerCorner(LineMetricsHelper info, [bool toRight = true]) {
        // To left
        if (!toRight) {
          final formattedHeight = info.fullHeight - innerLinePadding.bottom;
          path.lineTo(
            info.fullWidth + innerFactor,
            formattedHeight,
          );

          final controlPoint = Offset(
            info.fullWidth,
            formattedHeight,
          );
          final endPoint = Offset(
            info.fullWidth,
            info.fullHeight - innerFactor,
          );

          path.quadraticBezierTo(
            controlPoint.dx,
            controlPoint.dy,
            endPoint.dx,
            endPoint.dy,
          );
        } else {
          final formattedY = info.y + innerLinePadding.bottom;
          path.lineTo(
            info.fullWidth,
            formattedY + innerFactor,
          );

          final controlPoint = Offset(
            info.fullWidth,
            formattedY,
          );
          final endPoint = Offset(
            info.fullWidth + innerFactor,
            formattedY,
          );

          path.quadraticBezierTo(
            controlPoint.dx,
            controlPoint.dy,
            endPoint.dx,
            endPoint.dy,
          );
        }
      }

      if (next != null) {
        final differenceBigger = info == lastUsedInfo ||
            info.fullWidth - lastUsedInfo.fullWidth >= outerFactor;
        // If it's the first info or it's bigger than the last one
        if ((info == lastInfo || info.fullWidth > lastUsedInfo.fullWidth) &&
            differenceBigger) {
          drawBottomRightCorner(info);
        }

        if (info.fullWidth > next.fullWidth) {
          final factor = info.fullWidth - next.fullWidth;
          if (factor >= outerFactor) {
            drawTopRightCorner(info);
            drawInnerCorner(next, false);
          } else {
            drawTopRightCorner(info, factor);
          }
        }

        if (info.fullWidth < next.fullWidth) {
          // If the current one is less than the next, draw the inner corner
          drawInnerCorner(info, true);
          drawBottomRightCorner(next);
        }
      } else {
        if (lastUsedInfo.fullWidth < info.fullWidth) {
          drawBottomRightCorner(info);
        }
        drawTopRightCorner(info);
      }

      lastUsedInfo = info;
    }

    // First line horizontal
    path
      ..lineTo(firstInfo.fullWidth / 2, firstInfo.y)
      ..close();
    canvas.drawPath(path, Paint()..color = backgroundColor);
  }

  @override
  bool shouldRepaint(covariant _HighlightPainter oldDelegate) {
    // If we're debugging, update everytime
    if (kDebugMode) return true;

    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.lineInfos != lineInfos;
  }

  @override
  bool shouldRebuildSemantics(_HighlightPainter oldDelegate) => false;
}

class LineMetricsHelper {
  /// The original line metrics, which stores the measurements and statistics of
  /// a single line in the paragraph.
  final LineMetrics metrics;

  /// The amount of lines in the text.
  ///
  /// See also:
  ///
  ///  * [isLast], which uses this property to check the amount of lines
  final int length;

  double? overridenWidth;
  double? overridenX;

  LineMetricsHelper(this.metrics, this.length);

  /// Whether this line has no content
  bool get isEmpty => metrics.width == 0.0;

  /// Whether this line is the last line in the paragraph
  bool get isLast => metrics.lineNumber == length - 1;

  double get x {
    if (overridenX != null) return overridenX!;
    final result = metrics.left;

    if (metrics.lineNumber == 0) {
      return result - firstLinePadding.left;
    } else if (isLast) {
      return result - lastLinePadding.left;
    } else {
      return result - innerLinePadding.left;
    }
  }

  double get y {
    final result = metrics.lineNumber * metrics.height;
    if (metrics.lineNumber == 0) {
      // return result - firstLinePadding.top;
    } else if (isLast) {
      return result + lastLinePadding.top / 2;
    } else {
      return result - innerLinePadding.top;
    }
    return result;
  }

  double get fullWidth {
    if (overridenWidth != null) return overridenWidth!;
    final result = x + width;

    if (!isEmpty) {
      if (metrics.lineNumber == 0) {
        return result + firstLinePadding.left;
      } else if (isLast) {
        return result + lastLinePadding.left;
      } else {
        return result + innerLinePadding.left;
      }
    }
    return x + metrics.width;
  }

  double get fullHeight {
    // final result = metrics.lineNumber * metrics.height + height;
    final result = y + height;

    if (isLast) {
      return result + lastLinePadding.bottom;
    } else {
      return result + innerLinePadding.bottom;
    }
  }

  double get height => metrics.height;

  double get width {
    final result = metrics.width;

    if (metrics.lineNumber == 0) {
      return result + firstLinePadding.right;
    } else if (isLast) {
      return result + lastLinePadding.right;
    } else {
      return result + innerLinePadding.right;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LineMetricsHelper &&
        other.metrics == metrics &&
        other.length == length &&
        other.overridenWidth == overridenWidth &&
        other.overridenX == overridenX;
  }

  @override
  int get hashCode {
    return metrics.hashCode ^
        length.hashCode ^
        overridenWidth.hashCode ^
        overridenX.hashCode;
  }

  @override
  String toString() {
    return 'LineMetricsHelper(metrics: $metrics, length: $length, overridenWidth: $overridenWidth, overridenX: $overridenX)';
  }
}
