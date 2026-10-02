import Flutter
import UIKit

/// Factory for native iOS SegmentedControl platform views.
class LiquidGlassSegmentedFactory: NSObject, FlutterPlatformViewFactory {
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
        return LiquidGlassSegmentedView(
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

/// Native iOS UISegmentedControl — on iOS 26+ glass style is applied.
class LiquidGlassSegmentedView: NSObject, FlutterPlatformView {
    private let containerView: UIView
    private let segmentedControl: UISegmentedControl
    private var methodChannel: FlutterMethodChannel?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        messenger: FlutterBinaryMessenger
    ) {
        let params = args as? [String: Any]
        let segments = params?["segments"] as? [String] ?? []
        let selectedIndex = params?["selectedIndex"] as? Int ?? 0

        containerView = UIView(frame: frame)
        containerView.backgroundColor = .clear

        segmentedControl = UISegmentedControl(items: segments)
        segmentedControl.selectedSegmentIndex = selectedIndex
        segmentedControl.autoresizingMask = [
            .flexibleWidth, .flexibleHeight,
        ]
        segmentedControl.frame = containerView.bounds

        super.init()

        segmentedControl.addTarget(
            self,
            action: #selector(segmentChanged),
            for: .valueChanged
        )

        containerView.addSubview(segmentedControl)

        methodChannel = FlutterMethodChannel(
            name: "liquidify/segmented_\(viewId)",
            binaryMessenger: messenger
        )
        methodChannel?.setMethodCallHandler(handleMethodCall)
    }

    func view() -> UIView { return containerView }

    @objc private func segmentChanged() {
        methodChannel?.invokeMethod(
            "onChanged",
            arguments: segmentedControl.selectedSegmentIndex
        )
    }

    private func handleMethodCall(
        _ call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) {
        switch call.method {
        case "setSelectedIndex":
            if let idx = call.arguments as? Int {
                segmentedControl.selectedSegmentIndex = idx
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
