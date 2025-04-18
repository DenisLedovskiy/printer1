import UIKit

struct SettingCellModel {
    let id = UUID()
    var title: String
    var icon: UIImage
}

extension SettingCellModel: Hashable {
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    static func == (lhs: SettingCellModel, rhs: SettingCellModel) -> Bool {
      lhs.id == rhs.id
    }
}
