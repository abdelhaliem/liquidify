import Flutter
import UIKit

/// Factory for native glass-styled toolbar views.
class LiquidGlassToolbarFactory: NSObject, FlutterPlatformViewFactory {
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
        return LiquidGlassToolbarView(
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

/// Native `UIToolbar` with Liquid Glass styling.
///
/// Renders a UIToolbar with glass background material, displaying SF
/// Symbol icons as toolbar items. On iOS 26+ uses `UIGlassEffect`.
class LiquidGlassToolbarView: NSObject, FlutterPlatformView {
    private let containerView: UIView
    private let toolbar: UIToolbar
    private var methodChannel: FlutterMethodChannel?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        messenger: FlutterBinaryMessenger
    ) {
        let params = args as? [String: Any]
        let items = params?["items"] as? [[String: Any]] ?? []
        let tintColorHex = params?["tintColor"] as? Int

        containerView = UIView(frame: frame)
        containerView.backgroundColor = .clear

        toolbar = UIToolbar(frame: containerView.bounds)
        toolbar.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        super.init()

        // Glass background
        if #available(iOS 26, *),
           let glassClass = NSClassFromString("UIGlassEffect")
               as? NSObject.Type,
           let effect = glassClass.init() as? UIVisualEffect
        {
            let appearance = UIToolbarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundEffect = effect
            toolbar.standardAppearance = appearance
            toolbar.scrollEdgeAppearance = appearance
        } else {
            let appearance = UIToolbarAppearance()
            appearance.configureWithDefaultBackground()
            toolbar.standardAppearance = appearance
        }

        if let hex = tintColorHex {
            toolbar.tintColor = UIColor(hex: hex)
        }

        // Build bar button items
        var barItems: [UIBarButtonItem] = []
        for (index, item) in items.enumerated() {
            let icon = item["icon"] as? String ?? "circle"
            let label = item["label"] as? String

            let image = UIImage(systemName: icon)
            let barButton = UIBarButtonItem(
                image: image,
                style: .plain,
                target: self,
                action: #selector(itemTapped(_:))
            )
            barButton.tag = index

            if let label = label {
                barButton.accessibilityLabel = label
            }

            barItems.append(barButton)

            // Add flexible space between items
            if index < items.count - 1 {
                barItems.append(
                    UIBarButtonItem(
                        barButtonSystemItem: .flexibleSpace,
                        target: nil,
                        action: nil
                    )
                )
            }
        }

        toolbar.setItems(barItems, animated: false)
        containerView.addSubview(toolbar)

        methodChannel = FlutterMethodChannel(
            name: "liquidify/toolbar_\(viewId)",
            binaryMessenger: messenger
        )
        methodChannel?.setMethodCallHandler(handleMethodCall)
    }

    func view() -> UIView { return containerView }

    @objc private func itemTapped(_ sender: UIBarButtonItem) {
        methodChannel?.invokeMethod(
            "onItemTapped",
            arguments: sender.tag
        )
    }

    private func handleMethodCall(
        _ call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) {
        switch call.method {
        case "setEnabled":
            if let enabled = call.arguments as? Bool {
                toolbar.isUserInteractionEnabled = enabled
                toolbar.alpha = enabled ? 1.0 : 0.5
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
