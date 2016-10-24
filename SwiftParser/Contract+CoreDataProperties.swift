//
//  Contract+CoreDataProperties.swift
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

extension Contract {

    @NSManaged var disabled: NSNumber!
    @NSManaged var id: NSNumber!
    @NSManaged var uuid: String!
    @NSManaged var name: String!
    @NSManaged var number: String!
    @NSManaged var status: String!
    @NSManaged var desc: String!
    @NSManaged var contractor: Organization!
    @NSManaged var customer: Organization!
    @NSManaged var devices: Set<DeviceContract>
    @NSManaged var deviceTypeAttributes: Set<DeviceTypeAttributeContract>
    @NSManaged var serviceRequests: Set<SR>
    @NSManaged var srCategoryAttributes: Set<SRCategoryAttribute>
    @NSManaged var srStateMachineCategories: Set<SRStateMachineCategory>

}
