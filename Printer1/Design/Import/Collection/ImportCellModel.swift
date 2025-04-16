import Foundation
import UIKit

struct ImportCellModel {
    let id = UUID()
    var image: UIImage
    var title: String
    var desc: String
}

extension ImportCellModel: Hashable {
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    static func == (lhs: ImportCellModel, rhs: ImportCellModel) -> Bool {
      lhs.id == rhs.id
    }
}
