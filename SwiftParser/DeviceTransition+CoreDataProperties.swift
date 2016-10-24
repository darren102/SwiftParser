//
//  DeviceTransition+CoreDataProperties.swift
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

extension DeviceTransition {

    @NSManaged var machine: DeviceStateMachine!
    @NSManaged var mainTransition: DeviceTransition!
    @NSManaged var source: DeviceState!
    @NSManaged var stateUpdates: Set<DeviceStateUpdate>
    @NSManaged var target: DeviceState!
    @NSManaged var undoTransition: DeviceTransition!

}
