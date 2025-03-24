## 0.6.0

* feat: Add `RoundedBackgroundTextField.stylusHandwritingEnabled`
* **BREAKING** fix: Do not use material's `SelectableText` in `RoundedBackgroundText.selectable` ([#21](https://github.com/bdlukaa/rounded_background_text/issues/21))
  `RoundedBackgroundTextField` is used under the hood instead. It contains all the logic to make the text scrollable, adapts to the style and more.

  `RoundedBackgroundText.selectableRich` has been removed. Use `RoundedBackgroundTextField` with custom text controller instead.

## 0.5.0

* fix: Update vertical alignment ([#19](https://github.com/bdlukaa/rounded_background_text/issues/19))
* breaking: Remove `textScaleFactor`. Use `textScaler` instead ([83f0348e](https://github.com/bdlukaa/rounded_background_text/commit/83f0348ea9edebe225fd009d7e90c97a261b635d))
* feat: Add missing fields to `RoundedBackgroundTextField` ([8e7ce4a](https://github.com/bdlukaa/rounded_background_text/commit/8e7ce4aa71d8cdf513922c77f8ea6a4df09912af))
    * Added `textHeightBehavior`
    * Added `textWidthBasis`
    * Added `selectionHeightStyle`
    * Added `selectionWidthStyle`
    * Added `strutStyle`
    * Added `dragStartBehavior`
    * Added `contentInsertionConfiguration`
    * Added `contextMenuBuilder`
    * Added `spellCheckConfiguration`
    * Added `magnifierConfiguration`
    * Added `undoController`
    * Added `scribbleEnabled`
    * Added `locale`
    * Added `onChanged`
    * Added `onEditingComplete`
    * Added `onSubmitted`
    * Added `onAppPrivateCommand`
    * Added `onSelectionHandleTapped`
    * Added `onTapOutside` 

## 0.4.3

* fix: `RoundedBackgroundTextField.textAlign` is respected ([#17](https://github.com/bdlukaa/rounded_background_text/issues/17))
* fix: `RoundedBackgroundTextField` automatic line break is respected
* fix: `RoundedBackgroundText.selectable` text is no longer duplicated
* fix: outerRadius is correctly calculated when normalizing the lines
* fix: update painting cases on the right side

## 0.4.2

* fix: TextField's text is no longer transparent

## 0.4.1

* fix: update how the line heights are calculated based on the baseline and its accent

## 0.4.0

* fix: hint is aligned with the text field ([#7](https://github.com/bdlukaa/rounded_background_text/issues/7))
* feat: `RoundedBackgroundText.selectable` now uses `SelectableText` under the hood instead of `EditableText` ([4ba757](https://github.com/bdlukaa/rounded_background_text/commit/4ba7578ad22290d7a6ae31d7ffdd7490bc614f68))
* fix: the width normalizer now works reversely. This means there will not be any inconsistencies when breaking lines ([9ac0b6](https://github.com/bdlukaa/rounded_background_text/commit/9ac0b685b76a8c603437c57a3e31e20e3a0d24b7))
* fix: the background painter now updates correctly when property changes ([076dd05](https://github.com/bdlukaa/rounded_background_text/commit/076dd05ab251cd84a34de723d0e01436c05d3481))
fix: Highlighted text now works properly on `RoundedBackgroundTextField`

## 0.3.0

* feat: `RoundedBackgroundTextField` is now scrollable. The background will follow the scroll of the text field
* feat: Added `.scrollController`, `.scrollPhysics`, `.scrollBehavior` and `.scrollPadding` to `RoundedBackgroundTextField`
* feat: `RoundedBackgroundTextField.controller` is no longer required. If omitted, a local controller is created instead
* fix: Dynamically calculate padding and factors for `RoundedBackgroundText` ([#6](https://github.com/bdlukaa/rounded_background_text/issues/6))

## 0.2.1

* fix: `RoundedBackgroundTextField` now shows the background properly as the user types

## 0.2.0

* fix: `RoundedBackgroundTextField.hint` is no longer hidden.
* feat: Added `RoundedBackgroundTextField.hintStyle`, which is the text style applied to `.hint`
* fix: Correctly apply padding to inner corners
* fix: Correctly apply size to background painter
* fix: Correctly inherit any `DefaultTextStyle` above
* feat: Added `RoundedBackgroundText.selectable`, a backgrounded version of `SelectableText`

## 0.1.3

* Do not center the whole stack. It was causing clipping on the text field

## 0.1.2

* `RoundedBackgroundTextField` now scales down to fit the text
* `RoundedBackgroundTextField` now can't be scrollable
* `RoundedBackgroundTextField` now uses `EditableText` instead of `TextField` in order to get the best positioning
* Expose more text field properties
* Update example app

## 0.1.1

* Customizable radius

## 0.1.0

* Implement `RoundedBackgroundText`
* Implemnet `RoundedBackgroundTextField`
* Implemnet `RoundedBackgroundTextSpan`
