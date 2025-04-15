import UIKit

protocol SettingPresenterInterface {
    func viewDidLoad(withView view: SettingPresenterOutputInterface)
}

final class SettingPresenter: NSObject {

    private weak var view: SettingPresenterOutputInterface?
    private var router: SettingRouterInterface

    init(router: SettingRouterInterface) {
        self.router = router
    }
}

// MARK: - SettingPresenterInterface

extension SettingPresenter: SettingPresenterInterface {
    func viewDidLoad(withView view: SettingPresenterOutputInterface) {
        self.view = view
    }
}
