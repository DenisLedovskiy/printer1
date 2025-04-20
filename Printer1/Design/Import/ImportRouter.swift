import UIKit

protocol ImportRouterInterface: AnyObject {
    func routeAddPrinter()
    func routeBroweser()
    func routeDocPreview(file: FileModel)
}

class ImportRouter: NSObject {
    weak var controller: UIViewController?
}

// MARK: - ImportRouterInterface

extension ImportRouter: ImportRouterInterface {
    func routeDocPreview(file: FileModel) {
        guard let viewController = controller else { return }
        let vc = PreviewInit.createViewController(file: file)
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
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
