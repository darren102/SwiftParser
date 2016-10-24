//
//  Priority+CoreDataProperties.swift
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

extension Priority {

    @NSManaged var disabled: NSNumber!
    @NSManaged var id: NSNumber!
    @NSManaged var uuid: String!
    @NSManaged var color: String!
    @NSManaged var desc: String!
    @NSManaged var multiplier: NSNumber!
    @NSManaged var name: String!
    @NSManaged var priorityEnum: String!
    @NSManaged var priorityNum: NSNumber!
    @NSManaged var serviceRequests: Set<SR>

}
