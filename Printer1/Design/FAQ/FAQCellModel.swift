import Foundation

struct FAQCellModel {
    let id = UUID()
    var title: String
    var texts: [String]
    var link: String?
}

extension FAQCellModel: Hashable {
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    static func == (lhs: FAQCellModel, rhs: FAQCellModel) -> Bool {
      lhs.id == rhs.id
    }
}
