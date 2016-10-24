//
//  StaticDataMapper.swift
//  Job-Connect
//
//  Created by Darren Ferguson on 3/25/16.
//  Copyright © 2016 M.C. Dean, Inc. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CoreDataStack

struct StaticDataMapper {

    /// Dictionary Keys that are used throughout this static mapper
    ///
    /// - Disabled: key inside each entity determines if disabled in the application or not
    /// - Entities: wrapper object holding the entities provided from the server
    /// - Id: server id for each entity from the application (requests and updates generally use this)
    /// - UUID: unique id for each entity mostly used when the **id* does not exist
    fileprivate enum Keys: String {
        case disabled
        case entities
        case id
        case uuid
    }

    // MARK: - Properties

    /// **NSManagedObjectContext** the mapper will create and update existing static data inside
    fileprivate let context: NSManagedObjectContext

    /// Entities requested during Static Data requesting from the server
    fileprivate let requestEntities: [String]

    /// Object implementing the **CoreDataMapper** protocol to map entities as quickly as possible
    fileprivate let mapper: CoreDataMapper

    // MARK: - Initializer
    init(context: NSManagedObjectContext, requestEntities: [String]) {
        self.context = context
        self.requestEntities = requestEntities
        self.mapper = CoreDataMemoryMapper(context: context)
    }
}

// MARK: - Internal
extension StaticDataMapper {

    /// Method processes the server data received verifying it exists and making sure it can be
    /// converted into the expected type before beginning to process each entity in turn
    ///
    /// - parameter serverData: Data received from the server for StaticData
    func processData(_ serverData: Any?) {
        guard let data = serverData as? [String: Any],
            let entities = data[Keys.entities.rawValue] as? [String: Any] else {
                print("Data entities was not of the datatype required")
                return
        }

        process(entities)
    }
}

// MARK: - Private
private extension StaticDataMapper {

    /// Process the returned JSON information from the server and add / update the entities into the persistence layer
    ///
    /// - parameter json: server response holding the relevant entities to be processed
    func process(_ json: [String: Any]) {

        let objectMapper = Mapper(context: context, deleteNotProvided: true, mapper: mapper)
        for entity in requestEntities {
            guard let objects = json[entity] as? [[String: Any]] else { continue }

            /// Since we are using relations defined in abstract entities we need to reset the mapper
            /// before processing static data for each entity otherwise duplicate objects are created.
            ///
            /// For instance we have abstract entity AbstractState and two subclasses DeviceState and
            /// SRState. When we first process DeviceTypeAttributeStateBehavior objects which have a
            /// relation state pointing to AbstractState we load all AbstractState objects. At this
            /// moment we load only DeviceState objects since SRState objects has not yet been processed.
            /// When we process state relation of SRCategoryAttributeStateBehavior objects we cannot
            /// find corresponding AbstractState objects in the mapper because they were never loaded
            /// since AbstractState objects were loaded into the memory when SRState objects were not
            /// yet processed. As a result mapper creates a dublicate AbstractState objects.
            objectMapper.resetMapper()
            objectMapper.processStaticData(entityType(entity), serverData: objects)
        }
    }
}
