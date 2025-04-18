import UIKit

final class SettingSection: Section<SettingCellModel> { }

extension SettingSection {

    static func makeSection() -> [SettingSection] {
        var items = [SettingCellModel]()
        let titles = [perevod("FAQ"),
                      perevod("Switch icon"),
                      perevod("Share link"),
                      perevod("Terms of Use"),
                      perevod("Privacy Policy")]
        for index in 0...4 {
            items.append(SettingCellModel(title: titles[index],
                                          icon: UIImage(named: "set.\(index)") ?? .set0))
        }
        return [
            .init(title: "",
                  items: items)
        ]
    }
}

