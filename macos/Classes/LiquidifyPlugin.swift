import FlutterMacOS
import Cocoa

/// macOS plugin entry point for Liquidify.
///
/// Currently a placeholder — macOS native glass effects will be added
/// when macOS 26 Liquid Glass APIs become available.
public class LiquidifyPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "liquidify/platform",
            binaryMessenger: registrar.messenger
        )
        let instance = LiquidifyPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(
        _ call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) {
        switch call.method {
        case "supportsNativeLiquidGlass":
            // macOS Liquid Glass support will be added in future
            result(false)
        case "getPlatformVersion":
            result("macOS \(ProcessInfo.processInfo.operatingSystemVersionString)")
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
