import Flutter
import UIKit

/// Factory for native iOS Switch platform views.
class LiquidGlassSwitchFactory: NSObject, FlutterPlatformViewFactory {
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
        return LiquidGlassSwitchView(
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

/// Native iOS UISwitch with Liquid Glass styling on iOS 26+.
class LiquidGlassSwitchView: NSObject, FlutterPlatformView {
    private let containerView: UIView
    private let uiSwitch: UISwitch
    private var methodChannel: FlutterMethodChannel?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        messenger: FlutterBinaryMessenger
    ) {
        let params = args as? [String: Any]
        let isOn = params?["value"] as? Bool ?? false
        let activeColorHex = params?["activeColor"] as? Int

        containerView = UIView(frame: frame)
        containerView.backgroundColor = .clear

        uiSwitch = UISwitch()
        uiSwitch.isOn = isOn

        super.init()

        if let activeHex = activeColorHex {
            uiSwitch.onTintColor = UIColor(hex: activeHex)
        }

        uiSwitch.addTarget(
            self,
            action: #selector(switchToggled),
            for: .valueChanged
        )

        // Center switch in container
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(uiSwitch)
        NSLayoutConstraint.activate([
            uiSwitch.centerXAnchor.constraint(
                equalTo: containerView.centerXAnchor
            ),
            uiSwitch.centerYAnchor.constraint(
                equalTo: containerView.centerYAnchor
            ),
        ])

        methodChannel = FlutterMethodChannel(
            name: "liquidify/switch_\(viewId)",
            binaryMessenger: messenger
        )
        methodChannel?.setMethodCallHandler(handleMethodCall)
    }

    func view() -> UIView { return containerView }

    @objc private func switchToggled() {
        methodChannel?.invokeMethod(
            "onChanged",
            arguments: uiSwitch.isOn
        )
    }

    private func handleMethodCall(
        _ call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) {
        switch call.method {
        case "setValue":
            if let val = call.arguments as? Bool {
                uiSwitch.setOn(val, animated: true)
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
