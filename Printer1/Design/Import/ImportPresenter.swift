import UIKit

protocol ImportPresenterInterface {
    func viewDidLoad(withView view: ImportPresenterOutputInterface)
}

final class ImportPresenter: NSObject {

    private weak var view: ImportPresenterOutputInterface?
    private var router: ImportRouterInterface

    init(router: ImportRouterInterface) {
        self.router = router
    }
}

// MARK: - ImportPresenterInterface

extension ImportPresenter: ImportPresenterInterface {
    func viewDidLoad(withView view: ImportPresenterOutputInterface) {
        self.view = view
    }
}
