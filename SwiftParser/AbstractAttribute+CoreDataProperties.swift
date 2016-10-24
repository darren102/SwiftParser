//
//  AbstractAttribute+CoreDataProperties.swift
//  Job-Connect
//
//  Created by Darren Ferguson on 3/25/16.
//  Copyright © 2016 M.C. Dean, Inc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension AbstractAttribute {

    @NSManaged var disabled: NSNumber!
    @NSManaged var id: NSNumber!
    @NSManaged var uuid: String!
    @NSManaged var datatype: String!
    @NSManaged var dateFormat: String!
    @NSManaged var desc: String!
    @NSManaged var floatFormat: String!
    @NSManaged var format: String!
    @NSManaged var height: Int32
    @NSManaged var inlineImage: Bool
    @NSManaged var max: String!
    @NSManaged var maxLength: Int32
    @NSManaged var min: String!
    @NSManaged var multiInstance: Bool
    @NSManaged var name: String!
    @NSManaged var order: Int32
    @NSManaged var ordinalChoice: NSNumber!
    @NSManaged var regex: String!
    @NSManaged var regexMessage: String!
    @NSManaged var time24Hours: Bool
    @NSManaged var width: Int32
    @NSManaged var choiceValues: Set<ChoiceValue>
    @NSManaged var customFieldValues: Set<DeviceCustomFieldValue>
    @NSManaged var group: AttributeGroup!

}
