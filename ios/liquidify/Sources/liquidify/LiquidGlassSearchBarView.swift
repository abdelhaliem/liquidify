import Flutter
import UIKit

/// Factory for native iOS SearchBar platform views.
class LiquidGlassSearchBarFactory: NSObject, FlutterPlatformViewFactory {
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
        return LiquidGlassSearchBarView(
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

/// Native iOS UISearchBar — on iOS 26+ automatically adopts glass.
class LiquidGlassSearchBarView: NSObject, FlutterPlatformView {
    private let containerView: UIView
    private let searchBar: UISearchBar
    private var methodChannel: FlutterMethodChannel?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        messenger: FlutterBinaryMessenger
    ) {
        let params = args as? [String: Any]
        let placeholder = params?["placeholder"] as? String ?? "Search..."
        let text = params?["text"] as? String ?? ""

        containerView = UIView(frame: frame)
        containerView.backgroundColor = .clear

        searchBar = UISearchBar(frame: containerView.bounds)
        searchBar.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        searchBar.placeholder = placeholder
        searchBar.text = text
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundImage = UIImage()

        super.init()

        searchBar.delegate = self
        containerView.addSubview(searchBar)

        methodChannel = FlutterMethodChannel(
            name: "liquidify/search_bar_\(viewId)",
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
                searchBar.text = text
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

extension LiquidGlassSearchBarView: UISearchBarDelegate {
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        methodChannel?.invokeMethod("onChanged", arguments: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        methodChannel?.invokeMethod(
            "onSubmitted",
            arguments: searchBar.text
        )
        searchBar.resignFirstResponder()
    }
}
