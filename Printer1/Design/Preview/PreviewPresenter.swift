import UIKit

protocol PreviewPresenterInterface {
    func viewDidLoad(withView view: PreviewPresenterOutputInterface)
}

final class PreviewPresenter: NSObject {

    private weak var view: PreviewPresenterOutputInterface?
    private var router: PreviewRouterInterface

    init(router: PreviewRouterInterface) {
        self.router = router
    }
}

// MARK: - PreviewPresenterInterface

extension PreviewPresenter: PreviewPresenterInterface {
    func viewDidLoad(withView view: PreviewPresenterOutputInterface) {
        self.view = view
    }
}
