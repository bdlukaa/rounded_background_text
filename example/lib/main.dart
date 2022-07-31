import 'dart:math';

import 'package:flutter/material.dart';

import 'package:rounded_background_text/rounded_background_text.dart';

final _primaryAndAccentColors = [...Colors.primaries, ...Colors.accents];

enum _HighlightTextType { field, text, span, selectableText }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final ScrollController colorsController;
  final controller = TextEditingController();

  double fontSize = 20.0;
  double innerRadius = kDefaultInnerFactor;
  double outerRadius = kDefaultOuterFactor;

  TextAlign textAlign = TextAlign.center;
  FontWeight fontWeight = FontWeight.bold;
  _HighlightTextType type = _HighlightTextType.text;

  late Color selectedColor;

  @override
  void initState() {
    super.initState();

    final initialIndex = Random().nextInt(_primaryAndAccentColors.length);
    selectedColor = _primaryAndAccentColors[initialIndex];

    colorsController = ScrollController(
      initialScrollOffset: 40.0 * initialIndex,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    colorsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rounded Background Showcase',
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      home: Scaffold(
        body: SafeArea(
          child: Column(children: [
            Material(
              child: Row(children: [
                const VerticalDivider(),
                Expanded(
                  child: DropdownButton<FontWeight>(
                    isExpanded: true,
                    value: fontWeight,
                    onChanged: (w) => setState(
                      () => fontWeight = w ?? FontWeight.normal,
                    ),
                    icon: const Icon(Icons.font_download),
                    items: FontWeight.values.map((e) {
                      return DropdownMenuItem(
                        child: Text('$e'.replaceAll('FontWeight.', '')),
                        value: e,
                      );
                    }).toList(),
                  ),
                ),
                const VerticalDivider(),
                Expanded(
                  child: DropdownButton<TextAlign>(
                    value: textAlign,
                    onChanged: (align) => setState(
                      () => textAlign = align ?? TextAlign.center,
                    ),
                    icon: const Icon(Icons.align_horizontal_left),
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        child: Text('Start'),
                        value: TextAlign.start,
                      ),
                      DropdownMenuItem(
                        child: Text('Center'),
                        value: TextAlign.center,
                      ),
                      DropdownMenuItem(
                        child: Text('End'),
                        value: TextAlign.end,
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(),
                Expanded(
                  child: DropdownButton<_HighlightTextType>(
                    value: type,
                    onChanged: (t) => setState(
                      () => type = t ?? _HighlightTextType.field,
                    ),
                    icon: const Icon(Icons.text_fields),
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        child: Text('Field'),
                        value: _HighlightTextType.field,
                      ),
                      DropdownMenuItem(
                        child: Text('Text'),
                        value: _HighlightTextType.text,
                      ),
                      DropdownMenuItem(
                        child: Text('Selectable Text'),
                        value: _HighlightTextType.selectableText,
                      ),
                      DropdownMenuItem(
                        child: Text('Span'),
                        value: _HighlightTextType.span,
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(),
              ]),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: () {
                    final textColor = selectedColor.computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white;
                    switch (type) {
                      case _HighlightTextType.field:
                        return RoundedBackgroundTextField(
                          controller: controller,
                          backgroundColor: selectedColor,
                          textAlign: textAlign,
                          hint: 'Type your text here',
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: fontWeight,
                            color: textColor,
                          ),
                          innerRadius: innerRadius,
                          outerRadius: outerRadius,
                        );
                      case _HighlightTextType.text:
                        return RoundedBackgroundText(
                          '''Rounded Background Text Showcase

It handles well all font sizes and weights, as well as text alignments

Contributions are welcome!
Done with so much <3 by @bdlukaa''',
                          backgroundColor: selectedColor,
                          textAlign: textAlign,
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: fontWeight,
                            color: textColor,
                          ),
                          innerRadius: innerRadius,
                          outerRadius: outerRadius,
                        );
                      case _HighlightTextType.selectableText:
                        return RoundedBackgroundText.selectable(
                          '''Rounded Background Text Showcase

It handles well all font sizes and weights, as well as text alignments

Contributions are welcome!
Done with so much <3 by @bdlukaa''',
                          backgroundColor: selectedColor,
                          textAlign: textAlign,
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: fontWeight,
                            color: textColor,
                          ),
                          innerRadius: innerRadius,
                          outerRadius: outerRadius,
                        );
                      case _HighlightTextType.span:
                        return RichText(
                          textAlign: textAlign,
                          text: TextSpan(
                            text: 'You can use this to ',
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: fontWeight,
                              color: Colors.white,
                            ),
                            children: [
                              RoundedBackgroundTextSpan(
                                text: 'highlight important stuff inside a text',
                                backgroundColor: selectedColor,
                                innerRadius: innerRadius,
                                outerRadius: outerRadius,
                                textAlign: textAlign,
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: fontWeight,
                                  color: textColor,
                                ),
                              ),
                              const TextSpan(text: ' and stuff like that'),
                            ],
                          ),
                        );
                    }
                  }(),
                ),
              ),
            ),
            Row(children: [
              GestureDetector(
                onTap: () {
                  colorsController.animateTo(
                    (colorsController.position.pixels - 40),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
                child: const Icon(Icons.chevron_left),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  colorsController.animateTo(
                    (colorsController.position.pixels + 40),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
                child: const Icon(Icons.chevron_right),
              ),
            ]),
            Material(
              child: SingleChildScrollView(
                controller: colorsController,
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  runSpacing: 10.0,
                  spacing: 10.0,
                  alignment: WrapAlignment.center,
                  children: _primaryAndAccentColors.map((color) {
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => setState(() => selectedColor = color),
                        child: AnimatedContainer(
                          duration: kThemeChangeDuration,
                          curve: Curves.bounceInOut,
                          height: 30.0,
                          width: 30.0,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(2.0),
                            border: Border.all(
                              color: color.computeLuminance() > 0.5
                                  ? Colors.black
                                  : Colors.white,
                              width: 2.5,
                              style: selectedColor == color
                                  ? BorderStyle.solid
                                  : BorderStyle.none,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Material(
              child: Row(children: [
                Expanded(
                  child: Slider(
                    onChanged: (v) => setState(() => fontSize = v),
                    value: fontSize,
                    min: 8,
                    max: 30,
                    divisions: 30 - 8,
                    label: '${fontSize.toInt()}',
                  ),
                ),
                Expanded(
                  child: Slider(
                    onChanged: (v) => setState(() => innerRadius = v),
                    value: innerRadius,
                    min: 0,
                    max: 20,
                    label: '${innerRadius.toInt()}',
                    divisions: 20,
                  ),
                ),
                Expanded(
                  child: Slider(
                    onChanged: (v) => setState(() => outerRadius = v),
                    value: outerRadius,
                    min: 0,
                    max: 20,
                    label: '${outerRadius.toInt()}',
                    divisions: 20,
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
