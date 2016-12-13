//
//  Word.swift
//  WordBee
//
//  Created by dh on 10/21/16.
//  Copyright © 2016 dh. All rights reserved.
//

import UIKit

class Word: NSObject, NSCoding {
  var term: String!
  var definition: String!
  var mnemonic: String
  // private var helperText: String
  // private var image: UIImage

  init(_ text: String, definition: String, mnemonic: String) {
    self.term = text
    self.definition = definition
    self.mnemonic = mnemonic
  }

  required init(coder aDecoder: NSCoder) {
    term = aDecoder.decodeObject(forKey: "term") as? String ?? "term"
    definition = aDecoder.decodeObject(forKey: "definition") as? String ?? "definition"
    mnemonic = aDecoder.decodeObject(forKey: "mnemonic") as? String ?? "mnemonic"
  }

  func encode(with aCoder: NSCoder) {
    aCoder.encode(term, forKey: "term")
    aCoder.encode(definition, forKey: "definition")
    aCoder.encode(mnemonic, forKey: "mnemonic")

  }
}
