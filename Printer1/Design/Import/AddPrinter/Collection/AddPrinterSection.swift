import UIKit

final class AddPrinterSection: Section<AddPrinterCellModel> { }

extension AddPrinterSection {

    static func makeSection(_ data: [AddPrinterCellModel]) -> [AddPrinterSection] {
        return [
            .init(title: "",
                  items: data)
        ]
    }
}
