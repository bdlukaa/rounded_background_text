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
    <a title="Web Example" href="https://bdlukaa.github.io/fluent_ui">
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

## Contribution

Feel free to [file an issue](https://github.com/bdlukaa/rounded_background_text/issues/new) if you find a problem or [make pull requests](https://github.com/bdlukaa/rounded_background_text/pulls).

All contributions are welcome!
