<div>
  <h1 align="center">rounded_background_text</h1>
  <p align="center" >
    <a title="Discord" href="https://discord.gg/674gpDQUVq">
      <img src="https://img.shields.io/discord/809528329337962516?label=discord&logo=discord" />
    </a>
    <a title="Pub" href="https://pub.dartlang.org/packages/rounded_background_text" >
      <img src="https://img.shields.io/pub/v/rounded_background_text.svg?style=popout&include_prereleases" />
    </a>
    <a title="Github License">
      <img src="https://img.shields.io/github/license/bdlukaa/rounded_background_text" />
    </a>
    <a title="Web Example" href="https://bdlukaa.github.io/rounded_background_text">
      <img src="https://img.shields.io/badge/web-example---?style=flat-square&color=e88d0c" />
    </a>
  </p>
  <p align="center">
  Highlight text with rounded corners
  </p>
</div>

<div align="center">
  <a href="https://bdlukaa.github.io/rounded_background_text">
    <img src="assets/showcase.png" />
  </a>
</div>

## Content

- [Features](#features)
- [Getting started](#getting-started)
- [Usage](#usage)
  - [Highlight a simple text](#highlight-a-simple-text)
  - [Highlight a text field](#highlight-a-text-field)
  - [Highlight a text span](#highlight-a-text-span)
- [You may like to know](#you-may-like-to-know)
  - [Change the corner radius](#change-the-corner-radius)
  - [Known issues with the text field](#known-issues-with-the-text-field),
  - [Deep dive](#deep-dive)
- [Contribution](#contribution)

## Features

- ✅ Highlight Text
- ✅ Highlight Text Field [beta]
- ✅ Highlight Text Span

## Getting started

Import the package:

```dart
import 'package:rounded_background_text/rounded_background_text.dart';
```

## Usage

### Highlight a simple text:

```dart
RoundedBackgroundText(
  'A cool text to be highlighted',
  style: const TextStyle(fontWeight: FontWeight.bold),
  backgroundColor: Colors.white,
),
```

![Simple Text](assets/simple_text.png)

Multiline text is also supported

```dart
RoundedBackgroundText(
  'A cool text to be highlighted\nWith two lines or more',
  style: const TextStyle(fontWeight: FontWeight.bold),
  backgroundColor: Colors.amber,
),
```

![Two Lines Text](assets/two_lines_text.png)

### Highlight a text field:

You must use a `TextEditingController`

```dart
final controller = TextEditingController();

RoundedBackgroundTextField(
  controller: controller, // required
  backgroundColor: Colors.blue,
  style: const TextStyle(fontWeight: FontWeight.bold),
  textAlign: TextAlign.center,
),
```

The text will be highlighted as the user types

![TextField Preview](assets/textfield_preview.gif)

The font size of the text will be reduced if there isn't enough space to fit the text. The text field can't be scrollable

### Highlight a text span:

Highlight a small part of a text

```dart
RichText(
  text: TextSpan(
    text: 'Start your text and ',
    children: [
      RoundedBackgroundTextSpan(
        text: 'highlight something',
        backgroundColor: Colors.blue,
      ),
      const TextSpan(text: ' when necessary'),
    ],
  ),
),
```

![TextSpan Highlight Preview](assets/highlight_text_span.png)

## You may like to know:

### Change the corner radius

You can change the radius of the corners by setting `innerRadius` and `outerRadius`:

```dart
RoundedBackgroundText(
  'A cool text to be highlighted',
  style: const TextStyle(fontWeight: FontWeight.bold),
  backgroundColor: Colors.white,
  innerRadius: 15.0,
  outerRadius: 10.0,
),
```

The max allowed value is `20.0`. The min is `0.0`

### Known issues with the text field

- It can't be scrollable. Instead, as a workaround, the text is scaled down to fit the available space

### Deep dive

This section explains, with details, how the background painting works.

`RoundedBackgroundText` doesn't use a `Text` widget under the hood. Instead, it uses a custom text painter to paint the text above the background. As soon as the `RoundedBackgroundText` widget is initialized, the line metrics for the text is calculated (See [computeLineMetrics](https://api.flutter.dev/flutter/painting/TextPainter/computeLineMetrics.html)), and is recalculated when the text changes or when the parent width changes. This is done at built time, resulting in a smooth experience for the user.

To paint the background, the line metrics generated before is used. Each line has 4 properties:

- `x` - where the line starts horizontally within the size
- `y` - where the line starts vertically within the size
- `width` - the horizontal size of the line
- `height` - the vertical size of the line

With these values, we can generate the background for each line. The background is generated around the whole text: from top-left to bottom-left to bottom-right to top-right to top-left. This makes it easy to calculate when there is a corner, either outer or inner. 

## Contribution

Feel free to [file an issue](https://github.com/bdlukaa/rounded_background_text/issues/new) if you find a problem or [make pull requests](https://github.com/bdlukaa/rounded_background_text/pulls).

All contributions are welcome!
