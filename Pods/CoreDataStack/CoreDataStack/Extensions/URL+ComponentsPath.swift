//
//  NSURL+ComponentsPath.swift
//  CoreDataStack
//
//  Created by Darren Ferguson on 2/23/16.
//  Copyright © 2016 M.C. Dean, Inc. All rights reserved.
//

import UIKit

extension URL {

    /// Append the **String** path component to the NSURL
    ///
    /// - parameter component: String path component to be appended to the NSURL
    ///
    /// - returns: String version of **NSURL** with the component string appended.
    ///            **nil** if failure occurs
    func dtf_appendPathComponent(_ component: String) -> String? {
        var url = self
        url.appendPathComponent(component)
        return url.path
    }
}
