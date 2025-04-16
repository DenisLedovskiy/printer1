import Foundation
import UIKit

struct AddPrinterCellModel {
    let id = UUID()
    var title: String
}

extension AddPrinterCellModel: Hashable {
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    static func == (lhs: AddPrinterCellModel, rhs: AddPrinterCellModel) -> Bool {
      lhs.id == rhs.id
    }
}
