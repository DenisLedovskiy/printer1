import Foundation
import CoreData


extension PFile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PFile> {
        return NSFetchRequest<PFile>(entityName: "PFile")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var date: Date?

}

extension PFile : Identifiable {

}
