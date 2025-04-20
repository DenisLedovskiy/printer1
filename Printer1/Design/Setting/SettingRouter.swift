import UIKit
import SafariServices
import PanModal

protocol SettingRouterInterface: AnyObject {
    func routeInApp()
    func openLink(_ url: URL)
    func openShare(_ url: URL)
    func routeChangeIcon()
    func routeFAQ()
}

class SettingRouter: NSObject {
    weak var controller: UIViewController?
}

// MARK: - SettingRouterInterface

extension SettingRouter: SettingRouterInterface {
    func routeFAQ() {
        guard let viewController = controller else { return }
        let vc = FAQVC()
        vc.modalPresentationStyle = .overFullScreen
        viewController.present(vc, animated: true)
    }
    
    func routeInApp() {
        guard let viewController = controller else { return }
        let vc = InAppInit.createViewController()
        vc.modalPresentationStyle = .overFullScreen
        viewController.present(vc, animated: true)
    }

    func routeChangeIcon() {
        guard let viewController = controller else { return }
        let vc = ChangeIcon()
        viewController.presentPanModal(vc)
    }

    func openShare(_ url: URL) {
        guard let viewController = controller else { return }
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        viewController.present(vc, animated: true)
    }

    func openLink(_ url: URL) {
        guard let viewController = controller else { return }
        let safariVC = SFSafariViewController(url: url)
        viewController.present(safariVC, animated: true, completion: nil)
    }
}
