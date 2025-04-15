import UIKit

protocol HistoryRouterInterface: AnyObject {

}

class HistoryRouter: NSObject {
    weak var controller: UIViewController?
}

// MARK: - HistoryRouterInterface

extension HistoryRouter: HistoryRouterInterface {

}
