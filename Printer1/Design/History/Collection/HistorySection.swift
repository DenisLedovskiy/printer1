import UIKit

final class HistorySection: Section<HistoryCellModel> { }

extension HistorySection {

    static func makeSection(_ items: [HistoryCellModel]) -> [HistorySection] {

        return [
            .init(title: "",
                  items: items)
        ]
    }
}
