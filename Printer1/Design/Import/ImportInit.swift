import UIKit

final class ImportInit {
    static func createViewController() -> UIViewController {
        let router = ImportRouter()
        let presenter = ImportPresenter(router: router)
        let viewController = ImportViewController(presenter: presenter,
                                                                     router: router)

        router.controller = viewController

        return viewController
    }
}
