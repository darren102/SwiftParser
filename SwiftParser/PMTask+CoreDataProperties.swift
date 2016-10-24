//
//  PMTask+CoreDataProperties.swift
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

extension PMTask {

    @NSManaged var disabled: NSNumber!
    @NSManaged var id: NSNumber!
    @NSManaged var uuid: String!
    @NSManaged var comment: String!
    @NSManaged var formSavedDate: Date!
    @NSManaged var formResult: String!
    @NSManaged var page: Int16
    @NSManaged var state: String!
    @NSManaged var device: Device!
    @NSManaged var form: WorkForm!
    @NSManaged var formData: WorkFormPDFData!
    @NSManaged var formRevision: WorkFormPDFRevision!
    @NSManaged var formSavedBy: User!
    @NSManaged var location: Location!
    @NSManaged var sr: SR!

}
