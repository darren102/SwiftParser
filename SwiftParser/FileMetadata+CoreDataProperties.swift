//
//  FileMetadata+CoreDataProperties.swift
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

extension FileMetadata {

    @NSManaged var disabled: NSNumber!
    @NSManaged var id: NSNumber!
    @NSManaged var uuid: String!
    @NSManaged var contentType: String!
    @NSManaged var digest: String!
    @NSManaged var lastModified: Date!
    @NSManaged var originalName: String!
    @NSManaged var pmTaskUuid: String!
    @NSManaged var size: Int64
    @NSManaged var relatedObjectUuid: String!
    @NSManaged var customFieldValueUuid: String!
    @NSManaged var updateFiles: Set<AbstractUpdateFile>
    @NSManaged var workFormPDFData: Set<WorkFormPDFData>
    @NSManaged var workFormPDFRevisions: Set<WorkFormPDFRevision>
    @NSManaged var drawingsFileMetaData: Set<Drawing>
    @NSManaged var customFieldValues: Set<AbstractCustomFieldValue>

}
