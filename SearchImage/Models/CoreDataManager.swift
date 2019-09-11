//
//  CoreDataManager.swift
//  ratoc
//
//  Created by Hiroshi Nasu on 7/7/18.
//  Copyright © 2018 Hiroshi Nasu. All rights reserved.
//

import CoreData

class CoreDataManager<T> {
    
    var context: NSManagedObjectContext = DatabaseController.getContext()
    var entityName: String
    
    init(entityName: String){
        //self.context = DatabaseController.getContext()
        self.entityName = entityName
    }
    
    // Creates
    func getCreate() -> T {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: self.entityName, into: context) as! T
        return newItem
    }
    
    // Gets Object by id
    func getById(id: NSManagedObjectID) -> T? {
        return context.object(with: id) as? T
    }
    
    // Gets all.
    func getAll() -> [T]{
        return get(withPredicate: NSPredicate(value:true))
    }
    
    // Gets all that fulfill the specified predicate.
    // Predicates examples:
    // - NSPredicate(format: "name == %@", "Juan Carlos")
    // - NSPredicate(format: "name contains %@", "Juan")
    func get(withPredicate queryPredicate: NSPredicate, sorts: [NSSortDescriptor]? = nil, groupBy: [String]? = nil) -> [T]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        
        fetchRequest.predicate = queryPredicate
        
        if sorts != nil {
            fetchRequest.sortDescriptors = sorts
        }
        
        if groupBy != nil {
            fetchRequest.propertiesToGroupBy = groupBy
            fetchRequest.propertiesToFetch = groupBy
            fetchRequest.resultType = .dictionaryResultType
        }
        
        do {
            let response = try context.fetch(fetchRequest)
            return response as! [T]
            
        } catch let error as NSError {
            // failure
            print(error)
            return [T]()
        }
    }
    
    // Update
    func getUpdate(objectID: NSManagedObjectID) -> T? {
        if let item = getById(id: objectID){
            return item
        }
        return nil
    }
    
    // Deletes
    func delete(id: NSManagedObjectID){
        if let itemToDelete = getById(id: id){
            context.delete(itemToDelete as! NSManagedObject)
        }
    }
    
    // Delete All
    public func deleteAll() {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try context.execute(request)
        } catch {
            print(error)
        }
    }
    
    // Saves all changes
    func saveChanges(){
        do{
            try context.save()
        } catch let error as NSError {
            // failure
            print(error)
        }
    }
}
