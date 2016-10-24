//
//  NSManagedObject+Mapper.swift
//  Job-Connect
//
//  Created by Darren Ferguson on 3/25/16.
//  Copyright © 2016 M.C. Dean, Inc. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {

    // MARK: - Properties

    /// The field inside each **NSManagedObject** which is the unique identifier
    var UUIDField: String {
        return "uuid"
    }

    /// The field inside each **NSManagedObject** which is the external identifier
    var idField: String {
        return "id"
    }

    /// The field inside each **NSManagedObject** which is the external identifier
    static var idField: String {
        return "id"
    }

    /// External name mapping if the name of the property in the server data
    /// different than the property name inside core data
    var managedObjectPropertyExternalName: String {
        return "externalName"
    }

    /// If set in the **userInfo** for the **relationship** then the application should not
    /// process the **relationship** and should just ignore it and continue on to the next
    ///
    /// - seealso: **shouldIgnoreRelationship(_:)** method in this class for more detailed information
    var managedObjectRelationshipProcessingIgnore: String {
        return "processingIgnore"
    }

    //  Mark that destination object does not have an id
    var managedObjectRelationshipNoId: String {
        return "noId"
    }

    /// The field inside the objects from the server which determine if reference object or full object
    var referenceOnly: String {
        return "referenceOnly"
    }

    /// Placeholder to mark the property / relation for deletion
    var entityRelationDeletionPlaceholder: String {
        return "<--DELETE-->"
    }

    /// Key to be used inside the **userInfo** of the property if it might be different than the property name
    var userInfoKeyPath: String {
        return "keyPath"
    }
}

// MARK: - Public
extension NSManagedObject {

    /// Method processes both attribute and relationships for the current entity in the application
    ///
    /// - parameter values: String keyed Dictionary holding the values to be set for the entities attributes and relationships
    /// - parameter parentRelationship: relationship that originally brought the user to process this entity
    /// - parameter processToMany: **true** will try and process **ToMany** relationships
    ///                            **false** will not process **ToMany** relationships
    /// - parameter mapper: Object conforming to the protocol for CoreDatatMapper so retrieving objects
    ///                     can be done in memory as much as possible versus going to persistence everytime
    func processValues(_ values: [String: Any], parentRelationship: NSRelationshipDescription? = nil, processToMany: Bool = true, mapper: CoreDataMapper) {
        // Do not process if just a reference object
        guard !isReferenceObject(values) else { return }

        // Process the attributes of the entity first
        processPropertyValues(values)

        // Process the relationships of the entity
        processRelationshipValues(values, parentRelationship: parentRelationship, processToMany: processToMany, mapper: mapper)
    }
}

// MARK: - Private
private extension NSManagedObject {

    /// Method determines whether the object is a reference object (id only) or a fully instantiated object
    ///
    /// - parameter values: object data received from the server
    ///
    /// - returns: **true** object is a reference object
    ///            **false** object is a fully instantiated object
    func isReferenceObject(_ values: [String: Any]) -> Bool {
        if let referenceOnly = values[referenceOnly] as? Bool {
            return referenceOnly
        }

        return false
    }

    /// Resolve the property value key for the current property determining whether there is a valid value or not
    ///
    /// - note: this method is used to check the external name associated with the property since some information from
    ///         the server can be coming in as reserved fields in **iOS** such as **description** where we cannot overwrite
    ///         these in our models hence this way the key name can be different than the name from the external data yet
    ///         still the correct value can be resolved from the data by using this method
    ///
    /// - parameter key: original key inside the core data model
    /// - parameter entityDescription: all relevant information about the current attribute property of the core data model
    /// - parameter attributeValues: list of key value pairs received from the external datasource
    ///
    /// - returns: key to process the values for or **nil** if the value should not be processed
    func resolvePropertyValueKey(_ key: String, entityDescription: NSAttributeDescription, attributeValues: [String: Any]) -> String? {
        let propertyValueKey = entityDescription.userInfo?[managedObjectPropertyExternalName] as? String ?? key
        guard attributeValues[propertyValueKey] != nil else {
            return nil
        }

        return propertyValueKey
    }

