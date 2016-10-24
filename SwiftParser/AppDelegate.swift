//
//  AppDelegate.swift
//  SwiftParser
//
//  Created by Darren Ferguson on 10/12/16.
//  Copyright © 2016 M.C. Dean, Inc. All rights reserved.
//

import CoreDataStack
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    /// Filename **CoreDataStack** will use to store information on the persistence layer
    fileprivate let dataStoreName = "Fabrication.sqlite"

    var window: UIWindow?
    
    /// Main persistence stack for the application
    fileprivate(set) var coreDataStack: CoreDataStack!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Setting up the persistence layer for the application
        coreDataStack = CoreDataStack(dataStoreName: dataStoreName)

        if let controller = window?.rootViewController as? ViewController {
            controller.coreDataStack = coreDataStack
        }

        return true
    }
}
