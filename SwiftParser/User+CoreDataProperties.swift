//
//  User+CoreDataProperties.swift
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

extension User {

    @NSManaged var disabled: NSNumber!
    @NSManaged var firstName: String!
    @NSManaged var fullName: String!
    @NSManaged var id: NSNumber!
    @NSManaged var lastName: String!
    @NSManaged var middleName: String!
    @NSManaged var name: String!
    @NSManaged var personType: String!
    @NSManaged var salutation: String!
    @NSManaged var serviceUser: NSNumber!
    @NSManaged var status: String!
    @NSManaged var suffix: String!
    @NSManaged var uuid: String!
    @NSManaged var contactInfo: ContactInfo!
    @NSManaged var devicesCreatedBy: Set<Device>
    @NSManaged var devicesUpdatedBy: Set<Device>
    @NSManaged var drawingsCreatedBy: Set<Drawing>
    @NSManaged var drawingsUpdatedBy: Set<Drawing>
    @NSManaged var pmTasksFormSavedBy: Set<PMTask>
    @NSManaged var serviceRequestsAssignedUser: Set<SR>
    @NSManaged var serviceRequestsCreatedBy: Set<SR>
    @NSManaged var serviceRequestsUpdatedBy: Set<SR>
    @NSManaged var serviceRequestUpdatesCreatedBy: Set<SRUpdate>
    @NSManaged var workFormCategoriesCreatedBy: Set<WorkFormCategory>
    @NSManaged var workFormPDFDataCreatedBy: Set<WorkFormPDFData>
    @NSManaged var workFormsCreatedBy: Set<WorkForm>
    @NSManaged var drawingSetCreatedBy: Set<DrawingSet>
    @NSManaged var drawingSetUpdatedBy: Set<DrawingSet>

}
