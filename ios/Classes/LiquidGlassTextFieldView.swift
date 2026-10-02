import Flutter
import UIKit

/// Factory for native iOS TextField platform views.
class LiquidGlassTextFieldFactory: NSObject, FlutterPlatformViewFactory {
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
        return LiquidGlassTextFieldView(
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

/// Native iOS UITextField wrapped in UIVisualEffectView for glass look.
class LiquidGlassTextFieldView: NSObject, FlutterPlatformView {
    private let containerView: UIView
    private let textField: UITextField
    private var methodChannel: FlutterMethodChannel?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        messenger: FlutterBinaryMessenger
    ) {
        let params = args as? [String: Any]
        let placeholder = params?["placeholder"] as? String ?? ""
        let text = params?["text"] as? String ?? ""
        let cornerRadius = params?["cornerRadius"] as? CGFloat ?? 12.0
        let labelText = params?["label"] as? String

        containerView = UIView(frame: frame)
        containerView.backgroundColor = .clear

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
            .withAlphaComponent(0.2).cgColor

        textField = UITextField()
        textField.placeholder = placeholder
        textField.text = text
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false

        super.init()

        textField.delegate = self

        containerView.addSubview(blurView)
        blurView.contentView.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(
                equalTo: blurView.contentView.leadingAnchor,
                constant: 16
            ),
            textField.trailingAnchor.constraint(
                equalTo: blurView.contentView.trailingAnchor,
                constant: -16
            ),
            textField.centerYAnchor.constraint(
                equalTo: blurView.contentView.centerYAnchor
            ),
        ])

        // Add floating label if provided
        if let label = labelText, !label.isEmpty {
            let floatLabel = UILabel()
            floatLabel.text = label
            floatLabel.font = .systemFont(ofSize: 11, weight: .medium)
            floatLabel.textColor = .secondaryLabel
            floatLabel.translatesAutoresizingMaskIntoConstraints = false
            blurView.contentView.addSubview(floatLabel)
            NSLayoutConstraint.activate([
                floatLabel.leadingAnchor.constraint(
                    equalTo: blurView.contentView.leadingAnchor,
                    constant: 16
                ),
                floatLabel.topAnchor.constraint(
                    equalTo: blurView.contentView.topAnchor,
                    constant: 8
                ),
            ])
            // Move text field down a bit
            textField.centerYAnchor.constraint(
                equalTo: blurView.contentView.centerYAnchor,
                constant: 6
            ).isActive = true
        }

        methodChannel = FlutterMethodChannel(
            name: "liquidify/text_field_\(viewId)",
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
        case "setText":
            if let text = call.arguments as? String {
                textField.text = text
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        case "getText":
            result(textField.text ?? "")
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

extension LiquidGlassTextFieldView: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(
            in: range,
            with: string
        ) ?? string
        methodChannel?.invokeMethod("onChanged", arguments: newText)
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        methodChannel?.invokeMethod("onSubmitted", arguments: textField.text)
        textField.resignFirstResponder()
        return true
    }
}
