<p align="center">
  <img src="https://raw.githubusercontent.com/abdelhaliem/liquidify/main/assets/liquidify_banner.jpg" alt="Liquidify - Native Apple Liquid Glass for Flutter" width="100%">
</p>

<p align="center">
  <a href="https://pub.dev/packages/liquidify"><img src="https://img.shields.io/pub/v/liquidify.svg" alt="Pub Version"></a>
  <a href="https://pub.dev/packages/liquidify/score"><img src="https://img.shields.io/pub/points/liquidify.svg" alt="Pub Points"></a>
  <a href="https://github.com/abdelhaliem/liquidify"><img src="https://img.shields.io/github/stars/abdelhaliem/liquidify?style=social" alt="GitHub Stars"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License: MIT"></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-%3E%3D3.16-02569B?logo=flutter" alt="Flutter Compatibility"></a>
</p>

---

## Overview

**Liquidify** brings Apple's authentic Liquid Glass design system to Flutter applications without the complexity of rewriting your interface or manually writing native platform code.

### The Problem

Achieving authentic Apple Liquid Glass in Flutter traditionally meant choosing between two frustrating extremes:

1. **Writing complex native code:** Manually bridging iOS UIKit APIs (`UIGlassEffect`, `UIVisualEffectView`, `UITabBar`, `UINavigationBar`) through custom Platform Views, Method Channels, and Xcode configuration.
2. **Reinventing the wheel in Flutter:** Replacing standard Flutter widgets with proprietary custom widgets, losing standard constructor parameters, keys, controllers, focus trees, accessibility semantics, and form validation in the process.

### The Solution: One Simple Extension

With Liquidify, you build your UI using standard Flutter widgets—exactly as you normally would—and simply append `.liquidGlass()`:

```dart
BottomNavigationBar(
  currentIndex: _selectedIndex,
  onTap: (index) => setState(() => _selectedIndex = index),
  items: const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  ],
).liquidGlass();
```

Behind the scenes, Liquidify automatically handles everything:
- **On iOS:** Integrates native UIKit Platform Views using Apple's official `UIGlassEffect` (iOS 26+) and `UIVisualEffectView` for real specular highlights, depth refraction, and authentic system materials.
- **On Android, Web, and Desktop:** Automatically provides a smooth, GPU-accelerated backdrop blur fallback with specular gradients and multi-layered depth shadows.
- **Everywhere:** All callbacks (`onPressed`, `onChanged`, `onTap`), `TextEditingController`, `FocusNode`, form validation, and semantics remain 100% intact.

---

## Features

- **18 Native iOS Platform Views:** Directly embeds real iOS UIKit components utilizing Apple's official `UIGlassEffect` and `UIVisualEffectView` for pixel-perfect specular refraction, fluid light response, and genuine system materials.
- **32+ Supported Widgets:** Buttons, inputs, navigation, containers, dialogs, pickers, progress indicators, and more — all via `.liquidGlass()`.
- **Zero Rewrite Requirement:** Extend standard widgets rather than replacing them with custom proprietary classes.
- **Full State & Callback Preservation:** Controllers, focus nodes, form keys, tap gestures, animations, and accessibility trees remain completely functional.
- **Adaptive Cross-Platform Fallback:** Seamlessly operates across Android, Web, macOS, Windows, and Linux using optimized shaders and backdrop filters.
- **Forced Universal Mode:** Enable `.liquidGlass(options: LiquidGlassOptions(force: true))` to render the glass aesthetic uniformly across all operating systems.
- **Dynamic Lighting & Mode Adaptation:** Automatic contrast adjustments for light mode (crystalline frost) and dark mode (translucent smoke).
- **Extensible Architecture:** Register custom widget adapters with `LiquidGlassRegistry.register<T>()`.
- **Zero External Dart Dependencies:** Lightweight, clean, and built on core Flutter and native UIKit APIs.

---

## Installation

Add `liquidify` to your project's `pubspec.yaml`:

```bash
flutter pub add liquidify
```

