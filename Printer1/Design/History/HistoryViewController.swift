import UIKit

protocol HistoryPresenterOutputInterface: AnyObject {

}

final class HistoryViewController: GeneralViewController {

    private var presenter: HistoryPresenterInterface?
    private var router: HistoryRouterInterface?

    init(presenter: HistoryPresenterInterface, router: HistoryRouterInterface) {
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

        view.backgroundColor = .systemPink
    }
}

// MARK: - HistoryPresenterOutputInterface

extension HistoryViewController: HistoryPresenterOutputInterface {

}

// MARK: - UISetup

private extension HistoryViewController {
    func customInit() {

    }
}
