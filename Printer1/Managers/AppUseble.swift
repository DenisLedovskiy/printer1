import Foundation
import UIKit
import SystemConfiguration

enum PSize {
    case small
    case medium
    case big
}

var phoneSize: PSize = {
    let height = UIScreen.main.bounds.size.height
    if height < 700 {
        return .small
    } else if height > 700 && height < 900 {
        return .medium
    } else {
        return .big
    }
}()

let isSmallPhone = UIScreen.main.bounds.size.height < 700

let screenHeight = UIScreen.main.bounds.size.height
let screeneWidth = UIScreen.main.bounds.size.width

func perevod(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

var currentLocal: String {
    return Locale.current.language.languageCode?.identifier ?? "en"
}

var isEnLocal: Bool {
    return Locale.current.language.languageCode?.identifier == "en"
}
