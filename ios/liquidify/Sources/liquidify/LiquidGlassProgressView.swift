import Flutter
import UIKit

/// Factory for native glass-styled progress views.
class LiquidGlassProgressFactory: NSObject, FlutterPlatformViewFactory {
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
        return LiquidGlassProgressView(
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

/// Native `UIProgressView` with Liquid Glass track styling.
///
/// On iOS 26+, the progress bar track uses `UIGlassEffect` for the
/// authentic glass look. On older versions falls back to system
/// thin material blur behind the track.
class LiquidGlassProgressView: NSObject, FlutterPlatformView {
    private let containerView: UIView
    private let progressView: UIProgressView
    private var methodChannel: FlutterMethodChannel?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        messenger: FlutterBinaryMessenger
    ) {
        let params = args as? [String: Any]
        let progress = params?["progress"] as? Float ?? 0.0
        let cornerRadius = params?["cornerRadius"] as? CGFloat ?? 8.0
        let trackHeight = params?["trackHeight"] as? CGFloat ?? 6.0
        let tintColorHex = params?["tintColor"] as? Int
        let trackTintColorHex = params?["trackTintColor"] as? Int

        containerView = UIView(frame: frame)
        containerView.backgroundColor = .clear

        progressView = UIProgressView(progressViewStyle: .default)

        super.init()

        // Glass background behind the track
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

        // Configure progress view
        progressView.progress = progress
        progressView.translatesAutoresizingMaskIntoConstraints = false

        // Custom track height via transform
        let scale = trackHeight / 4.0
        progressView.transform = CGAffineTransform(
            scaleX: 1.0,
            y: scale
        )

        // Rounded corners on progress bar
        progressView.layer.cornerRadius = trackHeight / 2.0
        progressView.clipsToBounds = true
        progressView.layer.sublayers?.forEach { layer in
            layer.cornerRadius = trackHeight / 2.0
        }

        // Colors
        if let hex = tintColorHex {
            progressView.progressTintColor = UIColor(hex: hex)
        } else {
            progressView.progressTintColor = .systemBlue
        }

        if let hex = trackTintColorHex {
            progressView.trackTintColor = UIColor(hex: hex)
        } else {
            progressView.trackTintColor = UIColor.white
                .withAlphaComponent(0.15)
        }

        blurView.contentView.addSubview(progressView)

        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(
                equalTo: blurView.contentView.leadingAnchor,
                constant: 12
            ),
            progressView.trailingAnchor.constraint(
                equalTo: blurView.contentView.trailingAnchor,
                constant: -12
            ),
            progressView.centerYAnchor.constraint(
                equalTo: blurView.contentView.centerYAnchor
            ),
        ])

        containerView.addSubview(blurView)

        methodChannel = FlutterMethodChannel(
            name: "liquidify/progress_\(viewId)",
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
        case "setProgress":
            if let args = call.arguments as? [String: Any],
               let value = args["progress"] as? Float
            {
                let animated = args["animated"] as? Bool ?? true
                progressView.setProgress(value, animated: animated)
                result(nil)
            } else {
                result(
                    FlutterError(
                        code: "INVALID_ARGS",
                        message: "Expected progress value",
                        details: nil
                    )
                )
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
