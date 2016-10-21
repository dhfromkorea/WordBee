//
//  Word.swift
//  WordBee
//
//  Created by dh on 10/21/16.
//  Copyright © 2016 dh. All rights reserved.
//

import UIKit

class Word: NSObject, NSCoding {
    var term: String
    var definition: String
    // private var helperText: String
    // private var image: UIImage
    
    init(_ text: String, definition: String) {
        self.term = text
        self.definition = definition
    }
    
    required init(coder aDecoder: NSCoder) {
        term = aDecoder.decodeObject(forKey: "term") as! String
        definition = aDecoder.decodeObject(forKey: "definition") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(term, forKey: "term")
        aCoder.encode(definition, forKey: "definition")
    }
}
