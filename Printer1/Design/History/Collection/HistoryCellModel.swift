import Foundation
import UIKit

struct HistoryCellModel {
    let id = UUID()
    var date: String
    var title: String
    var type: String
}

extension HistoryCellModel: Hashable {
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    static func == (lhs: HistoryCellModel, rhs: HistoryCellModel) -> Bool {
      lhs.id == rhs.id
    }
}
