//
//  Organization+CoreDataProperties.swift
//  Job-Connect
//
//  Created by Darren Ferguson on 5/12/16.
//  Copyright © 2016 M.C. Dean, Inc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Organization {

    @NSManaged var abbreviation: String!
    @NSManaged var disabled: Bool
    @NSManaged var id: NSNumber!
    @NSManaged var name: String!
    @NSManaged var type: String!
    @NSManaged var uuid: String!
    @NSManaged var desc: String!
    @NSManaged var contractorContracts: Set<Contract>
    @NSManaged var customerContracts: Set<Contract>

}
