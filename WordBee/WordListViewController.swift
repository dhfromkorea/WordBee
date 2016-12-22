//
//  ViewController.swift
//  WordBee
//
//  Created by dh on 10/21/16.
//  Copyright © 2016 dh. All rights reserved.
//

import UIKit
import CoreData

class WordListViewController: UITableViewController {
  var words = [Word]()
  weak var appDelegate: AppDelegate!
  var viewContext: NSManagedObjectContext!


  override func viewDidLoad() {
    super.viewDidLoad()

    appDelegate = UIApplication.shared.delegate as! AppDelegate
    viewContext = appDelegate.managedObjectContext

    configureView()
    loadData()
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return words.count
  }


  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath) as! WordTableViewCell
    let word = words[indexPath.row]
    cell.wordLabel?.text = word.term
    cell.mnemonicLabel?.text = word.mnemonic

    return cell
  }


  @IBAction func hintTapped(_ sender: AnyObject) {
    print("hint tapped")
    let word = words[sender.tag]
    print("hint button found with \(word.mnemonic)")
  }


  // MARK: configure views
  func configureView() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWord))
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 80
  }


  func loadData() {
    let request = Word.createFetchRequest()

    if let words = try? viewContext.fetch(request) {
      if words.count > 0 {
        print("fetched \(words.count) words")
        self.words = words
      }
    } else {
      fatalError("failed to fetch saved words")
    }
    appDelegate.saveContext()
  }



  // MARK: CRUD funcs for Words
  func addWord() {
    let ac = UIAlertController(title: "add a new word", message: nil, preferredStyle: .alert)
    // TODO: add some spacing
    ac.addTextField { (textField : UITextField!) in
      textField.placeholder = "word"
    }
    ac.addTextField { (textField : UITextField!) in
      textField.placeholder = "definition"
    }
    ac.addTextField { (textField : UITextField!) in
      textField.placeholder = "hint (one word)"
    }

    let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self, ac ] _ in
      if let term = ac.textFields?[0].text, !term.isEmpty,
        let definition = ac.textFields?[1].text, !definition.isEmpty,
        let hint = ac.textFields?[2].text, !hint.isEmpty {
        self.saveWord(term: term, mnemonic: hint, definition: definition)
      }
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

    ac.addAction(saveAction)
    ac.addAction(cancelAction)
    present(ac, animated: true)
  }

  func saveWord(term: String, mnemonic: String, definition: String) {
    var word: Word!

    if #available(iOS 10.0, *) {
      word = Word(context: self.viewContext)
    } else {
      word = NSEntityDescription.insertNewObject(forEntityName: "Word", into: self.viewContext) as! Word
    }

    word.term = term
    word.definition = definition
    word.mnemonic = mnemonic
    word.createdAt = Date()

    self.words.append(word)
    self.appDelegate.saveContext()
    self.tableView.reloadData()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "WordDetailViewSegue" else { return }
    guard let vc = segue.destination as? WordDetailViewController,
      let row = tableView.indexPathForSelectedRow?.row else { return }
    vc.word = words[row]
  }



}
