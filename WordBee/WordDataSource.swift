//
//  WordDataSource.swift
//  WordBee
//
//  Created by dh on 12/22/16.
//  Copyright © 2016 dh. All rights reserved.
//

import UIKit

class WordDataSource: NSObject, UITableViewDataSource {
  var words = [Word]()

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return words.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath) as! WordTableViewCell
    let word = words[indexPath.row]
    cell.wordLabel?.text = word.term
    cell.mnemonicLabel?.text = word.mnemonic

    return cell
  }

}
