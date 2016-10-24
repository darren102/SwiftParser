//
//  SRStateUpdate+CoreDataProperties.swift
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

extension SRStateUpdate {

    @NSManaged var state: SRState!
    @NSManaged var transition: SRTransition!
    @NSManaged var undoneRecord: SRStateUpdate!
    @NSManaged var undoRecord: SRStateUpdate!
    @NSManaged var update: SRUpdate!

}
