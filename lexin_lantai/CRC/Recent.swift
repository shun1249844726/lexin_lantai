//
//  Recent.swift
//  lexin_lantai
//
//  Created by 徐顺 on 16/4/11.
//  Copyright © 2016年 徐顺. All rights reserved.
//

import Foundation
import CoreData


class Recent: NSManagedObject {
    convenience init(name : String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Recent", inManagedObjectContext: managedObjectContext)!
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
        self.name = name

    }
    
    /// Function to get all CoreData values
    ///
    /// - parameter managedObjectContext: CoreData Connection
    ///
    class func fetchAll(managedObjectContext: NSManagedObjectContext) -> [Recent] {
        let listagemCoreData = NSFetchRequest(entityName: "Recent")
        
        // Sort alphabetical by field "name"
        let orderByName = NSSortDescriptor(key: "name", ascending: true, selector: "caseInsensitiveCompare:")
        listagemCoreData.sortDescriptors = [orderByName]
        
        // Get items from CoreData
        return (try? managedObjectContext.executeFetchRequest(listagemCoreData)) as? [Recent] ?? []
    }
    /// Function to save CoreData values
    ///
    /// - parameter managedObjectContext: CoreData Connection
    ///
    func save(managedObjectContext: NSManagedObjectContext) {
        do {
            try managedObjectContext.save()
        }
        catch {
            let nserror = error as NSError
            print("Error on save: \(nserror.debugDescription)")
        }
    }
    /// Function to delete a item
    ///
    /// - parameter managedObjectContext: CoreData Connection
    ///
    func destroy(managedObjectContext: NSManagedObjectContext) {
        managedObjectContext.deleteObject(self)
    }
    
    /// Function to search item by name
    ///
    /// - parameter name: Item name
    /// - parameter managedObjectContext: CoreData Connection
    ///
    class func search(name: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Recent? {
        let fetchRequest = NSFetchRequest(entityName: "Recent")
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        
        let result = (try? managedObjectContext.executeFetchRequest(fetchRequest)) as? [Recent]
        return result?.first
    }
    
    /// Function to check duplicate item
    ///
    /// - parameter name: Item name
    /// - parameter managedObjectContext: CoreData Connection
    ///
    class func checkDuplicate(name: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Bool {
        return search(name, inManagedObjectContext: managedObjectContext) != nil
    }
}
