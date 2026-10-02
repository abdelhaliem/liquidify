import Flutter
import UIKit

/// Factory for native Liquid Glass navigation bar views.
class LiquidGlassNavBarFactory: NSObject, FlutterPlatformViewFactory {
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
        return LiquidGlassNavBarView(
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

/// Native Liquid Glass navigation bar using real UINavigationBar.
///
/// On iOS 26+, UINavigationBar natively adopts the Liquid Glass material.
/// On older versions, it uses the system blur appearance.
class LiquidGlassNavBarView: NSObject, FlutterPlatformView {
    private let containerView: UIView
    private let navBar: UINavigationBar

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        messenger: FlutterBinaryMessenger
    ) {
        let params = args as? [String: Any]
        let title = params?["title"] as? String ?? ""
        let tintColorHex = params?["tintColor"] as? Int

        containerView = UIView(frame: frame)
        containerView.backgroundColor = .clear

        navBar = UINavigationBar(frame: containerView.bounds)
        navBar.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        super.init()

        let navItem = UINavigationItem(title: title)
        navBar.setItems([navItem], animated: false)

        if let tintHex = tintColorHex {
            navBar.tintColor = UIColor(hex: tintHex)
        }

        // On iOS 26+, UINavigationBar natively uses Liquid Glass
        if #available(iOS 26, *) {
            // System handles liquid glass automatically
        } else {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundEffect = UIBlurEffect(
                style: .systemChromeMaterial
            )
            navBar.standardAppearance = appearance
            navBar.scrollEdgeAppearance = appearance
            navBar.compactAppearance = appearance
        }

        containerView.addSubview(navBar)
    }

    func view() -> UIView {
        return containerView
    }
}
