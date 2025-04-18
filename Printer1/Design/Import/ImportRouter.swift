import UIKit

protocol ImportRouterInterface: AnyObject {
    func routeAddPrinter()
    func routeBroweser()
}

class ImportRouter: NSObject {
    weak var controller: UIViewController?
}

// MARK: - ImportRouterInterface

extension ImportRouter: ImportRouterInterface {
    func routeBroweser() {
        guard let viewController = controller else { return }
        let vc = BrowserVC()
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeAddPrinter() {
        guard let viewController = controller else { return }
        let vc = AddPrinterVC()
        viewController.presentPanModal(vc)
    }
}
