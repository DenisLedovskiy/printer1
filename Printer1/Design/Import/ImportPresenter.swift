import UIKit

protocol ImportPresenterInterface {
    func viewDidLoad(withView view: ImportPresenterOutputInterface)
    func selectAddPrinter()
    func selectBroweser()
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
    func selectBroweser() {
        router.routeBroweser()
    }
    
    func selectAddPrinter() {
        router.routeAddPrinter()
    }
    
    func viewDidLoad(withView view: ImportPresenterOutputInterface) {
        self.view = view
    }
}
