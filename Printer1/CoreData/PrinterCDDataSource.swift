import CoreData
import UIKit
import PDFKit

final class PrinterCDDataSource {

    let controller: NSFetchedResultsController<NSFetchRequestResult>
    let request: NSFetchRequest<NSFetchRequestResult> = PFile.fetchRequest()

    let defaultSort: NSSortDescriptor = NSSortDescriptor(key: #keyPath(PFile.date), ascending: false)

    init(context: NSManagedObjectContext, sortDescriptors: [NSSortDescriptor] = []) {
        var sort: [NSSortDescriptor] = sortDescriptors
        if sort.isEmpty { sort = [defaultSort] }

        request.sortDescriptors = sort
        controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }

    // MARK: - DataSource APIs

    func fetch(completion: ((ResultCoreData) -> ())?) {
        self.request.predicate = nil
        do {
            try controller.performFetch()
            completion?(.success)
        } catch let error {
            completion?(.fail(error))
        }
    }

    var count: Int { return controller.fetchedObjects?.count ?? 0 }

    func getFilesList() -> [PFile] {
        guard let data: [PFile] = controller.fetchedObjects as? [PFile] else {return []}
        return data
    }

    func getAllFileModel() -> [FileModel] {
        guard let data: [PFile] = controller.fetchedObjects as? [PFile] else {return []}
        return data.map({
            FileModel(id: $0.id ?? UUID(),
                      title: $0.name ?? "no name",
                      type: $0.type ?? "",
                      date: $0.date ?? Date())
        })
    }
}
