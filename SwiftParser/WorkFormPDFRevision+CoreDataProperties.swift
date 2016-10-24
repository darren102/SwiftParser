//
//  WorkFormPDFRevision+CoreDataProperties.swift
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

extension WorkFormPDFRevision {

    @NSManaged var disabled: NSNumber!
    @NSManaged var id: NSNumber!
    @NSManaged var uuid: String!
    @NSManaged var fileName: String!
    @NSManaged var revision: Int32
    @NSManaged var updatedOn: Date!
    @NSManaged var fileMetaData: FileMetadata!
    @NSManaged var form: WorkForm!
    @NSManaged var formCurrent: WorkForm!
    @NSManaged var formData: Set<WorkFormPDFData>
    @NSManaged var pmTasks: Set<PMTask>

}
