//
//  CoreDataStack.swift
//  CoreDataStack
//
//  Created by Darren Ferguson on 2/23/16.
//  Copyright © 2016 M.C. Dean, Inc. All rights reserved.
//

import Foundation
import CoreData

/**
 Class holds a CoreDataStack persistence layer for iOS applications. The
 **CoreDataStack** is based on a **writerContext** which is created as a
 privateQueue **NSManagedObjectContext** this is the context that will write
 all data to the underlying storage. The **applicationMainContext** is a child
 **NSManagedObjectContext** that has the **writerContext** as its parent context.
 The **applicationMainContext** should only be used on the UI Main Thread since 
 otherwise you run the risk of concurrency issues.
*/
public final class CoreDataStack {

    // MARK: - Properties

    /// Name for the persistence datastore
    /// defaults to Datastore.sqlite if not provided
    fileprivate let DataStore: String

    /// Name for the persistence write ahead logging file
    fileprivate let DataStoreWalFile: String

    /// DataStore persistence shared memory logging file
    fileprivate let DataStoreShmFile: String

    /// Context to be used to write data to the persistent store
    /// This is a private context queue and should not be used on
    /// any thread except the thread which is designated by utilizing
    /// the **performBlock** and **performBlockAndWait** functionality
    fileprivate var writerContext: NSManagedObjectContext!

    /// Context to be used on the main thread for application UI
    ///
    /// - note: You must be on the main thread to access this context however
    ///         once you have a handle to it you can use anywhere however this
    ///         will most likely cause concurrency issues and **YOU SHOULD ONLY**
    ///         use this context while on the applications main UI thread
    ///
    fileprivate var applicationMainContext: NSManagedObjectContext!

    /// Type of store this stack will support defaults to SQLite
    fileprivate let storeType: String

    /// Logger to allow logging messages from the CoreDataStack object
    fileprivate var logger: CoreDataStackLogger?

    /// **NSManagedObjectContext** of concurrency type **mainQueueConcurrencyType**
    ///
    /// - precondition: must be accessed only on the main thread otherwise it will fail
    public var mainContext: NSManagedObjectContext {
        precondition(Thread.isMainThread)
        return applicationMainContext
    }

    /// Setups a private concurrency queue child **NSManagedObjectContext** of the main **NSManagedObjectContext**
    ///
    /// - note: This context can be used as a scratch pad in order to add new elements to the
    ///         persistence storage. If save is called then it will save to the main context using
    ///         pointer arithmetic then the data is available to the application on the main thread.
    ///         if you do not wish to keep the data simply destroy the context by releasing it
    public var childContext: NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = applicationMainContext
        return context
    }

    // MARK: - Initializers
    public init(dataStoreName: String = "Datastore.sqlite",
        storeType: String = NSSQLiteStoreType,
        logger: CoreDataStackLogger? = nil) {
            self.DataStore = dataStoreName
            self.DataStoreWalFile = "\(dataStoreName)-wal"
            self.DataStoreShmFile = "\(dataStoreName)-shm"

            self.storeType = storeType
            self.logger = logger
            setupWriterContext()
    }
}

// MARK: - Public
public extension CoreDataStack {

