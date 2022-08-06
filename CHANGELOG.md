## [next]

* fix: hint is aligned with the text field ([#7](https://github.com/bdlukaa/rounded_background_text/issues/7))

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
