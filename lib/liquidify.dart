/// Liquidify: Seamless Apple-style Liquid Glass UI transformation for Flutter.
///
/// Write standard Flutter widgets first, then simply add `.liquidGlass()`!
///
/// ```dart
/// BottomNavigationBar(
///   items: [...],
///   currentIndex: index,
///   onTap: onTabTapped,
/// ).liquidGlass();
/// ```
library;

// Core
export 'src/core/liquid_glass_adapter.dart';
export 'src/core/liquid_glass_engine.dart';
export 'src/core/liquid_glass_options.dart';
export 'src/core/liquid_glass_platform.dart';
export 'src/core/liquid_glass_registry.dart';
export 'src/core/liquid_glass_theme.dart';
export 'src/core/liquid_glass_transformer.dart';

// Native (Platform Views)
export 'src/native/liquidify_platform_channel.dart';
export 'src/native/native_liquid_glass_view.dart';
export 'src/native/native_liquid_glass_tab_bar.dart';
export 'src/native/native_liquid_glass_nav_bar.dart';
export 'src/native/native_liquid_glass_slider.dart';
export 'src/native/native_liquid_glass_switch.dart';
export 'src/native/native_liquid_glass_text_field.dart';
export 'src/native/native_liquid_glass_search_bar.dart';
export 'src/native/native_liquid_glass_segmented.dart';
export 'src/native/native_liquid_glass_button.dart';
export 'src/native/native_liquid_glass_alert.dart';
export 'src/native/native_liquid_glass_sheet.dart';
export 'src/native/native_liquid_glass_date_picker.dart';
export 'src/native/native_liquid_glass_toolbar.dart';
export 'src/native/native_liquid_glass_menu.dart';
export 'src/native/native_liquid_glass_progress.dart';
export 'src/native/native_liquid_glass_activity.dart';
export 'src/native/native_liquid_glass_page_control.dart';
export 'src/native/native_liquid_glass_picker.dart';

// Widgets
export 'src/widgets/liquid_app_bar.dart';
export 'src/widgets/liquid_bottom_navigation_bar.dart';
export 'src/widgets/liquid_button.dart';
export 'src/widgets/liquid_glass_container.dart';
export 'src/widgets/liquid_slider.dart';
export 'src/widgets/liquid_switch.dart';

// Adapters
export 'src/adapters/bootstrap_adapters.dart';
export 'src/adapters/buttons/elevated_button_adapter.dart';
export 'src/adapters/buttons/filled_button_adapter.dart';
export 'src/adapters/buttons/floating_action_button_adapter.dart';
export 'src/adapters/buttons/icon_button_adapter.dart';
export 'src/adapters/buttons/outlined_button_adapter.dart';
export 'src/adapters/buttons/segmented_button_adapter.dart';
export 'src/adapters/buttons/text_button_adapter.dart';
export 'src/adapters/containers/app_bar_adapter.dart';
export 'src/adapters/containers/card_adapter.dart';
export 'src/adapters/containers/container_adapter.dart';
export 'src/adapters/containers/list_tile_adapter.dart';
export 'src/adapters/containers/sliver_app_bar_adapter.dart';
export 'src/adapters/dialogs/alert_dialog_adapter.dart';
export 'src/adapters/dialogs/dialog_adapter.dart';
export 'src/adapters/inputs/dropdown_button_adapter.dart';
export 'src/adapters/inputs/search_bar_adapter.dart';
export 'src/adapters/inputs/text_field_adapter.dart';
export 'src/adapters/inputs/text_form_field_adapter.dart';
export 'src/adapters/misc/chip_adapters.dart';
export 'src/adapters/misc/generic_widget_adapter.dart';
export 'src/adapters/misc/progress_indicator_adapters.dart';
export 'src/adapters/navigation/bottom_navigation_bar_adapter.dart';
export 'src/adapters/navigation/navigation_bar_adapter.dart';
export 'src/adapters/navigation/navigation_rail_adapter.dart';
export 'src/adapters/navigation/tab_bar_adapter.dart';
export 'src/adapters/selection/checkbox_adapter.dart';
export 'src/adapters/selection/checkbox_list_tile_adapter.dart';
export 'src/adapters/selection/radio_adapter.dart';
export 'src/adapters/selection/radio_list_tile_adapter.dart';
export 'src/adapters/selection/switch_adapter.dart';
export 'src/adapters/selection/switch_list_tile_adapter.dart';
export 'src/adapters/sliders/range_slider_adapter.dart';
export 'src/adapters/sliders/slider_adapter.dart';

// Extensions
export 'src/extensions/button_extensions.dart';
export 'src/extensions/container_extensions.dart';
export 'src/extensions/dialog_extensions.dart';
export 'src/extensions/input_extensions.dart';
export 'src/extensions/misc_extensions.dart';
export 'src/extensions/navigation_extensions.dart';
export 'src/extensions/selection_extensions.dart';
export 'src/extensions/slider_extensions.dart';
export 'src/extensions/widget_extensions.dart';
