import UIKit

protocol ImportPresenterOutputInterface: AnyObject {

}

final class ImportViewController: GeneralViewController {

    private var presenter: ImportPresenterInterface?
    private var router: ImportRouterInterface?

    init(presenter: ImportPresenterInterface, router: ImportRouterInterface) {
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
    }
}

// MARK: - ImportPresenterOutputInterface

extension ImportViewController: ImportPresenterOutputInterface {

}

// MARK: - UISetup

private extension ImportViewController {
    func customInit() {

    }
}
