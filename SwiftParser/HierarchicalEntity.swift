//
//  HierarchicalEntity.swift
//  Job-Connect
//
//  Created by Darren Ferguson on 4/21/16.
//  Copyright © 2016 M.C. Dean, Inc. All rights reserved.
//

import Foundation
import CoreData

protocol HierarchicalEntity: Hashable {
    var id: NSNumber! { get }
    var name: String! { get }
    var children: Set<Self> { get }
    var parent: Self! { get }
}

extension HierarchicalEntity where Self: NSManagedObject, Self: HierarchicalEntity {

    /// Return all child object in the hierarchy below the current object
    ///
    /// - parameter includeSelf: **true** also return the current object
    ///                          **false** only return the children **false** is default
    ///
    /// - returns: array of objects in the hierarchy below the current object
    func allChildren(includeSelf: Bool = false) -> [Self] {
        var data: [Self] = []

        if includeSelf {
            data.append(self)
        }

        // Sort the children then go through each of them pulling their children hierarchy
        children
            .sorted(by: { (lhs: Self, rhs: Self) in lhs.name < rhs.name })
            .forEach({ (entity: Self) in
                data.append(entity)
                data.append(contentsOf: entity.allChildren())
            })
        return data
    }
}
