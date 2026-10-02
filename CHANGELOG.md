## 0.1.1

- Added 9 new native iOS Platform Views (18 total):
  - **Alert Dialog**: `NativeLiquidGlassAlert` — native glass alert with action buttons.
  - **Bottom Sheet**: `NativeLiquidGlassSheet` — glass sheet with drag handle.
  - **Date Picker**: `NativeLiquidGlassDatePicker` — `UIDatePicker` with date, time, and dateAndTime modes.
  - **Toolbar**: `NativeLiquidGlassToolbar` — `UIToolbar` with SF Symbol items.
  - **Context Menu**: `NativeLiquidGlassMenu` — `UIMenu` with glass trigger button.
  - **Progress Bar**: `NativeLiquidGlassProgress` — `UIProgressView` with glass track.
  - **Activity Indicator**: `NativeLiquidGlassActivity` — `UIActivityIndicatorView` in glass capsule.
  - **Page Control**: `NativeLiquidGlassPageControl` — `UIPageControl` with glass pill background.
  - **Wheel Picker**: `NativeLiquidGlassPicker` — `UIPickerView` with multi-column support.
- Updated README with complete usage examples for all 18 native widgets.
- Fixed GitHub repository URLs.

## 0.1.0

- Initial production-ready release of `liquidify`.
- Core engine: `LiquidGlassOptions`, `LiquidGlassPlatform`, `LiquidGlassTheme`, `LiquidGlassRegistry`, and `LiquidGlassEngine`.
- Direct `.liquidGlass()` extensions for standard Flutter widgets:
  - **Buttons**: `ElevatedButton`, `FilledButton`, `OutlinedButton`, `TextButton`, `IconButton`, `FloatingActionButton`, `SegmentedButton`.
  - **Inputs**: `TextField`, `TextFormField`, `SearchBar`, `DropdownButton`.
  - **Selection**: `Switch`, `Checkbox`, `Radio`, `SwitchListTile`, `CheckboxListTile`, `RadioListTile`.
  - **Sliders**: `Slider`, `RangeSlider`.
  - **Navigation**: `BottomNavigationBar`, `NavigationBar`, `NavigationRail`, `TabBar`.
  - **Containers**: `AppBar` (with `PreferredSizeWidget`), `SliverAppBar`, `Card`, `ListTile`, `Container`.
  - **Dialogs**: `AlertDialog`, `Dialog`.
  - **Misc**: `Chip`, `FilterChip`, `ChoiceChip`, `ActionChip`, `CircularProgressIndicator`, `LinearProgressIndicator`, generic `Widget`.
- **Native iOS Plugin Engine**: Authentic UIKit Platform Views supporting Apple's official `UIGlassEffect` (iOS 26+) and `UIVisualEffectView` across TabBar, NavBar, Slider, Switch, TextField, SearchBar, SegmentedControl, Button, and Container.
- Apple-style frosted glass container with specular gradient rims and multi-layered depth shadows.
- Dynamic light and dark mode adaptation.
- Full platform-aware behavior with safe fallback for Android, Web, and Desktop.
- Unit and widget test suite with 100% passing tests.
- Interactive example app with real-time controls.
