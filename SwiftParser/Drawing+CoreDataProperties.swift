//
//  Drawing+CoreDataProperties.swift
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

extension Drawing {

    @NSManaged var created: Date!
    @NSManaged var disabled: NSNumber!
    @NSManaged var fileName: String!
    @NSManaged var fileType: String!
    @NSManaged var id: NSNumber!
    @NSManaged var name: String!
    @NSManaged var uuid: String!
    @NSManaged var createdBy: User!
    @NSManaged var fileMetaData: FileMetadata!
    @NSManaged var location: Location!
    @NSManaged var updatedBy: User!
    @NSManaged var drawingSet: DrawingSet!

}
