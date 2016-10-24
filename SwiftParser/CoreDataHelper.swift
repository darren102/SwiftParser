//
//  CoreDataHelper.swift
//  Job-Connect
//
//  Created by Darren Ferguson on 3/2/16.
//  Copyright © 2016 M.C. Dean, Inc. All rights reserved.
//

import Foundation
import CoreData

/// Resolve the actual type of the entity based on the **String** class name provided
///
/// - parameter entity: String representation of the entities class name
///
/// - returns: Actual type of the object represented by the **String entity** parameter
func entityType<T: NSManagedObject>(_ entity: String) -> T.Type {
    guard let type = NSClassFromString(entity) as? T.Type else {
        let message = "Invalid type of class received by the system"
        print(message)
        fatalError(message)
    }

    return type
}

/// Load a specific object of Type T from the provided **NSManagedObjectContext**
///
/// - note: This method uses plain **NSStringFromClass** to retrieve the entity name
///         It can do this since all of the objects created in this application should
///         be annotated with the **@objc()** in the file directly above their class definition
///
/// - parameter object: Type of object to be loaded from the context
/// - parameter id: id of the object to load from context
/// - parameter returnsDisabled: **true** object will be returned regardless of the **disabled** property value,
///                              **false** object will be returned only if it's **disabled** property value is **false**
/// - parameter returnsObjectAsFault: **true** **NSManagedObject** will be returned as fault,
///                                   **false** **NSManagedObject** will be fully initialized and not fault
/// - parameter context: The **NSManagedObjectContext** to load the object from
///
/// - returns: Object of Type T from the **NSManagedObjectContext** whose id matches the
///            provided **objectId**. **nil** if nothing or an error occurs
func loadObject<T: NSManagedObject>(_ object: T.Type,
                id: NSNumber,
                returnsDisabled: Bool = false,
                returnsObjectAsFault: Bool = false,
                context: NSManagedObjectContext) -> T? {

    let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: NSStringFromClass(object))
    fetchRequest.returnsDistinctResults = returnsObjectAsFault
    fetchRequest.fetchLimit = 1

    // Build the necessary predicate based on provided parameters
    let idPredicate = NSPredicate(format: "id = %@", argumentArray: [id])
    if returnsDisabled {
        let predicates = [idPredicate, NSPredicate(format: "disabled == false", argumentArray: nil)]
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    } else {
        fetchRequest.predicate = idPredicate
    }

    do {
        let results = try context.fetch(fetchRequest)
        return results.first
    } catch let error as NSError {
        print("Error: \(error)")
    }

    return nil
}

/// Load a specific object of Type T from the provided **NSManagedObjectContext**
///
/// - note: This method uses plain **NSStringFromClass** to retrieve the entity name
///         It can do this since all of the objects created in this application should
///         be annotated with the **@objc()** in the file directly above their class definition
///
/// - parameter object: Type of object to be loaded from the context
/// - parameter uuid: Unique UUID of the object to load from the context
/// - parameter returnsDisabled: **true** object will be returned regardless of the **disabled** property value,
///                              **false** object will be returned only if it's **disabled** property value is **false**
/// - parameter returnsObjectAsFault: **true** **NSManagedObject** will be returned as fault,
///                                   **false** **NSManagedObject** will be fully initialized and not fault
/// - parameter context: The **NSManagedObjectContext** to load the object from
///
/// - returns: Object of Type T from the **NSManagedObjectContext** whose id matches the
///            provided **objectId**. **nil** if nothing or an error occurs
func loadObject<T: NSManagedObject>(_ object: T.Type,
                uuid: String,
                returnsDisabled: Bool = false,
                returnsObjectAsFault: Bool = false,
                context: NSManagedObjectContext) -> T? {

    let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: NSStringFromClass(object))
    fetchRequest.returnsDistinctResults = returnsObjectAsFault
    fetchRequest.fetchLimit = 1

    // Build the necessary predicate based on provided parameters
    let uuidPredicate = NSPredicate(format: "uuid = %@", argumentArray: [uuid])
    if returnsDisabled {
        let predicates = [uuidPredicate, NSPredicate(format: "disabled == false", argumentArray: nil)]
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    } else {
        fetchRequest.predicate = uuidPredicate
    }

    do {
        let results = try context.fetch(fetchRequest)
        return results.first
    } catch let error as NSError {
        print("Error: \(error)")
    }

    return nil
}

