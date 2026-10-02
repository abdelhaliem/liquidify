import Flutter
import UIKit

/// Factory for native glass-styled picker wheel views.
class LiquidGlassPickerFactory: NSObject, FlutterPlatformViewFactory {
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
        return LiquidGlassPickerView(
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

/// Native `UIPickerView` (wheel selector) with Liquid Glass background.
///
/// On iOS 26+, the picker wheel container uses `UIGlassEffect`.
/// Supports single-column or multi-column data with selectable items.
class LiquidGlassPickerView: NSObject, FlutterPlatformView,
    UIPickerViewDataSource, UIPickerViewDelegate
{
    private let containerView: UIView
    private let pickerView: UIPickerView
    private var columns: [[String]] = []
    private var selectedRows: [Int] = []
    private var methodChannel: FlutterMethodChannel?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        messenger: FlutterBinaryMessenger
    ) {
        let params = args as? [String: Any]
        let cornerRadius = params?["cornerRadius"] as? CGFloat ?? 16.0
        columns = params?["columns"] as? [[String]] ?? [["Item 1"]]
        let initialSelections =
            params?["initialSelections"] as? [Int] ?? []

        containerView = UIView(frame: frame)
        containerView.backgroundColor = .clear

        pickerView = UIPickerView()

        // Initialize selected rows
        selectedRows = Array(repeating: 0, count: columns.count)
        for (i, row) in initialSelections.enumerated()
            where i < columns.count
        {
            selectedRows[i] = row
        }

        super.init()

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

        // Configure picker
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false

        blurView.contentView.addSubview(pickerView)

        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(
                equalTo: blurView.contentView.topAnchor
            ),
            pickerView.leadingAnchor.constraint(
                equalTo: blurView.contentView.leadingAnchor
            ),
            pickerView.trailingAnchor.constraint(
                equalTo: blurView.contentView.trailingAnchor
            ),
            pickerView.bottomAnchor.constraint(
                equalTo: blurView.contentView.bottomAnchor
            ),
        ])

        // Set initial selections
        for (component, row) in selectedRows.enumerated() {
            if row < columns[component].count {
                pickerView.selectRow(
                    row,
                    inComponent: component,
                    animated: false
                )
            }
        }

        containerView.addSubview(blurView)

        methodChannel = FlutterMethodChannel(
            name: "liquidify/picker_\(viewId)",
            binaryMessenger: messenger
        )
        methodChannel?.setMethodCallHandler(handleMethodCall)
    }

    func view() -> UIView { return containerView }

    // MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return columns.count
    }

    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        return columns[component].count
    }

    // MARK: - UIPickerViewDelegate

    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        return columns[component][row]
    }

    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        selectedRows[component] = row

        methodChannel?.invokeMethod(
            "onChanged",
            arguments: [
                "component": component,
                "row": row,
                "value": columns[component][row],
            ]
        )
    }

    // MARK: - Method Channel

    private func handleMethodCall(
        _ call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) {
        switch call.method {
        case "selectRow":
            if let args = call.arguments as? [String: Any],
               let component = args["component"] as? Int,
               let row = args["row"] as? Int
            {
                let animated = args["animated"] as? Bool ?? true
                pickerView.selectRow(
                    row,
                    inComponent: component,
                    animated: animated
                )
                selectedRows[component] = row
                result(nil)
            } else {
                result(
                    FlutterError(
                        code: "INVALID_ARGS",
                        message: "Expected component and row",
                        details: nil
                    )
                )
            }
        case "updateColumns":
            if let newColumns = call.arguments as? [[String]] {
                columns = newColumns
                selectedRows = Array(
                    repeating: 0,
                    count: columns.count
                )
                pickerView.reloadAllComponents()
                result(nil)
            } else {
                result(
                    FlutterError(
                        code: "INVALID_ARGS",
                        message: "Expected array of string arrays",
                        details: nil
                    )
                )
            }
        case "getSelectedRows":
            result(selectedRows)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
