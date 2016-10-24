//
//  CoreDataStackSetable.swift
//  CoreDataStack
//
//  Created by Darren Ferguson on 2/23/16.
//  Copyright © 2016 M.C. Dean, Inc. All rights reserved.
//

import Foundation

/// Protocol that allows class type objects to state they support
/// the CoreDataStack as a variable
///
/// - note: done as a class since otherwise it does not allow updating
///         the value since if a struct it would need to be **mutating**
///         so only supported on reference type objects for the protocol
public protocol CoreDataStackSetable: class {

    /// Variable to state the CoreDataStack can be associated with this object
    var coreDataStack: CoreDataStack! { get set }
}
