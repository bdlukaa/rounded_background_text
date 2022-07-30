## [next]

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
