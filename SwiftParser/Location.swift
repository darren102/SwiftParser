//
//  Location.swift
//  Job-Connect
//
//  Created by Darren Ferguson on 3/25/16.
//  Copyright © 2016 M.C. Dean, Inc. All rights reserved.
//

import Foundation
import CoreData

@objc(Location) // Done so we can use the NSStringFromClass without worrying about the mangled name
final class Location: NSManagedObject {
}

// MARK: - HierarchicalEntity
extension Location: HierarchicalEntity {
}
