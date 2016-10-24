//
//  SR+CoreDataProperties.swift
//  Job-Connect
//
//  Created by Darren Ferguson on 4/28/16.
//  Copyright © 2016 M.C. Dean, Inc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SR {

    @NSManaged var created: Date!
    @NSManaged var disabled: NSNumber!
    @NSManaged var dueDate: Date!
    @NSManaged var id: NSNumber!
    @NSManaged var name: String!
    @NSManaged var number: String!
    @NSManaged var reportedOn: Date!
    @NSManaged var reporter: String!
    @NSManaged var reporterContact: String!
    @NSManaged var updatedOn: Date!
    @NSManaged var uuid: String!
    @NSManaged var allUpdates: Set<SRUpdate>
    @NSManaged var assigned: Set<SRAssignedUser>
    @NSManaged var category: SRCategory!
    @NSManaged var contract: Contract!
    @NSManaged var createdBy: User!
    @NSManaged var customFieldValues: Set<SRCustomFieldValue>
    @NSManaged var devices: Set<SRDevice>
    @NSManaged var location: Location!
    @NSManaged var pmTasks: Set<PMTask>
    @NSManaged var priority: Priority!
    @NSManaged var state: SRState!
    @NSManaged var updatedBy: User!

}
