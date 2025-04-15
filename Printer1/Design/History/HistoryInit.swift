import UIKit

final class HistoryInit {
    static func createViewController() -> UIViewController {
        let router = HistoryRouter()
        let presenter = HistoryPresenter(router: router)
        let viewController = HistoryViewController(presenter: presenter,
                                                                     router: router)

        router.controller = viewController

        return viewController
    }
}
