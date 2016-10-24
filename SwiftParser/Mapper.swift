//
//  Mapper.swift
//  Job-Connect
//
//  Created by Darren Ferguson on 4/11/16.
//  Copyright © 2016 M.C. Dean, Inc. All rights reserved.
//

import Foundation
import CoreData
import QuartzCore

/// Generic Mapper class for the NSManagedObject type subclasses does the processing and
/// mapping of the data inside the objects based on the **context** provided and **type**
struct Mapper {

    /// Dictionary Keys that are used throughout this static mapper
    ///
    /// - disabled: key inside each entity determines if disabled in the application or not
    /// - data: dictionary object holding the devices from the server
    /// - id: server id for each entity from the application (requests and updates generally use this)
    /// - uuid: unique id for each entity mostly used when the **id* does not exist
    fileprivate enum Keys: String {
        case disabled = "disabled"
        case data = "data"
        case id = "id"
        case uuid = "uuid"
    }

    // MARK: - Properties

    /// **NSManagedObjectContext** the mapper will create and update existing device data
    fileprivate let context: NSManagedObjectContext

    /// **true** will delete any objects in the persistence of this type not provided by the query
    /// **false** will not delete objects will only insert and update objects in the persistence layer
    fileprivate let deleteNotProvided: Bool

    /// Object implementing the **CoreDataMapper** protocol to map entities as quickly as possible
    fileprivate let mapper: CoreDataMapper

    // MARK: - Initializer
    init(context: NSManagedObjectContext, deleteNotProvided: Bool = false, mapper: CoreDataMapper? = nil) {
        self.context = context
        self.deleteNotProvided = deleteNotProvided
        self.mapper = mapper ?? CoreDataMemoryMapper(context: context)
    }
}

// MARK: - Internal
extension Mapper {

    /// Method processes an individual record that holds information about an object type in the system
    ///
    /// - parameter type: datatype of the object being processed
    /// - parameter objectType: string version of the datatype for the object being processed
    /// - parameter records: array of string keyed dictionary holding the data for the object to be processed
    func processRecords<T: NSManagedObject>(_ type: T.Type, objectType: String, records: [[String: Any]]) {
        context.performAndWait {
            self.process(type, objectType: objectType, data: records)
        }
    }

    /// Method processes the server data received verifying it exists and making sure it can be
    /// converted into the expected type before beginning to process each entity in turn
    ///
    /// - parameter type: datatype of the object being processed
    /// - parameter serverData: Data received from the server for StaticData
    func processData<T: NSManagedObject>(_ type: T.Type, serverData: Any?) {
        guard let data = serverData as? [String: Any],
            let objectData = data[Keys.data.rawValue] as? [[String: Any]] else {
                print("Data entities was not of the datatype required")
                return
        }

        context.performAndWait {
            self.process(type, objectType: NSStringFromClass(type), data: objectData)
        }
    }

    /// Method is a helper method for the static data processing since the static data does not come
    /// as regular data out of the server but has its own special format
    ///
    /// - parameter type: datatype of the object being processed
    /// - parameter serverData: static data for the type object received by the server
    func processStaticData<T: NSManagedObject>(_ type: T.Type, serverData: [[String: Any]]) {
        context.performAndWait {
            self.process(type, objectType: NSStringFromClass(type), data: serverData)
        }
    }

    /// Reset the mapper implementing **CoreDataMapper** protocol
    func resetMapper() {
        mapper.reset()
    }
}

// MARK: - Private
private extension Mapper {

    /// Process the returned JSON information from the server and add / update the entities into the persistence layer
    ///
    /// - parameter type: type of NSManagedObject being processed
    /// - parameter data: server response holding the relevant deviceData to be processed
    func process<T: NSManagedObject>(_ type: T.Type, objectType: String, data: [[String: Any]]) {

        print("Start processing \(type) into persistence")
        let startTime = CACurrentMediaTime()

        // Run through each entity and process the data into the persistence layer
        // Previous filter makes sure the **id** key has a value and is an **Int** so the line inside
        // the forEach here is going to just force cast the value as an Int since it knows that it is
        var ids: [NSNumber] = []
        data.forEach { (object: [String: Any]) in
            if let disabled = object[Keys.disabled.rawValue] as? Bool,
                disabled {
                    return
            }
            guard let id = object[Keys.id.rawValue] as? Int else { return }

            ids.append(NSNumber(value: id))
            mapper.object(type, objectType: objectType, id: id, uuid: object[Keys.uuid.rawValue] as? String)
                .processValues(object, mapper: mapper)
        }

        print("Finished adding to the persistence layer time taken: \(CACurrentMediaTime() - startTime)")

        // If **deleteNotProvided** is **false** just finish the processing now otherwise continue to delete them
        guard deleteNotProvided else {
            print("Finished processing \(type) time taken: \(CACurrentMediaTime() - startTime) no deletion")
            return
        }

        // Delete the objects not provided in the system
        let deleteIds = Set(mapper.allObjectsIdsOf(objectType)).subtracting(ids)
        if !deleteIds.isEmpty {
            let deletionObjects = mapper.allObjectsOf(type, objectType: objectType)
                .filter({ (managedObject: NSManagedObject) in
                    deleteIds.contains(managedObject.value(forKey: managedObject.idField) as! NSNumber)
                })
            deleteObjects(deletionObjects, context: context)
            print("Finished deleteing objects \(deleteIds) from the system time taken to this point: \(CACurrentMediaTime() - startTime)")
        }

        print("Finished processing \(type) time taken: \(CACurrentMediaTime() - startTime)")
    }
}