    /// Determine whether the relationship should be ignored or whether it should be processed by the application
    ///
    /// - note: the reason for this method is that in Core Data you always have to have an inverse relationship for the
    ///         relationships you set up. Now sometimes that is done purely to satisfy Core Data and the endpoints the
    ///         application is pulling data from do not return the data for the inverse. (Sometimes they do if there is
    ///         a link back but this is to handle the time it does not have the return link). Since this **relationship**
    ///         has been added to satisfy Core Data if we do not ignore it, the application will always reset the value to
    ///         **nil** since no value comes from the endpoint hence it has to be treated that there is no longer a value in
    ///         that **field** from the endpoint data hence the relationship should be reset to **nil** in the object
    ///
    /// - parameter relationship: relationship to check if processing should be ignored on it or not
    ///
    /// - returns: **true** relationship **SHOULD BE** processed by the application
    ///            **false** relationship **SHOULD NOT BE** processed by the application
    func shouldIgnoreRelationship(_ relationship: NSPropertyDescription) -> Bool {
        return relationship.userInfo?[managedObjectRelationshipProcessingIgnore] != nil
    }

    /// Method will process the entities **attribute values only** trying to set the appropriate value
    /// for the entities attribute based on information provided in the String keyed Dictionary
    ///
    /// - note: This method only deals with the attributes and will not try and do anything with the relationship
    ///         properties. A seperate method will handle going through the relationships. This method bypasses
    ///         setting the **IdField** of the attribute since this is already set and should not be overwritten
    ///
    /// - parameter attributeValues: String keyed Dictionary holding the values to be set for the entities attributes and relationships
    func processPropertyValues(_ attributeValues: [String: Any]) {
        for (key, entityDescription) in entity.attributesByName where key != idField {
            guard let propertyValueKey = resolvePropertyValueKey(key, entityDescription: entityDescription, attributeValues: attributeValues) else { continue }

            let value = valueFromAttributeDescription(attributeValues[propertyValueKey]!, entityDescription: entityDescription)
            setValue(value, forKey: key)
        }
    }

    /// Method will process the entities **relationship values only** trying to set the appropriate values
    ///
    /// - note: This method will check the **inverseRelationship** or the **parentRelationship** to determine
    ///         whether it is the same as the relationship currently being processed. If it is this will skip
    ///         that relationship since otherwise you will get into an endless loop
    ///
    /// - parameter values: String keyed Dictionary holding the values to be set for the entities attributes and relationships
    /// - parameter parentRelationship: relationship that originally brought the user to process this entity
    /// - parameter processToMany: **true** will try and process **ToMany** relationships
    ///                            **false** will not process **ToMany** relationships
    /// - parameter mapper: Object conforming to the protocol for CoreDataMapper so retrieving objects
    ///                     can be done in memory as much as possible versus going to persistence everytime
    func processRelationshipValues(_ values: [String: Any], parentRelationship: NSRelationshipDescription? = nil, processToMany: Bool = true, mapper: CoreDataMapper) {

        // Loop through the relationships in the entity and check each relationship to determine if the relationship should
        // be processed. If the relationship should be processed then perform the processing otherwise ignore it. If you want
        // to know more about why a relationship should be ignored please check the **shouldIgnoreRelationShip** method
        for (key, relationship) in entity.relationshipsByName where !shouldIgnoreRelationship(relationship) {
            // Checking for back references and if this is a back reference do not process
            if let parentRelationship = parentRelationship,
                let inverseRelationship = parentRelationship.inverseRelationship,
                inverseRelationship == relationship {
                    continue
            }

            if !relationship.isToMany {
                // If the value is **nil** or no key was sent then just have the relationship **nilled** out for **toOne** relationships
                if values[key] == nil {
                    setValue(nil, forKey: key)
                    continue
                }

                // A ToOne relationship will be a dictionary so this needs to be checked for here
                guard let relationshipValues = values[key] as? [String: AnyObject] else {
                    #if DEBUG
                        fatalError("Relationship To One was not of the correct type \(values[key])")
                    #else
                        print("Relationship To One was not of the correct type \(values[key])")
                        continue
                    #endif
                }

                processToOneRelationship(key, values: relationshipValues, relationship: relationship, processToMany: processToMany, mapper: mapper)

            } else if processToMany && values[key] != nil {
                // A ToMany relationship will be an array of dictionaries so this needs to be checked for here
                guard let relationshipValuesArray = values[key] as? [[String: AnyObject]] else {
                    #if DEBUG
                        fatalError("Relationship To Many was not of the correct type \(values[key])")
                    #else
                        print("Relationship To Many was not of the correct type \(values[key])")
                        continue
                    #endif
                }

                processToManyRelationship(key, valuesArray: relationshipValuesArray, relationship: relationship, processToMany: processToMany, mapper: mapper)
            }
        }
    }

