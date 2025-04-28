import Foundation
import CoreData

enum ResultCoreData {
    case success, fail(Error)
}

// MARK: - Save, Delete
extension NSManagedObjectContext {
    func saveInCD(completion: ((ResultCoreData) -> ())?) {
        do {
            try self.save()
            completion?(.success)
        } catch let error {
            self.rollback()
            completion?(.fail(error))
        }
    }

    func deleteFromCD(object: NSManagedObject?, completion: ((ResultCoreData) -> ())?) {
        guard let item = object else {return}
        perform {
            self.delete(item)
            self.saveInCD(completion: completion)
        }
    }
}

// MARK: - Methods

extension NSManagedObjectContext {

    // MARK: - Load data

    var printeDS: PrinterCDDataSource { return PrinterCDDataSource(context: self) }

    // MARK: - Data manupulation

    func addFile(item: FileModel, completion: ((ResultCoreData) -> ())?) {
        perform {
            let entity: PFile = PFile(context: self)
            entity.id = item.id
            entity.name = item.title
            entity.date = item.date
            entity.type = item.type
            self.saveInCD(completion: completion)
        }
    }
}