Import the package in your Dart code:

```dart
import 'package:liquidify/liquidify.dart';
```

---

## Usage Examples

### Navigation Bar

```dart
Scaffold(
  bottomNavigationBar: BottomNavigationBar(
    currentIndex: currentIndex,
    onTap: (index) => setState(() => currentIndex = index),
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.widgets), label: 'Widgets'),
      BottomNavigationBarItem(icon: Icon(Icons.palette), label: 'Themes'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    ],
  ).liquidGlass(),
  body: Center(child: Text('Active Index: $currentIndex')),
);
```

### App Bar

`LiquidAppBar` implements `PreferredSizeWidget` and directly slots into standard `Scaffold.appBar`:

```dart
Scaffold(
  extendBodyBehindAppBar: true,
  appBar: AppBar(
    title: const Text('Liquidify'),
    actions: [
      IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: _handleRefresh,
      ).liquidGlass(),
    ],
  ).liquidGlass(),
  body: const ContentWidget(),
);
```

### Form Controls & Sliders

```dart
// Native UISlider on iOS, glass slider elsewhere
Slider(
  value: sliderValue,
  min: 0,
  max: 100,
  onChanged: (val) => setState(() => sliderValue = val),
).liquidGlass();

// Native UISwitch on iOS, glass toggle elsewhere
Switch(
  value: isEnabled,
  onChanged: (val) => setState(() => isEnabled = val),
).liquidGlass();

// Native UISegmentedControl on iOS
SegmentedButton<int>(
  segments: const [
    ButtonSegment(value: 0, label: Text('Frost')),
    ButtonSegment(value: 1, label: Text('Crystal')),
    ButtonSegment(value: 2, label: Text('Smoke')),
  ],
  selected: {selectedSegment},
  onSelectionChanged: (val) => setState(() => selectedSegment = val.first),
).liquidGlass();
```

### Inputs & Text Fields

```dart
TextField(
  controller: searchController,
  decoration: const InputDecoration(
    hintText: 'Search components...',
    prefixIcon: Icon(Icons.search),
  ),
  onChanged: (query) => _filterResults(query),
).liquidGlass();
```

### Buttons

```dart
ElevatedButton(
  onPressed: () => _handleSubmit(),
  child: const Text('Confirm Action'),
).liquidGlass(
  options: const LiquidGlassOptions(
    tint: Color(0xFF007AFF),
  ),
);
```

---

## Native iOS Platform Views

Liquidify ships with **18 native UIKit Platform Views** that render real Apple materials on iOS. These are used automatically by the adapter system, but you can also use them directly for maximum control.

### Native Glass Container

```dart
NativeLiquidGlassView(
  width: 300,
  height: 200,
  cornerRadius: 20.0,
  options: const LiquidGlassOptions(blur: 20),
  child: const Center(child: Text('Hello Glass')),
  fallback: const Card(child: Text('Non-iOS fallback')),
);
```

### Native Glass Button

```dart
NativeLiquidGlassButton(
  title: 'Tap Me',
  icon: 'star.fill',  // SF Symbol name
  cornerRadius: 12.0,
  height: 48.0,
  onPressed: () => print('Tapped!'),
  fallback: ElevatedButton(
    onPressed: () {},
    child: const Text('Tap Me'),
  ),
);
```

### Native Glass Tab Bar

```dart
NativeLiquidGlassTabBar(
  items: const [
    NativeLiquidTabItem(icon: 'house.fill', label: 'Home'),
    NativeLiquidTabItem(icon: 'magnifyingglass', label: 'Search'),
    NativeLiquidTabItem(icon: 'gearshape.fill', label: 'Settings'),
  ],
  selectedIndex: _currentIndex,
  onTabSelected: (index) => setState(() => _currentIndex = index),
  height: 80.0,
);
```

### Native Glass Navigation Bar

```dart
NativeLiquidGlassNavBar(
  title: 'Settings',
  height: 56.0,
  fallback: AppBar(title: const Text('Settings')),
);
```

