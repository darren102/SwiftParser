//
//  ContactInfo+CoreDataProperties.swift
//  Job-Connect
//
//  Created by Miglius Alaburda on 5/23/16.
//  Copyright © 2016 M.C. Dean, Inc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ContactInfo {

    @NSManaged var email: String!
    @NSManaged var user: Organization!

}
