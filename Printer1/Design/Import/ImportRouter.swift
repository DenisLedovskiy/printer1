import UIKit

protocol ImportRouterInterface: AnyObject {
    func routeAddPrinter()
}

class ImportRouter: NSObject {
    weak var controller: UIViewController?
}

// MARK: - ImportRouterInterface

extension ImportRouter: ImportRouterInterface {
    func routeAddPrinter() {
        guard let viewController = controller else { return }
        let vc = AddPrinterVC()
        viewController.presentPanModal(vc)
    }
}
