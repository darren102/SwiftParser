//
//  SRAssignedUser+CoreDataProperties.swift
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

extension SRAssignedUser {

    @NSManaged var id: NSNumber!
    @NSManaged var disabled: NSNumber!
    @NSManaged var uuid: String!
    @NSManaged var sr: SR!
    @NSManaged var user: User!

}
