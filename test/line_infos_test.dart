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
    painter.layout();
    final lines = RoundedBackgroundTextPainter.computeLines(painter);

    expect(lines, isNotEmpty);
    expect(lines.length, 3);
    expect(lines[0][0].x, 255.0);
    expect(lines[1][0].x, -4.0);
    expect(lines[2][0].x, 283.0);
  });
}
