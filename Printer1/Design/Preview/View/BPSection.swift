import UIKit

final class BPSection: Section<BPCellModel> { }

extension BPSection {

    static func setPDF() -> [BPSection] {
        var items = [BPCellModel(title: perevod("edit"), icon: .pEdit),
                     BPCellModel(title: perevod("print"), icon: .pPrint),
                     BPCellModel(title: perevod("add page"), icon: .pAdd)]
        return [
            .init(title: "",
                  items: items)
        ]
    }

    static func setDoc() -> [BPSection] {
        var items = [BPCellModel(title: perevod("edit"), icon: .pEdit),
                     BPCellModel(title: perevod("print"), icon: .pPrint)]
        return [
            .init(title: "",
                  items: items)
        ]
    }
}

