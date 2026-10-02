import Flutter
import UIKit

/// Factory for native Liquid Glass tab bar views.
class LiquidGlassTabBarFactory: NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return LiquidGlassTabBarView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            messenger: messenger
        )
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

/// Native Liquid Glass tab bar that renders using real iOS 26 system components.
///
/// On iOS 26+, the UITabBar automatically adopts the Liquid Glass material.
/// On older versions, it uses the default system blur material.
class LiquidGlassTabBarView: NSObject, FlutterPlatformView {
    private let containerView: UIView
    private let tabBar: UITabBar
    private var methodChannel: FlutterMethodChannel?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        messenger: FlutterBinaryMessenger
    ) {
        let params = args as? [String: Any]
        let items = params?["items"] as? [[String: Any]] ?? []
        let currentIndex = params?["currentIndex"] as? Int ?? 0
        let selectedColorHex = params?["selectedColor"] as? Int
        let unselectedColorHex = params?["unselectedColor"] as? Int

        containerView = UIView(frame: frame)
        containerView.backgroundColor = .clear

        tabBar = UITabBar(frame: containerView.bounds)
        tabBar.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        super.init()

        // Configure tab bar items
        var tabItems: [UITabBarItem] = []
        for (index, item) in items.enumerated() {
            let label = item["label"] as? String ?? ""
            let iconName = item["icon"] as? String ?? "circle"
            let activeIconName = item["activeIcon"] as? String

            let image = UIImage(systemName: iconName)
            let selectedImage = activeIconName != nil
                ? UIImage(systemName: activeIconName!)
                : nil

            let tabItem = UITabBarItem(
                title: label,
                image: image,
                selectedImage: selectedImage
            )
            tabItem.tag = index
            tabItems.append(tabItem)
        }

        tabBar.items = tabItems
        tabBar.selectedItem = tabItems.indices.contains(currentIndex)
            ? tabItems[currentIndex]
            : tabItems.first
        tabBar.delegate = self

        // Apply tint colors
        if let selectedHex = selectedColorHex {
            tabBar.tintColor = UIColor(hex: selectedHex)
        }
        if let unselectedHex = unselectedColorHex {
            tabBar.unselectedItemTintColor = UIColor(hex: unselectedHex)
        }

        // On iOS 26+, the tab bar natively adopts Liquid Glass
        if #available(iOS 26, *) {
            // System handles liquid glass automatically
        } else {
            // Pre-iOS 26: use system blur appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundEffect = UIBlurEffect(
                style: .systemChromeMaterial
            )
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }

        containerView.addSubview(tabBar)

        // Set up method channel
        methodChannel = FlutterMethodChannel(
            name: "liquidify/tab_bar_\(viewId)",
            binaryMessenger: messenger
        )
        methodChannel?.setMethodCallHandler(handleMethodCall)
    }

    func view() -> UIView {
        return containerView
    }

    private func handleMethodCall(
        _ call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) {
        switch call.method {
        case "setSelectedIndex":
            if let index = call.arguments as? Int,
               let items = tabBar.items,
               items.indices.contains(index)
            {
                tabBar.selectedItem = items[index]
                result(nil)
            } else {
                result(
                    FlutterError(
                        code: "INVALID_INDEX",
                        message: "Index out of bounds",
                        details: nil
                    )
                )
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

// MARK: - UITabBarDelegate

extension LiquidGlassTabBarView: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        methodChannel?.invokeMethod("onTabSelected", arguments: item.tag)
    }
}
