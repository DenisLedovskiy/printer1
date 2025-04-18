import UIKit

enum Fonts {
    case dmSans
    case jacarta

    var prefix: String {
        switch self {
        case .dmSans:
            return "DMSans-"
        case .jacarta:
            return "PlusJakartaSans"
        }
    }
}

private func getFont(_ type: UIFont.Weight = .regular,
                        size: CGFloat,
                        fontFamily: Fonts) -> UIFont {
    var typeString = ""

    switch type {
    case .bold:
        typeString = "Bold"
    case .medium:
        typeString = "Medium"
    case .semibold:
        typeString = "SemiBold"
    case .regular:
        typeString = "Regular"
    case .thin:
        typeString = "Thin"
    case .heavy:
        typeString = "ExtraBold"
    case .ultraLight:
        typeString = "ExtraLight"
    case .black:
        typeString = "Black"
    default:
        return UIFont.systemFont(ofSize: size)
    }

    let fontName = fontFamily.prefix + typeString
    let font: UIFont = UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size, weight: type)
    return font
}

extension UIFont {

    static func dmSans(_ type: UIFont.Weight, size: CGFloat) -> UIFont {
        return getFont(type, size: size, fontFamily: .dmSans)
    }

    static func jacarta(_ type: UIFont.Weight, size: CGFloat) -> UIFont {
        return getFont(type, size: size, fontFamily: .jacarta)
    }
}
