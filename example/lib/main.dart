import 'package:flutter/material.dart';

import 'package:rounded_background_text/rounded_background_text.dart';

final _primaryAndAccentColors =
    (<ColorSwatch>[...Colors.primaries]).followedBy(Colors.accents);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controller = TextEditingController();

  double fontSize = 20.0;
  TextAlign textAlign = TextAlign.center;
  FontWeight fontWeight = FontWeight.bold;

  Color selectedColor = Colors.blue;

  @override
  void dispose() {
    controller.dispose();
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
            Row(
              children: [
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
                        child: Text(e.toString()),
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
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: RoundedBackgroundText(
                  'A cool text to be highlighted\nWith two lines or more',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  backgroundColor: Colors.amber,
                ),
                // child: RoundedBackgroundTextField(
                //   controller: controller,
                //   backgroundColor: selectedColor,
                //   textAlign: textAlign,
                //   hint: 'Type your text here',
                //   style: TextStyle(
                //     fontSize: fontSize,
                //     fontWeight: fontWeight,
                //   ),
                // ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
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
                            color: Colors.white,
                            width: 2.0,
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
            Slider(
              onChanged: (v) => setState(() => fontSize = v),
              value: fontSize,
              min: 10,
              max: 20,
            ),
          ]),
        ),
      ),
    );
  }
}
