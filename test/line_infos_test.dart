import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rounded_background_text/src/rounded_background_text.dart';

const testText = '''Rounded Background Text Showcase

It handles well all font sizes and weight, as well as text alignments

Contributions are welcome <3''';

void main() {
  test('Ensure the proper values are returned', () {
    final painter = TextPainter(
      text: const TextSpan(text: testText),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    final lines = RoundedBackgroundTextPainter.computeLines(painter);

    expect(lines, isNotEmpty);
    expect(lines.length, 3);
    expect(
      lines[0].toString(),
      '[LineMetricsHelper(x: 254.8, y: 0.0, w: 711.2, h: 16.1)]',
    );
    expect(
      lines[1].toString(),
      '[LineMetricsHelper(x: -4.2, y: 28.0, w: 970.2, h: 44.1)]',
    );
    expect(
      lines[2].toString(),
      '[LineMetricsHelper(x: 282.8, y: 56.0, w: 683.2, h: 72.1)]',
    );
  });
}