    /// Method is processing To-One relationships for the current entity
    ///
    /// - note: There might be objects which do not have an id property.
    ///         Those relations are marked and proccessed differently.
    ///
    /// - parameter key: maps this entity to the relationship entity
    /// - parameter values: **String** keyed **Dictionary** holding the values for the relationship entity
    /// - parameter relationship: description information on the **ToOne** relationship being processed
    /// - parameter processToMany: **true** will try and process **ToMany** relationships
    ///                            **false** will not process **ToMany** relationships
    /// - parameter mapper: object conforming to the protocol for **CoreDataMapper** so retrieving objects
    ///                     can be done in memory as much as possible versus going to persistence everytime
    func processToOneRelationship(_ key: String, values: [String: AnyObject], relationship: NSRelationshipDescription, processToMany: Bool = true, mapper: CoreDataMapper) {
        guard let id = values[idField] as? Int else {
            if let noId = relationship.userInfo?[managedObjectRelationshipNoId] as? String,
                noId == "true" {
                    processToOneRelationshipNoId(key, values: values, relationship: relationship, processToMany: processToMany, mapper: mapper)
                    return
            }
            setValue(nil, forKey: key)
            return
        }

        guard let object = persistenceObjectFor(id, uuid: values[UUIDField] as? String, relationship: relationship, mapper: mapper) else {
            setValue(nil, forKey: key)
            return
        }

        object.processValues(values, parentRelationship: relationship, processToMany: processToMany, mapper: mapper)
        setValue(object, forKey: key)
    }

    /// Method is processing To-One relationships for the current entity if relationships do not have an id
    ///
    /// - note: For relations to the objects which do not have an id we don't lookup by id.
    ///         Instead we use either existing object or create a new one.
    ///
    /// - parameter key: maps this entity to the relationship entity
    /// - parameter values: **String** keyed **Dictionary** holding the values for the relationship entity
    /// - parameter relationship: description information on the **ToOne** relationship being processed
    /// - parameter processToMany: **true** will try and process **ToMany** relationships
    ///                            **false** will not process **ToMany** relationships
    /// - parameter mapper: object conforming to the protocol for **CoreDataMapper** so retrieving objects
    ///                     can be done in memory as much as possible versus going to persistence everytime
    func processToOneRelationshipNoId(_ key: String, values: [String: AnyObject], relationship: NSRelationshipDescription, processToMany: Bool = true, mapper: CoreDataMapper) {
        guard let object = value(forKey: key) as? NSManagedObject ?? persistenceObjectFor(nil, uuid: nil, relationship: relationship, mapper: mapper) else {
            setValue(nil, forKey: key)
            return
        }

        object.processValues(values, parentRelationship: relationship, processToMany: processToMany, mapper: mapper)
        setValue(object, forKey: key)
    }

    /// Method is processing To-Many relationships for the current entity
    ///
    /// - parameter key: maps the entity to the relationship entity
    /// - parameter valuesArray: the array of attributes to be processed for each relationship object
    /// - parameter relationship: description information on the **ToMany** relationship being processed
    /// - parameter processToMany: **true** will try and process **ToMany** relationships
    ///                            **false** will not process **ToMany** relationships
    /// - parameter mapper: object conforming to the protocol for **CoreDataMapper** so retrieving objects
    ///                     can be done in memory as much as possible versus going to persistence everytime
    func processToManyRelationship(_ key: String, valuesArray: [[String: AnyObject]], relationship: NSRelationshipDescription, processToMany: Bool = true, mapper: CoreDataMapper) {
        let objects = mutableSetValue(forKey: key)
        objects.removeAllObjects()

        valuesArray.forEach({ (values: [String: AnyObject]) in
            guard let object = persistenceObjectFor(values[idField] as? Int, uuid: values[UUIDField] as? String, relationship: relationship, mapper: mapper) else { return }

            object.processValues(values, parentRelationship: relationship, processToMany: processToMany, mapper: mapper)
            objects.add(object)
        })
    }

