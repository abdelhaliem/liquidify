import Flutter
import UIKit

/// Factory for native glass-styled page control views.
class LiquidGlassPageControlFactory: NSObject,
    FlutterPlatformViewFactory
{
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
        return LiquidGlassPageControlView(
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

/// Native `UIPageControl` with Liquid Glass pill background.
///
/// On iOS 26+, the page indicator background uses `UIGlassEffect`
/// for the authentic glass dot-indicator look. Supports custom
/// active/inactive colors and page count updates.
class LiquidGlassPageControlView: NSObject, FlutterPlatformView {
    private let containerView: UIView
    private let pageControl: UIPageControl
    private var methodChannel: FlutterMethodChannel?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        messenger: FlutterBinaryMessenger
    ) {
        let params = args as? [String: Any]
        let numberOfPages = params?["numberOfPages"] as? Int ?? 3
        let currentPage = params?["currentPage"] as? Int ?? 0
        let cornerRadius = params?["cornerRadius"] as? CGFloat ?? 14.0
        let activeColorHex = params?["activeColor"] as? Int
        let inactiveColorHex = params?["inactiveColor"] as? Int
        let backgroundStyle =
            params?["backgroundStyle"] as? String ?? "prominent"

        containerView = UIView(frame: frame)
        containerView.backgroundColor = .clear

        pageControl = UIPageControl()

        super.init()

        // Glass background pill
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

        // Configure page control
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = currentPage
        pageControl.translatesAutoresizingMaskIntoConstraints = false

        // Background style
        switch backgroundStyle {
        case "minimal":
            pageControl.backgroundStyle = .minimal
        case "automatic":
            pageControl.backgroundStyle = .automatic
        default:
            pageControl.backgroundStyle = .prominent
        }

        // Colors
        if let hex = activeColorHex {
            pageControl.currentPageIndicatorTintColor = UIColor(hex: hex)
        }
        if let hex = inactiveColorHex {
            pageControl.pageIndicatorTintColor = UIColor(hex: hex)
        } else {
            pageControl.pageIndicatorTintColor = UIColor.white
                .withAlphaComponent(0.35)
        }

        pageControl.addTarget(
            self,
            action: #selector(pageChanged),
            for: .valueChanged
        )

        blurView.contentView.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(
                equalTo: blurView.contentView.centerXAnchor
            ),
            pageControl.centerYAnchor.constraint(
                equalTo: blurView.contentView.centerYAnchor
            ),
        ])

        containerView.addSubview(blurView)

        methodChannel = FlutterMethodChannel(
            name: "liquidify/page_control_\(viewId)",
            binaryMessenger: messenger
        )
        methodChannel?.setMethodCallHandler(handleMethodCall)
    }

    func view() -> UIView { return containerView }

    @objc private func pageChanged() {
        methodChannel?.invokeMethod(
            "onPageChanged",
            arguments: pageControl.currentPage
        )
    }

    private func handleMethodCall(
        _ call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) {
        switch call.method {
        case "setCurrentPage":
            if let page = call.arguments as? Int {
                pageControl.currentPage = page
                result(nil)
            } else {
                result(
                    FlutterError(
                        code: "INVALID_ARGS",
                        message: "Expected page index",
                        details: nil
                    )
                )
            }
        case "setNumberOfPages":
            if let count = call.arguments as? Int {
                pageControl.numberOfPages = count
                result(nil)
            } else {
                result(
                    FlutterError(
                        code: "INVALID_ARGS",
                        message: "Expected page count",
                        details: nil
                    )
                )
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
