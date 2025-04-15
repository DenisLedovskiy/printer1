import UIKit

protocol InAppPresenterInterface {
    func viewDidLoad(withView view: InAppPresenterOutputInterface)
    func selectPP()
    func selectTerm()
    func selectClose()
}

final class InAppPresenter: NSObject {

    private weak var view: InAppPresenterOutputInterface?
    private var router: InAppRouterInterface

    init(router: InAppRouterInterface) {
        self.router = router
    }
}

// MARK: - InAppPresenterInterface

extension InAppPresenter: InAppPresenterInterface {
    func viewDidLoad(withView view: InAppPresenterOutputInterface) {
        self.view = view
    }

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

    func selectClose() {
        DispatchQueue.main.async {
            self.router.dismiss()
        }
    }
}
