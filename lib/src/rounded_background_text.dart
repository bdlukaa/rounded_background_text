import 'dart:ui';

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

@visibleForTesting
List<List<LineMetricsHelper>> generateLineInfosForPainter(
  TextPainter painter, [
  double maxWidth = double.infinity,
]) {
  painter.layout(maxWidth: maxWidth);
  final metrics = painter.computeLineMetrics();

  final helpers = metrics.map((lineMetric) {
    return LineMetricsHelper(lineMetric, metrics.length, painter);
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
    super.key,
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
  }) : text = TextSpan(text: text, style: style);

  /// Creates a rounded background text based on an [InlineSpan], that can have
  /// multiple styles
  const RoundedBackgroundText.rich({
    super.key,
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
        assert(outerRadius >= 0.0 && outerRadius <= 20.0);

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
    TextSelectionControls? selectionControls,
    TextStyle? style,
    TextDirection? textDirection,
    Color? backgroundColor,
    TextAlign textAlign = TextAlign.start,
    TextWidthBasis? textWidthBasis,
    double textScaleFactor = 1.0,
    double innerRadius = kDefaultInnerFactor,
    double outerRadius = kDefaultOuterFactor,
    double cursorWidth = 2.0,
    Color? cursorColor,
    double? cursorHeight,
    Radius? cursorRadius,
    SelectionChangedCallback? onSelectionChanged,
    bool enableInteractiveSelection = true,
    String? semanticsLabel,
  }) {
    return Stack(children: [
      RoundedBackgroundText(
        text,
        style: style,
        textDirection: textDirection,
        textAlign: textAlign,
        textScaleFactor: textScaleFactor,
        innerRadius: innerRadius,
        outerRadius: outerRadius,
        backgroundColor: backgroundColor,
      ),
      SelectableText(
        text,
        style: style,
        textDirection: textDirection,
        textAlign: textAlign,
        textScaleFactor: textScaleFactor,
        cursorColor: cursorColor,
        cursorHeight: cursorHeight,
        cursorRadius: cursorRadius,
        cursorWidth: cursorWidth,
        selectionControls: selectionControls,
        onSelectionChanged: onSelectionChanged,
        enableInteractiveSelection: enableInteractiveSelection,
        focusNode: focusNode,
        autofocus: autofocus,
        semanticsLabel: semanticsLabel,
      ),
    ]);
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
  /// The radius is dynamically calculated based on the line height and the
  /// provided factor.
  ///
  /// Defaults to 8.0
  /// {@end-template}
  final double innerRadius;

  /// {@template rounded_background_text.outerRadius}
  /// The radius of the inner corners.
  ///
  /// The radius is dynamically calculated based on the line height and the
  /// provided factor.
  ///
  /// Defaults to 10.0
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
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    // This does not care about composing.
    return TextSpan(style: style, children: <TextSpan>[_textSpan]);
  }

  @override
  set text(String? newText) {
    // This should never be reached.
    throw UnimplementedError();
  }
}

class _RoundedBackgroundText extends StatefulWidget {
  const _RoundedBackgroundText({
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
  });

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
  static const String _debugPrefix = 'HighlightPainter:';

  final double innerFactor;
  final double outerFactor;

  const _HighlightPainter({
    required this.lineInfos,
    required this.backgroundColor,
    required this.text,
    required this.innerFactor,
    required this.outerFactor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final lineInfo in lineInfos) {
      paintBackground(canvas, lineInfo);
    }

    text.paint(canvas, Offset.zero);
  }

