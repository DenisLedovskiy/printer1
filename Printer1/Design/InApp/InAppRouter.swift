import UIKit
import SafariServices

protocol InAppRouterInterface: AnyObject {
    func openLink(_ url: URL)
    func dismiss()
}

class InAppRouter: NSObject {
    weak var controller: UIViewController?
}

// MARK: - InAppRouterInterface

extension InAppRouter: InAppRouterInterface {
    func dismiss() {
        if UserInfoManager.isNotFirstEnter ?? false {
            guard let viewController = controller else { return }
            viewController.dismiss(animated: false)
        } else {
            print("23e234")
            let appLaunch = AppLaunch()
            appLaunch.startMainScene()
        }
    }

    func openLink(_ url: URL) {
        guard let viewController = controller else { return }
        let safariVC = SFSafariViewController(url: url)
        viewController.present(safariVC, animated: true, completion: nil)
    }
}
