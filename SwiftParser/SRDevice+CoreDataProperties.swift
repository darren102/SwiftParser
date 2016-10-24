//
//  SRDevice+CoreDataProperties.swift
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

extension SRDevice {

    @NSManaged var disabled: Bool
    @NSManaged var id: NSNumber!
    @NSManaged var uuid: String!
    @NSManaged var timeOccurred: Date!
    @NSManaged var device: Device!
    @NSManaged var location: Location!
    @NSManaged var sr: SR!
    @NSManaged var symptoms: Set<SRDeviceSymptom>

}
