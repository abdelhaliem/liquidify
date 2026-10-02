import Flutter
import UIKit

/// Factory for native iOS Slider platform views.
class LiquidGlassSliderFactory: NSObject, FlutterPlatformViewFactory {
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
        return LiquidGlassSliderView(
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

/// Native iOS UISlider with Liquid Glass styling on iOS 26+.
class LiquidGlassSliderView: NSObject, FlutterPlatformView {
    private let containerView: UIView
    private let slider: UISlider
    private var methodChannel: FlutterMethodChannel?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        messenger: FlutterBinaryMessenger
    ) {
        let params = args as? [String: Any]
        let value = params?["value"] as? Float ?? 0.0
        let minVal = params?["min"] as? Float ?? 0.0
        let maxVal = params?["max"] as? Float ?? 1.0
        let activeColorHex = params?["activeColor"] as? Int
        let inactiveColorHex = params?["inactiveColor"] as? Int

        containerView = UIView(frame: frame)
        containerView.backgroundColor = .clear

        slider = UISlider(frame: containerView.bounds)
        slider.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        slider.minimumValue = minVal
        slider.maximumValue = maxVal
        slider.value = value

        super.init()

        if let activeHex = activeColorHex {
            slider.minimumTrackTintColor = UIColor(hex: activeHex)
        }
        if let inactiveHex = inactiveColorHex {
            slider.maximumTrackTintColor = UIColor(hex: inactiveHex)
        }

        slider.addTarget(
            self,
            action: #selector(sliderValueChanged),
            for: .valueChanged
        )

        containerView.addSubview(slider)

        methodChannel = FlutterMethodChannel(
            name: "liquidify/slider_\(viewId)",
            binaryMessenger: messenger
        )
        methodChannel?.setMethodCallHandler(handleMethodCall)
    }

    func view() -> UIView { return containerView }

    @objc private func sliderValueChanged() {
        methodChannel?.invokeMethod(
            "onChanged",
            arguments: Double(slider.value)
        )
    }

    private func handleMethodCall(
        _ call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) {
        switch call.method {
        case "setValue":
            if let val = call.arguments as? Double {
                slider.value = Float(val)
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
