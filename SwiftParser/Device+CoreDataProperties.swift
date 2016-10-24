//
//  Device+CoreDataProperties.swift
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

extension Device {

    @NSManaged var created: Date!
    @NSManaged var desc: String!
    @NSManaged var disabled: NSNumber!
    @NSManaged var id: NSNumber!
    @NSManaged var name: String!
    @NSManaged var updatedOn: Date!
    @NSManaged var uuid: String!
    @NSManaged var allUpdates: Set<DeviceUpdate>
    @NSManaged var children: Set<Device>
    @NSManaged var contracts: Set<DeviceContract>
    @NSManaged var createdBy: User!
    @NSManaged var customFieldValues: Set<DeviceCustomFieldValue>
    @NSManaged var fromLinks: Set<DeviceLink>
    @NSManaged var location: Location!
    @NSManaged var parent: Device!
    @NSManaged var pmTasks: Set<PMTask>
    @NSManaged var provides: DeviceLink!
    @NSManaged var serviceRequestDevices: Set<SRDevice>
    @NSManaged var state: DeviceState!
    @NSManaged var toLinks: Set<DeviceLink>
    @NSManaged var type: DeviceType!
    @NSManaged var updatedBy: User!
    @NSManaged var drawingSets: Set<DrawingSet>

}
