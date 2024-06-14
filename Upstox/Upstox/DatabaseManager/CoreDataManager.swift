//
//  CoreDataManager.swift
//  Upstox
//
//  Created by Pushkar Dubey on 14/06/24.
//

import Foundation
import CoreData

protocol CoreDataConvertible {
    associatedtype Entity: NSManagedObject
    func toCoreDataEntity(context: NSManagedObjectContext) -> Entity
    init(entity: Entity)
}

class DatabaseManager<T: CoreDataConvertible> where T.Entity: NSManagedObject {
    private let entityName: String
    private let context: NSManagedObjectContext

    init(entityName: String, context: NSManagedObjectContext = CoreDataHelper.shared.context) {
        self.entityName = entityName
        self.context = context
    }

    func save(objects: [T]) {
        context.performAndWait {
            for object in objects {
                _ = object.toCoreDataEntity(context: context)
            }
            do {
                try context.save()
            } catch {
                debugPrint("Failed to save objects: \(error)")
            }
        }
    }

    func fetch() -> [T] {
        let fetchRequest = NSFetchRequest<T.Entity>(entityName: entityName)
        do {
            let results = try context.fetch(fetchRequest)
            return results.map { T(entity: $0) }
        } catch {
            debugPrint("Failed to fetch objects: \(error)")
            return []
        }
    }
    
    func deleteAll() {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try context.execute(batchDeleteRequest)
                try context.save()
            } catch {
                debugPrint("Failed to delete all objects: \(error)")
            }
        }
}
