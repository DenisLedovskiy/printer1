import Foundation
import CoreData

final class Store {
    private init() {}
    private static let shared: Store = Store()

    lazy var container: NSPersistentContainer = {

        let cdContainer = NSPersistentContainer(name: "PrinterCD")
        cdContainer.loadPersistentStores { desc, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }

        cdContainer.viewContext.automaticallyMergesChangesFromParent = true
        return cdContainer
    }()

    // MARK: - APIs

    static var viewContext: NSManagedObjectContext { return shared.container.viewContext }
    static var newContext: NSManagedObjectContext { return shared.container.newBackgroundContext() }
}
