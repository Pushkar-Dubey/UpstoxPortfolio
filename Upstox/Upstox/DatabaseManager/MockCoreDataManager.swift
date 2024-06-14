//
//  MockCoreDataManager.swift
//  Upstox
//
//  Created by Pushkar Dubey on 14/06/24.
//

import Foundation
import CoreData

class MockDatabaseManager<T: CoreDataConvertible>: DatabaseManager<T> where T.Entity: NSManagedObject {
    var mockObjects: [T] = []

    override func save(objects: [T]) {
        mockObjects.append(contentsOf: objects)
    }

    override func fetch() -> [T] {
        return mockObjects
    }
    
    override func deleteAll() {
        mockObjects.removeAll()
    }
}
