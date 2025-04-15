import UIKit

final class InAppInit {
    static func createViewController() -> UIViewController {
        let router = InAppRouter()
        let presenter = InAppPresenter(router: router)
        let viewController = InAppViewController(presenter: presenter,router: router)
        router.controller = viewController
        return viewController
    }
}
