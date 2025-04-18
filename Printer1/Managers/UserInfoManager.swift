import Foundation

final class UserInfoManager {

    private enum UserInfoKeys: String {
        case isNotFirstEnter
        case isFirstIconSet
    }

    static var isNotFirstEnter: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: UserInfoKeys.isNotFirstEnter.rawValue)
        } set {
            let defaults = UserDefaults.standard
            let key = UserInfoKeys.isNotFirstEnter.rawValue
            if let flag = newValue {
                defaults.set(flag, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }

    static var isFirstIconSet: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: UserInfoKeys.isFirstIconSet.rawValue)
        } set {
            let defaults = UserDefaults.standard
            let key = UserInfoKeys.isFirstIconSet.rawValue
            if let flag = newValue {
                defaults.set(flag, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
}
