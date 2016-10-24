//
//  Location+CoreDataProperties.swift
//  Job-Connect
//
//  Created by Darren Ferguson on 4/14/16.
//  Copyright © 2016 M.C. Dean, Inc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Location {

    @NSManaged var disabled: NSNumber!
    @NSManaged var id: NSNumber!
    @NSManaged var uuid: String!
    @NSManaged var name: String!
    @NSManaged var children: Set<Location>
    @NSManaged var devices: Set<Device>
    @NSManaged var parent: Location!
    @NSManaged var pmTasks: Set<PMTask>
    @NSManaged var serviceRequestDevices: Set<SRDevice>
    @NSManaged var serviceRequests: Set<SR>
    @NSManaged var drawings: Set<Drawing>

}
