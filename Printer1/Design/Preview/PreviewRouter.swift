import UIKit

protocol PreviewRouterInterface: AnyObject {

}

class PreviewRouter: NSObject {
    weak var controller: UIViewController?
}

// MARK: - PreviewRouterInterface

extension PreviewRouter: PreviewRouterInterface {

}
