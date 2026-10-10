//
//  LibraryStorage.swift
//  ReadPath
//
//  Created by Егор on 04.10.2026.
//

import CoreData

final class CoreDataLibraryStorage: CoreDataLibraryStorageProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func saveBook(_ book: SavedBook) throws {
        guard try !containsBook(key: book.key) else { return }
        
        let entity = SavedBookEntity(context: context)
        entity.title = book.title
        entity.addedAt = book.addedAt
        entity.key = book.key
        entity.status = book.status.rawValue
        
        if let coverID = book.coverID {
            entity.coverID = Int64(coverID)
        }
        try context.save()
    }
    
    func loadBooks() throws -> [SavedBook] {
        let request = SavedBookEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "addedAt", ascending: false)
        ]
        let entities = try context.fetch(request)
        
        return entities.compactMap { entity in
            guard
                let key = entity.key,
                let title = entity.title,
                let statusValue = entity.status,
                let status = ReadingStatus(rawValue: statusValue),
                let addedAt = entity.addedAt
            else {
                return nil
            }
            
            return SavedBook(
                key: key,
                title: title,
                coverID: entity.coverID == 0 ? nil : Int(entity.coverID),
                status: status,
                addedAt: addedAt
            )
        }
    }
    
    func changeStatus(key: String, status: ReadingStatus) throws {
        let request = SavedBookEntity.fetchRequest()
        request.predicate = NSPredicate(format: "key == %@", key)
        request.fetchLimit = 1
        
        guard let entity = try context.fetch(request).first else { return }
        entity.status = status.rawValue
        try context.save()
    }
    
    func containsBook(key: String) throws -> Bool {
        let request = SavedBookEntity.fetchRequest()
        request.predicate = NSPredicate(format: "key == %@", key)
        request.fetchLimit = 1
        
        return try context.count(for: request) > 0
    }
    
    func deleteBook(key: String) throws {
        let request = SavedBookEntity.fetchRequest()
        request.predicate = NSPredicate(format: "key == %@", key)
        request.fetchLimit = 1
        
        guard let entity = try context.fetch(request).first else { return }
        context.delete(entity)
        try context.save()
    }
}
