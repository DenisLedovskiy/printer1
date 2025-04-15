import UIKit

protocol HistoryPresenterInterface {
    func viewDidLoad(withView view: HistoryPresenterOutputInterface)
}

final class HistoryPresenter: NSObject {

    private weak var view: HistoryPresenterOutputInterface?
    private var router: HistoryRouterInterface

    init(router: HistoryRouterInterface) {
        self.router = router
    }
}

// MARK: - HistoryPresenterInterface

extension HistoryPresenter: HistoryPresenterInterface {
    func viewDidLoad(withView view: HistoryPresenterOutputInterface) {
        self.view = view
    }
}
