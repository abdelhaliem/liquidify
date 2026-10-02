import Flutter
import UIKit

/// Factory for native glass-styled date picker views.
class LiquidGlassDatePickerFactory: NSObject, FlutterPlatformViewFactory {
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
        return LiquidGlassDatePickerView(
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

/// Native `UIDatePicker` with Liquid Glass background.
///
/// Supports `.date`, `.time`, and `.dateAndTime` modes. On iOS 26+,
/// the picker inherits Liquid Glass material. On older versions it uses
/// system blur.
class LiquidGlassDatePickerView: NSObject, FlutterPlatformView {
    private let containerView: UIView
    private let datePicker: UIDatePicker
    private var methodChannel: FlutterMethodChannel?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        messenger: FlutterBinaryMessenger
    ) {
        let params = args as? [String: Any]
        let mode = params?["mode"] as? String ?? "dateAndTime"
        let cornerRadius = params?["cornerRadius"] as? CGFloat ?? 16.0
        let initialTimestamp = params?["initialDate"] as? Double
        let minTimestamp = params?["minimumDate"] as? Double
        let maxTimestamp = params?["maximumDate"] as? Double

        containerView = UIView(frame: frame)
        containerView.backgroundColor = .clear

        datePicker = UIDatePicker()

        super.init()

        // Mode
        switch mode {
        case "date":
            datePicker.datePickerMode = .date
        case "time":
            datePicker.datePickerMode = .time
        case "countDownTimer":
            datePicker.datePickerMode = .countDownTimer
        default:
            datePicker.datePickerMode = .dateAndTime
        }

        // Prefer inline style for modern look
        datePicker.preferredDatePickerStyle = .inline

        // Initial/min/max dates
        if let ts = initialTimestamp {
            datePicker.date = Date(timeIntervalSince1970: ts / 1000.0)
        }
        if let minTs = minTimestamp {
            datePicker.minimumDate = Date(
                timeIntervalSince1970: minTs / 1000.0
            )
        }
        if let maxTs = maxTimestamp {
            datePicker.maximumDate = Date(
                timeIntervalSince1970: maxTs / 1000.0
            )
        }

        datePicker.addTarget(
            self,
            action: #selector(dateChanged),
            for: .valueChanged
        )

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
            .withAlphaComponent(0.2).cgColor

        datePicker.translatesAutoresizingMaskIntoConstraints = false
        blurView.contentView.addSubview(datePicker)

        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(
                equalTo: blurView.contentView.topAnchor,
                constant: 8
            ),
            datePicker.leadingAnchor.constraint(
                equalTo: blurView.contentView.leadingAnchor,
                constant: 8
            ),
            datePicker.trailingAnchor.constraint(
                equalTo: blurView.contentView.trailingAnchor,
                constant: -8
            ),
            datePicker.bottomAnchor.constraint(
                equalTo: blurView.contentView.bottomAnchor,
                constant: -8
            ),
        ])

        containerView.addSubview(blurView)

        methodChannel = FlutterMethodChannel(
            name: "liquidify/date_picker_\(viewId)",
            binaryMessenger: messenger
        )
        methodChannel?.setMethodCallHandler(handleMethodCall)
    }

    func view() -> UIView { return containerView }

    @objc private func dateChanged() {
        let timestamp = datePicker.date.timeIntervalSince1970 * 1000.0
        methodChannel?.invokeMethod(
            "onChanged",
            arguments: timestamp
        )
    }

    private func handleMethodCall(
        _ call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) {
        switch call.method {
        case "setDate":
            if let ts = call.arguments as? Double {
                datePicker.setDate(
                    Date(timeIntervalSince1970: ts / 1000.0),
                    animated: true
                )
                result(nil)
            } else {
                result(
                    FlutterError(
                        code: "INVALID_ARGS",
                        message: "Expected timestamp",
                        details: nil
                    )
                )
            }
        case "getDate":
            let timestamp =
                datePicker.date.timeIntervalSince1970 * 1000.0
            result(timestamp)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
