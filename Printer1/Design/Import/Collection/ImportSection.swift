import UIKit

final class ImportSection: Section<ImportCellModel> { }

extension ImportSection {

    static func makeSection() -> [ImportSection] {

        return [
            .init(title: "",
                  items: [ImportCellModel(image: .top0, title: perevod("Scan"), desc: perevod("From your Camera ")),
                          ImportCellModel(image: .top1, title: perevod("Photos"), desc: perevod("Print from Gallery")),
                          ImportCellModel(image: .top2, title: perevod("Files"), desc: perevod("Print from Files")),
                          ImportCellModel(image: .top3, title: perevod("Web pages"), desc: perevod("From Web pages")),])
        ]
    }
}
