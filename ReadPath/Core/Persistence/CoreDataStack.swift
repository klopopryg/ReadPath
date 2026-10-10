//
//  CoreDataStack.swift
//  ReadPath
//
//  Created by Егор on 04.10.2026.
//

import CoreData

final class CoreDataStack {
    private let container: NSPersistentContainer
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    init() {
        container = NSPersistentContainer(name: "ReadPath")
        container.loadPersistentStores { _, error in
            if let error {
                print("CoreData error \(error)")
            }
        }
    }
}
