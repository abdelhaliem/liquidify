import Flutter
import UIKit

/// Factory that creates native Liquid Glass container views for Flutter.
///
/// On iOS 26+, creates a `UIGlassEffectView` with the real Apple Liquid Glass
/// material. On older versions, creates a `UIVisualEffectView` with a system
/// blur material as a graceful fallback.
class LiquidGlassContainerFactory: NSObject, FlutterPlatformViewFactory {
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
        return LiquidGlassContainerView(
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

/// A native platform view that renders Apple's Liquid Glass effect.
///
/// On iOS 26+, uses `UIGlassEffectView` for the authentic Apple Liquid Glass
/// material with real-time blur, specular highlights, and depth-aware rendering.
/// On older iOS versions, falls back to `UIVisualEffectView` with system blur.
class LiquidGlassContainerView: NSObject, FlutterPlatformView {
    private let containerView: UIView
    private let messenger: FlutterBinaryMessenger
    private let viewId: Int64
    private var methodChannel: FlutterMethodChannel?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        messenger: FlutterBinaryMessenger
    ) {
        self.viewId = viewId
        self.messenger = messenger

        let params = args as? [String: Any]
        let cornerRadius = params?["cornerRadius"] as? CGFloat ?? 20.0
        let tintColorHex = params?["tintColor"] as? Int
        let showBorder = params?["showBorder"] as? Bool ?? true
        let borderWidth = params?["borderWidth"] as? CGFloat ?? 0.5

        containerView = UIView(frame: frame)
        containerView.backgroundColor = .clear

        super.init()

        // Set up the method channel for this specific view
        methodChannel = FlutterMethodChannel(
            name: "liquidify/glass_container_\(viewId)",
            binaryMessenger: messenger
        )
        methodChannel?.setMethodCallHandler(handleMethodCall)

        // Build the glass view — try native iOS 26+ first, then fallback
        if Self.supportsNativeGlass {
            setupNativeLiquidGlass(
                cornerRadius: cornerRadius,
                tintColorHex: tintColorHex,
                showBorder: showBorder,
                borderWidth: borderWidth
            )
        } else {
            setupFallbackBlur(
                cornerRadius: cornerRadius,
                tintColorHex: tintColorHex
            )
        }
    }

    func view() -> UIView {
        return containerView
    }

    // MARK: - Native Glass Availability

    /// Whether the current SDK and runtime support native `UIGlassEffect`.
    private static var supportsNativeGlass: Bool {
        if #available(iOS 26, *) {
            return NSClassFromString("UIGlassEffect") != nil
        }
        return false
    }

    // MARK: - iOS 26+ Native Liquid Glass

    private func setupNativeLiquidGlass(
        cornerRadius: CGFloat,
        tintColorHex: Int?,
        showBorder: Bool,
        borderWidth: CGFloat
    ) {
        guard #available(iOS 26, *),
              let glassEffectClass = NSClassFromString("UIGlassEffect") as? NSObject.Type,
              let effect = glassEffectClass.init() as? UIVisualEffect
        else {
            // If runtime class not available, fallback
            setupFallbackBlur(
                cornerRadius: cornerRadius,
                tintColorHex: tintColorHex
            )
            return
        }

        let glassView = UIVisualEffectView(effect: effect)
        glassView.frame = containerView.bounds
        glassView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        glassView.layer.cornerRadius = cornerRadius
        glassView.layer.cornerCurve = .continuous
        glassView.clipsToBounds = true

        // Apply tint if provided
        if let hex = tintColorHex {
            let tintColor = UIColor(hex: hex)
            glassView.contentView.backgroundColor =
                tintColor.withAlphaComponent(0.15)
        }

        // Add subtle border for glass rim effect
        if showBorder {
            glassView.layer.borderWidth = borderWidth
            glassView.layer.borderColor = UIColor.white
                .withAlphaComponent(0.25).cgColor
        }

        containerView.addSubview(glassView)
    }

    // MARK: - Fallback for pre-iOS 26

    private func setupFallbackBlur(
        cornerRadius: CGFloat,
        tintColorHex: Int?
    ) {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = containerView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.layer.cornerRadius = cornerRadius
        blurView.layer.cornerCurve = .continuous
        blurView.clipsToBounds = true

        // Apply tint overlay
        if let hex = tintColorHex {
            let overlay = UIView()
            overlay.backgroundColor = UIColor(hex: hex)
                .withAlphaComponent(0.12)
            overlay.frame = blurView.contentView.bounds
            overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurView.contentView.addSubview(overlay)
        }

        // Subtle border
        blurView.layer.borderWidth = 0.5
        blurView.layer.borderColor = UIColor.white
            .withAlphaComponent(0.2).cgColor

        containerView.addSubview(blurView)
    }

    // MARK: - Method Channel Handler

    private func handleMethodCall(
        _ call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) {
        switch call.method {
        case "updateStyle":
            if let args = call.arguments as? [String: Any] {
                updateStyle(args)
                result(nil)
            } else {
                result(
                    FlutterError(
                        code: "INVALID_ARGS",
                        message: "Expected dictionary arguments",
                        details: nil
                    )
                )
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func updateStyle(_ params: [String: Any]) {
        let cornerRadius = params["cornerRadius"] as? CGFloat ?? 20.0

        for subview in containerView.subviews {
            subview.layer.cornerRadius = cornerRadius
        }
    }
}

// MARK: - UIColor Hex Extension

extension UIColor {
    convenience init(hex: Int) {
        let alpha = CGFloat((hex >> 24) & 0xFF) / 255.0
        let red = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