  void paintBackground(Canvas canvas, List<LineMetricsHelper> lineInfo) {
    if (lineInfo.isEmpty) return;
    if (lineInfo.length == 1) {
      final info = lineInfo.first;
      if (!info.isEmpty) {
        canvas.drawRRect(
          RRect.fromLTRBR(
            info.x,
            info.y,
            info.fullWidth,
            info.fullHeight,
            Radius.circular(info.outerFactor(outerFactor)),
          ),
          Paint()..color = backgroundColor,
        );
      }
      return;
    }

    final path = Path();
    final firstInfo = lineInfo.elementAt(0);
    final lastInfo = lineInfo.elementAt(lineInfo.length - 1);

    path.moveTo(firstInfo.x + outerFactor, firstInfo.y);

    LineMetricsHelper previous = firstInfo;
    int currentIndex = -1;

    for (final info in lineInfo) {
      currentIndex++;

      final next = () {
        try {
          return lineInfo.elementAt(currentIndex + 1);
        } catch (e) {
          return null;
        }
      }();

      final outerFactor = info.outerFactor(this.outerFactor);
      final innerFactor = info.innerFactor(this.innerFactor);

      normalize(next, info);

      void drawTopLeftCorner(LineMetricsHelper info) {
        final localOuterFactor = previous == info
            ? outerFactor
            : (previous.x - info.x).clamp(0, outerFactor);
        final controlPoint = Offset(info.x, info.y);
        final endPoint = Offset(info.x, info.y + localOuterFactor);

        path.lineTo(info.x + localOuterFactor, info.y);
        path.quadraticBezierTo(
            controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
      }

      void drawBottomLeftCorner(LineMetricsHelper info) {
        path.lineTo(info.x, info.fullHeight - outerFactor);

        final iControlPoint = Offset(info.x, info.fullHeight);
        final iEndPoint = Offset(info.x + outerFactor, info.fullHeight);

        path.quadraticBezierTo(
            iControlPoint.dx, iControlPoint.dy, iEndPoint.dx, iEndPoint.dy);
      }

      void drawInnerCorner(LineMetricsHelper info, [bool toLeft = true]) {
        //Set innerFactor to zero if there is no room to draw an arc (14px).
        final localInnerFactor = ((info.x - next!.x).abs() < 14) ? 0 : innerFactor;
        if (toLeft) {
          final formattedHeight =
              info.fullHeight - info.innerLinePadding.bottom;
          path.lineTo(info.x, info.fullHeight - localInnerFactor);
          final iControlPoint = Offset(info.x, formattedHeight);
          final iEndPoint = Offset(info.x - localInnerFactor, formattedHeight);

          path.quadraticBezierTo(
              iControlPoint.dx, iControlPoint.dy, iEndPoint.dx, iEndPoint.dy);
        } else {
          final formattedY = next.y + info.innerLinePadding.bottom;
          path.lineTo(next.x - localInnerFactor, formattedY);
          final iControlPoint = Offset(next.x, formattedY);
          final iEndPoint = Offset(next.x, formattedY + localInnerFactor);

          path.quadraticBezierTo(
              iControlPoint.dx, iControlPoint.dy, iEndPoint.dx, iEndPoint.dy);
        }
      }

      if (next != null) {
        // If it's the first line OR the previous line is bigger than the current
        // one, draw the top left corner
        if (info == firstInfo || previous.x > info.x) {
          drawTopLeftCorner(info);
        }
        if (info.x > next.x) {
          // If the current one is less than the next, draw the inner corner
          drawInnerCorner(info);
          // drawBottomLeftCorner(info);
        } else
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

      previous = info;
    }

    // Draw the last line only to the half of it
    path.lineTo(lastInfo.fullWidth / 2, lastInfo.fullHeight);

    final reversedInfo = lineInfo.reversed;
    currentIndex = -1;
    previous = reversedInfo.first;

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

      LineMetricsHelper? nextLineElement() {
        try {
          return reversedInfo.elementAt(currentIndex + 2);
        } catch (e) {
          return null;
        }
      }

      final next = nextElement();
      final nextLine = nextLineElement() ?? nextElement();

      final outerFactor = info.outerFactor(this.outerFactor);
      final innerFactor = info.innerFactor(this.innerFactor);

      void drawTopRightCorner(
        LineMetricsHelper info, [
        double? factor,
      ]) {
        factor ??= outerFactor;
        final controlPoint = Offset(info.fullWidth, info.y);
        final endPoint = Offset(info.fullWidth - factor, info.y);

        path.lineTo(info.fullWidth, info.y + factor);
        path.quadraticBezierTo(
            controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
      }

      void drawBottomRightCorner(LineMetricsHelper info) {
        path.lineTo(info.fullWidth - outerFactor, info.fullHeight);

        final iControlPoint = Offset(info.fullWidth, info.fullHeight);
        final iEndPoint = Offset(info.fullWidth, info.fullHeight - outerFactor);

        path.quadraticBezierTo(
            iControlPoint.dx, iControlPoint.dy, iEndPoint.dx, iEndPoint.dy);
      }

      void drawInnerCorner(LineMetricsHelper info, [bool toRight = true]) {
        //Set innerFactor to zero if there is no room to draw an arc (15px).
        final _next = (info.fullWidth != next?.fullWidth) ? next : nextLine;
        final localInnerFactor = ((info.fullWidth - _next!.fullWidth).abs() < 15)
                                  ? 0 : innerFactor;

        if (!toRight) {
          final formattedHeight =
              info.fullHeight - info.innerLinePadding.bottom;
          path.lineTo(info.fullWidth + localInnerFactor, formattedHeight);

          final controlPoint = Offset(info.fullWidth, formattedHeight);
          final endPoint =
              Offset(info.fullWidth, formattedHeight - localInnerFactor);

          path.quadraticBezierTo(
              controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
        } else {
          final formattedY = info.y + info.innerLinePadding.bottom;
          path.lineTo(info.fullWidth, formattedY + localInnerFactor);

          final controlPoint = Offset(info.fullWidth, formattedY);
          final endPoint = Offset(info.fullWidth + localInnerFactor, formattedY);

          path.quadraticBezierTo(
              controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
        }
      }

      if (next != null) {
        final differenceBigger = info == previous ||
            info.fullWidth - previous.fullWidth >= outerFactor;
        // If it's the first info or it's bigger than the last one
        if ((info == lastInfo || info.fullWidth > previous.fullWidth) &&
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
        if (previous.fullWidth < info.fullWidth) {
          drawBottomRightCorner(info);
        }
        drawTopRightCorner(info);
      }

      previous = info;
    }

    // First line horizontal
    path
      ..lineTo(firstInfo.fullWidth / 2, firstInfo.y)
      ..close();
    canvas.drawPath(path, Paint()..color = backgroundColor);
  }

  @override
  bool shouldRepaint(covariant _HighlightPainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.lineInfos != lineInfos ||
        oldDelegate.text != text ||
        oldDelegate.innerFactor != innerFactor ||
        oldDelegate.outerFactor != outerFactor;
  }

  // Normalize the width of the next element based on the difference between
  // the width of the current element and the next one. This is responsible
  // to not let the next element go too little away from the current one
  void normalize(LineMetricsHelper? next, LineMetricsHelper info) {
    if (next != null) {
      var difference = () {
        final width = (info.width - next.width);
        return width.roundToDouble();
      }();
      // If the difference is negative, it means that the next element is a little
      // bigger than the current one. The current one takes the dimensions of
      // the next one
      if (difference.isNegative) {
        difference = -difference;
        final differenceBigger = difference > outerFactor * 2;
        if (!differenceBigger) {
          info.overridenX = next.x;
          info.overridenWidth = next.fullWidth;
        }
      }
      // If the difference is positive, it means that the current element is a
      // little bigger than the next one. The next one takes the dimensions of
      // the current one
      else {
        final differenceBigger = difference > outerFactor * 2;
        if (!differenceBigger) {
          next.overridenX = info.x;
          next.overridenWidth = info.fullWidth;
        }
      }
    }
  }
}

/// A helper class that holds important information about a single line metrics.
/// This is used to calculate the position of the line in the paragraph.
class LineMetricsHelper {
  /// The original line metrics, which stores the measurements and statistics of
  /// a single line in the paragraph.
  final LineMetrics metrics;

  final TextPainter text;

  /// The amount of lines in the text.
  ///
  /// See also:
  ///
  ///  * [isLast], which uses this property to check the amount of lines
  final int length;

  /// The overriden width of the line
  ///
  /// This allows another line to affect the width of this line based on the
  /// difference between the two. If the difference is minimal, the width may
  /// be the same
  double? overridenWidth;

  /// The overriden x of the line
  ///
  /// This allows another line to affect the x of this line based on the
  /// difference between the two. If the difference is minimal, the x may
  /// be the same
  double? overridenX;

  /// Creates a new line metrics helper
  LineMetricsHelper(this.metrics, this.length, this.text);

  /// Whether this line has no content
  bool get isEmpty => metrics.width == 0.0;

  /// Whether this line is the first line in the paragraph
  bool get isFirst => metrics.lineNumber == 0;

  /// Whether this line is the last line in the paragraph
  bool get isLast => metrics.lineNumber == length - 1;

  late EdgeInsets firstLinePadding = EdgeInsets.only(
    left: height * 0.3,
    right: height * 0.3,
    top: height * 0.3,
    bottom: 0,
  );
  late EdgeInsets innerLinePadding = EdgeInsets.only(
    left: height * 0.3,
    right: height * 0.3,
    top: 0.0,
    bottom: height * 0.05,
  );
  late EdgeInsets lastLinePadding = EdgeInsets.only(
    left: height * 0.3,
    right: height * 0.3,
    top: 0.0,
    bottom: height * 0.05,
  );

  /// Dynamically calculate the outer factor based on the provided [outerFactor]
  /// The bigger the text.size.height, the bigger the reduction
  double outerFactor(double outerFactor) {
    if (text.size.height > 279) {
      return (height * outerFactor) / 35;
    }
    else {return (height * outerFactor) / 45;}
  }

  /// Dynamically calculate the inner factor based on the provided [innerFactor]
  /// The bigger the text.size.height, the bigger the reduction
  double innerFactor(double innerFactor) {
    if (text.size.height > 279) {
      return (height * innerFactor) / 35;
    }
    else {return (height * innerFactor) / 45;}
  }

  double get x {
    if (overridenX != null) return overridenX!;
    final result = metrics.left;

    if (isFirst) {
      return (result - firstLinePadding.left).roundToDouble();
    } else if (isLast) {
      return (result - lastLinePadding.left).roundToDouble();
    } else {
      return (result - innerLinePadding.left).roundToDouble();
    }
  }

  double get y {
    final result = metrics.lineNumber * metrics.height;
    if (isFirst) {
      return result.roundToDouble();
    } else if (isLast) {
      return (result + (lastLinePadding.top / 2)).roundToDouble();
    } else {
      return (result - innerLinePadding.top).roundToDouble();
    }
  }

  double get fullWidth {
    if (overridenWidth != null) return overridenWidth!;
    final result = x + width;

    if (!isEmpty) {
      if (isFirst) {
        return (result + firstLinePadding.left).roundToDouble();
      } else if (isLast) {
        return (result + lastLinePadding.left).roundToDouble();
      } else {
        return (result + innerLinePadding.left).roundToDouble();
      }
    }
    return (x + metrics.width).roundToDouble();
  }

  double get fullHeight {
    final result = y + height;

    if (isLast) {
      return (result + lastLinePadding.bottom).roundToDouble();
    } else {
      return (result + innerLinePadding.bottom).roundToDouble();
    }
  }

  double get height => metrics.height;

  double get width {
    final result = metrics.width;

    if (metrics.lineNumber == 0) {
      return (result + firstLinePadding.right).roundToDouble();
    } else if (isLast) {
      return (result + lastLinePadding.right).roundToDouble();
    } else {
      return (result + innerLinePadding.right).roundToDouble();
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
    return 'LineMetricsHelper(x: $x, y: $y, w: $fullWidth, h: $fullHeight)';
  }
}
