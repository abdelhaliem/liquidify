import Flutter
import UIKit

/// Factory for native iOS Button platform views.
class LiquidGlassButtonFactory: NSObject, FlutterPlatformViewFactory {
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
        return LiquidGlassButtonView(
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

/// Native iOS UIButton with glass background — on iOS 26+
/// uses UIGlassEffect for authentic glass look.
class LiquidGlassButtonView: NSObject, FlutterPlatformView {
    private let containerView: UIView
    private var methodChannel: FlutterMethodChannel?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        messenger: FlutterBinaryMessenger
    ) {
        let params = args as? [String: Any]
        let title = params?["title"] as? String ?? ""
        let cornerRadius = params?["cornerRadius"] as? CGFloat ?? 12.0
        _ = params?["style"] as? String ?? "filled"
        let iconName = params?["icon"] as? String

        containerView = UIView(frame: frame)
        containerView.backgroundColor = .clear

        super.init()

        // Glass background
        let blurEffect: UIVisualEffect
        if #available(iOS 26, *),
           let glassClass = NSClassFromString("UIGlassEffect") as? NSObject.Type,
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

        // Button on top
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false

        if let iconName = iconName,
           let image = UIImage(systemName: iconName)
        {
            button.setImage(image, for: .normal)
        }

        button.addTarget(
            self,
            action: #selector(buttonTapped),
            for: .touchUpInside
        )

        containerView.addSubview(blurView)
        blurView.contentView.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(
                equalTo: blurView.contentView.centerXAnchor
            ),
            button.centerYAnchor.constraint(
                equalTo: blurView.contentView.centerYAnchor
            ),
            button.leadingAnchor.constraint(
                greaterThanOrEqualTo: blurView.contentView.leadingAnchor,
                constant: 12
            ),
            button.trailingAnchor.constraint(
                lessThanOrEqualTo: blurView.contentView.trailingAnchor,
                constant: -12
            ),
        ])

        methodChannel = FlutterMethodChannel(
            name: "liquidify/button_\(viewId)",
            binaryMessenger: messenger
        )
        methodChannel?.setMethodCallHandler(handleMethodCall)
    }

    func view() -> UIView { return containerView }

    @objc private func buttonTapped() {
        methodChannel?.invokeMethod("onPressed", arguments: nil)
    }

    private func handleMethodCall(
        _ call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) {
        switch call.method {
        case "setEnabled":
            if let enabled = call.arguments as? Bool {
                containerView.subviews.forEach {
                    $0.isUserInteractionEnabled = enabled
                    $0.alpha = enabled ? 1.0 : 0.5
                }
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
