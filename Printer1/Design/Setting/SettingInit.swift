import UIKit

final class SettingInit {
    static func createViewController() -> UIViewController {
        let router = SettingRouter()
        let presenter = SettingPresenter(router: router)
        let viewController = SettingViewController(presenter: presenter,
                                                                     router: router)

        router.controller = viewController

        return viewController
    }
}