    /// Method tries to provide an entity from the persistence layer matching the unique identifier and the entity type
    /// information that is stored inside the **NSRelationshipDescription** that is provided
    ///
    /// - note: When saying uniquely identified for the **value** parameter this means the combination of this **id** plus
    ///         the type of entity stroed in the **relationship** description will be enough to pull the object from the
    ///         persistence layer or have the correct object created in the persistence layer
    ///
    /// - parameter id: id provided by the server for the object **can be nil if a many to many relationship**
    /// - parameter uuid: unique uuid for the object if provided by the server or the applicatin
    /// - parameter relationship: provides information on the relationship between the current entity and the other entities associated with it
    /// - parameter mapper: object conforming to the protocol for **CoreDataMapper** so retrieving objects
    ///                     can be done in memory as much as possible versus going to persistence everytime
    ///
    /// - returns: NSManagedObject subclass of type T if successful otherwise **nil** will be returned
    func persistenceObjectFor<T: NSManagedObject>(_ id: Int?, uuid: String?, relationship: NSRelationshipDescription, mapper: CoreDataMapper) -> T? {

        // Must be able to determine the type of NSManagedObject for the entity relationship so
        // the correct type of object can be retrieved from the **CoreDataMapper**
        guard let managedObjectClassName = relationship.destinationEntity?.managedObjectClassName,
            let type = NSClassFromString(managedObjectClassName) as? T.Type else {
                return nil
        }

        // If **id** is nil i.e. a refernce object then just return a new created object
        // Since the mapper does not know how to handle non id methods so this will handle them
        if id == nil {
            return createObject(type, objectType: managedObjectClassName, context: mapper.context)
        }

        return mapper.object(type, objectType: managedObjectClassName, id: id!, uuid: uuid)
    }

    /// Will make sure the value to be set in the **CoreData** attribute is of the correct type based on the attribute type
    ///
    /// - note: This method uses the internal **NSAttributeType** information provided for the entity property via the
    ///         **entityDescription**
    ///
    /// - parameter value: Raw value that was received from the caller (could be server or application generated data)
    /// - parameter entityDescription: Description held inside **CoreData** regarding the property on the entity
    ///
    /// - returns: Value transformed into the appropriate datatype or **nil** if an error occurs in the processing
    func valueFromAttributeDescription(_ value: Any, entityDescription: NSAttributeDescription) -> Any? {
        switch entityDescription.attributeType {
        case .integer16AttributeType,
             .integer32AttributeType,
             .integer64AttributeType:
            return value as? Int
        case .decimalAttributeType:
            return value as? NSNumber
        case .doubleAttributeType:
            return value as? Double
        case .floatAttributeType:
            return value as? Float
        case .stringAttributeType:
            return value as? String
        case .booleanAttributeType:
            return value as? Bool
        case .dateAttributeType:
            return processDateAttribute(value)
        case .binaryDataAttributeType:
            return value as? Data
        case .transformableAttributeType:
            return value
        default:
            return value
        }
    }

    /// Method processes the value provided and returns an **NSDate** representation
    ///
    /// - note: If a **nil** value is passed to this method nothing will occur and the method
    ///         will exit immediately returning a **nil** value as the result
    ///
    /// - parameter value: Object containing a representation of the date from the system
    ///
    /// - returns: Valid **NSDate** representation or **nil** the attribute could not be processed
    func processDateAttribute(_ value: Any?) -> Date? {
        guard let value = value else { return nil }

        guard let processedValue = value as? NSNumber else {
            fatalError("Date value provided was not a supported format in the application")
        }

        return Date(timeIntervalSince1970: TimeInterval(processedValue.doubleValue / 1000))
    }
}
