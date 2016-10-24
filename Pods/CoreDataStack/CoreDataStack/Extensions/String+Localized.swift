//
//  String+Localized.swift
//  CoreDataStack
//
//  Created by Darren Ferguson on 2/23/16.
//  Copyright © 2016 M.C. Dean, Inc. All rights reserved.
//

import Foundation

extension String {

    /// Variable to return a localized version of the **String** based on the
    /// output of the **NSLocalizedString** method
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
