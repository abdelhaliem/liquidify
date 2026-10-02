import Flutter
import UIKit

/// Factory for native glass-styled activity indicator views.
class LiquidGlassActivityFactory: NSObject, FlutterPlatformViewFactory {
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
        return LiquidGlassActivityView(
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

/// Native `UIActivityIndicatorView` inside a Liquid Glass capsule.
///
/// On iOS 26+, the capsule background uses `UIGlassEffect` for the
/// authentic glass spinner look. On older versions falls back to
/// system blur.
class LiquidGlassActivityView: NSObject, FlutterPlatformView {
    private let containerView: UIView
    private let activityIndicator: UIActivityIndicatorView
    private var methodChannel: FlutterMethodChannel?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        messenger: FlutterBinaryMessenger
    ) {
        let params = args as? [String: Any]
        let styleName = params?["style"] as? String ?? "medium"
        let cornerRadius = params?["cornerRadius"] as? CGFloat ?? 16.0
        let colorHex = params?["color"] as? Int
        let hidesWhenStopped =
            params?["hidesWhenStopped"] as? Bool ?? true
        let animating = params?["animating"] as? Bool ?? true
        let label = params?["label"] as? String

        containerView = UIView(frame: frame)
        containerView.backgroundColor = .clear

        // Activity indicator style
        let style: UIActivityIndicatorView.Style
        switch styleName {
        case "large":
            style = .large
        default:
            style = .medium
        }

        activityIndicator = UIActivityIndicatorView(style: style)

        super.init()

        // Glass background capsule
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
            .withAlphaComponent(0.2).cgColor

        // Configure indicator
        activityIndicator.hidesWhenStopped = hidesWhenStopped
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        if let hex = colorHex {
            activityIndicator.color = UIColor(hex: hex)
        }

        if animating {
            activityIndicator.startAnimating()
        }

        // Stack with optional label
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8.0
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(activityIndicator)

        if let label = label, !label.isEmpty {
            let labelView = UILabel()
            labelView.text = label
            labelView.font = .systemFont(ofSize: 14, weight: .medium)
            labelView.textColor = .secondaryLabel
            stackView.addArrangedSubview(labelView)
        }

        blurView.contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(
                equalTo: blurView.contentView.centerXAnchor
            ),
            stackView.centerYAnchor.constraint(
                equalTo: blurView.contentView.centerYAnchor
            ),
            stackView.leadingAnchor.constraint(
                greaterThanOrEqualTo:
                    blurView.contentView.leadingAnchor,
                constant: 12
            ),
            stackView.trailingAnchor.constraint(
                lessThanOrEqualTo:
                    blurView.contentView.trailingAnchor,
                constant: -12
            ),
        ])

        containerView.addSubview(blurView)

        methodChannel = FlutterMethodChannel(
            name: "liquidify/activity_\(viewId)",
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
        case "start":
            activityIndicator.startAnimating()
            result(nil)
        case "stop":
            activityIndicator.stopAnimating()
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
