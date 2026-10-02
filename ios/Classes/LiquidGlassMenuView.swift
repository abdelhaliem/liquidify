import Flutter
import UIKit

/// Factory for native glass-styled context menu views.
class LiquidGlassMenuFactory: NSObject, FlutterPlatformViewFactory {
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
        return LiquidGlassMenuView(
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

/// Native iOS context menu trigger with Liquid Glass background.
///
/// Wraps a `UIButton` with `UIContextMenuInteraction` that displays a
/// native `UIMenu` on long-press. On iOS 26+ the button and menu adopt
/// Liquid Glass material styling.
class LiquidGlassMenuView: NSObject, FlutterPlatformView {
    private let containerView: UIView
    private var menuItems: [[String: Any]] = []
    private var methodChannel: FlutterMethodChannel?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        messenger: FlutterBinaryMessenger
    ) {
        let params = args as? [String: Any]
        let title = params?["title"] as? String ?? ""
        let icon = params?["icon"] as? String
        let cornerRadius = params?["cornerRadius"] as? CGFloat ?? 12.0
        menuItems = params?["items"] as? [[String: Any]] ?? []

        containerView = UIView(frame: frame)
        containerView.backgroundColor = .clear

        super.init()

        // Glass background for trigger button
        let blurEffect: UIVisualEffect
        if #available(iOS 26, *),
           let glassClass = NSClassFromString("UIGlassEffect")
               as? NSObject.Type,
           let effect = glassClass.init() as? UIVisualEffect
        {
            blurEffect = effect
        } else {
            blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        }

        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = containerView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.layer.cornerRadius = cornerRadius
        blurView.layer.cornerCurve = .continuous
        blurView.clipsToBounds = true
        blurView.layer.borderWidth = 0.5
        blurView.layer.borderColor = UIColor.white
            .withAlphaComponent(0.25).cgColor

        // Trigger button
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false

        if let iconName = icon,
           let image = UIImage(systemName: iconName)
        {
            button.setImage(image, for: .normal)
        }

        // Build UIMenu
        button.menu = buildMenu()
        button.showsMenuAsPrimaryAction = true

        blurView.contentView.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(
                equalTo: blurView.contentView.centerXAnchor
            ),
            button.centerYAnchor.constraint(
                equalTo: blurView.contentView.centerYAnchor
            ),
            button.leadingAnchor.constraint(
                greaterThanOrEqualTo:
                    blurView.contentView.leadingAnchor,
                constant: 8
            ),
            button.trailingAnchor.constraint(
                lessThanOrEqualTo:
                    blurView.contentView.trailingAnchor,
                constant: -8
            ),
        ])

        containerView.addSubview(blurView)

        methodChannel = FlutterMethodChannel(
            name: "liquidify/menu_\(viewId)",
            binaryMessenger: messenger
        )
        methodChannel?.setMethodCallHandler(handleMethodCall)
    }

    func view() -> UIView { return containerView }

    private func buildMenu() -> UIMenu {
        var actions: [UIAction] = []

        for (index, item) in menuItems.enumerated() {
            let label = item["label"] as? String ?? ""
            let icon = item["icon"] as? String
            let isDestructive = item["isDestructive"] as? Bool ?? false

            var image: UIImage?
            if let iconName = icon {
                image = UIImage(systemName: iconName)
            }

            let attributes: UIMenuElement.Attributes =
                isDestructive ? .destructive : []

            let action = UIAction(
                title: label,
                image: image,
                attributes: attributes
            ) { [weak self] _ in
                self?.methodChannel?.invokeMethod(
                    "onItemSelected",
                    arguments: index
                )
            }

            actions.append(action)
        }

        return UIMenu(title: "", children: actions)
    }

    private func handleMethodCall(
        _ call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) {
        switch call.method {
        case "updateItems":
            if let items = call.arguments as? [[String: Any]] {
                menuItems = items
                // Re-create menu items
                for subview in containerView.subviews {
                    if let blurView = subview as? UIVisualEffectView {
                        for contentChild in blurView.contentView.subviews {
                            if let button = contentChild as? UIButton {
                                button.menu = buildMenu()
                            }
                        }
                    }
                }
                result(nil)
            } else {
                result(
                    FlutterError(
                        code: "INVALID_ARGS",
                        message: "Expected array of items",
                        details: nil
                    )
                )
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
