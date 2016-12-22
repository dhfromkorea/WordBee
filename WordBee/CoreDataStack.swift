//
//  CoreDataStack.swift
//  WordBee
//
//  Created by dh on 12/22/16.
//  Copyright © 2016 dh. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStack: NSObject {
  var modelName: String!

  required init(modelName: String) {
    self.modelName = modelName
  }

  fileprivate lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
      fatalError("Error laoding model from bundle")
    }
    guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
      fatalError("Error initializing mom from: \(modelURL)")
    }
    let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let docURL = urls[urls.endIndex - 1]
    let storeURL = docURL.appendingPathComponent("\(self.modelName).sqlite")
    do {
      try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
    } catch {
      fatalError("error migrating store: \(error.localizedDescription)")
    }
    return psc
  }()

  @available(iOS 10.0, *)
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: self.modelName)
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error {
        fatalError("Unresolved error \(error)")
      }
    })
    return container
  }()

  lazy var managedObjectContext: NSManagedObjectContext = {
    var context: NSManagedObjectContext!
    if #available(iOS 10.0, *) {
      context = self.persistentContainer.viewContext
    } else {
      context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
      context?.persistentStoreCoordinator = self.persistentStoreCoordinator
    }
    return context
  }()

  func saveContext() {
    if managedObjectContext.hasChanges {
      do {
        try managedObjectContext.save()
      } catch {
        print("An error occurred while saving context: \(error.localizedDescription)")
      }
    }
  }
  
}
