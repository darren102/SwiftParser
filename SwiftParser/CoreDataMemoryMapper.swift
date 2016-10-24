//
//  CoreDataMemoryMapper.swift
//  Job-Connect
//
//  Created by Darren Ferguson on 3/25/16.
//  Copyright © 2016 M.C. Dean, Inc. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataMemoryMapper: CoreDataMapper {

    // MARK: - Properties

    /// NSManagedObjectContext being used for this memory object mapper
    let context: NSManagedObjectContext

    /// Object map providing the currently in memory **NSManagedObject**s using **id**s as keys
    fileprivate var objectIdMap: [String: [Int: NSManagedObject]] = [:]

    // MARK: - Initializers
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    /// Method searches through the memory mapper of **NSManagedObject** objects and returns the **NSManagedObject** for use
    ///
    /// - note: This method if it does not find the object will create it in the **NSManagedObjectContext** the implementing class
    ///         was created with. It guarantees to return an object ready to be used with the **id* field already set. If it could
    ///         not find / create the object it will call **fatalError** since something is wrong with the persistence store of the
    ///         application
    ///
    /// - parameter type: Type of object to be returned
    /// - parameter objectType: string representation of the **type** parameter
    /// - parameter id: External id for the object
    /// - parameter uuid: Unique identifier for the object
    ///
    /// - returns: **NSManagedObject** of the required type
    func object<T: NSManagedObject>(_ type: T.Type, objectType: String, id: Int, uuid: String?) -> T {
        if objectIdMap[objectType] == nil {
            loadMemoryObjectsOfType(type, objectType: objectType)
        }

        var objectMap = objectIdMap[objectType] ?? [:]
        // If an object already exists in the map return that object
        if let coreDataObject = objectMap[id] as? T {
            return coreDataObject
        }

        // Object did not exist so create a new memory object
        let coreDataObject = createMemoryObject(type, objectType: objectType, id: id, uuid: uuid)
        objectMap[id] = coreDataObject
        objectIdMap[objectType] = objectMap
        return coreDataObject
    }

    /// Provide all objects currently in memory for the specified object type
    ///
    /// - parameter type: type of object being looked for
    /// - parameter objectType: string representation of the **type** parameter
    ///
    /// - returns: an array of **NSManagedObject** objects based on the type from memory
    func allObjectsOf<T : NSManagedObject>(_ type: T.Type, objectType: String) -> [T] {
        guard let objectMap = objectIdMap[objectType] else { return [] }

        return objectMap.flatMap({ (_, value) in value as? T })
    }

    /// Provide all object ids currently in memory for the specified object type
    ///
    /// - parameter type: type of object being looked for
    /// - parameter objectType: string representation of the **type** parameter
    ///
    /// - returns: an array of **NSNumber** objects representing the ids of the objects of the type provided
    func allObjectsIdsOf(_ objectType: String) -> [NSNumber] {
        guard let objectMap = objectIdMap[objectType] else { return [] }

        return objectMap.map({ (key: Int, _) in NSNumber(value: key) })
    }

    /// Resets the memory mapper by deleting all objects stored in memory
    func reset() {
        objectIdMap.removeAll(keepingCapacity: false)
    }
}

// MARK: - Private
private extension CoreDataMemoryMapper {

    /// Creates a new **NSManagedObject** in the provided context and makes sure its id field is set
    ///
    /// - note: The configured **IdField** from the **NSManagedObject** extension will have its value set to the
    ///         **objectId** variable that is provided to this method
    ///
    /// - parameter object: Type of object to be returned
    /// - parameter objectType: string representation of the object type
    /// - parameter id: External identifier for the object
    /// - parameter uuid: Unique identifier for the object
    ///
    /// - returns: Fully initialized object of the provided type with the **IdField** and **UUIDField** already set
    func createMemoryObject<T: NSManagedObject>(_ object: T.Type, objectType: String, id: Int, uuid: String?) -> T {
        guard let coreDataObject = createObject(object, objectType: objectType, context: context) else {
            fatalError("CoreDataMemoryMapper could not create a new object within the context: \(context)")
        }

        coreDataObject.setValue(uuid ?? UUID().uuidString.lowercased(), forKey: coreDataObject.UUIDField)
        coreDataObject.setValue(NSNumber(value: id), forKey: coreDataObject.idField)
        return coreDataObject
    }

    /// Loads objects from the **NSManagedObjectContext** to the memory mapper for faster accessing
    ///
    /// - note: This method passes **returnsObjectsAsFaults** as **false** to the **loadObjects** method in the application.
    ///         The reason for this is if we get lots of faults then it is expensive to go back to disk everytime and since
    ///         this will be a load operation for **presumably** lots of data having the faults fetched in the beginning will
    ///         significantly speed up the in memory searching that occurs
    ///
    /// - parameter type: Type of object to be mapped into memory
    /// - parameter objectType: string representation of the **type** variable
    func loadMemoryObjectsOfType<T: NSManagedObject>(_ type: T.Type, objectType: String) {
        // There might be multiple objects which are not yet sent to the server with idField = 0. Therefore filter them
        // out so that a new object with **idField** = 0 would be created instead of reusing one of existing ones.
        let predicate = NSPredicate(format: "%K <> 0", argumentArray: [NSManagedObject.idField])
        guard let objects = loadObjects(type, returnsObjectsAsFaults: false, predicate: predicate, context: context) else { return }

        var map: [Int: T] = [:]
        objects.forEach({ (obj: T) in
            guard let id = obj.value(forKey: obj.idField) as? Int else { return }
            map[id] = obj
        })
        objectIdMap[objectType] = map
    }
}
