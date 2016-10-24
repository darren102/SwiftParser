//
//  CoreDataStackLogger.swift
//  CoreDataStack
//
//  Created by Darren Ferguson on 2/23/16.
//  Copyright © 2016 M.C. Dean, Inc. All rights reserved.
//

import Foundation

/// Type of log message being logged by the CoreDataStackLogger
///
/// - debug: Message to be logged when not an error but helpful to debug issues
/// - error: Message to be logged when an error occurs
/// - notice: Message to be logged for informational purposes
/// - warn: Message to be logged to let the user know about potential problems
public enum CoreDataStackLoggerType {
    case debug
    case error
    case notice
    case warn
}

public protocol CoreDataStackLogger {

    /// Method to called when logging occurs in SPLNX parser
    ///
    /// - parameter type: Type of message being logged
    /// - parameter message: Message being logged
    /// - parameter function: code function that generated the log message
    /// - parameter file: code file that generated the log message
    /// - parameter line: line of the file that generated the log message
    /// - parameter column: column in the line that generated the log message
    func log(_ type: CoreDataStackLoggerType,
        message: String,
        function: String,
        file: String,
        line: Int,
        column: Int)
}
