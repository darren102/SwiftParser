//
//  WorkForm+CoreDataProperties.swift
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

extension WorkForm {

    @NSManaged var disabled: NSNumber!
    @NSManaged var id: NSNumber!
    @NSManaged var uuid: String!
    @NSManaged var created: Date!
    @NSManaged var name: String!
    @NSManaged var categories: Set<WorkFormCategory>
    @NSManaged var createdBy: User!
    @NSManaged var current: WorkFormPDFRevision!
    @NSManaged var pmTasks: Set<PMTask>
    @NSManaged var revisions: Set<WorkFormPDFRevision>

}
