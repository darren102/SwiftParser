//
//  AbstractUpdate+CoreDataProperties.swift
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

extension AbstractUpdate {

    @NSManaged var disabled: NSNumber!
    @NSManaged var id: NSNumber!
    @NSManaged var uuid: String!
    @NSManaged var created: Date!
    @NSManaged var desc: String!
    @NSManaged var effectiveTime: Date!
    @NSManaged var createdBy: User!

}
