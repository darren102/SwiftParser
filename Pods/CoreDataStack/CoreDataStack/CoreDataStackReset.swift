//
//  CoreDataStackReset.swift
//  CoreDataStack
//
//  Created by Darren Ferguson on 2/23/16.
//  Copyright © 2016 M.C. Dean, Inc. All rights reserved.
//

import Foundation
import CoreData

/// Protocol that provides the ability to reset the CoreDataStack
/// back to the defaults basically removing all underlying storage
/// then re-building the stack so it has no data but is ready for use
public protocol CoreDataStackReset: CoreDataStackSetable {

    /// Reset the CoreDataStack back to an empty persistence layer
    func resetCoreDataStack()
}

/// Default implementation of the CoreDataStackReset which utilizes
/// the **resetStack** method available only to the framework internally
public extension CoreDataStackReset {

    /// Reset the CoreDataStack back to an empty persistence layer
    func resetCoreDataStack() {
        coreDataStack.resetStack()
    }
}