### Native Glass Search Bar

```dart
NativeLiquidGlassSearchBar(
  placeholder: 'Search...',
  onChanged: (text) => _filterResults(text),
  onSubmitted: (text) => _performSearch(text),
  height: 44.0,
);
```

### Native Glass Text Field

```dart
NativeLiquidGlassTextField(
  placeholder: 'Enter your name',
  text: _nameValue,
  onChanged: (text) => setState(() => _nameValue = text),
  height: 44.0,
);
```

### Native Glass Switch

```dart
NativeLiquidGlassSwitch(
  value: _isEnabled,
  onChanged: (val) => setState(() => _isEnabled = val),
  height: 32.0,
);
```

### Native Glass Slider

```dart
NativeLiquidGlassSlider(
  value: _sliderValue,
  minimumValue: 0.0,
  maximumValue: 100.0,
  onChanged: (val) => setState(() => _sliderValue = val),
  height: 32.0,
);
```

### Native Glass Segmented Control

```dart
NativeLiquidGlassSegmented(
  segments: const ['Day', 'Week', 'Month'],
  selectedIndex: _selectedSegment,
  onChanged: (index) => setState(() => _selectedSegment = index),
  height: 32.0,
);
```

### Native Glass Alert Dialog

```dart
NativeLiquidGlassAlert(
  title: 'Delete Item?',
  message: 'This action cannot be undone.',
  actions: const [
    NativeAlertAction(label: 'Cancel'),
    NativeAlertAction(
      label: 'Delete',
      isDestructive: true,
      isDefault: true,
    ),
  ],
  onAction: (index) {
    if (index == 1) _deleteItem();
  },
  height: 180.0,
);
```

### Native Glass Bottom Sheet

```dart
NativeLiquidGlassSheet(
  cornerRadius: 20.0,
  showHandle: true,
  tintColor: Colors.blue.withValues(alpha: 0.1),
  height: 300.0,
  onDismiss: () => Navigator.pop(context),
);
```

### Native Glass Date Picker

```dart
// Date mode
NativeLiquidGlassDatePicker(
  mode: LiquidDatePickerMode.date,
  initialDate: DateTime.now(),
  minimumDate: DateTime(2020),
  maximumDate: DateTime(2030),
  onChanged: (date) => setState(() => _selectedDate = date),
  height: 340.0,
);

// Time mode
NativeLiquidGlassDatePicker(
  mode: LiquidDatePickerMode.time,
  onChanged: (time) => setState(() => _selectedTime = time),
  height: 200.0,
);

// Date and Time combined
NativeLiquidGlassDatePicker(
  mode: LiquidDatePickerMode.dateAndTime,
  onChanged: (dateTime) => print('Selected: $dateTime'),
  height: 340.0,
);
```

### Native Glass Toolbar

```dart
NativeLiquidGlassToolbar(
  items: const [
    NativeToolbarItem(icon: 'square.and.arrow.up', label: 'Share'),
    NativeToolbarItem(icon: 'bookmark', label: 'Bookmark'),
    NativeToolbarItem(icon: 'trash', label: 'Delete'),
  ],
  tintColor: Colors.blue,
  onItemTapped: (index) {
    switch (index) {
      case 0: _share();
      case 1: _bookmark();
      case 2: _delete();
    }
  },
  height: 44.0,
);
```

### Native Glass Context Menu

```dart
NativeLiquidGlassMenu(
  title: 'Options',
  icon: 'ellipsis.circle',
  items: const [
    NativeMenuItem(label: 'Copy', icon: 'doc.on.doc'),
    NativeMenuItem(label: 'Edit', icon: 'pencil'),
    NativeMenuItem(
      label: 'Delete',
      icon: 'trash',
      isDestructive: true,
    ),
  ],
  onItemSelected: (index) {
    switch (index) {
      case 0: _copy();
      case 1: _edit();
      case 2: _delete();
    }
  },
  height: 44.0,
);
```

