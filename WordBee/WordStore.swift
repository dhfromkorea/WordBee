//
//  WordListStore.swift
//  WordBee
//
//  Created by dh on 12/22/16.
//  Copyright © 2016 dh. All rights reserved.
//

import UIKit
import CoreData

class WordStore {
  // CRUD
  var coreDataStack: CoreDataStack!
  var mainContext: NSManagedObjectContext!


  init() {
    coreDataStack = CoreDataStack(modelName: "WordBee")
    mainContext = coreDataStack.managedObjectContext
  }


  func fetchWords() -> [Word] {
    var words = [Word]()

    let request = Word.createFetchRequest()

    if let fetchedWords = try? mainContext.fetch(request) {
      if words.count > 0 {
        print("fetched \(words.count) words")
        words = fetchedWords
      }
    } else {
      fatalError("failed to fetch saved words")
    }

    return words
  }


  func saveWords() {
    coreDataStack.saveContext()
  }


  func deleteWord(word: Word) {
    mainContext.delete(word)
  }

  func createWord(term: String, mnemonic: String) -> Word {
    var word: Word!
    word = NSEntityDescription.insertNewObject(forEntityName: "Word", into: mainContext) as! Word

    word.term = term    
    word.mnemonic = mnemonic
    word.createdAt = Date()

    coreDataStack.saveContext()

    return word
  }


  func fetchExamples() {

  }


  func fetchDefinitions() {
    
  }
  
  
  func fetchImages() {
    
  }
}
