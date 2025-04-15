import UIKit

protocol SettingPresenterOutputInterface: AnyObject {

}

final class SettingViewController: GeneralViewController {

    private var presenter: SettingPresenterInterface?
    private var router: SettingRouterInterface?

    init(presenter: SettingPresenterInterface, router: SettingRouterInterface) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
        presenter?.viewDidLoad(withView: self)

        view.backgroundColor = .gray
    }
}

// MARK: - SettingPresenterOutputInterface

extension SettingViewController: SettingPresenterOutputInterface {

}

// MARK: - UISetup

private extension SettingViewController {
    func customInit() {

    }
}