### Native Glass Progress Bar

```dart
NativeLiquidGlassProgress(
  progress: _downloadProgress,  // 0.0 to 1.0
  cornerRadius: 8.0,
  trackHeight: 6.0,
  tintColor: Colors.green,
  height: 36.0,
);
```

### Native Glass Activity Indicator

```dart
// Simple spinner
NativeLiquidGlassActivity(
  style: LiquidActivityStyle.medium,
  cornerRadius: 16.0,
  height: 48.0,
  width: 48.0,
);

// Spinner with label
NativeLiquidGlassActivity(
  style: LiquidActivityStyle.large,
  label: 'Loading...',
  color: Colors.blue,
  cornerRadius: 20.0,
  height: 56.0,
  width: 160.0,
);
```

### Native Glass Page Control

```dart
NativeLiquidGlassPageControl(
  numberOfPages: 5,
  currentPage: _currentPage,
  activeColor: Colors.blue,
  inactiveColor: Colors.grey.withValues(alpha: 0.3),
  onPageChanged: (page) => setState(() => _currentPage = page),
  height: 36.0,
);
```

### Native Glass Wheel Picker

```dart
// Single column
NativeLiquidGlassPicker(
  columns: const [
    ['Small', 'Medium', 'Large', 'Extra Large'],
  ],
  initialSelections: const [1],  // Start at "Medium"
  onChanged: (change) {
    print('Selected: ${change.value}');
  },
  height: 216.0,
);

// Multi-column (e.g. hours & minutes)
NativeLiquidGlassPicker(
  columns: const [
    ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
    ['00', '15', '30', '45'],
    ['AM', 'PM'],
  ],
  initialSelections: const [7, 0, 0],
  onChanged: (change) {
    print('Column ${change.component}: ${change.value}');
  },
  height: 216.0,
);
```

---

## Supported Widgets

### Adapter-Based Widgets (`.liquidGlass()` extension)

| Category | Supported Widgets | iOS Native Platform View |
| :--- | :--- | :--- |
| **Navigation** | `BottomNavigationBar`, `NavigationBar`, `TabBar`, `NavigationRail` | `UITabBar`, `UINavigationBar` |
| **Containers** | `AppBar`, `SliverAppBar`, `Card`, `ListTile`, `Container` | `UIGlassEffect` / `UIVisualEffectView` |
| **Inputs** | `TextField`, `TextFormField`, `SearchBar`, `DropdownButton` | `UITextField`, `UISearchBar` |
| **Selection** | `Switch`, `Checkbox`, `Radio`, `SwitchListTile`, `CheckboxListTile`, `RadioListTile` | `UISwitch` |
| **Sliders** | `Slider`, `RangeSlider` | `UISlider` |
| **Buttons** | `ElevatedButton`, `FilledButton`, `OutlinedButton`, `TextButton`, `IconButton`, `FAB`, `SegmentedButton` | `UIButton`, `UISegmentedControl` |
| **Dialogs** | `AlertDialog`, `Dialog` | Glass Modal |
| **Chips & Progress** | `Chip`, `FilterChip`, `ActionChip`, `ChoiceChip`, `CircularProgressIndicator`, `LinearProgressIndicator` | Glass Material |
| **Generic** | Any standard Flutter `Widget` | Universal Glass Wrapper |

### Direct Native Platform Views (18 total)

