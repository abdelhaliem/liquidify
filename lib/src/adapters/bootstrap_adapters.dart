import 'package:flutter/material.dart';
import '../core/liquid_glass_registry.dart';
import 'buttons/elevated_button_adapter.dart';
import 'buttons/filled_button_adapter.dart';
import 'buttons/floating_action_button_adapter.dart';
import 'buttons/icon_button_adapter.dart';
import 'buttons/outlined_button_adapter.dart';
import 'buttons/segmented_button_adapter.dart';
import 'buttons/text_button_adapter.dart';
import 'containers/app_bar_adapter.dart';
import 'containers/card_adapter.dart';
import 'containers/container_adapter.dart';
import 'containers/list_tile_adapter.dart';
import 'containers/sliver_app_bar_adapter.dart';
import 'dialogs/alert_dialog_adapter.dart';
import 'dialogs/dialog_adapter.dart';
import 'inputs/dropdown_button_adapter.dart';
import 'inputs/search_bar_adapter.dart';
import 'inputs/text_field_adapter.dart';
import 'inputs/text_form_field_adapter.dart';
import 'misc/chip_adapters.dart';
import 'misc/progress_indicator_adapters.dart';
import 'navigation/bottom_navigation_bar_adapter.dart';
import 'navigation/navigation_bar_adapter.dart';
import 'navigation/navigation_rail_adapter.dart';
import 'navigation/tab_bar_adapter.dart';
import 'selection/checkbox_adapter.dart';
import 'selection/checkbox_list_tile_adapter.dart';
import 'selection/radio_adapter.dart';
import 'selection/radio_list_tile_adapter.dart';
import 'selection/switch_adapter.dart';
import 'selection/switch_list_tile_adapter.dart';
import 'sliders/range_slider_adapter.dart';
import 'sliders/slider_adapter.dart';

/// Registers all built-in Liquid Glass adapters into [registry].
void bootstrapLiquidGlassAdapters(LiquidGlassRegistry registry) {
  // Buttons
  LiquidGlassRegistry.register<ElevatedButton>(
    const ElevatedButtonLiquidAdapter(),
  );
  LiquidGlassRegistry.register<FilledButton>(const FilledButtonLiquidAdapter());
  LiquidGlassRegistry.register<OutlinedButton>(
    const OutlinedButtonLiquidAdapter(),
  );
  LiquidGlassRegistry.register<TextButton>(const TextButtonLiquidAdapter());
  LiquidGlassRegistry.register<IconButton>(const IconButtonLiquidAdapter());
  LiquidGlassRegistry.register<FloatingActionButton>(
    const FloatingActionButtonLiquidAdapter(),
  );
  LiquidGlassRegistry.register<SegmentedButton<dynamic>>(
    const SegmentedButtonLiquidAdapter<dynamic>(),
  );

  // Inputs
  LiquidGlassRegistry.register<TextField>(const TextFieldLiquidAdapter());
  LiquidGlassRegistry.register<TextFormField>(
    const TextFormFieldLiquidAdapter(),
  );
  LiquidGlassRegistry.register<SearchBar>(const SearchBarLiquidAdapter());
  LiquidGlassRegistry.register<DropdownButton<dynamic>>(
    const DropdownButtonLiquidAdapter<dynamic>(),
  );

  // Selection
  LiquidGlassRegistry.register<Switch>(const SwitchLiquidAdapter());
  LiquidGlassRegistry.register<Checkbox>(const CheckboxLiquidAdapter());
  LiquidGlassRegistry.register<Radio<dynamic>>(
    const RadioLiquidAdapter<dynamic>(),
  );
  LiquidGlassRegistry.register<SwitchListTile>(
    const SwitchListTileLiquidAdapter(),
  );
  LiquidGlassRegistry.register<CheckboxListTile>(
    const CheckboxListTileLiquidAdapter(),
  );
  LiquidGlassRegistry.register<RadioListTile<dynamic>>(
    const RadioListTileLiquidAdapter<dynamic>(),
  );

  // Sliders
  LiquidGlassRegistry.register<Slider>(const SliderLiquidAdapter());
  LiquidGlassRegistry.register<RangeSlider>(const RangeSliderLiquidAdapter());

  // Navigation
  LiquidGlassRegistry.register<BottomNavigationBar>(
    const BottomNavigationBarLiquidAdapter(),
  );
  LiquidGlassRegistry.register<NavigationBar>(
    const NavigationBarLiquidAdapter(),
  );
  LiquidGlassRegistry.register<NavigationRail>(
    const NavigationRailLiquidAdapter(),
  );
  LiquidGlassRegistry.register<TabBar>(const TabBarLiquidAdapter());

  // Containers
  LiquidGlassRegistry.register<AppBar>(const AppBarLiquidAdapter());
  LiquidGlassRegistry.register<SliverAppBar>(const SliverAppBarLiquidAdapter());
  LiquidGlassRegistry.register<Card>(const CardLiquidAdapter());
  LiquidGlassRegistry.register<ListTile>(const ListTileLiquidAdapter());
  LiquidGlassRegistry.register<Container>(const ContainerLiquidAdapter());

  // Dialogs
  LiquidGlassRegistry.register<AlertDialog>(const AlertDialogLiquidAdapter());
  LiquidGlassRegistry.register<Dialog>(const DialogLiquidAdapter());

  // Chips & Progress
  LiquidGlassRegistry.register<Chip>(const ChipLiquidAdapter());
  LiquidGlassRegistry.register<FilterChip>(const FilterChipLiquidAdapter());
  LiquidGlassRegistry.register<ChoiceChip>(const ChoiceChipLiquidAdapter());
  LiquidGlassRegistry.register<ActionChip>(const ActionChipLiquidAdapter());
  LiquidGlassRegistry.register<CircularProgressIndicator>(
    const CircularProgressIndicatorLiquidAdapter(),
  );
  LiquidGlassRegistry.register<LinearProgressIndicator>(
    const LinearProgressIndicatorLiquidAdapter(),
  );
}
