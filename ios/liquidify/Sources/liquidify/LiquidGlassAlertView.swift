import Flutter
import UIKit

/// Factory for native glass-styled alert views.
class LiquidGlassAlertFactory: NSObject, FlutterPlatformViewFactory {
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
        return LiquidGlassAlertView(
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

/// Native iOS alert with glass background.
///
/// Uses `UIVisualEffectView` with `UIGlassEffect` on iOS 26+ for
/// authentic Liquid Glass dialogs. Falls back to system blur on older
/// versions.
class LiquidGlassAlertView: NSObject, FlutterPlatformView {
    private let containerView: UIView
    private var methodChannel: FlutterMethodChannel?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        messenger: FlutterBinaryMessenger
    ) {
        let params = args as? [String: Any]
        let title = params?["title"] as? String
        let message = params?["message"] as? String
        let actions = params?["actions"] as? [[String: Any]] ?? []
        let cornerRadius = params?["cornerRadius"] as? CGFloat ?? 22.0

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

        // Content stack
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8.0
        stackView.translatesAutoresizingMaskIntoConstraints = false

        // Title label
        if let title = title, !title.isEmpty {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 0
            stackView.addArrangedSubview(titleLabel)
        }

        // Message label
        if let message = message, !message.isEmpty {
            let messageLabel = UILabel()
            messageLabel.text = message
            messageLabel.font = .systemFont(ofSize: 13, weight: .regular)
            messageLabel.textColor = .secondaryLabel
            messageLabel.textAlignment = .center
            messageLabel.numberOfLines = 0
            stackView.addArrangedSubview(messageLabel)
        }

        // Separator
        let separator = UIView()
        separator.backgroundColor = UIColor.separator
        separator.translatesAutoresizingMaskIntoConstraints = false

        // Action buttons row
        let buttonStack = UIStackView()
        buttonStack.axis = actions.count <= 2 ? .horizontal : .vertical
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 0.5
        buttonStack.translatesAutoresizingMaskIntoConstraints = false

        for (index, action) in actions.enumerated() {
            let label = action["label"] as? String ?? ""
            let isDestructive = action["isDestructive"] as? Bool ?? false
            let isDefault = action["isDefault"] as? Bool ?? false

            let button = UIButton(type: .system)
            button.setTitle(label, for: .normal)
            button.tag = index

            if isDestructive {
                button.setTitleColor(.systemRed, for: .normal)
            }

            let weight: UIFont.Weight = isDefault ? .semibold : .regular
            button.titleLabel?.font = .systemFont(
                ofSize: 17,
                weight: weight
            )
            button.contentEdgeInsets = UIEdgeInsets(
                top: 12, left: 16, bottom: 12, right: 16
            )

            button.addTarget(
                self,
                action: #selector(actionTapped(_:)),
                for: .touchUpInside
            )

            buttonStack.addArrangedSubview(button)
        }

        blurView.contentView.addSubview(stackView)
        blurView.contentView.addSubview(separator)
        blurView.contentView.addSubview(buttonStack)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: blurView.contentView.topAnchor,
                constant: 20
            ),
            stackView.leadingAnchor.constraint(
                equalTo: blurView.contentView.leadingAnchor,
                constant: 16
            ),
            stackView.trailingAnchor.constraint(
                equalTo: blurView.contentView.trailingAnchor,
                constant: -16
            ),
            separator.topAnchor.constraint(
                equalTo: stackView.bottomAnchor,
                constant: 16
            ),
            separator.leadingAnchor.constraint(
                equalTo: blurView.contentView.leadingAnchor
            ),
            separator.trailingAnchor.constraint(
                equalTo: blurView.contentView.trailingAnchor
            ),
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            buttonStack.topAnchor.constraint(
                equalTo: separator.bottomAnchor
            ),
            buttonStack.leadingAnchor.constraint(
                equalTo: blurView.contentView.leadingAnchor
            ),
            buttonStack.trailingAnchor.constraint(
                equalTo: blurView.contentView.trailingAnchor
            ),
            buttonStack.bottomAnchor.constraint(
                equalTo: blurView.contentView.bottomAnchor
            ),
        ])

        containerView.addSubview(blurView)

        methodChannel = FlutterMethodChannel(
            name: "liquidify/alert_\(viewId)",
            binaryMessenger: messenger
        )
        methodChannel?.setMethodCallHandler(handleMethodCall)
    }

    func view() -> UIView { return containerView }

    @objc private func actionTapped(_ sender: UIButton) {
        methodChannel?.invokeMethod(
            "onAction",
            arguments: sender.tag
        )
    }

    private func handleMethodCall(
        _ call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) {
        switch call.method {
        case "dismiss":
            containerView.removeFromSuperview()
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