| Native Widget | UIKit Component | Description |
| :--- | :--- | :--- |
| `NativeLiquidGlassView` | `UIVisualEffectView` | Generic glass container |
| `NativeLiquidGlassButton` | `UIButton` | Tappable button with glass |
| `NativeLiquidGlassTabBar` | `UITabBar` | Bottom tab navigation |
| `NativeLiquidGlassNavBar` | `UINavigationBar` | Top navigation bar |
| `NativeLiquidGlassTextField` | `UITextField` | Text input with glass |
| `NativeLiquidGlassSearchBar` | `UISearchBar` | Search input |
| `NativeLiquidGlassSwitch` | `UISwitch` | Toggle switch |
| `NativeLiquidGlassSlider` | `UISlider` | Value slider |
| `NativeLiquidGlassSegmented` | `UISegmentedControl` | Segmented selector |
| `NativeLiquidGlassAlert` | `UIAlertController`-style | Alert dialog |
| `NativeLiquidGlassSheet` | `UISheetPresentation`-style | Bottom sheet |
| `NativeLiquidGlassDatePicker` | `UIDatePicker` | Date/time picker |
| `NativeLiquidGlassToolbar` | `UIToolbar` | Action toolbar |
| `NativeLiquidGlassMenu` | `UIMenu` | Context menu |
| `NativeLiquidGlassProgress` | `UIProgressView` | Linear progress bar |
| `NativeLiquidGlassActivity` | `UIActivityIndicatorView` | Loading spinner |
| `NativeLiquidGlassPageControl` | `UIPageControl` | Page dots indicator |
| `NativeLiquidGlassPicker` | `UIPickerView` | Wheel picker |

---

## Customization with `LiquidGlassOptions`

Fine-tune the glass material parameters per widget or apply them globally:

```dart
ElevatedButton(
  onPressed: () {},
  child: const Text('Customized'),
).liquidGlass(
  options: const LiquidGlassOptions(
    blur: 24.0,           // Blur intensity radius
    opacity: 0.80,        // Glass material surface opacity
    tint: Colors.blue,    // Ambient tint overlay
    borderWidth: 1.0,     // Specular edge thickness
    force: true,          // Force glass on Android and Web
  ),
);
```

### Built-in Presets

```dart
// Subtle frosted texture (default)
LiquidGlassOptions.frosted()

// High-clarity crystalline refraction
LiquidGlassOptions.crystal()

// Deep translucent dark smoke
LiquidGlassOptions.smoke()
```

---

## Global Theming

Wrap your application tree in `LiquidGlassTheme` to set unified styling defaults:

```dart
LiquidGlassTheme(
  options: const LiquidGlassOptions(
    blur: 20.0,
    opacity: 0.78,
  ),
  child: MaterialApp(
    home: const HomeScreen(),
  ),
);
```

---

## Creating Custom Adapters

Extend Liquidify to support your proprietary widgets:

```dart
class CustomCardAdapter extends LiquidGlassAdapter<CustomCard> {
  const CustomCardAdapter();

  @override
  Widget build(CustomCard widget, LiquidGlassOptions options) {
    return LiquidGlassContainer(
      options: options,
      child: widget.child,
    );
  }
}

// Register once during application startup:
LiquidGlassRegistry.register<CustomCard>(const CustomCardAdapter());
```

---

## Architecture & Safety Guarantees

1. **Non-Destructive:** If an adapter encounters an unsupported widget or edge case, it safely returns the original widget unaltered.
2. **Platform-Respectful:** iOS devices automatically receive genuine Apple UIKit materials. Non-Apple platforms automatically receive native Material/Cupertino representations unless `force: true` is explicitly passed.
3. **Optimized Render Passes:** Measured platform view embedding prevents layout thrashing and ensures smooth 120 FPS scrolling performance.
4. **Hybrid Architecture:** The plugin uses a registry-based adapter system on the Dart side and factory-registered `FlutterPlatformView` classes on the native side, enabling seamless hot-reload and widget-level native/fallback switching.

---

## Platform Support

| Platform | Rendering |
| :--- | :--- |
| **iOS 26+** | Native `UIGlassEffect` via Platform Views |
| **iOS < 26** | `UIVisualEffectView` with system blur fallback |
| **Android** | GPU-accelerated `BackdropFilter` with specular gradients |
| **Web** | CSS-backed blur with glass overlays |
| **macOS** | Native `NSVisualEffectView` (partial) |
| **Windows/Linux** | `BackdropFilter` fallback |

---

## License

This project is licensed under the MIT License. Developed by [abdelhaliem](https://github.com/abdelhaliem).
