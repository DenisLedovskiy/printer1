import UIKit

protocol HistoryRouterInterface: AnyObject {
    func routeDocPreview(file: FileModel)
    func routeShare(_ data: URL)
    func routeBroweser(_ url: String)
}

class HistoryRouter: NSObject {
    weak var controller: UIViewController?
}

// MARK: - HistoryRouterInterface

extension HistoryRouter: HistoryRouterInterface {
    func routeBroweser(_ url: String) {
        guard let viewController = controller else { return }
        let vc = BrowserVC(url: url)
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeShare(_ data: URL) {
        guard let viewController = controller else { return }
        let activityViewController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        viewController.present(activityViewController, animated: true, completion: nil)
    }
    
    func routeDocPreview(file: FileModel) {
        guard let viewController = controller else { return }
        let vc = PreviewInit.createViewController(file: file)
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
}
