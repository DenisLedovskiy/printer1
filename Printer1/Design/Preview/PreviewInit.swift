import UIKit

final class PreviewInit {
    static func createViewController(file: FileModel) -> UIViewController {
        let router = PreviewRouter()
        let presenter = PreviewPresenter(router: router)
        let viewController = PreviewViewController(file: file, presenter: presenter,router: router)

        router.controller = viewController

        return viewController
    }
}
