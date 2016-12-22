//
//  ViewController.swift
//  WordBee
//
//  Created by dh on 10/21/16.
//  Copyright © 2016 dh. All rights reserved.
//

import UIKit
import CoreData

class WordsViewController: UITableViewController {
  var store: WordStore!
  let wordDatasource = WordDataSource()

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()

    tableView.dataSource = wordDatasource
    wordDatasource.words = store.fetchWords()
  }


  // MARK: configure views
  func configureView() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWord))
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 80
  }


  // MARK: CRUD funcs for Words
  func addWord() {
    let ac = UIAlertController(title: "add a new word", message: nil, preferredStyle: .alert)
    // TODO: add some spacing
    ac.addTextField { (textField : UITextField!) in
      textField.placeholder = "word"
    }
    ac.addTextField { (textField : UITextField!) in
      textField.placeholder = "hint (one word)"
    }

    let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self, ac ] _ in
      guard let term = ac.textFields?[0].text, !term.isEmpty,
            let hint = ac.textFields?[1].text, !hint.isEmpty else { return }

      let word = self.store.createWord(term: term, mnemonic: hint)

      self.wordDatasource.words.append(word)
      self.store.saveWords()
      self.tableView.reloadData()

    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

    ac.addAction(saveAction)
    ac.addAction(cancelAction)
    present(ac, animated: true)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "WordDetailViewSegue" else { return }
    guard let vc = segue.destination as? WordDetailViewController,
      let row = tableView.indexPathForSelectedRow?.row else { return }
    vc.store = store
    vc.word = wordDatasource.words[row]
    vc.wordIndex = row
  }



}