/// Load objects of Type T from the provided **NSManagedObjectContext**
///
/// - note: This method uses plain **NSStringFromClass** to retrieve the entity name
///         It can do this since all of the objects created in this application should
///         be annotated with the **@objc()** in the file directly above their class definition
///
/// - parameter object: Type of object to be loaded from the context
/// - parameter returnsDisabled: **true** objects will be returned regardless of the **disabled** property value,
///                              **false** objects will be returned only if their **disabled** property value is **false**
/// - parameter returnsObjectsAsFaults: **true** **NSManagedObject**s will be returned as faults
///                                     **false** **NSManagedObject**s will be fully initialized and not faults
/// - parameter fetchBatchSize: number of objects to return in batches default 0 returns all
/// - parameter predicate: filtering the result set based on the provided predicate
/// - parameter sortDescriptors: sort descriptors to provide sorting of the results from the context
/// - parameter context: The **NSManagedObjectContext** to load the objects from
///
/// - returns: Array of objects of Type T or **nil** if an error occurred
func loadObjects<T: NSManagedObject>(_ object: T.Type,
                 returnsDisabled: Bool = false,
                 returnsObjectsAsFaults: Bool = true,
                 fetchBatchSize: Int = 0,
                 predicate: NSPredicate? = nil,
                 sortDescriptors: [NSSortDescriptor]? = nil,
                 context: NSManagedObjectContext) -> [T]? {

    let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: NSStringFromClass(object))
    fetchRequest.returnsObjectsAsFaults = returnsObjectsAsFaults
    fetchRequest.fetchBatchSize = fetchBatchSize
    fetchRequest.sortDescriptors = sortDescriptors

    // Build the predicate based on provided parameters making it clear at each case what will occur
    if !returnsDisabled && predicate == nil {
        fetchRequest.predicate = NSPredicate(format: "disabled = false", argumentArray: nil)
    } else if !returnsDisabled && predicate != nil {
        let predicates = [NSPredicate(format: "disabled = false", argumentArray: nil), predicate!]
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    } else {
        fetchRequest.predicate = predicate
    }

    do {
        return try context.fetch(fetchRequest)
    } catch let error as NSError {
        print("Error: \(error)")
    }

    return nil
}

/// Create objects of Type T in the provided **NSManagedObjectContext**
///
/// - note: This method uses plain **NSStringFromClass** to retrieve the entity name
///         It can do this since all of the objects created in this application should
///         be annotated with the **@objc()** in the file directly above their class definition
///
/// - parameter object: Type of object to be created in the context
/// - parameter objectType: String type of the object to be created in the context
/// - parameter context: The **NSManagedObjectContext** to create the object in
///
/// - returns: Created object in the provided context. **nil** if the object could not be created
func createObject<T: NSManagedObject>(_ object: T.Type, objectType: String? = nil, context: NSManagedObjectContext) -> T? {
    let entityName: String
    if let objectType = objectType {
        entityName = objectType
    } else {
        entityName = NSStringFromClass(object)
    }

    if let object = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? T {
        return object
    }

    return nil
}

/// Delete the **NSManagedObject**s of Type T from the provided **NSManagedObjectContext**
///
/// - note: Method will do nothing if the **objects** array is empty
///
/// - parameter objects: **NSManagedObject** subclass objects to be deleted
/// - parameter context: **NSManagedObjectContext** from which to delete the provided objects
func deleteObjects<T: NSManagedObject>(_ objects: [T], context: NSManagedObjectContext) {
    if !objects.isEmpty {
        objects.forEach { (object: T) in context.delete(object) }
    }
}
