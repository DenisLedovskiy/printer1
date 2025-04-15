import UIKit

protocol ImportRouterInterface: AnyObject {

}

class ImportRouter: NSObject {
    weak var controller: UIViewController?
}

// MARK: - ImportRouterInterface

extension ImportRouter: ImportRouterInterface {

}
