import Flutter
import UIKit

/// Factory for native glass-styled bottom sheet views.
class LiquidGlassSheetFactory: NSObject, FlutterPlatformViewFactory {
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
        return LiquidGlassSheetView(
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

/// Native iOS bottom sheet with Liquid Glass styling.
///
/// Uses `UIVisualEffectView` with `UIGlassEffect` on iOS 26+ for the
/// authentic sheet material. Includes a drag handle and rounded corners
/// matching the system sheet presentation style.
class LiquidGlassSheetView: NSObject, FlutterPlatformView {
    private let containerView: UIView
    private var methodChannel: FlutterMethodChannel?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        messenger: FlutterBinaryMessenger
    ) {
        let params = args as? [String: Any]
        let cornerRadius = params?["cornerRadius"] as? CGFloat ?? 20.0
        let showHandle = params?["showHandle"] as? Bool ?? true
        let tintColorHex = params?["tintColor"] as? Int

        containerView = UIView(frame: frame)
        containerView.backgroundColor = .clear

        super.init()

        // Glass background
        let blurEffect: UIVisualEffect
        if #available(iOS 26, *),
           let glassClass = NSClassFromString("UIGlassEffect")
               as? NSObject.Type,
           let effect = glassClass.init() as? UIVisualEffect
        {
            blurEffect = effect
        } else {
            blurEffect = UIBlurEffect(style: .systemThickMaterial)
        }

        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = containerView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Only round top corners for bottom sheet style
        blurView.layer.cornerRadius = cornerRadius
        blurView.layer.cornerCurve = .continuous
        blurView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner,
        ]
        blurView.clipsToBounds = true
        blurView.layer.borderWidth = 0.5
        blurView.layer.borderColor = UIColor.white
            .withAlphaComponent(0.2).cgColor

        // Tint overlay
        if let hex = tintColorHex {
            let overlay = UIView()
            overlay.backgroundColor = UIColor(hex: hex)
                .withAlphaComponent(0.12)
            overlay.frame = blurView.contentView.bounds
            overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurView.contentView.addSubview(overlay)
        }

        // Drag handle
        if showHandle {
            let handle = UIView()
            handle.backgroundColor = UIColor.tertiaryLabel
            handle.layer.cornerRadius = 2.5
            handle.translatesAutoresizingMaskIntoConstraints = false
            blurView.contentView.addSubview(handle)

            NSLayoutConstraint.activate([
                handle.topAnchor.constraint(
                    equalTo: blurView.contentView.topAnchor,
                    constant: 8
                ),
                handle.centerXAnchor.constraint(
                    equalTo: blurView.contentView.centerXAnchor
                ),
                handle.widthAnchor.constraint(equalToConstant: 36),
                handle.heightAnchor.constraint(equalToConstant: 5),
            ])
        }

        // Shadow for depth
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: -4)
        containerView.layer.shadowRadius = 16
        containerView.layer.shadowOpacity = 0.15

        containerView.addSubview(blurView)

        methodChannel = FlutterMethodChannel(
            name: "liquidify/sheet_\(viewId)",
            binaryMessenger: messenger
        )
        methodChannel?.setMethodCallHandler(handleMethodCall)
    }

    func view() -> UIView { return containerView }

    private func handleMethodCall(
        _ call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) {
        switch call.method {
        case "dismiss":
            methodChannel?.invokeMethod("onDismiss", arguments: nil)
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
