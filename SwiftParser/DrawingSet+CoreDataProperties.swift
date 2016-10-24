//
//  DrawingSet+CoreDataProperties.swift
//  Job-Connect
//
//  Created by Darren Ferguson on 8/26/16.
//  Copyright © 2016 M.C. Dean, Inc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DrawingSet {

    @NSManaged var id: NSNumber!
    @NSManaged var name: String!
    @NSManaged var created: Date!
    @NSManaged var disabled: NSNumber!
    @NSManaged var uuid: String!
    @NSManaged var location: Location!
    @NSManaged var rootDevice: Device!
    @NSManaged var createdBy: User!
    @NSManaged var updatedBy: User!
    @NSManaged var drawings: Set<Drawing>
}
