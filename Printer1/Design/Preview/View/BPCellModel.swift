import UIKit

struct BPCellModel {
    let id = UUID()
    var title: String
    var icon: UIImage
}

extension BPCellModel: Hashable {
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    static func == (lhs: BPCellModel, rhs: BPCellModel) -> Bool {
      lhs.id == rhs.id
    }
}
