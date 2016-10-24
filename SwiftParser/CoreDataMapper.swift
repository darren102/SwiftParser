//
//  CoreDataMapper.swift
//  Job-Connect
//
//  Created by Darren Ferguson on 3/25/16.
//  Copyright © 2016 M.C. Dean, Inc. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataMapper {

    /// **NSManagedObjectContext** the objects in the wrapper will be retrieved from or created inside
    var context: NSManagedObjectContext { get }

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
    func object<T: NSManagedObject>(_ type: T.Type, objectType: String, id: Int, uuid: String?) -> T

    /// Provide all objects currently in memory for the specified object type
    ///
    /// - parameter type: type of object being looked for
    /// - parameter objectType: string representation of the **type** parameter
    ///
    /// - returns: an array of **NSManagedObject** objects based on the type from memory
    func allObjectsOf<T: NSManagedObject>(_ type: T.Type, objectType: String) -> [T]

    /// Provide all object ids currently in memory for the specified object type
    ///
    /// - parameter objectType: string representation the object type name
    ///
    /// - returns: an array of **NSNumber** objects representing the ids of the objects of the object type provided
    func allObjectsIdsOf(_ objectType: String) -> [NSNumber]

    /// Resets the mapper by removing its backing store of current objects
    func reset()
}
