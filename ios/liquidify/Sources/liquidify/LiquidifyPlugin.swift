import Flutter
import UIKit

/// Main plugin entry point for Liquidify.
///
/// Registers platform view factories for native Liquid Glass rendering
/// on iOS 26+ and provides a MethodChannel for platform capability queries.
public class LiquidifyPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger = registrar.messenger()

        // Glass container (Card, AppBar background, generic containers)
        registrar.register(
            LiquidGlassContainerFactory(messenger: messenger),
            withId: "liquidify/glass_container"
        )

        // Tab bar (BottomNavigationBar)
        registrar.register(
            LiquidGlassTabBarFactory(messenger: messenger),
            withId: "liquidify/tab_bar"
        )

        // Navigation bar (AppBar)
        registrar.register(
            LiquidGlassNavBarFactory(messenger: messenger),
            withId: "liquidify/nav_bar"
        )

        // Slider (UISlider)
        registrar.register(
            LiquidGlassSliderFactory(messenger: messenger),
            withId: "liquidify/slider"
        )

        // Switch (UISwitch)
        registrar.register(
            LiquidGlassSwitchFactory(messenger: messenger),
            withId: "liquidify/switch"
        )

        // TextField (UITextField with glass background)
        registrar.register(
            LiquidGlassTextFieldFactory(messenger: messenger),
            withId: "liquidify/text_field"
        )

        // SearchBar (UISearchBar)
        registrar.register(
            LiquidGlassSearchBarFactory(messenger: messenger),
            withId: "liquidify/search_bar"
        )

        // SegmentedControl (UISegmentedControl)
        registrar.register(
            LiquidGlassSegmentedFactory(messenger: messenger),
            withId: "liquidify/segmented"
        )

        // Button (UIButton with glass background)
        registrar.register(
            LiquidGlassButtonFactory(messenger: messenger),
            withId: "liquidify/button"
        )

        // Alert (UIAlertController-style with glass)
        registrar.register(
            LiquidGlassAlertFactory(messenger: messenger),
            withId: "liquidify/alert"
        )

        // Bottom Sheet (UISheetPresentationController-style)
        registrar.register(
            LiquidGlassSheetFactory(messenger: messenger),
            withId: "liquidify/sheet"
        )

        // Date Picker (UIDatePicker with glass)
        registrar.register(
            LiquidGlassDatePickerFactory(messenger: messenger),
            withId: "liquidify/date_picker"
        )

        // Toolbar (UIToolbar with glass)
        registrar.register(
            LiquidGlassToolbarFactory(messenger: messenger),
            withId: "liquidify/toolbar"
        )

        // Context Menu (UIMenu with glass trigger)
        registrar.register(
            LiquidGlassMenuFactory(messenger: messenger),
            withId: "liquidify/menu"
        )

        // Progress (UIProgressView with glass track)
        registrar.register(
            LiquidGlassProgressFactory(messenger: messenger),
            withId: "liquidify/progress"
        )

        // Activity Indicator (UIActivityIndicatorView in glass capsule)
        registrar.register(
            LiquidGlassActivityFactory(messenger: messenger),
            withId: "liquidify/activity"
        )

        // Page Control (UIPageControl with glass pill)
        registrar.register(
            LiquidGlassPageControlFactory(messenger: messenger),
            withId: "liquidify/page_control"
        )

        // Picker (UIPickerView with glass background)
        registrar.register(
            LiquidGlassPickerFactory(messenger: messenger),
            withId: "liquidify/picker"
        )

        // Method channel for platform queries
        let channel = FlutterMethodChannel(
            name: "liquidify/platform",
            binaryMessenger: messenger
        )

        let instance = LiquidifyPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(
        _ call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) {
        switch call.method {
        case "supportsNativeLiquidGlass":
            if #available(iOS 26, *) {
                result(true)
            } else {
                result(false)
            }
        case "getPlatformVersion":
            result("iOS \(UIDevice.current.systemVersion)")
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
