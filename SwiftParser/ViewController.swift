//
//  ViewController.swift
//  SwiftParser
//
//  Created by Darren Ferguson on 10/12/16.
//  Copyright © 2016 M.C. Dean, Inc. All rights reserved.
//

import CoreDataStack
import UIKit

final class ViewController: UIViewController {

    var coreDataStack: CoreDataStack!

    let entities = ["Organization",
                    "Contract",
                    "User",
                    "Symptom",
                    "AttributeGroup",
                    "Priority",
                    "DeviceState",
                    "DeviceStateMachine",
                    "DeviceType",
                    "DeviceAttribute",
                    "DeviceTypeAttribute",
                    "DeviceTypeAttributeStateBehavior",
                    "SRState",
                    "SRStateMachine",
                    "SRCategory",
                    "SRAttribute",
                    "SRCategoryAttribute",
                    "SRCategoryAttributeStateBehavior",
                    "WorkForm"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async { [unowned self] in
            let data = self.readDataFile()
            self.processData(data: data)
        }
    }

    func readDataFile() -> Any {
        // Make sure we have the JMC configuration file and that the file has valid data inside it
        guard let jsonFile = Bundle.main.path(forResource: "data", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: jsonFile)) else {
                fatalError("Could not read the data file from disk")
        }

        do {
            return try JSONSerialization.jsonObject(with: data, options: [])
        } catch let error as NSError {
            fatalError("Data serialization error: \(error)")
        }
    }

    func processData(data: Any) {
        let context = coreDataStack.childContext
        let mapper = StaticDataMapper(context: context, requestEntities: entities)
        mapper.processData(data)
        coreDataStack.saveChildContext(context)
    }
}
