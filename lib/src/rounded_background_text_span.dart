import 'package:flutter/material.dart';

import 'rounded_background_text.dart';

/// A text with rounded background that is embedded inline within text.
///
/// See also:
///
///  * [TextSpan], a node that represents text in an [InlineSpan] tree.
///  * [RoundedBackgroundText], which renders rounded background texts
class RoundedBackgroundTextSpan extends TextSpan {
  const RoundedBackgroundTextSpan({
    super.children,
    super.locale,
    super.mouseCursor,
    super.onEnter,
    super.onExit,
    super.recognizer,
    super.semanticsLabel,
    super.spellOut,
    super.style,
    super.text,
  });
}

class RoundedBackgroundRichTextPainter extends CustomPainter {
  final Color backgroundColor;
  final TextPainter painter;
  final double innerRadius;
  final double outerRadius;

  const RoundedBackgroundRichTextPainter({
    required this.backgroundColor,
    required this.painter,
    required this.innerRadius,
    required this.outerRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Paint the text first

    // 2. Find and draw the backgrounds as a single path
    final roundedBackgroundTextSpans = <RoundedBackgroundTextSpan>[];
    painter.text!.visitChildren((child) {
      if (child is RoundedBackgroundTextSpan) {
        roundedBackgroundTextSpans.add(child);
      }
      return true;
    });

    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final backgroundPath = Path();

    for (final span in roundedBackgroundTextSpans) {
      // Find the text range for this span
      final startIndex = painter.text!.toPlainText().indexOf(span.text!);
      if (startIndex == -1) {
        continue; // Span's text not found
      }
      final endIndex = startIndex + span.text!.length;

      // Get boxes for the text using getBoxesForSelection
      final boxes = painter.getBoxesForSelection(
        TextSelection(baseOffset: startIndex, extentOffset: endIndex),
      );

      // Add the boxes to the path
      for (final box in boxes) {
        final rect = box.toRect();
        addRoundedRectToPath(backgroundPath, rect, outerRadius, innerRadius);
      }
    }

    canvas.drawPath(backgroundPath, paint);

    painter.paint(canvas, Offset.zero);
  }

  @override
  bool shouldRepaint(covariant RoundedBackgroundRichTextPainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.painter != painter ||
        oldDelegate.innerRadius != innerRadius ||
        oldDelegate.outerRadius != outerRadius;
  }

  // Helper function to add a rounded rectangle to the path with individual corner radii
  void addRoundedRectToPath(
      Path path, Rect rect, double outerRadius, double innerRadius) {
    final RRect rrect = RRect.fromRectAndCorners(
      rect,
      topLeft: Radius.circular(outerRadius),
      topRight: Radius.circular(outerRadius),
      bottomLeft: Radius.circular(outerRadius),
      bottomRight: Radius.circular(outerRadius),
    );

    path.addRRect(rrect);
  }
}