    /// Saves a Child Context in the system and waits until it has been completed
    ///
    /// - note: This will only wait for the child to be completed, the **saveUsingContext**
    ///         is utilized afterwards which does a **performBlock** on the parent context
    ///         without waiting thus making sure not to block the main thread and writer thread
    ///
    /// - precondition: The context must be a child private **NSManagedObjectContext** with the
    ///                 main **NSManagedObjectContext** as its parent otherwise it will fail
    ///
    /// - parameter context: **NSManagedObjectContext** to be saved
    func saveChildContext(_ context: NSManagedObjectContext) {
        precondition(context.concurrencyType == .privateQueueConcurrencyType &&
            context.parent != nil &&
            context.parent == applicationMainContext)

        guard context.hasChanges else { return }

        context.performAndWait { [weak self] in
            do {
                try context.save()
                // Safe to implicitly unwrap since precondition has done this check for the method
                self?.saveUsingContext(context.parent!)
            } catch let error as NSError {
                let errorMessage = "Could not save child context: \(error)".localized
                self?.logger?.log(.error, message: errorMessage, function: #function, file: #file, line: #line, column: #column)
                fatalError(errorMessage)
            }
        }
    }

    /// Save the provided **NSManagedObjectContext** without waiting for the results
    ///
    /// - note: This method will go up the **NSManagedObjectContext** hierarchy performing
    ///         recursively the same **saveUsingContext** method on the parent objects until
    ///         the writer context is reached in which case no parent will be associated
    ///
    /// - parameter context: **NSManagedObjectContext** to be saved
    func saveUsingContext(_ context: NSManagedObjectContext) {
        guard context.hasChanges else { return }

        context.perform { [weak self] in
            do {
                try context.save()

                if context.parent != nil {
                    self?.saveUsingContext(context.parent!)
                }
            } catch let error as NSError {
                let errorMessage = "Could not save context: \(error)".localized
                self?.logger?.log(.error, message: errorMessage, function: #function, file: #file, line: #line, column: #column)
                fatalError(errorMessage)
            }
        }
    }
}

// MARK: - Internal
extension CoreDataStack {

    /// Reset the CoreDataStack back to an empty persistence layer
    ///
    /// - note: This method will remove the SQLite underlying database, write ahead logging
    ///         and shared memory files from the file system to truely have an empty persistence layer
    func resetStack() {
        writerContext = nil
        applicationMainContext = nil

        do {
            let filePath = dataStorePath()
            if FileManager.default.fileExists(atPath: filePath) {
                try FileManager.default.removeItem(atPath: dataStorePath())
            }

            let writeAheadPath = writeAheadLoggingPath()
            if FileManager.default.fileExists(atPath: writeAheadPath) {
                try FileManager.default.removeItem(atPath: writeAheadPath)
            }

            let sharedMemoryPath = sharedMemoryLoggingPath()
            if FileManager.default.fileExists(atPath: sharedMemoryPath) {
                try FileManager.default.removeItem(atPath: sharedMemoryPath)
            }
        } catch let error as NSError {
            let errorMessage = "Application error while removing underlying persistence files: \(error.localizedDescription)".localized
            logger?.log(.error, message: errorMessage, function: #function, file: #file, line: #line, column: #column)
        }

        setupWriterContext()
    }
}

// MARK: - Private
private extension CoreDataStack {

    /// Helper method to retrieve the applications root documents directory
    ///
    /// - returns: NSURL pointing to the root documents directory
    func applicationDocumentsDirectory() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        guard let documentDirectory = urls.first else {
            let errorMessage = "Could not find the Application Documents Directory".localized
            logger?.log(.error, message: errorMessage, function: #function, file: #file, line: #line, column: #column)
            fatalError(errorMessage)
        }

        return documentDirectory
    }

    /// Generate the path for the SQLite file used as the backing store
    ///
    /// - returns: Location on the file system of the backing store SQLite file
    func dataStorePath() -> String {
        guard let path = applicationDocumentsDirectory().dtf_appendPathComponent(DataStore) else {
            let errorMessage = "Could not generate the path for the SQLite backing store file".localized
            logger?.log(.error, message: errorMessage, function: #function, file: #file, line: #line, column: #column)
            fatalError(errorMessage)
        }

        return path
    }

    /// Generate the path for the SQLite Write Ahead Logging file
    ///
    /// - returns: Location on the file system where the Write Ahead Logging file will reside
    func writeAheadLoggingPath() -> String {
        guard let path = applicationDocumentsDirectory().dtf_appendPathComponent(DataStoreWalFile) else {
            let errorMessage = "Could not generate the path for the SQLite Write Ahead Logging file".localized
            logger?.log(.error, message: errorMessage, function: #function, file: #file, line: #line, column: #column)
            fatalError(errorMessage)
        }

        return path
    }

    /// Generate the path for the SQLite Shared Memory file
    ///
    /// - returns: Location on the file system where the Shared Memory file will reside
    func sharedMemoryLoggingPath() -> String {
        guard let path = applicationDocumentsDirectory().dtf_appendPathComponent(DataStoreShmFile) else {
            let errorMessage = "Could not generate the path for the SQLite Shared Memory file".localized
            logger?.log(.error, message: errorMessage, function: #function, file: #file, line: #line, column: #column)
            fatalError(errorMessage)
        }

        return path
    }

    /// Generate the persistent store coordinator the application will utilize
    ///
    /// - note: This method will generate a **fatalError** if it cannot add the persistent
    ///         storage type or created an **NSManagedObjectModel** for the coordinator
    ///
    /// - returns: **NSPersistentStoreCoordinator** for the application, **nil** if it could not
    func persistentStoreCoordinator() -> NSPersistentStoreCoordinator? {
        guard let managedObjectModel = NSManagedObjectModel.mergedModel(from: nil) else {
            let errorMessage = "Error in NSManagedObjectModel setup. No models found in the main application bundle".localized
            logger?.log(.error, message: errorMessage, function: #function, file: #file, line: #line, column: #column)
            fatalError(errorMessage)
        }

        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            let storeUrl = URL(fileURLWithPath: dataStorePath())
            let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                           NSInferMappingModelAutomaticallyOption: true]

            try coordinator.addPersistentStore(ofType: storeType,
                configurationName: nil,
                at: storeUrl,
                options: options)
        } catch let error as NSError {
            let errorMessage = "Error setting up the PersistentStoreCoordinator: \(error.localizedDescription)".localized
            logger?.log(.error, message: errorMessage, function: #function, file: #file, line: #line, column: #column)
            fatalError(errorMessage)
        }
        return coordinator
    }

    /// Setup the applications writer **NSManagedObjectContext**
    ///
    /// - note: This **NSManagedObjectContext** is only used to write data back to the persistence.
    ///         This is done on a private queue to avoid having the generated write commands done
    ///         on the main thread and thus blocking the application which is not desired
    func setupWriterContext() {
        guard let coordinator = persistentStoreCoordinator() else {
            let errorMessage = "PersistentStoreCoordinator initialization failed. Could not setup writer context".localized
            logger?.log(.error, message: errorMessage, function: #function, file: #file, line: #line, column: #column)
            fatalError(errorMessage)
        }

        writerContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        writerContext.persistentStoreCoordinator = coordinator

        setupMainContext()
    }

    /// Setup the applications main **NSManagedObjectContext** will be used for UI interaction
    func setupMainContext() {
        applicationMainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        applicationMainContext.parent = writerContext
    }
}
