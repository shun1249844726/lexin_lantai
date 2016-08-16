//
//  Plans.swift
//  lexin_lantai
//
//  Created by 徐顺 on 16/3/3.
//  Copyright © 2016年 徐顺. All rights reserved.
//

import Foundation
import CoreData

class Plans: NSManagedObject {
    /*
    @NSManaged var planDetails: String?
    @NSManaged var planName: String?
    @NSManaged var planNum: String?
    @NSManaged var roadNum: String?
*/
    /// Function to initialize a new Item
    convenience init(plannum : String,planname:String,plandetails:String,roadnum :String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Plans", inManagedObjectContext: managedObjectContext)!
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
        self.planNum = plannum
        self.planName = planname
        self.roadNum  = roadnum
        self.planDetails = plandetails
    }
    
    /// Function to get all CoreData values
    ///
    /// - parameter managedObjectContext: CoreData Connection
    ///
    class func fetchAll(managedObjectContext: NSManagedObjectContext) -> [Plans] {
        let listagemCoreData = NSFetchRequest(entityName: "Plans")
        
        // Sort alphabetical by field "name"
        let orderByName = NSSortDescriptor(key: "planNum", ascending: true, selector: "caseInsensitiveCompare:")
        listagemCoreData.sortDescriptors = [orderByName]
        
        // Get items from CoreData
        return (try? managedObjectContext.executeFetchRequest(listagemCoreData)) as? [Plans] ?? []
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
    class func search(name: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Plans? {
        let fetchRequest = NSFetchRequest(entityName: "Plans")
        fetchRequest.predicate = NSPredicate(format: "planName = %@", name)
        
        let result = (try? managedObjectContext.executeFetchRequest(fetchRequest)) as? [Plans]
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
