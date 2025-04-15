import UIKit

protocol SettingRouterInterface: AnyObject {

}

class SettingRouter: NSObject {
    weak var controller: UIViewController?
}

// MARK: - SettingRouterInterface

extension SettingRouter: SettingRouterInterface {

}
