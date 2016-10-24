//
//  Symptom.swift
//  Job-Connect
//
//  Created by Darren Ferguson on 3/25/16.
//  Copyright © 2016 M.C. Dean, Inc. All rights reserved.
//

import Foundation
import CoreData

@objc(Symptom) // Done so we can use the NSStringFromClass without worrying about the mangled name
final class Symptom: NSManagedObject {
}

// MARK: - HierarchicalEntity
extension Symptom: HierarchicalEntity {
}
