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
    final lines = generateLineInfosForPainter(painter);

    expect(lines, isNotEmpty);
    expect(lines.length, 3);
    expect(
      lines[0].toString(),
      '[LineMetricsHelper(x: 251.0, y: 0.0, w: 715.0, h: 18.0)]',
    );
    expect(
      lines[1].toString(),
      '[LineMetricsHelper(x: -8.0, y: 30.0, w: 974.0, h: 46.0)]',
    );
    expect(
      lines[2].toString(),
      '[LineMetricsHelper(x: 279.0, y: 58.0, w: 687.0, h: 74.0)]',
    );
  });
}
