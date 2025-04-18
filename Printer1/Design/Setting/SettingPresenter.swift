import UIKit

protocol SettingPresenterInterface {
    func viewDidLoad(withView view: SettingPresenterOutputInterface)
    func selectTry()
    func selectMenu(_ index: Int)
}

final class SettingPresenter: NSObject {

    private weak var view: SettingPresenterOutputInterface?
    private var router: SettingRouterInterface

    init(router: SettingRouterInterface) {
        self.router = router
    }
}

private extension SettingPresenter {
    func selectPP() {
        guard let url = URL(string: Config.privacy.rawValue) else {
            return
        }
        router.openLink(url)
    }

    func selectTerm() {
        guard let url = URL(string: Config.term.rawValue) else {
          return
        }
        router.openLink(url)
    }

    func selectShare() {
        guard let url = URL(string: "https://apps.apple.com/us/app/id\(Config.appID.rawValue)") else {return}
        router.openShare(url)
    }
}

// MARK: - SettingPresenterInterface

extension SettingPresenter: SettingPresenterInterface {
    func selectMenu(_ index: Int) {
        switch index {
        case 0: return
        case 1: router.routeChangeIcon()
        case 2: selectShare()
        case 3: selectTerm()
        case 4: selectPP()
        default:
            break
        }
    }
    
    func selectTry() {
        router.routeInApp()
    }
    
    func viewDidLoad(withView view: SettingPresenterOutputInterface) {
        self.view = view
    }
}
