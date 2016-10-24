//
//  String+ComponentsPath.swift
//  CoreDataStack
//
//  Created by Darren Ferguson on 2/23/16.
//  Copyright © 2016 M.C. Dean, Inc. All rights reserved.
//

import Foundation

extension String {

    /// Append a path component to a **String**
    ///
    /// - parameter component: Path component to append to the **String**
    ///
    /// - returns: **String** with appended path component, **nil** if an error occurs
    func appendingPathComponent(_ component: String) -> String? {
        guard let fileUrlString = URL(fileURLWithPath: self).dtf_appendPathComponent(component) else {
            return nil
        }

        return fileUrlString
    }
}
