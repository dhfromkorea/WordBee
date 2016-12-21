//
//  Word+CoreDataProperties.swift
//  WordBee
//
//  Created by dh on 12/21/16.
//  Copyright © 2016 dh. All rights reserved.
//

import Foundation
import CoreData


extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word");
    }

    @NSManaged public var term: String
    @NSManaged public var definition: String
    @NSManaged public var mnemonic: String
    @NSManaged public var examples: NSObject?
    @NSManaged public var createdAt: NSDate

}
