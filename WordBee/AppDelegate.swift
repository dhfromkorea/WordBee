//
//  AppDelegate.swift
//  WordBee
//
//  Created by dh on 10/21/16.
//  Copyright © 2016 dh. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    let modelName = "WordBee"
    guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
      fatalError("Error laoding model from bundle")
    }
    guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
      fatalError("Error initializing mom from: \(modelURL)")
    }
    let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let docURL = urls[urls.endIndex - 1]
    let storeURL = docURL.appendingPathComponent("\(modelName).sqlite")
    do {
      try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
    } catch {
      fatalError("error migrating store: \(error.localizedDescription)")
    }
    return psc
  }()


  @available(iOS 10.0, *)
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "WordBee")
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

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
  }
}
